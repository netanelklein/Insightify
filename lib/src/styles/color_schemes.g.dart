import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff36693e),
      surfaceTint: Color(0xff36693e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffb7f1ba),
      onPrimaryContainer: Color(0xff002109),
      secondary: Color(0xff35693e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffb7f1ba),
      onSecondaryContainer: Color(0xff002109),
      tertiary: Color(0xff006874),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff9eeffd),
      onTertiaryContainer: Color(0xff001f24),
      error: Color(0xff904a43),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad5),
      onErrorContainer: Color(0xff3b0907),
      surface: Color(0xfff7fbf2),
      onSurface: Color(0xff181d18),
      onSurfaceVariant: Color(0xff424940),
      outline: Color(0xff727970),
      outlineVariant: Color(0xffc1c9be),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322c),
      inversePrimary: Color(0xff9cd49f),
      primaryFixed: Color(0xffb7f1ba),
      onPrimaryFixed: Color(0xff002109),
      primaryFixedDim: Color(0xff9cd49f),
      onPrimaryFixedVariant: Color(0xff1d5128),
      secondaryFixed: Color(0xffb7f1ba),
      onSecondaryFixed: Color(0xff002109),
      secondaryFixedDim: Color(0xff9cd4a0),
      onSecondaryFixedVariant: Color(0xff1c5129),
      tertiaryFixed: Color(0xff9eeffd),
      onTertiaryFixed: Color(0xff001f24),
      tertiaryFixedDim: Color(0xff82d3e0),
      onTertiaryFixedVariant: Color(0xff004f57),
      surfaceDim: Color(0xffd7dbd3),
      surfaceBright: Color(0xfff7fbf2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f5ec),
      surfaceContainer: Color(0xffebefe7),
      surfaceContainerHigh: Color(0xffe5e9e1),
      surfaceContainerHighest: Color(0xffe0e4db),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff184d25),
      surfaceTint: Color(0xff36693e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff4c8052),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff174d25),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff4b8053),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff004a53),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff25808c),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff6e302a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffaa6057),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff7fbf2),
      onSurface: Color(0xff181d18),
      onSurfaceVariant: Color(0xff3e453d),
      outline: Color(0xff5a6158),
      outlineVariant: Color(0xff757d73),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322c),
      inversePrimary: Color(0xff9cd49f),
      primaryFixed: Color(0xff4c8052),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff33673c),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff4b8053),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff33673c),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff25808c),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff006671),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd7dbd3),
      surfaceBright: Color(0xfff7fbf2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f5ec),
      surfaceContainer: Color(0xffebefe7),
      surfaceContainerHigh: Color(0xffe5e9e1),
      surfaceContainerHighest: Color(0xffe0e4db),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff00290c),
      surfaceTint: Color(0xff36693e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff184d25),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff00290d),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff174d25),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff00272c),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff004a53),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff44100c),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff6e302a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff7fbf2),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff1f261f),
      outline: Color(0xff3e453d),
      outlineVariant: Color(0xff3e453d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322c),
      inversePrimary: Color(0xffc0fac3),
      primaryFixed: Color(0xff184d25),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003512),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff174d25),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff003512),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff004a53),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff003238),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd7dbd3),
      surfaceBright: Color(0xfff7fbf2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f5ec),
      surfaceContainer: Color(0xffebefe7),
      surfaceContainerHigh: Color(0xffe5e9e1),
      surfaceContainerHighest: Color(0xffe0e4db),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff9cd49f),
      surfaceTint: Color(0xff9cd49f),
      onPrimary: Color(0xff003914),
      primaryContainer: Color(0xff1d5128),
      onPrimaryContainer: Color(0xffb7f1ba),
      secondary: Color(0xff9cd4a0),
      onSecondary: Color(0xff003914),
      secondaryContainer: Color(0xff1c5129),
      onSecondaryContainer: Color(0xffb7f1ba),
      tertiary: Color(0xff82d3e0),
      onTertiary: Color(0xff00363d),
      tertiaryContainer: Color(0xff004f57),
      onTertiaryContainer: Color(0xff9eeffd),
      error: Color(0xffffb4ab),
      onError: Color(0xff561e19),
      errorContainer: Color(0xff73342d),
      onErrorContainer: Color(0xffffdad5),
      surface: Color(0xff101510),
      onSurface: Color(0xffe0e4db),
      onSurfaceVariant: Color(0xffc1c9be),
      outline: Color(0xff8b9389),
      outlineVariant: Color(0xff424940),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4db),
      inversePrimary: Color(0xff36693e),
      primaryFixed: Color(0xffb7f1ba),
      onPrimaryFixed: Color(0xff002109),
      primaryFixedDim: Color(0xff9cd49f),
      onPrimaryFixedVariant: Color(0xff1d5128),
      secondaryFixed: Color(0xffb7f1ba),
      onSecondaryFixed: Color(0xff002109),
      secondaryFixedDim: Color(0xff9cd4a0),
      onSecondaryFixedVariant: Color(0xff1c5129),
      tertiaryFixed: Color(0xff9eeffd),
      onTertiaryFixed: Color(0xff001f24),
      tertiaryFixedDim: Color(0xff82d3e0),
      onTertiaryFixedVariant: Color(0xff004f57),
      surfaceDim: Color(0xff101510),
      surfaceBright: Color(0xff363a35),
      surfaceContainerLowest: Color(0xff0b0f0b),
      surfaceContainerLow: Color(0xff181d18),
      surfaceContainer: Color(0xff1c211c),
      surfaceContainerHigh: Color(0xff272b26),
      surfaceContainerHighest: Color(0xff313630),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffa0d8a3),
      surfaceTint: Color(0xff9cd49f),
      onPrimary: Color(0xff001b06),
      primaryContainer: Color(0xff679d6d),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffa0d8a4),
      onSecondary: Color(0xff001b06),
      secondaryContainer: Color(0xff679d6d),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xff86d7e4),
      onTertiary: Color(0xff001a1d),
      tertiaryContainer: Color(0xff489ca9),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff330403),
      errorContainer: Color(0xffcc7b72),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff101510),
      onSurface: Color(0xfff8fcf3),
      onSurfaceVariant: Color(0xffc6cdc2),
      outline: Color(0xff9ea59b),
      outlineVariant: Color(0xff7e857c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4db),
      inversePrimary: Color(0xff1e5229),
      primaryFixed: Color(0xffb7f1ba),
      onPrimaryFixed: Color(0xff001504),
      primaryFixedDim: Color(0xff9cd49f),
      onPrimaryFixedVariant: Color(0xff073f19),
      secondaryFixed: Color(0xffb7f1ba),
      onSecondaryFixed: Color(0xff001504),
      secondaryFixedDim: Color(0xff9cd4a0),
      onSecondaryFixedVariant: Color(0xff063f19),
      tertiaryFixed: Color(0xff9eeffd),
      onTertiaryFixed: Color(0xff001417),
      tertiaryFixedDim: Color(0xff82d3e0),
      onTertiaryFixedVariant: Color(0xff003c44),
      surfaceDim: Color(0xff101510),
      surfaceBright: Color(0xff363a35),
      surfaceContainerLowest: Color(0xff0b0f0b),
      surfaceContainerLow: Color(0xff181d18),
      surfaceContainer: Color(0xff1c211c),
      surfaceContainerHigh: Color(0xff272b26),
      surfaceContainerHighest: Color(0xff313630),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff0ffec),
      surfaceTint: Color(0xff9cd49f),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffa0d8a3),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfff0ffec),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffa0d8a4),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff1fdff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff86d7e4),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff101510),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfff6fdf1),
      outline: Color(0xffc6cdc2),
      outlineVariant: Color(0xffc6cdc2),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4db),
      inversePrimary: Color(0xff003210),
      primaryFixed: Color(0xffbbf5be),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffa0d8a3),
      onPrimaryFixedVariant: Color(0xff001b06),
      secondaryFixed: Color(0xffbbf5be),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffa0d8a4),
      onSecondaryFixedVariant: Color(0xff001b06),
      tertiaryFixed: Color(0xffaaf3ff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xff86d7e4),
      onTertiaryFixedVariant: Color(0xff001a1d),
      surfaceDim: Color(0xff101510),
      surfaceBright: Color(0xff363a35),
      surfaceContainerLowest: Color(0xff0b0f0b),
      surfaceContainerLow: Color(0xff181d18),
      surfaceContainer: Color(0xff1c211c),
      surfaceContainerHigh: Color(0xff272b26),
      surfaceContainerHighest: Color(0xff313630),
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
        scaffoldBackgroundColor: colorScheme.surface,
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
