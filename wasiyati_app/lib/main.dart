import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'firebase_options.dart';
import 'config/theme.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/onboarding_screen.dart';
import 'screens/auth/auth_screens.dart';
import 'screens/home/home_shell.dart';
import 'screens/messages/message_composer_screen.dart';
import 'screens/checkin/checkin_screen.dart';
import 'providers/vault_provider.dart';
import 'providers/auth_provider.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  // Preserve the native splash screen until app is fully ready
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Notification Service (FCM & local reminders)
  await NotificationService().initialize();

  // Set system UI overlay style for warm aesthetic
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF1A0A00),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Remove the splash screen — Flutter UI is now ready
  FlutterNativeSplash.remove();

  runApp(const ProviderScope(child: WasiyatiApp()));
}

class WasiyatiApp extends ConsumerWidget {
  const WasiyatiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'Wasiyati — وصيتي',
      debugShowCheckedModeBanner: false,
      locale: Locale(currentLocale),
      supportedLocales: const [
        Locale('en', ''),
        Locale('ar', ''),
        Locale('fr', ''),
        Locale('tr', ''),
        Locale('ur', ''),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: wasiyatiTheme().copyWith(
        textTheme: GoogleFonts.dmSansTextTheme(
          wasiyatiTheme().textTheme,
        ),
      ),
      home: const AppNavigator(),
    );
  }
}

/// Simple navigator managing auth flow vs main app
class AppNavigator extends ConsumerStatefulWidget {
  const AppNavigator({super.key});

  @override
  ConsumerState<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends ConsumerState<AppNavigator> {
  AppScreen _currentScreen = AppScreen.splash;

  void _navigate(AppScreen screen) {
    setState(() => _currentScreen = screen);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<dynamic>>(authStateProvider, (prev, next) {
      next.when(
        data: (user) {
          if (user == null) {
            if (_currentScreen == AppScreen.home ||
                _currentScreen == AppScreen.composer ||
                _currentScreen == AppScreen.checkin) {
              setState(() => _currentScreen = AppScreen.signIn);
            }
          } else {
            // Sync remote user preference to localeProvider
            Future.microtask(() {
              ref.read(localeProvider.notifier).state = user.language;
            });

            if (_currentScreen == AppScreen.splash ||
                _currentScreen == AppScreen.onboarding ||
                _currentScreen == AppScreen.signIn ||
                _currentScreen == AppScreen.signUp) {
              setState(() => _currentScreen = AppScreen.home);
            }
          }
        },
        error: (_, __) {},
        loading: () {},
      );
    });

    switch (_currentScreen) {
      case AppScreen.splash:
        return SplashScreen(
          onGetStarted: () => _navigate(AppScreen.onboarding),
          onSignIn: () => _navigate(AppScreen.signIn),
        );

      case AppScreen.onboarding:
        return OnboardingScreen(
          onComplete: () => _navigate(AppScreen.signUp),
        );

      case AppScreen.signUp:
        return SignUpScreen(
          onSignIn: () => _navigate(AppScreen.signIn),
          onSuccess: () => _navigate(AppScreen.profileSetup),
        );

      case AppScreen.signIn:
        return SignInScreen(
          onSignUp: () => _navigate(AppScreen.signUp),
          onSuccess: () => _navigate(AppScreen.home),
          onForgotPassword: () => _navigate(AppScreen.forgotPassword),
        );

      case AppScreen.forgotPassword:
        return ForgotPasswordScreen(
          onBack: () => _navigate(AppScreen.signIn),
        );

      case AppScreen.profileSetup:
        return ProfileSetupScreen(
          onComplete: () => _navigate(AppScreen.home),
        );

      case AppScreen.home:
        return HomeShell(
          onNewMessage: () => _navigate(AppScreen.composer),
          onViewMessage: (id) => _navigate(AppScreen.composer),
          onCheckIn: () => _navigate(AppScreen.checkin),
          onUpgrade: () {
            // Show premium bottom sheet
            _showPremiumSheet(context);
          },
        );

      case AppScreen.composer:
        return MessageComposerScreen(
          onBack: () => _navigate(AppScreen.home),
          onSaved: () => _navigate(AppScreen.home),
        );

      case AppScreen.checkin:
        return CheckinScreen(
          onConfirm: () => _navigate(AppScreen.home),
          onRemindLater: () => _navigate(AppScreen.home),
        );
    }
  }

  void _showPremiumSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: WasiyatiColors.muted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text('✨', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              'Upgrade to Premium',
              style: WasiyatiTypography.headlineLarge.copyWith(
                color: WasiyatiColors.charcoal,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Unlock the full power of Wasiyati',
              style: WasiyatiTypography.bodyMedium.copyWith(
                color: WasiyatiColors.warmTaupe,
              ),
            ),
            const SizedBox(height: 24),

            // Feature list
            ...[
              '🎬 Video messages',
              '📱 Unlimited messages & recipients',
              '🏛️ The Vault (encrypted storage)',
              '🧪 Test send to preview delivery',
              '🤝 2 Trusted Contacts',
              '🔄 Forever recurring messages',
              '👨‍👩‍👧‍👦 Family plan available',
            ].map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Text(feature.substring(0, 2),
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature.substring(2).trim(),
                      style: WasiyatiTypography.bodyMedium,
                    ),
                  ),
                ],
              ),
            )),

            const SizedBox(height: 24),

            // Price buttons
            GestureDetector(
              onTap: () {
                ref.read(subscriptionProvider.notifier).upgradeToPremium();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✨ Welcome to Premium! (Mock)'),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: WasiyatiColors.primaryGradient,
                  borderRadius: BorderRadius.circular(WasiyatiRadius.pill),
                  boxShadow: WasiyatiColors.buttonShadow,
                ),
                child: Text(
                  '\$4.99/month',
                  style: WasiyatiTypography.labelLarge.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(WasiyatiRadius.pill),
                  border: Border.all(
                    color: WasiyatiColors.warmTaupe.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '\$39.99/year (save 33%)',
                  style: WasiyatiTypography.labelMedium.copyWith(
                    color: WasiyatiColors.warmTaupe,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

enum AppScreen {
  splash,
  onboarding,
  signUp,
  signIn,
  forgotPassword,
  profileSetup,
  home,
  composer,
  checkin,
}
