import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/api_handle/Repository.dart';
import 'package:gifthamperz/componant/dialogs/dialogs.dart';
import 'package:gifthamperz/componant/dialogs/loading_indicator.dart';
import 'package:gifthamperz/configs/apicall_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/internet_controller.dart';
import 'package:gifthamperz/models/loginModel.dart';
import 'package:gifthamperz/models/validation_model.dart';
import 'package:gifthamperz/preference/UserPreference.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/MainScreen/MainScreen.dart';

class GuestLoginController extends GetxController {
  final InternetController networkManager = Get.find<InternetController>();
  final resetpasskey = GlobalKey<FormState>();
  late FocusNode numberNode, otpNode;
  late TextEditingController numberCtr, otpController;
  late TextEditingController fieldOne, fieldTwo, fieldThree, fieldFour;

  var numberModel = ValidationModel(null, null, isValidate: false).obs;
  RxBool isDark = false.obs;
  RxBool isFormInvalidate = false.obs;
  RxBool isOtpFormInvalidate = false.obs;
  bool showError = false;

  @override
  void onInit() {
    numberNode = FocusNode();
    otpNode = FocusNode();
    numberCtr = TextEditingController();
    otpController = TextEditingController();
    fieldOne = TextEditingController();
    fieldTwo = TextEditingController();
    fieldThree = TextEditingController();
    fieldFour = TextEditingController();
    fieldOne.text = '';
    fieldTwo.text = '';
    fieldThree.text = '';
    fieldFour.text = '';
    super.onInit();
  }

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

  void enableSignUpButton() {
    if (numberModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else {
      isFormInvalidate.value = true;
    }
  }

  void enableButton(value) {
    if (value.trim().length < 4) {
      isOtpFormInvalidate.value = false;
    } else {
      isOtpFormInvalidate.value = true;
    }

    update();
  }

  void clearFocuseNode() {
    fieldOne.clear();
    fieldTwo.clear();
    fieldThree.clear();
    fieldFour.clear();
  }

  RxInt countdown = 10.obs; // Initial countdown time in seconds
  late Timer timer;
  bool isTimerRunning = false;
  void startTimer() {
    if (!isTimerRunning) {
      isTimerRunning = true;
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (countdown > 0) {
          countdown--;
          update();
        } else {
          stopTimer();
        }
      });
    }
  }

  void stopTimer() {
    if (isTimerRunning) {
      isTimerRunning = false;
      timer.cancel();
      // Handle timer completion (e.g., show a "Resend OTP" button)
    }
  }

  RxBool? isOtpVisible = false.obs;
  RxString? otp = ''.obs;

  void getSignUpOtp(context, number) async {
    var loadingIndicator = LoadingProgressDialog();
    loadingIndicator.show(context, '');
    try {
      if (networkManager.connectionType == 0) {
        loadingIndicator.hide(context);
        showDialogForScreen(
            context, LoginConst.buttonLabel, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }

      var response = await Repository.post({
        "mobile_no": number,
      }, ApiUrl.getSignUpOtp, allowHeader: false);
      loadingIndicator.hide(context);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data['status'] == 1) {
          isOtpVisible!.value = true;
          controller.isFormInvalidate.value = false;
          startTimer();
          otp!.value = data['otp'].toString();
          showDialogForScreen(
              context, LoginConst.buttonLabel, data['otp'].toString(),
              callback: () {
            // Get.to(OtpScreen(
            //   mobile: number.toString().trim(),
            //   otp: data['otp'].toString(),
            //   isFromSignUp: true,
            // ));
          });
        } else {
          showDialogForScreen(context, LoginConst.buttonLabel, data['message'],
              callback: () {});
        }
      } else {
        isOtpVisible!.value = false;
        showDialogForScreen(
            context,
            LoginConst.buttonLabel,
            data['message'] != null && data['message'].toString().isNotEmpty
                ? data['message'].toString()
                : ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      logcat("Exception", e);
      showDialogForScreen(
          context, LoginConst.buttonLabel, ServerError.servererror,
          callback: () {});
    }
  }

  void verifyOtpAPI(context, String otp, String mobile) async {
    var loadingIndicator = LoadingProgressDialog();
    loadingIndicator.show(context, '');

    try {
      if (networkManager.connectionType == 0) {
        loadingIndicator.hide(context);
        showDialogForScreen(
            context, VerificationScreen.title, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      logcat("PASSING_DATA", {
        "mobile_no": mobile,
        "otp": otpController.text,
      });
      var response = await Repository.post({
        "mobile_no": mobile,
        "otp": otpController.text,
      }, ApiUrl.getVerifyGuestOtp);
      loadingIndicator.hide(context);
      var data = jsonDecode(response.body);
      logcat("verifyOtpAPI_RESPONSE", jsonEncode(data));
      if (response.statusCode == 200) {
        logcat("STEP-1", 'DONE');
        if (data['status'] == 1) {
          logcat("STEP-2", 'DONE');
          var loginData = LoginModel.fromJson(data);
          UserPreferences().saveSignInInfo(loginData.user);
          UserPreferences().setToken(loginData.user.token);
          UserPreferences().setIsGuestUser(false);
          Get.offAll(const BottomNavScreen());
        } else {
          logcat("STEP-3", 'DONE');

          showDialogForScreen(
              context, VerificationScreen.title, data['message'], callback: () {
            startTimer();
            //FocusScope.of(context).requestFocus(otpNode);
            otpController.text = "";
          });
        }
      } else {
        logcat("STEP-4", jsonEncode(data));
        showDialogForScreen(context, VerificationScreen.title, data['message'],
            callback: () {
          startTimer();
          FocusScope.of(context).requestFocus(otpNode);
          otpController.text = "";
        });
      }
    } catch (e) {
      logcat("STEP-5", 'DONE');
      logcat("Exception", e);
      showDialogForScreen(
          context, VerificationScreen.title, ServerError.servererror,
          callback: () {});
    }
  }
}
