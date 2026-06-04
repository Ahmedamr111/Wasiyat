import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../widgets/common/wasiyati_button.dart';
import '../../widgets/animations/animations.dart';

/// Onboarding screen — 3 emotional slides
class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _slides = [
    _OnboardingSlide(
      icon: '💌',
      title: 'Your words are too precious\nto leave unsaid',
      subtitle:
          'Write heartfelt messages to the people you love — letters that will be delivered when you can no longer say them yourself.',
    ),
    _OnboardingSlide(
      icon: '👥',
      title: 'Choose who receives\nyour messages, and when',
      subtitle:
          'Send immediately, on special occasions, or as recurring reminders. By email, SMS, or WhatsApp.',
    ),
    _OnboardingSlide(
      icon: '🕊️',
      title: 'We\'ll make sure\nthey reach them',
      subtitle:
          'Our trusted system ensures your messages are delivered safely, securely, and on time. Your legacy, protected.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: WasiyatiColors.splashGradient,
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: widget.onComplete,
                  child: Text(
                    'Skip',
                    style: WasiyatiTypography.labelMedium.copyWith(
                      color: WasiyatiColors.warmTaupe,
                    ),
                  ),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (page) => setState(() => _currentPage = page),
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeSlideTransition(
                          key: ValueKey('icon_$index'),
                          child: Text(
                            slide.icon,
                            style: const TextStyle(fontSize: 80),
                          ),
                        ),
                        const SizedBox(height: 40),
                        FadeSlideTransition(
                          key: ValueKey('title_$index'),
                          delay: const Duration(milliseconds: 200),
                          child: Text(
                            slide.title,
                            style: WasiyatiTypography.headlineLarge.copyWith(
                              height: 1.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FadeSlideTransition(
                          key: ValueKey('subtitle_$index'),
                          delay: const Duration(milliseconds: 400),
                          child: Text(
                            slide.subtitle,
                            style: WasiyatiTypography.bodyMedium.copyWith(
                              color: WasiyatiColors.warmTaupe,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? WasiyatiColors.deepRose
                        : WasiyatiColors.warmTaupe.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: WasiyatiButton(
                label: _currentPage == _slides.length - 1
                    ? 'Get Started'
                    : 'Next',
                onPressed: () {
                  if (_currentPage < _slides.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    widget.onComplete();
                  }
                },
                fullWidth: true,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  final String icon;
  final String title;
  final String subtitle;

  const _OnboardingSlide({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
