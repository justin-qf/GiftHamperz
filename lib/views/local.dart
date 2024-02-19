import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:gifthamperz/views/l10n/messages_all.dart' as l10n;

// class AppLocalizations {
//   static Future<AppLocalizations> load(Locale locale) async {
//     final String name =
//         locale.countryCode!.isEmpty ? locale.languageCode : locale.toString();
//     final String localeName = Intl.canonicalizedLocale(name);

//     final localeDelegates = AppLocalizations();

//     await initializeMessages(localeName).then((_) {
//       // Initialize messages for the specific locale
//     });
//     return localeDelegates;
//   }

//   // static Future<AppLocalizations> load(Locale locale) async {
//   //   final String name = (locale.languageCode == 'en') ? 'en' : 'default';
//   //   final String localeName =
//   //       (locale.countryCode.isEmpty) ? locale.languageCode : locale.toString();

//   //   final localeDelegates = AppLocalizations();
//   //   await initializeMessages(localeName).then((_) {
//   //     // Initialize messages for the specific locale
//   //   });
//   //   return localeDelegates;
//   // }

//   static const LocalizationsDelegate<AppLocalizations> delegate =
//       _AppLocalizationsDelegate();

//   String translate(String key) {
//     return Intl.message(
//       key,
//       name: key,
//       desc: 'Translate a key',
//     );
//   }

//   static of(BuildContext context) {}
// }

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  String translate(String key) {
    return Intl.message(
      key,
      locale: locale.toString(),
    );
  }

  static of(BuildContext context) {}
}

// class _AppLocalizationsDelegate
//     extends LocalizationsDelegate<AppLocalizations> {
//   const _AppLocalizationsDelegate();

//   @override
//   bool isSupported(Locale locale) {
//     return ['en', 'es'].contains(locale.languageCode);
//   }

//   @override
//   Future<AppLocalizations> load(Locale locale) {
//     return AppLocalizations.load(locale);
//   }

//   @override
//   bool shouldReload(_AppLocalizationsDelegate old) => false;
// }
