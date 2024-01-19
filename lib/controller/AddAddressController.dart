import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/api_handle/Repository.dart';
import 'package:gifthamperz/componant/dialogs/dialogs.dart';
import 'package:gifthamperz/componant/dialogs/loading_indicator.dart';
import 'package:gifthamperz/componant/input/form_inputs.dart';
import 'package:gifthamperz/configs/apicall_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/internet_controller.dart';
import 'package:gifthamperz/models/addressModel.dart';
import 'package:gifthamperz/models/cityModel.dart';
import 'package:gifthamperz/models/validation_model.dart';
import 'package:gifthamperz/utils/enum.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:sizer/sizer.dart';

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

  late TextEditingController searchCityctr;
  late FocusNode searchCityNode;
  var searchCityModel = ValidationModel(null, null, isValidate: false).obs;

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
  RxString cityId = "".obs;

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
    searchCityNode = FocusNode();
    deliverynamectr = TextEditingController();
    deliveryaddressctr = TextEditingController();
    addressLinectr = TextEditingController();
    streetctr = TextEditingController();
    cityctr = TextEditingController();
    landMarkctr = TextEditingController();
    pincodectr = TextEditingController();
    searchCityctr = TextEditingController();
    super.onInit();
  }

  setDataInFormFields(
      BuildContext context, bool isFromEdit, AddressListItem? itemData) {
    if (isFromEdit == true) {
      String dynamicString = itemData!.address.trim().toString();
      //NEW LOGIC
      List<String> addressParts = dynamicString.split(',');
      addressLinectr.text =
          addressParts.isNotEmpty ? addressParts[0].toString().trim() : "";
      streetctr.text =
          addressParts.length >= 2 ? addressParts[1].toString().trim() : "";
      landMarkctr.text =
          addressParts.length >= 3 ? addressParts[2].toString().trim() : "";

      deliverynamectr.text = itemData.name.toString();
      pincodectr.text = itemData.pincode.toString();
      cityId.value = itemData.cityId.toString();
      logcat("cityIDDDDD", cityId.value);
      if (itemData.isOffice == 0) {
        addressType.value = "HOME";
        apiPassingAddressType.value = "0";
      } else {
        addressType.value = "WORK";
        apiPassingAddressType.value = "1";
      }
      // ignore: unrelated_type_equality_checks
      // if (itemData.cityId != "null" && itemData.cityId.toString().isNotEmpty) {
      //   getCityList(context, itemData.cityId.toString());
      // }

      validateDeliveryName(deliverynamectr.text);
      validateAddressline(addressLinectr.text);
      validateStreet(streetctr.text);
      validateLandMark(landMarkctr.text);
      validatePinCode(pincodectr.text);
      update();
      //selectCity = itemData.cityName.toString();
    } else {
      logcat('isFromEdit', 'false');
      deliverynamectr.text = "";
      addressLinectr.text = "";
      streetctr.text = "";
      landMarkctr.text = "";
      pincodectr.text = "";
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
    enablButton();
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
    enablButton();
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
    enablButton();
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
    enablButton();
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
    enablButton();
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
    enablButton();
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
    enablButton();
  }

  void enablButton() {
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
        "city_id": cityId.value.toString().trim(),
        "pincode": pincodectr.text.toString().trim(),
        "is_office": apiPassingAddressType.value.toString().trim(),
        "is_active": isActive.value.toString().trim(),
      });

      var response = await Repository.post({
        "address": storeAddress.toString().trim(),
        "city_id":
            cityId.value.toString().trim(), // selectCity.toString().trim(),
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
        "city_id": cityId.value.toString().trim(),
        "pincode": pincodectr.text.toString().trim(),
        "is_office": apiPassingAddressType.value.toString().trim(),
        "is_active": isActive.value.toString().trim(),
      });

      var response = await Repository.update({
        "address": storeAddress.toString().trim(),
        "city_id": cityId.value.toString().trim(),
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

  void applyFilterforCity(String keyword) {
    filterCityList.clear();
    for (var model in cityList) {
      if (model['name']
          .toString()
          .toLowerCase()
          .contains(keyword.toLowerCase())) {
        filterCityList.add(model);
      }
    }
    filterCityList.refresh();
    filterCityList.call();
    logcat('filterApply', filterCityList.length.toString());
    update();
  }

  Widget setCityDialog() {
    return Obx(() {
      return setDropDownContent(
          filterCityList,
          ListView.builder(
            shrinkWrap: true,
            itemCount: filterCityList.length,
            itemBuilder: (BuildContext context, int index) {
              var modelData = CityList.fromJson(filterCityList[index]);
              return ListTile(
                  dense: true,
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                  contentPadding:
                      const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
                  horizontalTitleGap: null,
                  minLeadingWidth: 5,
                  onTap: () {
                    cityId.value = modelData.id.toString();
                    cityctr.text = modelData.name.capitalize.toString();
                    if (cityctr.text.toString().isNotEmpty) {
                      filterCityList.clear();
                      filterCityList.addAll(cityList);
                    }
                    validateCity(cityctr.text);
                    Get.back();
                  },
                  title: Text(
                    modelData.name.capitalize.toString(),
                    style:
                        TextStyle(fontFamily: fontRegular, fontSize: 13.5.sp),
                  ));
            },
          ),
          searchcontent: getReactiveFormField(
              node: searchCityNode,
              controller: searchCityctr,
              hintLabel: "Search Here...",
              onChanged: (val) {
                applyFilterforCity(val.toString());
                update();
              },
              isSearch: true,
              inputType: TextInputType.text,
              errorText: searchCityModel.value.error));
    });
  }

  RxList cityList = [].obs;
  RxList filterCityList = [].obs;

  void getCityList(context, String cityID) async {
    var loadingIndicator = LoadingProgressDialog();
    loadingIndicator.show(context, '');

    try {
      if (networkManager.connectionType == 0) {
        showDialogForScreen(
            context, CategoryScreenConstant.title, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      var response =
          await Repository.get({}, "${ApiUrl.getCity}/7", allowHeader: true);
      logcat("RESPONSE::", response.body);
      loadingIndicator.hide(context);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          for (int i = 0; i < responseData['data'].length; i++) {
            var models = CityList.fromJson(responseData['data'][i]);
            if (cityID == models.id.toString()) {
              cityList.addAll(responseData['data']);
              filterCityList.addAll(responseData['data']);
              cityctr.text = models.name.capitalize.toString();
              cityId.value = models.id.toString();
              update();
              break;
            } else {
              cityList.clear();
              filterCityList.clear();
              cityList.addAll(responseData['data']);
              filterCityList.addAll(responseData['data']);
            }
          }
          // cityList.clear();
          // filterCityList.clear();
          // cityList.addAll(responseData['data']);
          // filterCityList.addAll(responseData['data']);
          update();
        } else {
          message.value = responseData['message'];
          showDialogForScreen(
              context, CategoryScreenConstant.title, responseData['message'],
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(
            context, CategoryScreenConstant.title, ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      logcat("Ecxeption", e);
      loadingIndicator.hide(context);
      showDialogForScreen(
          context, CategoryScreenConstant.title, ServerError.servererror,
          callback: () {});
    }
  }
}
