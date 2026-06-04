import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/wasiyati_button.dart';
import '../../widgets/common/wasiyati_input.dart';

/// Screen to edit current user's profile
class EditProfileScreen extends ConsumerStatefulWidget {
  final VoidCallback onBack;

  const EditProfileScreen({super.key, required this.onBack});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Pre-populate fields with current user model values
    final user = ref.read(currentUserProvider);
    if (user != null) {
      _nameController.text = user.name;
      _phoneController.text = user.phone ?? '';
      _countryController.text = user.country ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      await ref.read(authStateProvider.notifier).updateProfile(
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
            country: _countryController.text.trim().isEmpty ? null : _countryController.text.trim(),
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Profile updated successfully!'),
            backgroundColor: WasiyatiColors.success,
          ),
        );
        widget.onBack();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: WasiyatiColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: WasiyatiColors.background,
      appBar: AppBar(
        backgroundColor: WasiyatiColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: widget.onBack,
          color: WasiyatiColors.charcoal,
        ),
        title: Text(
          'Edit Profile',
          style: WasiyatiTypography.headlineSmall,
        ),
      ),
      body: user == null
          ? const Center(
              child: CircularProgressIndicator(color: WasiyatiColors.softAmber),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar placeholder or mock picture
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: WasiyatiColors.primaryGradient,
                          ),
                          child: Center(
                            child: Text(
                              _nameController.text.isNotEmpty
                                  ? _nameController.text[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: WasiyatiColors.deepRose,
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Email (Read-only indication)
                  Text('EMAIL ADDRESS (READ-ONLY)', style: WasiyatiTypography.overline),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: WasiyatiColors.warmTaupe.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(WasiyatiRadius.md),
                      border: Border.all(color: WasiyatiColors.cardBorder),
                    ),
                    child: Text(
                      user.email,
                      style: WasiyatiTypography.bodyMedium.copyWith(
                        color: WasiyatiColors.muted,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Full Name
                  WasiyatiInput(
                    label: 'Full Name',
                    hint: 'e.g. Abdullah Ahmed',
                    controller: _nameController,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 24),

                  // Phone Number
                  WasiyatiInput(
                    label: 'Phone Number',
                    hint: '+966 50 xxx xxxx',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),

                  // Country / Region
                  WasiyatiInput(
                    label: 'Country / Region',
                    hint: 'e.g. Saudi Arabia',
                    controller: _countryController,
                  ),
                  const SizedBox(height: 48),

                  WasiyatiButton(
                    label: 'Save Profile Changes',
                    onPressed: _save,
                    isLoading: _isSaving,
                    fullWidth: true,
                  ),
                ],
              ),
            ),
    );
  }
}
