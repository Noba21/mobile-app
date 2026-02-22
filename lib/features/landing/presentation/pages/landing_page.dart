import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../domain/entities/gallery_image.dart';
import '../../domain/entities/package.dart';
import '../bloc/landing_bloc.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: ResponsiveUtils.screenPadding(context),
              child: BlocBuilder<LandingBloc, LandingState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHero(context),
                      const SizedBox(height: AppTheme.spacingXl),
                      _buildIntro(context),
                      const SizedBox(height: AppTheme.spacingXl),
                      _buildFeaturedPackages(context, state.packages, state.status == LandingStatus.loading),
                      const SizedBox(height: AppTheme.spacingXl),
                      _buildFeaturedGallery(context, state.images, state.status == LandingStatus.loading),
                      const SizedBox(height: AppTheme.spacingXl),
                      _buildContact(context),
                      const SizedBox(height: AppTheme.spacingXl),
                      _buildAuthButtons(context),
                      const SizedBox(height: AppTheme.spacingXl),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 80,
      floating: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      title: Row(
        children: [
          Icon(Icons.camera_alt, color: Colors.white, size: 28),
          const SizedBox(width: AppTheme.spacingSm),
          Text(
            AppConstants.appName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: child,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              Icons.photo_camera,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'Capture Your Moments',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Professional photography for every occasion',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntro(BuildContext context) {
    return Text(
      'Welcome to ${AppConstants.appName}. We offer premium photography packages for weddings, portraits, events, and more. Our experienced photographers bring your vision to life.',
      style: Theme.of(context).textTheme.bodyLarge,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildFeaturedPackages(BuildContext context, List<Package> packages, bool loading) {
    final items = packages.isEmpty ? _placeholderPackages : packages;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured Packages',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        SizedBox(
          height: 160,
          child: loading && packages.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(width: AppTheme.spacingMd),
                  itemBuilder: (context, index) {
                    final pkg = items[index];
                    final title = pkg is Package ? pkg.title : (pkg as _PlaceholderPackage).title;
                    final price = pkg is Package ? '\$${pkg.price.toStringAsFixed(0)}' : (pkg as _PlaceholderPackage).price;
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: Duration(milliseconds: 400 + (index * 100)),
                      builder: (context, value, child) => Opacity(
                        opacity: value,
                        child: child,
                      ),
                      child: SizedBox(
                        width: 200,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(AppTheme.spacingMd),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  title,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: AppTheme.spacingXs),
                                Text(
                                  price,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  static const List<_PlaceholderPackage> _placeholderPackages = [
    _PlaceholderPackage('Portrait Session', '\$199'),
    _PlaceholderPackage('Wedding Package', '\$999'),
    _PlaceholderPackage('Event Coverage', '\$499'),
  ];

  Widget _buildFeaturedGallery(BuildContext context, List<GalleryImage> images, bool loading) {
    final count = images.isEmpty ? 6 : images.length;
    final crossCount = ResponsiveUtils.gridCrossAxisCount(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured Gallery',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        loading && images.isEmpty
            ? const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossCount,
                  crossAxisSpacing: AppTheme.spacingSm,
                  mainAxisSpacing: AppTheme.spacingSm,
                  childAspectRatio: 1,
                ),
                itemCount: count,
                itemBuilder: (context, index) {
                  final image = index < images.length ? images[index] : null;
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(milliseconds: 300 + (index * 50)),
                    builder: (context, value, child) => Opacity(
                      opacity: value,
                      child: child,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: image != null && image.url.isNotEmpty
                          ? Image.network(
                              image.url,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (_, __, ___) => _placeholderImage(context),
                            )
                          : _placeholderImage(context),
                    ),
                  );
                },
              ),
      ],
    );
  }

  Widget _placeholderImage(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.image,
        size: 48,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildContact(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Us',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            _contactRow(context, Icons.email_outlined, 'hello@studio.example.com'),
            _contactRow(context, Icons.phone_outlined, '+1 (555) 123-4567'),
            _contactRow(context, Icons.location_on_outlined, '123 Photo Lane, City'),
          ],
        ),
      ),
    );
  }

  Widget _contactRow(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: AppTheme.spacingSm),
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildAuthButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          onPressed: () => context.go(AppConstants.routeLogin),
          child: const Text('Sign in'),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        OutlinedButton(
          onPressed: () => context.go(AppConstants.routeRegister),
          child: const Text('Create account'),
        ),
      ],
    );
  }
}

class _PlaceholderPackage {
  const _PlaceholderPackage(this.title, this.price);
  final String title;
  final String price;
}
