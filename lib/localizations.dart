import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

class initLocalizations {
  final String localeName;

  // Marca los campos como 'late'
  late YamlMap translations;
  late YamlMap translationsFallback;

  initLocalizations(this.localeName);

  static const LocalizationsDelegate<initLocalizations> delegate =
      _initLocalizationsDelegate();

  Future<void> load() async {
    String yamlString = await rootBundle.loadString('lang/$localeName.yml');
    translations = loadYaml(yamlString);

    String yamlString1 = await rootBundle.loadString('lang/en.yml');
    translationsFallback = loadYaml(yamlString1);
  }

  dynamic t(String key) {
    try {
      var keys = key.split(".");
      dynamic translated = translations;
      keys.forEach((k) => translated = translated[k]);

      if (translated == null) {
        return _fallback(key);
      }
      return translated;
    } catch (e) {
      return _fallback(key);
    }
  }

  dynamic _fallback(String key) {
    try {
      var keys = key.split(".");
      dynamic translated = translationsFallback;
      keys.forEach((k) => translated = translated[k]);

      if (translated == null) {
        return "Key not found....: $key";
      }
      return translated;
    } catch (e) {
      return "Key not found: $key";
    }
  }

  // Devuelve 'initLocalizations?' ya que puede ser nulo
  static initLocalizations? of(BuildContext context) {
    // Usa la función estática 'Localizations.of' de Flutter
    return Localizations.of<initLocalizations>(context, initLocalizations);
  }
}

class _initLocalizationsDelegate
    extends LocalizationsDelegate<initLocalizations> {
  const _initLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    print(locale.languageCode);
    return ['es', 'en'].contains(locale.languageCode);
  }

  @override
  Future<initLocalizations> load(Locale locale) async {
    var t = initLocalizations(locale.languageCode);
    await t.load();
    return t;
  }

  @override
  bool shouldReload(LocalizationsDelegate<initLocalizations> old) {
    return false;
  }
}
