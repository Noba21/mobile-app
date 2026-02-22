import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../landing/domain/entities/gallery_image.dart';
import '../../domain/repositories/admin_gallery_repository.dart';
import '../bloc/admin_gallery_bloc.dart';

class AdminGalleryPage extends StatelessWidget {
  const AdminGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminGalleryBloc(getIt<AdminGalleryRepository>())
        ..add(const AdminGalleryLoadRequested()),
      child: const _AdminGalleryContent(),
    );
  }
}

class _AdminGalleryContent extends StatelessWidget {
  const _AdminGalleryContent();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminGalleryBloc, AdminGalleryState>(
      listener: (context, state) {
        if (state.status == AdminGalleryStatus.failure && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: state.status == AdminGalleryStatus.loading && state.images.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : state.images.isEmpty
                  ? Center(
                      child: Text(
                        state.status == AdminGalleryStatus.failure
                            ? 'Could not load gallery'
                            : 'No images yet',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(AppTheme.spacingMd),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _crossAxisCount(context),
                        crossAxisSpacing: AppTheme.spacingMd,
                        mainAxisSpacing: AppTheme.spacingMd,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: state.images.length,
                      itemBuilder: (context, index) {
                        final image = state.images[index];
                        return _GalleryImageCard(
                          image: image,
                          onEdit: () => context.push(
                            '${AppConstants.routeAdminGallery}/edit/${image.id}',
                            extra: image,
                          ),
                          onDelete: () => _confirmDelete(context, image),
                        );
                      },
                    ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.push('${AppConstants.routeAdminGallery}/new'),
            child: const Icon(Icons.add_photo_alternate),
          ),
        );
      },
    );
  }

  int _crossAxisCount(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width > 900) return 4;
    if (width > 600) return 3;
    return 2;
  }

  void _confirmDelete(BuildContext context, GalleryImage image) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete image?'),
        content: const Text('Remove this image from the gallery?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AdminGalleryBloc>().add(
                    AdminGalleryDeleteRequested(image.id),
                  );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _GalleryImageCard extends StatelessWidget {
  const _GalleryImageCard({
    required this.image,
    required this.onEdit,
    required this.onDelete,
  });

  final GalleryImage image;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              image.url,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Center(
                child: Icon(Icons.broken_image, size: 48),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (image.caption != null && image.caption!.isNotEmpty)
                  Text(
                    image.caption!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                if (image.category != null && image.category!.isNotEmpty)
                  Text(
                    image.category!,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: onEdit,
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                      onPressed: onDelete,
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
