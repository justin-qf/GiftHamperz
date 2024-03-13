import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/api_handle/Repository.dart';
import 'package:gifthamperz/componant/dialogs/loading_indicator.dart';
import 'package:gifthamperz/configs/apicall_constant.dart';
import 'package:gifthamperz/componant/dialogs/loading_indicator.dart';
import 'package:gifthamperz/controller/internet_controller.dart';
import 'package:gifthamperz/models/loginModel.dart';
import 'package:gifthamperz/models/validation_model.dart';
import 'package:gifthamperz/preference/UserPreference.dart';
import 'package:gifthamperz/utils/enum.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/MainScreen/MainScreen.dart';
import 'package:gifthamperz/views/OtpScreen/OtpScreen.dart';
import '../../configs/string_constant.dart';
import '../../componant/dialogs/dialogs.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> signinkey = GlobalKey<FormState>();
  final InternetController networkManager = Get.find<InternetController>();
  late TextEditingController numberCtr, passwordctr;
  late FocusNode numberNode, passNode;
  var numberModel = ValidationModel(null, null, isValidate: false).obs;
  var passModel = ValidationModel(null, null, isValidate: false).obs;
  RxBool isFormInvalidate = false.obs;
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  String getPass = "";
  RxString getImagePath = "".obs;
  RxBool obsecureText = true.obs;
  bool? isVerify;

  @override
  void onInit() {
    numberNode = FocusNode();
    passNode = FocusNode();
    numberCtr = TextEditingController();
    passwordctr = TextEditingController();
    super.onInit();
  }

  RxList imageObjectList = [].obs;
  RxString loginImgPath = "".obs;

  void validatePhone(String? val) {
    numberModel.update((model) {
      if (val == null || val.isEmpty) {
        model!.error = 'Enter Phone Number';
        model.isValidate = false;
      } else if (val.replaceAll(' ', '').length != 10) {
        model!.error = 'Enter 10 digit Number';
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });

    enableSignUpButton();
  }

  void validatePassword(String? val) {
    passModel.update((model) {
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

  void enableSignUpButton() {
    if (numberModel.value.isValidate == false) {
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

  void getSignIn(context, String number) async {
    var loadingIndicator = LoadingProgressDialog();
    try {
      if (networkManager.connectionType == 0) {
        loadingIndicator.hide(context);
        showDialogForScreen(context, LoginConst.signIn, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      loadingIndicator.show(context, '');
      logcat('loginPassingData', {
        "mobile_no": numberCtr.text.toString().trim(),
        // "password": passwordctr.text.toString().trim()
      });

      var response = await Repository.post({
        "mobile_no": numberCtr.text.toString().trim(),
        //"password": passwordctr.text.toString().trim()
      }, ApiUrl.login);
      loadingIndicator.hide(context);
      var data = jsonDecode(response.body);
      logcat("tag", data);
      if (response.statusCode == 200) {
        if (data['status'] == 1) {
          // var loginData = LoginModel.fromJson(data);
          showDialogForScreen(
              context, LoginConst.signIn, data['otp'].toString(), callback: () {
            Get.to(OtpScreen(
              mobile: number.toString().trim(),
              otp: data['otp'].toString(),
              isFromSignUp: true,
            ));
          });
          // UserPreferences().saveSignInInfo(loginData.user);
          // UserPreferences().setToken(loginData.user.token);
          // UserPreferences().setIsGuestUser(false);
          // Get.offAll(const BottomNavScreen());
        } else {
          showDialogForScreen(context, LoginConst.signIn, data['message'],
              callback: () {});
        }
      } else {
        showDialogForScreen(context, LoginConst.signIn, data['message'],
            callback: () {});
      }
    } catch (e) {
      logcat("Exception", e);
      showDialogForScreen(context, LoginConst.signIn, ServerError.servererror,
          callback: () {});
    }
  }
}
