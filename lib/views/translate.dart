import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/LocalizationService.dart';
import 'package:sizer/sizer.dart';
import 'local.dart';

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({super.key});

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  var addDynamicTranslations = LocalizationService();
  var appLocalization;

  @override
  void setState(VoidCallback fn) {
    //appLocalization = AppLocalizations.of(context);
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    //appLocalization = AppLocalizations.of(context);
    var localization = AppLocalizations(Localizations.localeOf(context));

    return Scaffold(
      appBar: AppBar(
        title: const Text('test'), // Static content translation
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('title'.tr), // Dynamic content translation
            MaterialButton(
                height: 5.h,
                minWidth: 30.w,
                color: primaryColor,
                textColor: white,
                onPressed: () {
                  //  Get.updateLocale(const Locale('hi', 'HI'));
                  Get.updateLocale(const Locale('hi', 'HI'));
                  setState(() {});
                  // addDynamicTranslations.addDynamicTranslations(
                  //     const Locale('hi', 'HI'), {'dynamic_item3': 'Item 3'});
                  // setState(() {});
                },
                child: const Text('HINDI')),
            MaterialButton(
                height: 5.h,
                minWidth: 30.w,
                color: primaryColor,
                textColor: white,
                onPressed: () {
                  Get.updateLocale(const Locale('en', 'US'));
                  setState(() {});
                },
                child: const Text('ENGLISH'))
          ],
        ),
      ),
    );
  }
}
