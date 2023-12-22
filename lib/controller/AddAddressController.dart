import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/api_handle/Repository.dart';
import 'package:gifthamperz/componant/dialogs/dialogs.dart';
import 'package:gifthamperz/componant/dialogs/loading_indicator.dart';
import 'package:gifthamperz/configs/apicall_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/internet_controller.dart';
import 'package:gifthamperz/models/addressModel.dart';
import 'package:gifthamperz/models/validation_model.dart';
import 'package:gifthamperz/utils/enum.dart';
import 'package:gifthamperz/utils/log.dart';

class AddAddressController extends GetxController {
  final GlobalKey<FormState> signinkey = GlobalKey<FormState>();
  final InternetController networkManager = Get.find<InternetController>();
  late TextEditingController deliverynamectr,
      deliveryaddressctr,
      addressLinectr,
      streetctr,
      cityctr,
      landMarkctr,
      pincodectr;

  late FocusNode deliverynamenode,
      deliveryaddressnode,
      addressLinenode,
      streetnode,
      citynode,
      landMarknode,
      pinCodenode;
  var deliveryModel = ValidationModel(null, null, isValidate: false).obs;
  var deliveryaddressModel = ValidationModel(null, null, isValidate: false).obs;
  var addressLineModel = ValidationModel(null, null, isValidate: false).obs;
  var streetModel = ValidationModel(null, null, isValidate: false).obs;
  var cityModel = ValidationModel(null, null, isValidate: false).obs;
  var landMarkModel = ValidationModel(null, null, isValidate: false).obs;
  var pinCodeModel = ValidationModel(null, null, isValidate: false).obs;
  RxBool isFormInvalidate = false.obs;
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  String getPass = "";
  RxString getImagePath = "".obs;
  RxBool obsecureText = true.obs;
  bool? isVerify;
  RxString addressType = "".obs;
  RxString apiPassingAddressType = "".obs;
  String? selectCity;
  RxString isActive = "1".obs;

  List<TextEditingController> controllers = [];

  final List<String> city = [
    'AHMEDABAD',
    'VADODARA',
    'RAJKOT',
    'SURAT',
  ];
  @override
  void onInit() {
    pinCodenode = FocusNode();
    landMarknode = FocusNode();
    deliverynamenode = FocusNode();
    deliveryaddressnode = FocusNode();
    addressLinenode = FocusNode();
    streetnode = FocusNode();
    citynode = FocusNode();
    deliverynamectr = TextEditingController();
    deliveryaddressctr = TextEditingController();
    addressLinectr = TextEditingController();
    streetctr = TextEditingController();
    cityctr = TextEditingController();
    landMarkctr = TextEditingController();
    pincodectr = TextEditingController();
    super.onInit();
  }

  setDataInFormFields(bool isFromEdit, AddressListItem? itemData) {
    if (isFromEdit == true) {
      String dynamicString = itemData!.address.trim().toString();
      logcat("ADDRESS", dynamicString.toString());
      List<String> values = dynamicString.split(', ');
      logcat("ADDRESS", values);
      controllers = values
          .map((value) => TextEditingController(text: value.toString()))
          .toList();
      deliverynamectr.text = itemData.name.toString();
      addressLinectr.text = controllers.isNotEmpty ? controllers[0].text : "";
      streetctr.text = controllers.length > 1 ? controllers[1].text : "";
      landMarkctr.text = controllers.length > 2 ? controllers[2].text : "";
      pincodectr.text = itemData.pincode.toString();
      validateDeliveryName(deliverynamectr.text);
      validateAddressline(addressLinectr.text);
      validateStreet(streetctr.text);
      validateLandMark(landMarkctr.text);
      validatePinCode(pincodectr.text);
      //selectCity = itemData.cityName.toString();
    } else {
      deliverynamectr.text = "";
      addressLinectr.text = "";
      streetctr.text = "";
      landMarkctr.text = "";
      pincodectr.text = "";
      //selectCity = "";
    }
  }

  RxList imageObjectList = [].obs;
  RxString loginImgPath = "".obs;

  void validateDeliveryName(String? val) {
    deliveryModel.update((model) {
      if (val == null || val.isEmpty) {
        model!.error = "Enter Name";
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });
    enableSignUpButton();
  }

  void validatePinCode(String? val) {
    pinCodeModel.update((model) {
      if (val == null || val.isEmpty) {
        model!.error = AddAddressText.pinCodeHint;
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });
    enableSignUpButton();
  }

  void validateLandMark(String? val) {
    landMarkModel.update((model) {
      if (val == null || val.isEmpty) {
        model!.error = AddAddressText.landmarkHint;
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });
    enableSignUpButton();
  }

  void validateDeliveryAddress(String? val) {
    deliveryaddressModel.update((model) {
      if (val == null || val.isEmpty) {
        model!.error = "Enter Address";
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });
    enableSignUpButton();
  }

  void validateAddressline(String? val) {
    addressLineModel.update((model) {
      if (val == null || val.toString().trim().isEmpty) {
        model!.error = "Enter Password";
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });
    enableSignUpButton();
  }

  void validateStreet(String? val) {
    streetModel.update((model) {
      if (val == null || val.toString().trim().isEmpty) {
        model!.error = "Enter Password";
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });
    enableSignUpButton();
  }

  void validateCity(String? val) {
    cityModel.update((model) {
      if (val == null || val.isEmpty) {
        model!.error = "Enter Password";
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });
    enableSignUpButton();
  }

  void enableSignUpButton() {
    if (deliveryModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (addressLineModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (streetModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (landMarkModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (pinCodeModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else {
      isFormInvalidate.value = true;
    }
  }

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void addAddressAPI(context) async {
    var loadingIndicator = LoadingProgressDialog();
    loadingIndicator.show(context, '');
    try {
      if (networkManager.connectionType == 0) {
        loadingIndicator.hide(context);
        showDialogForScreen(
            context, AddAddressText.addressTitle, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      String storeAddress =
          "${addressLinectr.text},${streetctr.text},${landMarkctr.text}";

      logcat('loginPassingData', {
        "address": storeAddress.toString().trim(),
        "city_id": selectCity.toString().trim(),
        "pincode": pincodectr.text.toString().trim(),
        "is_office": apiPassingAddressType.value.toString().trim(),
        "is_active": isActive.value.toString().trim(),
      });

      var response = await Repository.post({
        "address": storeAddress.toString().trim(),
        "city_id": "25", // selectCity.toString().trim(),
        "pincode": pincodectr.text.toString().trim(),
        "is_office": apiPassingAddressType.value.toString().trim(),
        "is_active": isActive.value.toString().trim(),
      }, ApiUrl.addAddress, allowHeader: true);
      loadingIndicator.hide(context);
      var data = jsonDecode(response.body);
      logcat("tag", data);
      if (response.statusCode == 200) {
        if (data['status'] == 1) {
          showDialogForScreen(
              context, AddAddressText.addressTitle, data['message'],
              callback: () {
            Get.back(result: true);
          });
        } else {
          showDialogForScreen(
              context, AddAddressText.addressTitle, data['message'],
              callback: () {});
        }
      } else {
        showDialogForScreen(
            context, AddAddressText.addressTitle, data['message'] ?? "",
            callback: () {});
      }
    } catch (e) {
      logcat("Exception", e);
      showDialogForScreen(
          context, AddAddressText.addressTitle, ServerError.servererror,
          callback: () {});
    }
  }

  void updateAddressAPI(context, int id) async {
    var loadingIndicator = LoadingProgressDialog();
    loadingIndicator.show(context, '');
    try {
      if (networkManager.connectionType == 0) {
        loadingIndicator.hide(context);
        showDialogForScreen(
            context, AddAddressText.addressTitle, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      String storeAddress =
          "${addressLinectr.text}, ${streetctr.text}, ${landMarkctr.text}";

      logcat('loginPassingData', {
        "address": storeAddress.toString().trim(),
        "city_id": selectCity.toString().trim(),
        "pincode": pincodectr.text.toString().trim(),
        "is_office": apiPassingAddressType.value.toString().trim(),
        "is_active": isActive.value.toString().trim(),
      });

      var response = await Repository.update({
        "address": storeAddress.toString().trim(),
        "city_id": "25", // selectCity.toString().trim(),
        "pincode": pincodectr.text.toString().trim(),
        "is_office": apiPassingAddressType.value.toString().trim(),
        "is_active": isActive.value.toString().trim(),
      }, ApiUrl.updateAddress + id.toString(), allowHeader: true);
      loadingIndicator.hide(context);
      var data = jsonDecode(response.body);
      logcat("tag", data);
      if (response.statusCode == 200) {
        if (data['status'] == 1) {
          showDialogForScreen(
              context, AddAddressText.addressTitle, data['message'],
              callback: () {
            Get.back(result: true);
          });
        } else {
          showDialogForScreen(
              context, AddAddressText.addressTitle, data['message'],
              callback: () {});
        }
      } else {
        showDialogForScreen(
            context, AddAddressText.addressTitle, data['message'] ?? "",
            callback: () {});
      }
    } catch (e) {
      logcat("Exception", e);
      showDialogForScreen(
          context, AddAddressText.addressTitle, ServerError.servererror,
          callback: () {});
    }
  }
}
