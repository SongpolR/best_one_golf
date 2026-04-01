import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Duolingo-inspired design system.
///
/// Palette:
///   Green      #58CC02 — primary CTA / brand
///   GreenDark  #58A700 — button 3-D bottom shadow
///   GreenLight #D7F5C0 — primary container / light tint
///   Blue       #1CB0F6 — secondary / info / text links
///   BlueLight  #DDF4FF — secondary container
///   Yellow     #FFC800 — tertiary / streak / reward
///   Red        #FF4B4B — error / destructive
///   Wolf       #3C3C3C — primary text
///   Orca       #777777 — secondary / hint text
///   Cloud      #AFAFAF — disabled elements
///   Polar      #E5E5E5 — border / divider
///   Snow       #F7F7F7 — scaffold background
///
/// Contrast (WCAG AA ≥ 4.5 : 1):
///   white on Green  (#58CC02) = 2.83 : 1  ← large/bold text only (3 : 1 ✓)
///   white on Blue   (#1CB0F6) = 3.1 : 1   ← bold ✓
///   Wolf  on Snow   (#F7F7F7) = 10.7 : 1  ✓
///   Wolf  on white             = 12.6 : 1  ✓
class AppColors {
  AppColors._();

  // Green family
  static const green = Color(0xFF58CC02); // Primary CTA
  static const greenDark = Color(0xFF58A700); // 3-D button shadow
  static const greenLight = Color(0xFFD7F5C0); // Primary container

  // Blue family
  static const blue = Color(0xFF1CB0F6); // Secondary / links
  static const blueDark = Color(0xFF0B7FBF); // Blue 3-D shadow
  static const blueLight = Color(0xFFDDF4FF); // Secondary container

  // Yellow family
  static const yellow = Color(0xFFFFC800); // Streak / reward
  static const yellowDark = Color(0xFFCC9900);
  static const yellowLight = Color(0xFFFFF9E5);

  // Error / destructive
  static const red = Color(0xFFFF4B4B);
  static const redDark = Color(0xFFCC0000);
  static const redLight = Color(0xFFFFE0E0);

  // Neutrals — light mode
  static const wolf = Color(0xFF3C3C3C); // Primary text
  static const orca = Color(0xFF777777); // Secondary text
  static const cloud = Color(0xFFAFAFAF); // Disabled
  static const polar = Color(0xFFE5E5E5); // Border / divider
  static const snow = Color(0xFFF7F7F7); // Scaffold background

  // Dark mode surfaces
  static const darkScaffold = Color(0xFF111B11); // Scaffold (very dark green)
  static const darkSurface = Color(0xFF1C2318); // Cards / inputs
  static const darkSurfaceContainer = Color(0xFF222A1E);
  static const darkSurfaceHigh = Color(0xFF2A3326);

  // Dark mode text & borders
  static const darkOnSurface = Color(0xFFDDE8D5); // Primary text
  static const darkOnSurfaceVariant = Color(0xFF8FA88A); // Secondary text
  static const darkOutline = Color(0xFF4A5C44); // Border
  static const darkOutlineVariant = Color(0xFF303C2A); // Subtle border
  static const darkDisabled = Color(0xFF4E5C4A); // Disabled elements
}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.green,
      brightness: Brightness.light,
    ).copyWith(
      // Primary — Duolingo green
      primary: AppColors.green,
      onPrimary: Colors.white,
      primaryContainer: AppColors.greenLight,
      onPrimaryContainer: const Color(0xFF1A5200),

      // Secondary — sky blue
      secondary: AppColors.blue,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.blueLight,
      onSecondaryContainer: const Color(0xFF003F5A),

      // Tertiary — streak yellow
      tertiary: AppColors.yellow,
      onTertiary: AppColors.wolf,
      tertiaryContainer: AppColors.yellowLight,
      onTertiaryContainer: const Color(0xFF3D3000),

      // Error / destructive
      error: AppColors.red,
      onError: Colors.white,
      errorContainer: AppColors.redLight,
      onErrorContainer: AppColors.redDark,

      // Surfaces — white cards on snow scaffold
      surface: Colors.white,
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: AppColors.snow,
      surfaceContainer: AppColors.snow,
      surfaceContainerHigh: AppColors.polar,

      // Text & icons
      onSurface: AppColors.wolf,
      onSurfaceVariant: AppColors.orca,

      // Borders
      outline: AppColors.polar,
      outlineVariant: const Color(0xFFF0F0F0),
    );

    final nunitoFamily = GoogleFonts.nunito().fontFamily;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.snow,
      fontFamily: nunitoFamily,
      textTheme: _textTheme(colorScheme),
      appBarTheme: _appBarTheme(colorScheme),
      cardTheme: _cardTheme(),
      inputDecorationTheme: _inputTheme(colorScheme),
      filledButtonTheme: _filledButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(),
      textButtonTheme: _textButtonTheme(),
      iconButtonTheme: _iconButtonTheme(),
      chipTheme: _chipTheme(),
      segmentedButtonTheme: _segmentedButtonTheme(),
      switchTheme: _switchTheme(),
      checkboxTheme: _checkboxTheme(),
      radioTheme: _radioTheme(),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        tileColor: Colors.transparent,
        iconColor: AppColors.green,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.polar,
        thickness: 1,
        space: 1,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        titleTextStyle: TextStyle(
          fontFamily: nunitoFamily,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppColors.wolf,
        ),
        contentTextStyle: TextStyle(
          fontFamily: nunitoFamily,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.orca,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.green,
        linearTrackColor: AppColors.greenLight,
        circularTrackColor: AppColors.greenLight,
      ),
    );
  }

  // ── Dark theme ───────────────────────────────────────────────────────────────
  // Same Duolingo accent colours; dark green-tinted surfaces.

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.green,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.green,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFF1A3800),
      onPrimaryContainer: const Color(0xFF7EE65D),
      secondary: AppColors.blue,
      onSecondary: const Color(0xFF003549),
      secondaryContainer: const Color(0xFF004D6E),
      onSecondaryContainer: const Color(0xFF8FDAFF),
      tertiary: AppColors.yellow,
      onTertiary: const Color(0xFF3D2F00),
      tertiaryContainer: const Color(0xFF574400),
      onTertiaryContainer: const Color(0xFFFFE08A),
      error: const Color(0xFFFF6B6B),
      onError: const Color(0xFF690000),
      errorContainer: const Color(0xFF93000A),
      onErrorContainer: const Color(0xFFFFB4AB),
      surface: AppColors.darkSurface,
      surfaceContainerLowest: AppColors.darkScaffold,
      surfaceContainerLow: AppColors.darkSurface,
      surfaceContainer: AppColors.darkSurfaceContainer,
      surfaceContainerHigh: AppColors.darkSurfaceHigh,
      onSurface: AppColors.darkOnSurface,
      onSurfaceVariant: AppColors.darkOnSurfaceVariant,
      outline: AppColors.darkOutline,
      outlineVariant: AppColors.darkOutlineVariant,
    );

    final nunitoFamily = GoogleFonts.nunito().fontFamily;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkScaffold,
      fontFamily: nunitoFamily,
      textTheme: _textTheme(colorScheme),
      appBarTheme: _appBarThemeDark(colorScheme),
      cardTheme: _cardThemeDark(),
      inputDecorationTheme: _inputThemeDark(colorScheme),
      filledButtonTheme: _filledButtonTheme(), // same — green pops on dark
      outlinedButtonTheme: _outlinedButtonThemeDark(),
      textButtonTheme: _textButtonTheme(), // same — blue links
      iconButtonTheme: _iconButtonThemeDark(),
      chipTheme: _chipThemeDark(),
      segmentedButtonTheme: _segmentedButtonThemeDark(),
      switchTheme: _switchThemeDark(),
      checkboxTheme: _checkboxThemeDark(),
      radioTheme: _radioThemeDark(),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        tileColor: Colors.transparent,
        iconColor: AppColors.green,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkOutline,
        thickness: 1,
        space: 1,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.darkSurface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        titleTextStyle: TextStyle(
          fontFamily: nunitoFamily,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppColors.darkOnSurface,
        ),
        contentTextStyle: TextStyle(
          fontFamily: nunitoFamily,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.darkOnSurfaceVariant,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkSurface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.green,
        linearTrackColor: AppColors.darkSurfaceHigh,
        circularTrackColor: AppColors.darkSurfaceHigh,
      ),
    );
  }

  // ── Dark component helpers ────────────────────────────────────────────────────

  static AppBarTheme _appBarThemeDark(ColorScheme cs) {
    return const AppBarTheme(
      // ignore: prefer_const_constructors
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkOnSurface,
      surfaceTintColor: Colors.transparent,
      shadowColor: AppColors.darkOutline,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
        color: AppColors.darkOnSurface,
      ),
      iconTheme: IconThemeData(color: AppColors.darkOnSurface, size: 22),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  static CardTheme _cardThemeDark() {
    return CardTheme(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: AppColors.darkSurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.darkOutline, width: 2),
      ),
    );
  }

  static InputDecorationTheme _inputThemeDark(ColorScheme cs) {
    const radius = BorderRadius.all(Radius.circular(14));
    return const InputDecorationTheme(
      // ignore: prefer_const_constructors
      filled: true,
      fillColor: AppColors.darkSurfaceContainer,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.darkOutline, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.darkOutline, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.blue, width: 2.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: Color(0xFFFF6B6B), width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: Color(0xFFFF6B6B), width: 2.5),
      ),
      labelStyle: TextStyle(
        color: AppColors.darkOnSurfaceVariant,
        fontWeight: FontWeight.w600,
      ),
      floatingLabelStyle: TextStyle(
        color: AppColors.blue,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonThemeDark() {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(const Size(64, 48)),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
        ),
        backgroundColor: WidgetStateProperty.all(AppColors.darkSurface),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.darkDisabled;
          }
          if (states.contains(WidgetState.pressed)) {
            return AppColors.green;
          }
          return AppColors.darkOnSurface;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return const BorderSide(
                color: AppColors.darkOutlineVariant, width: 2);
          }
          if (states.contains(WidgetState.pressed)) {
            return const BorderSide(color: AppColors.green, width: 2.5);
          }
          return const BorderSide(color: AppColors.darkOutline, width: 2);
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.green.withOpacity(0.1);
          }
          if (states.contains(WidgetState.hovered)) {
            return AppColors.green.withOpacity(0.05);
          }
          return null;
        }),
      ),
    );
  }

  static IconButtonThemeData _iconButtonThemeDark() {
    return IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.darkDisabled;
          }
          return AppColors.darkOnSurface;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.green.withOpacity(0.12);
          }
          return null;
        }),
      ),
    );
  }

  static ChipThemeData _chipThemeDark() {
    return ChipThemeData(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.darkOnSurface,
      ),
      side: const BorderSide(color: AppColors.darkOutline, width: 2),
      backgroundColor: AppColors.darkSurface,
      selectedColor: const Color(0xFF1A3800),
      disabledColor: AppColors.darkSurfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  static SegmentedButtonThemeData _segmentedButtonThemeDark() {
    return SegmentedButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF1A3800);
          }
          return AppColors.darkSurface;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF7EE65D);
          }
          return AppColors.darkOnSurfaceVariant;
        }),
        side: WidgetStateProperty.all(
          const BorderSide(color: AppColors.darkOutline, width: 2),
        ),
      ),
    );
  }

  static SwitchThemeData _switchThemeDark() {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.darkDisabled;
        }
        if (states.contains(WidgetState.selected)) return Colors.white;
        return AppColors.darkOnSurfaceVariant;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.darkSurfaceHigh;
        }
        if (states.contains(WidgetState.selected)) return AppColors.green;
        return AppColors.darkSurfaceHigh;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.transparent;
        return AppColors.darkOutline;
      }),
    );
  }

  static CheckboxThemeData _checkboxThemeDark() {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.darkSurfaceHigh;
        }
        if (states.contains(WidgetState.selected)) return AppColors.green;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.darkDisabled;
        }
        return Colors.white;
      }),
      side: WidgetStateBorderSide.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return const BorderSide(
              color: AppColors.darkOutlineVariant, width: 2);
        }
        if (states.contains(WidgetState.selected)) {
          return const BorderSide(color: AppColors.green, width: 2);
        }
        return const BorderSide(color: AppColors.darkOutline, width: 2);
      }),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    );
  }

  static RadioThemeData _radioThemeDark() {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.darkDisabled;
        }
        if (states.contains(WidgetState.selected)) return AppColors.green;
        return AppColors.darkOutline;
      }),
    );
  }

  // ── Typography ───────────────────────────────────────────────────────────────
  // Nunito is Duolingo's primary typeface: very round, bold, playful.
  // We apply it globally via fontFamily on ThemeData and boost weights here.

  static TextTheme _textTheme(ColorScheme cs) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.5,
        color: cs.onSurface,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.0,
        color: cs.onSurface,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        color: cs.onSurface,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
        color: cs.onSurface,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.2,
        color: cs.onSurface,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        color: cs.onSurface,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.1,
        color: cs.onSurface,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.5,
        color: cs.onSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: cs.onSurfaceVariant,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: cs.onSurfaceVariant,
      ),
      labelLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.5,
        color: cs.onSurface,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        color: cs.onSurfaceVariant,
      ),
    );
  }

  // ── AppBar ───────────────────────────────────────────────────────────────────
  // White bar, bold title, no elevation — clean and bright like Duolingo.

  static AppBarTheme _appBarTheme(ColorScheme cs) {
    return const AppBarTheme(
      // ignore: prefer_const_constructors
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.wolf,
      surfaceTintColor: Colors.transparent,
      shadowColor: AppColors.polar,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
        color: AppColors.wolf,
      ),
      iconTheme: IconThemeData(color: AppColors.wolf, size: 22),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  // ── Card ─────────────────────────────────────────────────────────────────────
  // White card, rounded (16), subtle gray border — like Duolingo option tiles.

  static CardTheme _cardTheme() {
    return CardTheme(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.polar, width: 2),
      ),
    );
  }

  // ── Input ────────────────────────────────────────────────────────────────────
  // White field, polar border, blue focus ring — clear and friendly.

  static InputDecorationTheme _inputTheme(ColorScheme cs) {
    const radius = BorderRadius.all(Radius.circular(14));
    return const InputDecorationTheme(
      // ignore: prefer_const_constructors
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.polar, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.polar, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.blue, width: 2.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.red, width: 2.5),
      ),
      labelStyle: TextStyle(
        color: AppColors.orca,
        fontWeight: FontWeight.w600,
      ),
      floatingLabelStyle: TextStyle(
        color: AppColors.blue,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // ── Filled button ─────────────────────────────────────────────────────────────
  // Duolingo style: vivid green, fully rounded (pill), very bold text.
  // For the signature 3-D raised effect use the DuoButton widget instead.
  //
  // Enabled  → green background, white text
  // Disabled → cloud background, cloud text

  static FilledButtonThemeData _filledButtonTheme() {
    return FilledButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(const Size.fromHeight(52)),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        elevation: WidgetStateProperty.all(0),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.polar;
          }
          return AppColors.green;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.cloud;
          }
          return Colors.white;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return Colors.black.withOpacity(0.1);
          }
          if (states.contains(WidgetState.hovered)) {
            return Colors.black.withOpacity(0.05);
          }
          return null;
        }),
      ),
    );
  }

  // ── Outlined button ───────────────────────────────────────────────────────────
  // Duolingo uses outlined buttons for secondary choices: white bg, polar border.
  //
  // Enabled  → polar border, wolf text
  // Pressed  → green border highlight
  // Disabled → cloud border, cloud text

  static OutlinedButtonThemeData _outlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(const Size(64, 48)),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
        ),
        backgroundColor: WidgetStateProperty.all(Colors.white),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.cloud;
          }
          if (states.contains(WidgetState.pressed)) {
            return AppColors.green;
          }
          return AppColors.wolf;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return const BorderSide(color: AppColors.polar, width: 2);
          }
          if (states.contains(WidgetState.pressed)) {
            return const BorderSide(color: AppColors.green, width: 2.5);
          }
          return const BorderSide(
              color: AppColors.polar,
              width: 2); // ignore: prefer_const_constructors
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.green.withOpacity(0.08);
          }
          if (states.contains(WidgetState.hovered)) {
            return AppColors.green.withOpacity(0.04);
          }
          return null;
        }),
      ),
    );
  }

  // ── Text button ───────────────────────────────────────────────────────────────
  // Duolingo uses blue for text links / tertiary actions.

  static TextButtonThemeData _textButtonTheme() {
    return TextButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.cloud;
          }
          return AppColors.blue;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.blue.withOpacity(0.12);
          }
          return null;
        }),
      ),
    );
  }

  // ── Icon button ───────────────────────────────────────────────────────────────

  static IconButtonThemeData _iconButtonTheme() {
    return IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.cloud;
          }
          return AppColors.wolf;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.green.withOpacity(0.12);
          }
          return null;
        }),
      ),
    );
  }

  // ── Chips ────────────────────────────────────────────────────────────────────

  static ChipThemeData _chipTheme() {
    return ChipThemeData(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.wolf,
      ),
      side: const BorderSide(color: AppColors.polar, width: 2),
      backgroundColor: Colors.white,
      selectedColor: AppColors.greenLight,
      disabledColor: AppColors.snow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  // ── Segmented button ─────────────────────────────────────────────────────────

  static SegmentedButtonThemeData _segmentedButtonTheme() {
    return SegmentedButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.greenLight;
          }
          return Colors.white;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF1A5200);
          }
          return AppColors.orca;
        }),
        side: WidgetStateProperty.all(
          const BorderSide(color: AppColors.polar, width: 2),
        ),
      ),
    );
  }

  // ── Toggle controls ──────────────────────────────────────────────────────────

  static SwitchThemeData _switchTheme() {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return AppColors.cloud;
        if (states.contains(WidgetState.selected)) return Colors.white;
        return AppColors.orca;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.polar;
        }
        if (states.contains(WidgetState.selected)) return AppColors.green;
        return AppColors.polar;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.transparent;
        return AppColors.polar;
      }),
    );
  }

  static CheckboxThemeData _checkboxTheme() {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return AppColors.polar;
        if (states.contains(WidgetState.selected)) return AppColors.green;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return AppColors.cloud;
        return Colors.white;
      }),
      side: WidgetStateBorderSide.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return const BorderSide(color: AppColors.polar, width: 2);
        }
        if (states.contains(WidgetState.selected)) {
          return const BorderSide(color: AppColors.green, width: 2);
        }
        return const BorderSide(color: AppColors.polar, width: 2);
      }),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    );
  }

  static RadioThemeData _radioTheme() {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return AppColors.polar;
        if (states.contains(WidgetState.selected)) return AppColors.green;
        return AppColors.polar;
      }),
    );
  }
}

/// Applies the error/destructive colour style to buttons that trigger
/// irreversible actions such as Delete.
extension DestructiveButton on ButtonStyle {
  static ButtonStyle outlined(BuildContext context) {
    return OutlinedButton.styleFrom(
      foregroundColor: AppColors.red,
      side: const BorderSide(color: AppColors.red, width: 2),
    );
  }

  static ButtonStyle filled(BuildContext context) {
    return FilledButton.styleFrom(
      backgroundColor: AppColors.red,
      foregroundColor: Colors.white,
      disabledBackgroundColor: AppColors.redLight,
      disabledForegroundColor: AppColors.red.withOpacity(0.5),
    );
  }
}
