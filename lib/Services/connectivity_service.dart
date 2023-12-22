import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/controller/internet_controller.dart';

class ConnectivityService extends GetxService {
  final _connectivity = Connectivity();

  Stream<ConnectivityResult> get connectivityStream =>
      _connectivity.onConnectivityChanged;

  void startMonitoring() {
    connectivityStream.listen((result) {
      // Update your GetX state using the appropriate controller.
      Get.put<InternetController>(InternetController())
          .updateConnectivity(result);
    });
  }
}
