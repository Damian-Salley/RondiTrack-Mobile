import 'dart:async';

import 'package:alchemist/alchemist.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final theme = GoldenTestTheme.standard();
  await AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      goldenTestTheme: GoldenTestTheme(
        backgroundColor: theme.backgroundColor,
        borderColor: theme.borderColor,
        nameTextStyle: theme.nameTextStyle.copyWith(letterSpacing: 0),
      ),
      platformGoldensConfig: PlatformGoldensConfig(
        platforms: {HostPlatform.windows},
      ),
    ),
    run: testMain,
  );
}
