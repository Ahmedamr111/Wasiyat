import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/wasiyati_button.dart';
import '../../widgets/common/wasiyati_input.dart';

/// Sign Up screen — Email + Phone + Google + Apple
class SignUpScreen extends ConsumerStatefulWidget {
  final VoidCallback onSignIn;
  final VoidCallback onSuccess;

  const SignUpScreen({
    super.key,
    required this.onSignIn,
    required this.onSuccess,
  });

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(authStateProvider.notifier).signUpWithEmail(
            _emailController.text.trim(),
            _passwordController.text,
            _nameController.text.trim(),
          );
      widget.onSuccess();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign up failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WasiyatiColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Create your\naccount',
                style: WasiyatiTypography.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Start preserving your legacy today.',
                style: WasiyatiTypography.bodyMedium.copyWith(
                  color: WasiyatiColors.warmTaupe,
                ),
              ),
              const SizedBox(height: 40),

              // Name input
              WasiyatiInput(
                label: 'Full Name',
                hint: 'Ahmed',
                controller: _nameController,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 24),

              // Email input
              WasiyatiInput(
                label: 'Email',
                hint: 'ahmed@example.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),

              // Password input
              WasiyatiInput(
                label: 'Password',
                hint: '••••••••',
                controller: _passwordController,
                obscureText: _obscurePassword,
                suffix: GestureDetector(
                  onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                  child: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: WasiyatiColors.muted,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Sign up button
              WasiyatiButton(
                label: 'Create Account',
                onPressed: _signUp,
                isLoading: _isLoading,
                fullWidth: true,
              ),
              const SizedBox(height: 24),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: WasiyatiColors.divider)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'or continue with',
                      style: WasiyatiTypography.caption,
                    ),
                  ),
                  Expanded(child: Divider(color: WasiyatiColors.divider)),
                ],
              ),
              const SizedBox(height: 24),

              // Social buttons
              Row(
                children: [
                  Expanded(
                    child: _SocialButton(
                      icon: '🔵',
                      label: 'Google',
                      onTap: () async {
                        setState(() => _isLoading = true);
                        try {
                          await ref
                              .read(authStateProvider.notifier)
                              .signInWithGoogle();
                          widget.onSuccess();
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Google Sign-In failed: $e'),
                                backgroundColor: WasiyatiColors.error,
                              ),
                            );
                          }
                        } finally {
                          if (mounted) setState(() => _isLoading = false);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SocialButton(
                      icon: '🍎',
                      label: 'Apple',
                      onTap: () async {
                        setState(() => _isLoading = true);
                        try {
                          await ref
                              .read(authStateProvider.notifier)
                              .signInWithApple();
                          widget.onSuccess();
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Apple Sign-In failed: $e'),
                                backgroundColor: WasiyatiColors.error,
                              ),
                            );
                          }
                        } finally {
                          if (mounted) setState(() => _isLoading = false);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Sign in link
              Center(
                child: GestureDetector(
                  onTap: widget.onSignIn,
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: WasiyatiTypography.bodySmall,
                      children: [
                        TextSpan(
                          text: 'Sign in',
                          style: WasiyatiTypography.bodySmall.copyWith(
                            color: WasiyatiColors.deepRose,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback? onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(WasiyatiRadius.md),
          border: Border.all(color: WasiyatiColors.cardBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(label, style: WasiyatiTypography.labelMedium),
          ],
        ),
      ),
    );
  }
}

/// Sign In screen
class SignInScreen extends ConsumerStatefulWidget {
  final VoidCallback onSignUp;
  final VoidCallback onSuccess;
  final VoidCallback onForgotPassword;

  const SignInScreen({
    super.key,
    required this.onSignUp,
    required this.onSuccess,
    required this.onForgotPassword,
  });

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      return;
    }
    setState(() => _isLoading = true);
    try {
      await ref.read(authStateProvider.notifier).signInWithEmail(
            _emailController.text.trim(),
            _passwordController.text,
          );
      widget.onSuccess();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign in failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WasiyatiColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Welcome\nback',
                style: WasiyatiTypography.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Your legacy is safe with us.',
                style: WasiyatiTypography.bodyMedium.copyWith(
                  color: WasiyatiColors.warmTaupe,
                ),
              ),
              const SizedBox(height: 40),

              WasiyatiInput(
                label: 'Email',
                hint: 'ahmed@example.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),

              WasiyatiInput(
                label: 'Password',
                hint: '••••••••',
                controller: _passwordController,
                obscureText: _obscurePassword,
                suffix: GestureDetector(
                  onTap: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  child: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: WasiyatiColors.muted,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: widget.onForgotPassword,
                  child: Text(
                    'Forgot password?',
                    style: WasiyatiTypography.bodySmall.copyWith(
                      color: WasiyatiColors.deepRose,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),

              WasiyatiButton(
                label: 'Sign In',
                onPressed: _signIn,
                isLoading: _isLoading,
                fullWidth: true,
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(child: Divider(color: WasiyatiColors.divider)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'or continue with',
                      style: WasiyatiTypography.caption,
                    ),
                  ),
                  Expanded(child: Divider(color: WasiyatiColors.divider)),
                ],
              ),
              const SizedBox(height: 24),

              // Social buttons
              Row(
                children: [
                  Expanded(
                    child: _SocialButton(
                      icon: '🔵',
                      label: 'Google',
                      onTap: () async {
                        setState(() => _isLoading = true);
                        try {
                          await ref
                              .read(authStateProvider.notifier)
                              .signInWithGoogle();
                          widget.onSuccess();
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Google Sign-In failed: $e'),
                                backgroundColor: WasiyatiColors.error,
                              ),
                            );
                          }
                        } finally {
                          if (mounted) setState(() => _isLoading = false);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SocialButton(
                      icon: '🍎',
                      label: 'Apple',
                      onTap: () async {
                        setState(() => _isLoading = true);
                        try {
                          await ref
                              .read(authStateProvider.notifier)
                              .signInWithApple();
                          widget.onSuccess();
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Apple Sign-In failed: $e'),
                                backgroundColor: WasiyatiColors.error,
                              ),
                            );
                          }
                        } finally {
                          if (mounted) setState(() => _isLoading = false);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Center(
                child: GestureDetector(
                  onTap: widget.onSignUp,
                  child: RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style: WasiyatiTypography.bodySmall,
                      children: [
                        TextSpan(
                          text: 'Sign up',
                          style: WasiyatiTypography.bodySmall.copyWith(
                            color: WasiyatiColors.deepRose,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Forgot Password screen
class ForgotPasswordScreen extends StatefulWidget {
  final VoidCallback onBack;

  const ForgotPasswordScreen({super.key, required this.onBack});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WasiyatiColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: widget.onBack,
        ),
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _sent
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('📬', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 24),
                  Text(
                    'Check your email',
                    style: WasiyatiTypography.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'We\'ve sent a password reset link to ${_emailController.text}',
                    style: WasiyatiTypography.bodyMedium.copyWith(
                      color: WasiyatiColors.warmTaupe,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  WasiyatiButton(
                    label: 'Back to Sign In',
                    onPressed: widget.onBack,
                    fullWidth: true,
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter your email and we\'ll send you a link to reset your password.',
                    style: WasiyatiTypography.bodyMedium.copyWith(
                      color: WasiyatiColors.warmTaupe,
                    ),
                  ),
                  const SizedBox(height: 32),
                  WasiyatiInput(
                    label: 'Email',
                    hint: 'ahmed@example.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 32),
                  WasiyatiButton(
                    label: 'Send Reset Link',
                    onPressed: () => setState(() => _sent = true),
                    fullWidth: true,
                  ),
                ],
              ),
      ),
    );
  }
}

/// Profile Setup screen (after sign up)
class ProfileSetupScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const ProfileSetupScreen({super.key, required this.onComplete});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  String _selectedLanguage = 'en';
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WasiyatiColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Set up your\nprofile',
                style: WasiyatiTypography.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Tell us a little about yourself.',
                style: WasiyatiTypography.bodyMedium.copyWith(
                  color: WasiyatiColors.warmTaupe,
                ),
              ),
              const SizedBox(height: 40),

              // Avatar placeholder
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: WasiyatiColors.primaryGradient,
                      ),
                      child: const Center(
                        child: Text(
                          'A',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: WasiyatiColors.charcoal,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: WasiyatiColors.background,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              WasiyatiInput(
                label: 'Phone Number',
                hint: '+966 50 123 4567',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),

              // Language selector
              Text(
                'PREFERRED LANGUAGE',
                style: WasiyatiTypography.overline,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: {
                  'en': 'English',
                  'ar': 'العربية',
                  'fr': 'Français',
                  'tr': 'Türkçe',
                  'ur': 'اردو',
                }.entries.map((entry) {
                  final isSelected = _selectedLanguage == entry.key;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedLanguage = entry.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? WasiyatiColors.primaryGradient
                            : null,
                        color: isSelected ? null : Colors.white,
                        borderRadius:
                            BorderRadius.circular(WasiyatiRadius.xl),
                        border: isSelected
                            ? null
                            : Border.all(
                                color: WasiyatiColors.cardBorder,
                              ),
                      ),
                      child: Text(
                        entry.value,
                        style: TextStyle(
                          fontFamily: WasiyatiTypography.bodyFont,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : WasiyatiColors.warmTaupe,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 48),

              WasiyatiButton(
                label: 'Complete Setup',
                onPressed: widget.onComplete,
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
