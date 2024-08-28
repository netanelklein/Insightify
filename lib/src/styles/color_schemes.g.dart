import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4281755966),
      surfaceTint: Color(4281755966),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4290245050),
      onPrimaryContainer: Color(4278198537),
      secondary: Color(4281690430),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4290245050),
      onSecondaryContainer: Color(4278198537),
      tertiary: Color(4278216820),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4288606205),
      onTertiaryContainer: Color(4278198052),
      error: Color(4287646275),
      onError: Color(4294967295),
      errorContainer: Color(4294957781),
      onErrorContainer: Color(4282059015),
      surface: Color(4294441970),
      onSurface: Color(4279770392),
      onSurfaceVariant: Color(4282534208),
      outline: Color(4285692272),
      outlineVariant: Color(4290890174),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281152044),
      inversePrimary: Color(4288468127),
      primaryFixed: Color(4290245050),
      onPrimaryFixed: Color(4278198537),
      primaryFixedDim: Color(4288468127),
      onPrimaryFixedVariant: Color(4280111400),
      secondaryFixed: Color(4290245050),
      onSecondaryFixed: Color(4278198537),
      secondaryFixedDim: Color(4288468128),
      onSecondaryFixedVariant: Color(4280045865),
      tertiaryFixed: Color(4288606205),
      onTertiaryFixed: Color(4278198052),
      tertiaryFixedDim: Color(4286764000),
      onTertiaryFixedVariant: Color(4278210391),
      surfaceDim: Color(4292336595),
      surfaceBright: Color(4294441970),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294047212),
      surfaceContainer: Color(4293652455),
      surfaceContainerHigh: Color(4293257697),
      surfaceContainerHighest: Color(4292928731),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4279782693),
      surfaceTint: Color(4281755966),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4283203666),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4279717157),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4283138131),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4278209107),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4280647820),
      onTertiaryContainer: Color(4294967295),
      error: Color(4285411370),
      onError: Color(4294967295),
      errorContainer: Color(4289355863),
      onErrorContainer: Color(4294967295),
      surface: Color(4294441970),
      onSurface: Color(4279770392),
      onSurfaceVariant: Color(4282271037),
      outline: Color(4284113240),
      outlineVariant: Color(4285889907),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281152044),
      inversePrimary: Color(4288468127),
      primaryFixed: Color(4283203666),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4281558844),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4283138131),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4281558844),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4280647820),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4278216305),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292336595),
      surfaceBright: Color(4294441970),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294047212),
      surfaceContainer: Color(4293652455),
      surfaceContainerHigh: Color(4293257697),
      surfaceContainerHighest: Color(4292928731),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278200588),
      surfaceTint: Color(4281755966),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4279782693),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4278200589),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4279717157),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4278200108),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4278209107),
      onTertiaryContainer: Color(4294967295),
      error: Color(4282650636),
      onError: Color(4294967295),
      errorContainer: Color(4285411370),
      onErrorContainer: Color(4294967295),
      surface: Color(4294441970),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4280231455),
      outline: Color(4282271037),
      outlineVariant: Color(4282271037),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281152044),
      inversePrimary: Color(4290837187),
      primaryFixed: Color(4279782693),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4278203666),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4279717157),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4278203666),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4278209107),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4278202936),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292336595),
      surfaceBright: Color(4294441970),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294047212),
      surfaceContainer: Color(4293652455),
      surfaceContainerHigh: Color(4293257697),
      surfaceContainerHighest: Color(4292928731),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4288468127),
      surfaceTint: Color(4288468127),
      onPrimary: Color(4278204692),
      primaryContainer: Color(4280111400),
      onPrimaryContainer: Color(4290245050),
      secondary: Color(4288468128),
      onSecondary: Color(4278204692),
      secondaryContainer: Color(4280045865),
      onSecondaryContainer: Color(4290245050),
      tertiary: Color(4286764000),
      onTertiary: Color(4278203965),
      tertiaryContainer: Color(4278210391),
      onTertiaryContainer: Color(4288606205),
      error: Color(4294948011),
      onError: Color(4283833881),
      errorContainer: Color(4285740077),
      onErrorContainer: Color(4294957781),
      surface: Color(4279244048),
      onSurface: Color(4292928731),
      onSurfaceVariant: Color(4290890174),
      outline: Color(4287337353),
      outlineVariant: Color(4282534208),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292928731),
      inversePrimary: Color(4281755966),
      primaryFixed: Color(4290245050),
      onPrimaryFixed: Color(4278198537),
      primaryFixedDim: Color(4288468127),
      onPrimaryFixedVariant: Color(4280111400),
      secondaryFixed: Color(4290245050),
      onSecondaryFixed: Color(4278198537),
      secondaryFixedDim: Color(4288468128),
      onSecondaryFixedVariant: Color(4280045865),
      tertiaryFixed: Color(4288606205),
      onTertiaryFixed: Color(4278198052),
      tertiaryFixedDim: Color(4286764000),
      onTertiaryFixedVariant: Color(4278210391),
      surfaceDim: Color(4279244048),
      surfaceBright: Color(4281743925),
      surfaceContainerLowest: Color(4278914827),
      surfaceContainerLow: Color(4279770392),
      surfaceContainer: Color(4280033564),
      surfaceContainerHigh: Color(4280757030),
      surfaceContainerHighest: Color(4281415216),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4288731299),
      surfaceTint: Color(4288468127),
      onPrimary: Color(4278196998),
      primaryContainer: Color(4284980589),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4288731300),
      onSecondary: Color(4278196998),
      secondaryContainer: Color(4284980589),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4287027172),
      onTertiary: Color(4278196765),
      tertiaryContainer: Color(4282948777),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281533443),
      errorContainer: Color(4291591026),
      onErrorContainer: Color(4278190080),
      surface: Color(4279244048),
      onSurface: Color(4294507763),
      onSurfaceVariant: Color(4291218882),
      outline: Color(4288587163),
      outlineVariant: Color(4286481788),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292928731),
      inversePrimary: Color(4280177193),
      primaryFixed: Color(4290245050),
      onPrimaryFixed: Color(4278195460),
      primaryFixedDim: Color(4288468127),
      onPrimaryFixedVariant: Color(4278664985),
      secondaryFixed: Color(4290245050),
      onSecondaryFixed: Color(4278195460),
      secondaryFixedDim: Color(4288468128),
      onSecondaryFixedVariant: Color(4278599449),
      tertiaryFixed: Color(4288606205),
      onTertiaryFixed: Color(4278195223),
      tertiaryFixedDim: Color(4286764000),
      onTertiaryFixedVariant: Color(4278205508),
      surfaceDim: Color(4279244048),
      surfaceBright: Color(4281743925),
      surfaceContainerLowest: Color(4278914827),
      surfaceContainerLow: Color(4279770392),
      surfaceContainer: Color(4280033564),
      surfaceContainerHigh: Color(4280757030),
      surfaceContainerHighest: Color(4281415216),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4293984236),
      surfaceTint: Color(4288468127),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4288731299),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4293984236),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4288731300),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294049279),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4287027172),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4279244048),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294376945),
      outline: Color(4291218882),
      outlineVariant: Color(4291218882),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292928731),
      inversePrimary: Color(4278202896),
      primaryFixed: Color(4290508222),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4288731299),
      onPrimaryFixedVariant: Color(4278196998),
      secondaryFixed: Color(4290508222),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4288731300),
      onSecondaryFixedVariant: Color(4278196998),
      tertiaryFixed: Color(4289393663),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4287027172),
      onTertiaryFixedVariant: Color(4278196765),
      surfaceDim: Color(4279244048),
      surfaceBright: Color(4281743925),
      surfaceContainerLowest: Color(4278914827),
      surfaceContainerLow: Color(4279770392),
      surfaceContainer: Color(4280033564),
      surfaceContainerHigh: Color(4280757030),
      surfaceContainerHighest: Color(4281415216),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.background,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
