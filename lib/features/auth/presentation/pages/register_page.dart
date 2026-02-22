import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../domain/entities/user.dart';
import '../bloc/auth_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthRegisterRequested(
              fullName: _fullNameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
              phone: _phoneController.text.trim(),
            ),
          );
    }
  }

  static String _dashboardPathForUser(User user) {
    switch (user.role.toLowerCase()) {
      case 'admin':
        return AppConstants.routeAdminDashboard;
      case 'client':
        return AppConstants.routeClientDashboard;
      case 'photographer':
        return AppConstants.routePhotographerDashboard;
      default:
        return AppConstants.routeLanding;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppConstants.routeLogin),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.isAuthenticated && state.user != null) {
              context.go(_dashboardPathForUser(state.user!));
            }
            if (state.status == AuthStatus.failure && state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          },
          builder: (context, state) {
            final loading = state.status == AuthStatus.loading;
            return SingleChildScrollView(
              padding: ResponsiveUtils.screenPadding(context),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveUtils.maxContentWidth(context),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Create account',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      Text(
                        'Register as a client to book photography packages.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: AppTheme.spacingXl),
                      TextFormField(
                        controller: _fullNameController,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          hintText: 'John Doe',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Enter your full name';
                          if (v.trim().length < 2) return 'Name must be at least 2 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'you@example.com',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Enter your email';
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim())) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          hintText: '+1234567890',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Enter your phone number';
                          if (v.trim().length < 8) return 'Enter a valid phone number';
                          return null;
                        },
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () =>
                                setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Enter your password';
                          if (v.length < 6) return 'Password must be at least 6 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () => setState(
                                () => _obscureConfirmPassword = !_obscureConfirmPassword),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Confirm your password';
                          if (v != _passwordController.text) return 'Passwords do not match';
                          return null;
                        },
                      ),
                      const SizedBox(height: AppTheme.spacingXl),
                      FilledButton(
                        onPressed: loading ? null : _submit,
                        child: loading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Create account'),
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      TextButton(
                        onPressed: loading ? null : () => context.go(AppConstants.routeLogin),
                        child: const Text('Already have an account? Sign in'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
