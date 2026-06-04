import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../widgets/animations/animations.dart';
import '../../widgets/common/wasiyati_button.dart';

/// Splash screen — candle flicker, logo, tagline, get started
class SplashScreen extends ConsumerWidget {
  final VoidCallback onGetStarted;
  final VoidCallback onSignIn;

  const SplashScreen({
    super.key,
    required this.onGetStarted,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        gradient: WasiyatiColors.splashGradient,
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Warm radial glow behind candle
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        WasiyatiColors.goldenHour.withValues(alpha: 0.25),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  const Spacer(flex: 3),

                  // Candle animation
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 300),
                    child: const CandleFlicker(size: 64),
                  ),
                  const SizedBox(height: 24),

                  // App name
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 600),
                    child: Text(
                      'Wasiyati',
                      style: WasiyatiTypography.displayLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Arabic name
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 800),
                    child: Text(
                      'وصيتي',
                      style: WasiyatiTypography.arabicDisplay,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tagline
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 1000),
                    child: Text(
                      'Leave your words behind.\nForever.',
                      style: WasiyatiTypography.bodyMedium.copyWith(
                        color: WasiyatiColors.warmTaupe,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Buttons
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 1300),
                    child: Column(
                      children: [
                        WasiyatiButton(
                          label: 'Get Started',
                          onPressed: onGetStarted,
                          fullWidth: true,
                        ),
                        const SizedBox(height: 12),
                        WasiyatiButton(
                          label: 'I already have an account',
                          onPressed: onSignIn,
                          isOutlined: true,
                          fullWidth: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Language options
                  FadeSlideTransition(
                    delay: const Duration(milliseconds: 1500),
                    child: Text(
                      'Available in العربية · English · Français',
                      style: WasiyatiTypography.caption.copyWith(
                        color: WasiyatiColors.muted,
                      ),
                    ),
                  ),

                  const Spacer(flex: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
