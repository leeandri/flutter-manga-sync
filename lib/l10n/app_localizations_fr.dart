// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Manga Sync';

  @override
  String get favorites => 'Favoris';

  @override
  String get noFavorites => 'Aucun manga favori enregistré pour le moment.';
}
