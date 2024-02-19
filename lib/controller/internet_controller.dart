import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/utils/log.dart';

class InternetController extends GetxController {
  Rx<ConnectivityResult> connectivity = ConnectivityResult.none.obs;

  void updateConnectivity(ConnectivityResult result) {
    connectivity.value = result;
    update();
    refresh();
  }

  void getNetworkData() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      logcat("getNetworkData", 'ConnectivityResult.mobile');
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      logcat("getNetworkData", 'ConnectivityResult.wifi');
      // I am connected to a wifi network.
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      logcat("getNetworkData", 'ConnectivityResult.ethernet');
      // I am connected to a ethernet network.
    } else if (connectivityResult == ConnectivityResult.vpn) {
      logcat("getNetworkData", 'ConnectivityResult.vpn');
      // I am connected to a vpn network.
      // Note for iOS and macOS:
      // There is no separate network interface type for [vpn].
      // It returns [other] on any device (also simulator)
    } else if (connectivityResult == ConnectivityResult.bluetooth) {
      logcat("getNetworkData", 'ConnectivityResult.bluetooth');
      // I am connected to a bluetooth.
    } else if (connectivityResult == ConnectivityResult.other) {
      logcat("getNetworkData", 'ConnectivityResult.other');
      // I am connected to a network which is not in the above mentioned networks.
    } else if (connectivityResult == ConnectivityResult.none) {
      logcat("getNetworkData", 'ConnectivityResult.none');
      // I am not connected to any network.
    }
  }

  //this variable 0 = No Internet, 1 = connected to WIFI ,2 = connected to Mobile Data.
  int connectionType = 0;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _streamSubscription;
  Function? statusChange;
  void setStatusCallback(Function? fun) {
    statusChange = fun;
    update();
    update();
    update();
    refresh();
  }

  String roomId = "";

  @override
  void onInit() {
    getConnectionType();
    _streamSubscription =
        _connectivity.onConnectivityChanged.listen(_updateState);
    getNetworkData();
    super.onInit();
  }

  late ConnectivityResult connectivityResult;

  Future<void> getConnectionType() async {
    try {
      connectivityResult = await (_connectivity.checkConnectivity());
      logcat("Result", connectivityResult.toString());
    } on PlatformException catch (e) {
      logcat("EXCEPTION:", e);
    }
    update();
    return _updateState(connectivityResult);
  }

  _updateState(ConnectivityResult result) {
    connectivityResult = result;
    switch (result) {
      case ConnectivityResult.wifi:
        connectionType = 1;
        update();
        logcat("ConnectivityResult.wifi", "WIFI");
        break;
      case ConnectivityResult.mobile:
        connectionType = 2;
        update();
        logcat("ConnectivityResult.mobile", "mobile");
        break;
      case ConnectivityResult.ethernet:
        connectionType = 3;
        update();
        logcat("ConnectivityResult.ethernet", "ethernet");
        break;
      case ConnectivityResult.none:
        connectionType = 0;
        update();
        logcat("ConnectivityResult.none", "none");
        break;
      default:
        logcat("Network Error", "DONEEEEEE");
        Get.snackbar('Network Error', 'Failed to get Network Status');
        break;
    }
    if (statusChange != null) {
      statusChange!();
    }
    update();
    refresh();
  }

  @override
  void onClose() {
    _streamSubscription.cancel();
  }
}
