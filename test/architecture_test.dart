import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// No exceptions. Add any future exception here with its reason and end week,
// alongside an expiry assertion; do not silently skip an offending file.
List<String> architectureViolations(String path, String source) {
  final violations = <String>[];
  if (RegExp(
    r'\b(Color|Colors|MaterialColor|MaterialAccentColor|CupertinoColors|'
    r'HSLColor|HSVColor)\b|0[xX][0-9a-fA-F]{6,8}\b|#[0-9a-fA-F]{3,8}\b',
  ).hasMatch(source)) {
    violations.add('$path: use app theme tokens instead of typing a colour');
  }
  final screen =
      path.endsWith('_screen.dart') ||
      RegExp(r'\bclass\s+\w*Screen\b').hasMatch(source);
  if (screen || path.contains('/presentation/') || path.contains('/domain/')) {
    final imports = RegExp("(?:import|export)\\s+['\"]([^'\"]+)['\"]")
        .allMatches(source)
        .map((match) => match[1]!);
    for (final import in imports) {
      final transport = RegExp(r'(^|/)generated/|^package:(dio|retrofit)(/|\.)')
          .hasMatch(import);
      final screenData =
          screen && RegExp(r'(^|/)data/|^package:drift(/|\.)').hasMatch(import);
      if (transport || screenData) {
        violations.add('$path: imports $import');
      }
    }
  }
  return violations;
}

void main() {
  test('architecture: feature colours and screen data boundaries', () {
    final violations = <String>[];
    for (final file
        in Directory('lib/features')
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))) {
      violations.addAll(
        architectureViolations(
          file.path.replaceAll(r'\', '/'),
          file.readAsStringSync(),
        ),
      );
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test(
    'architecture: guard detects each prohibited dependency and colour form',
    () {
      for (final source in [
        'final color = Color(0xFF123456);',
        'final color = Colors.green;',
        'final color = ui.Color.fromARGB(255, 1, 2, 3);',
        'final color = HSVColor.fromAHSV(1, 1, 1, 1);',
        "import '../data/fake_repository.dart';",
        "import 'package:dio/dio.dart';",
        "import 'package:drift/drift.dart';",
      ]) {
        expect(
          architectureViolations('lib/features/x/x_screen.dart', source),
          isNotEmpty,
          reason: source,
        );
      }
      expect(
        architectureViolations(
          'lib/features/x/x_screen.dart',
          'final color = Theme.of(context).colorScheme.primary;',
        ),
        isEmpty,
      );
      expect(
        architectureViolations(
          'lib/features/x/providers.dart',
          "import 'data/fake_repository.dart';",
        ),
        isEmpty,
      );
    },
  );
}
