import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/controller/internet_controller.dart';
import 'package:gifthamperz/utils/log.dart';

// ignore: must_be_immutable
class CustomParentScaffold extends StatelessWidget {
  final Widget body;
  Future<bool> Function()? onWillPop;
  bool isSafeArea;
  bool isNormalScreen;
  bool isFormScreen;
  bool isDetailScreen;

  Function()? onTap;
  CustomParentScaffold({
    super.key,
    required this.onWillPop,
    required this.body,
    required this.isSafeArea,
    this.isNormalScreen = false,
    this.isFormScreen = false,
    this.isDetailScreen = false,
    this.onTap,
  });

  // PopScope(
  // onPopInvoked: (didPop) async => onWillPop,

  @override
  Widget build(BuildContext context) {
    return isSafeArea == true
        ? WillPopScope(
            onWillPop: onWillPop,
            child: GetBuilder<InternetController>(builder: (internetCtr) {
              // ignore: unrelated_type_equality_checks
              if (internetCtr.connectivityResult == ConnectivityResult.none) {
                return checkInternet();
              }
              return SafeArea(child: body);
            }),
          )
        : GestureDetector(
            onTap: () {
              onTap!();
            },
            child: GetBuilder<InternetController>(builder: (internetCtr) {
              // ignore: unrelated_type_equality_checks
              if (internetCtr.connectivityResult == ConnectivityResult.none) {
                return checkInternet();
              }
              return isNormalScreen == true
                  ? Scaffold(body: SafeArea(child: body))
                  : isDetailScreen == true
                      ? Scaffold(
                          extendBodyBehindAppBar: true,
                          body: SafeArea(child: body))
                      : isFormScreen == true
                          ? Scaffold(extendBodyBehindAppBar: true, body: body)
                          : WillPopScope(
                              onWillPop: onWillPop,
                              child: body,
                            );
            }),
          );
  }
}
