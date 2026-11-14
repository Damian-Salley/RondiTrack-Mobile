import 'package:flutter/material.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/status.dart';

const rondiSeed = Color(0xFF186B52);

/// Status foregrounds are always painted on the theme's surface colour.
@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  const new({
    required this.contributions,
    required this.cycles,
    required this.arrears,
  });

  final Map<ContributionStatus, Color> contributions;
  final Map<CycleStatus, Color> cycles;
  final Color arrears;

  static const light = StatusColors(
    contributions: {
      ContributionStatus.pending: Color(0xFF6B4800),
      ContributionStatus.paid: Color(0xFF174EA6),
      ContributionStatus.confirmed: Color(0xFF14633E),
      ContributionStatus.unknown: Color(0xFF43525F),
    },
    cycles: {
      CycleStatus.active: Color(0xFF14633E),
      CycleStatus.closed: Color(0xFF6B4800),
      CycleStatus.paid: Color(0xFF174EA6),
      CycleStatus.unknown: Color(0xFF43525F),
    },
    arrears: Color(0xFF9B2424),
  );

  static const dark = StatusColors(
    contributions: {
      ContributionStatus.pending: Color(0xFFFFD180),
      ContributionStatus.paid: Color(0xFFA8C7FA),
      ContributionStatus.confirmed: Color(0xFF8FD9AD),
      ContributionStatus.unknown: Color(0xFFCBD5E1),
    },
    cycles: {
      CycleStatus.active: Color(0xFF8FD9AD),
      CycleStatus.closed: Color(0xFFFFD180),
      CycleStatus.paid: Color(0xFFA8C7FA),
      CycleStatus.unknown: Color(0xFFCBD5E1),
    },
    arrears: Color(0xFFFFB4AB),
  );

  @override
  StatusColors copyWith({
    Map<ContributionStatus, Color>? contributions,
    Map<CycleStatus, Color>? cycles,
    Color? arrears,
  }) => StatusColors(
    contributions: contributions ?? this.contributions,
    cycles: cycles ?? this.cycles,
    arrears: arrears ?? this.arrears,
  );

  @override
  StatusColors lerp(StatusColors? other, double t) {
    if (other == null) return this;
    return StatusColors(
      contributions: {
        for (final status in ContributionStatus.values)
          status: Color.lerp(
            contributions[status],
            other.contributions[status],
            t,
          )!,
      },
      cycles: {
        for (final status in CycleStatus.values)
          status: Color.lerp(cycles[status], other.cycles[status], t)!,
      },
      arrears: Color.lerp(arrears, other.arrears, t)!,
    );
  }
}

ThemeData rondiTheme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(
    seedColor: rondiSeed,
    brightness: brightness,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    extensions: [
      if (brightness == Brightness.light)
        StatusColors.light
      else
        StatusColors.dark,
    ],
    // Use the same measured surface behind status text and control outlines.
    cardTheme: CardThemeData(color: scheme.surface),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(side: BorderSide(color: scheme.outline)),
    ),
  );
}
