import 'package:flutter/material.dart';

/// Wasiyati Design System
/// "Intimate, not clinical — feels like a personal journal, not a productivity app"

class WasiyatiColors {
  WasiyatiColors._();

  // Primary Palette
  static const Color warmIvory = Color(0xFFFAF6F1);
  static const Color softAmber = Color(0xFFE8A87C);
  static const Color deepRose = Color(0xFFC4736A);
  static const Color warmTaupe = Color(0xFF8B7355);
  static const Color charcoal = Color(0xFF2D2520);

  // Accent & Functional
  static const Color goldenHour = Color(0xFFF2C46D);
  static const Color background = Color(0xFFFDF9F5);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFFB8A99A);
  static const Color success = Color(0xFF7DB87D);
  static const Color error = Color(0xFFD45C4A);

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [softAmber, deepRose],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldenHour, softAmber],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [charcoal, Color(0xFF4A3830)],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment(-0.5, -1.0),
    end: Alignment(0.5, 1.0),
    colors: [Color(0xFFF5E6D3), Color(0xFFEDD5C0), Color(0xFFE0C4A8)],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF5E6D3), background],
  );

  static const LinearGradient parchmentGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFAF5), Color(0xFFFFF8F0)],
  );

  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF8B7355).withValues(alpha: 0.08),
      blurRadius: 16,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: const Color(0xFF8B7355).withValues(alpha: 0.12),
      blurRadius: 24,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: deepRose.withValues(alpha: 0.35),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> goldButtonShadow = [
    BoxShadow(
      color: goldenHour.withValues(alpha: 0.35),
      blurRadius: 20,
      offset: const Offset(0, 6),
    ),
  ];

  // Border colors
  static Color cardBorder = softAmber.withValues(alpha: 0.15);
  static Color inputBorder = softAmber.withValues(alpha: 0.3);
  static Color divider = warmTaupe.withValues(alpha: 0.1);
}

class WasiyatiTypography {
  WasiyatiTypography._();

  // Font families
  static const String displayFont = 'Cormorant Garamond';
  static const String bodyFont = 'DM Sans';
  static const String arabicFont = 'Noto Naskh Arabic';

  // Display styles (serif, emotional)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: displayFont,
    fontSize: 42,
    fontWeight: FontWeight.w600,
    color: WasiyatiColors.charcoal,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: displayFont,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: WasiyatiColors.charcoal,
    height: 1.2,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: displayFont,
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: WasiyatiColors.charcoal,
    height: 1.3,
  );

  // Headline styles
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: displayFont,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: WasiyatiColors.charcoal,
    height: 1.3,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: displayFont,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: WasiyatiColors.charcoal,
    height: 1.3,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: displayFont,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: WasiyatiColors.charcoal,
    height: 1.3,
  );

  // Body styles (sans-serif, readable)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: WasiyatiColors.charcoal,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: WasiyatiColors.charcoal,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: bodyFont,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: WasiyatiColors.muted,
    height: 1.5,
  );

  // Label styles
  static const TextStyle labelLarge = TextStyle(
    fontFamily: bodyFont,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: WasiyatiColors.charcoal,
    letterSpacing: 0.3,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: WasiyatiColors.charcoal,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: WasiyatiColors.muted,
  );

  // Caption / overline
  static const TextStyle caption = TextStyle(
    fontFamily: bodyFont,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: WasiyatiColors.muted,
    letterSpacing: 0.5,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: bodyFont,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: WasiyatiColors.muted,
    letterSpacing: 0.5,
    height: 1.5,
  );

  // Stat number (big serif digits)
  static const TextStyle statNumber = TextStyle(
    fontFamily: displayFont,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: WasiyatiColors.charcoal,
    height: 1.0,
  );

  // Editor content (parchment style)
  static const TextStyle editorContent = TextStyle(
    fontFamily: displayFont,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: WasiyatiColors.charcoal,
    height: 1.8,
  );

  static const TextStyle editorPlaceholder = TextStyle(
    fontFamily: displayFont,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    color: WasiyatiColors.muted,
    height: 1.8,
  );

  // Arabic text
  static const TextStyle arabicDisplay = TextStyle(
    fontFamily: arabicFont,
    fontSize: 22,
    fontWeight: FontWeight.w400,
    color: WasiyatiColors.warmTaupe,
  );
}

class WasiyatiSpacing {
  WasiyatiSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 48;
}

class WasiyatiRadius {
  WasiyatiRadius._();

  static const double sm = 10;
  static const double md = 14;
  static const double lg = 18;
  static const double xl = 20;
  static const double pill = 50;
  static const double circle = 999;
}

/// Build the full MaterialApp ThemeData
ThemeData wasiyatiTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: WasiyatiColors.background,
    primaryColor: WasiyatiColors.softAmber,
    colorScheme: const ColorScheme.light(
      primary: WasiyatiColors.softAmber,
      secondary: WasiyatiColors.deepRose,
      tertiary: WasiyatiColors.goldenHour,
      surface: WasiyatiColors.background,
      error: WasiyatiColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: WasiyatiColors.charcoal,
      onError: Colors.white,
    ),
    fontFamily: WasiyatiTypography.bodyFont,
    textTheme: const TextTheme(
      displayLarge: WasiyatiTypography.displayLarge,
      displayMedium: WasiyatiTypography.displayMedium,
      displaySmall: WasiyatiTypography.displaySmall,
      headlineLarge: WasiyatiTypography.headlineLarge,
      headlineMedium: WasiyatiTypography.headlineMedium,
      headlineSmall: WasiyatiTypography.headlineSmall,
      bodyLarge: WasiyatiTypography.bodyLarge,
      bodyMedium: WasiyatiTypography.bodyMedium,
      bodySmall: WasiyatiTypography.bodySmall,
      labelLarge: WasiyatiTypography.labelLarge,
      labelMedium: WasiyatiTypography.labelMedium,
      labelSmall: WasiyatiTypography.labelSmall,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: WasiyatiColors.background,
      foregroundColor: WasiyatiColors.charcoal,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: WasiyatiTypography.headlineSmall,
    ),
    cardTheme: CardThemeData(
      color: WasiyatiColors.cardWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
        side: BorderSide(color: WasiyatiColors.cardBorder),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: WasiyatiColors.inputBorder, width: 2),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: WasiyatiColors.inputBorder, width: 2),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: WasiyatiColors.softAmber, width: 2),
      ),
      hintStyle: WasiyatiTypography.editorPlaceholder,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
    ),
    dividerTheme: DividerThemeData(
      color: WasiyatiColors.divider,
      thickness: 1,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: WasiyatiColors.cardWhite,
      selectedItemColor: WasiyatiColors.deepRose,
      unselectedItemColor: WasiyatiColors.muted,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      selectedLabelStyle: TextStyle(
        fontFamily: WasiyatiTypography.bodyFont,
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: WasiyatiTypography.bodyFont,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: WasiyatiColors.softAmber,
      foregroundColor: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(WasiyatiRadius.lg)),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: WasiyatiColors.cardWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      modalBarrierColor: WasiyatiColors.charcoal.withValues(alpha: 0.4),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: WasiyatiColors.charcoal,
      contentTextStyle: WasiyatiTypography.bodyMedium.copyWith(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(WasiyatiRadius.md),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
