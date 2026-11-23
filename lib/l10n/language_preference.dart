import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final languagePreferencesProvider = Provider<SharedPreferencesAsync?>(
  (_) => null,
);

final languageProvider = AsyncNotifierProvider<LanguagePreference, Locale?>(
  LanguagePreference.new,
);

class LanguagePreference extends AsyncNotifier<Locale?> {
  static const _key = 'language';

  @override
  Future<Locale?> build() async {
    final code = await ref.watch(languagePreferencesProvider)?.getString(_key);
    return switch (code) {
      'en' => const Locale('en'),
      'af' => const Locale('af'),
      _ => null,
    };
  }

  Future<void> choose(String? code) async {
    final preferences = ref.read(languagePreferencesProvider);
    if (code == null) {
      await preferences?.remove(_key);
    } else {
      await preferences?.setString(_key, code);
    }
    state = AsyncData(code == null ? null : Locale(code));
  }
}
