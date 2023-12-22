import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationService extends Translations {
  // @override
  // Map<String, Map<String, String>> get keys => {
  //       'en_US': {
  //         // Add your static translations here
  //         'welcome': 'Welcome',
  //         // ...
  //       },
  //       'hi_HI': {
  //         'welcome': 'Hindi',
  //       },
  //     };
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'title': 'HELLO JUSTIN',
        },
        'ur_PK': {
          'title': 'اپنا ای میل درج کریں۔',
        },
        'hi_GU': {
          'title': 'नमस्ते जस्टिन',
        }
      };

  void addDynamicTranslations(
      Locale locale, Map<String, String> dynamicTranslations) {
    keys[locale.toString()]?.addAll(dynamicTranslations);
  }
}
