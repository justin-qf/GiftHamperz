import 'dart:async';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gifthamperz/Services/connectivity_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gifthamperz/configs/get_storage_key.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/internet_controller.dart';
import 'package:gifthamperz/controller/theme_controller.dart';
import 'package:gifthamperz/core/theme/app_theme.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/LocalizationService.dart';
import 'package:gifthamperz/views/SplashScreen/SplashScreen.dart';
import 'package:responsive_framework/breakpoint.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MainScreen());
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => HomeState();
}

class HomeState extends State<MainScreen> {
  final ConnectivityHelper connectivityHelper = ConnectivityHelper();
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final LocalizationService localizationService =
      Get.put(LocalizationService());
  @override
  void initState() {
    super.initState();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {});
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ConnectivityService()).startMonitoring();
    Get.lazyPut<InternetController>(() => InternetController());
    Get.lazyPut<ThemeController>(() => ThemeController());
    final getStorage = GetStorage();
    int isDarkMode = getStorage.read(GetStorageKey.IS_DARK_MODE) ?? 1;
    getStorage.write(GetStorageKey.IS_DARK_MODE, isDarkMode);
    Statusbar().trasparentStatusbar();
    return Sizer(builder: (context, orientation, deviceType) {
      return ThemeProvider(
          initTheme: isDarkMode == 1 ? AppTheme.lightTheme : AppTheme.darkTheme,
          child: Builder(builder: (context) {
            return GetBuilder<ThemeController>(
                init: ThemeController(),
                builder: (ctr) {
                  return GetMaterialApp(
                    supportedLocales: const [
                      Locale('en', ''),
                      Locale('es', ''),
                    ],
                    translations: localizationService,
                    locale: const Locale('en', 'US'),
                    fallbackLocale: const Locale('en', 'US'),
                    localizationsDelegates: const [
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                    ],
                    builder: (context, child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaler: const TextScaler.linear(1.0)),
                        child: child!,
                      );
                    },
                    enableLog: true,
                    title: AppConstant.name,
                    theme: !ctr.isDark.value
                        ? ThemeData.light(useMaterial3: true)
                        : ThemeData.dark(useMaterial3: true),
                    debugShowCheckedModeBanner: false,
                    home: const Splashscreen(),
                    defaultTransition: Transition.cupertino,
                  );
                });
          }));
    });
  }
}

class ConnectivityHelper {
  final Connectivity _connectivity = Connectivity();

  Future<bool> hasConnection() async {
    logcat('initCommite', "DONE");
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
