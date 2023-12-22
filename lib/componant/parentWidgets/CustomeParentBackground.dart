import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/controller/internet_controller.dart';

// ignore: must_be_immutable
class CustomParentScaffold extends StatelessWidget {
  final Widget body;
  Future<bool> Function()? onWillPop;
  bool isSafeArea;
  bool isNormalScreen;
  bool isFormScreen;

  Function()? onTap;
  CustomParentScaffold({
    super.key,
    required this.onWillPop,
    required this.body,
    required this.isSafeArea,
    this.isNormalScreen = false,
    this.isFormScreen = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return isSafeArea == true
        ? WillPopScope(
            onWillPop: onWillPop,
            child: GetBuilder<InternetController>(builder: (internetCtr) {
              // ignore: unrelated_type_equality_checks
              if (internetCtr.connectivity == ConnectivityResult.none) {
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
              if (internetCtr.connectivity == ConnectivityResult.none) {
                return checkInternet();
              }
              return isNormalScreen == true
                  ? Scaffold(body: SafeArea(child: body))
                  : isFormScreen == true
                      ? Scaffold(extendBodyBehindAppBar: true, body: body)
                      : WillPopScope(
                          onWillPop: onWillPop,
                          child: body,
                        );
            }),
          );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    // Your custom logic for handling the back button press.
    // Return true to allow back navigation, or false to block it.
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Do you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
