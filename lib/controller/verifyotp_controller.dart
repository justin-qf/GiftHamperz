import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/api_handle/Repository.dart';
import 'package:gifthamperz/componant/dialogs/loading_indicator.dart';
import 'package:gifthamperz/configs/apicall_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/models/loginModel.dart';
import 'package:gifthamperz/preference/UserPreference.dart';
import 'package:gifthamperz/utils/enum.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/MainScreen/MainScreen.dart';
import 'package:gifthamperz/views/RecoveryPassword/RecoveryScreen.dart';
import '../../componant/dialogs/dialogs.dart';
import 'internet_controller.dart';

class OtpController extends GetxController {
  RxBool isEmailVerified = false.obs;
  RxBool isMobileVerified = false.obs;
  RxString registeredUserId = ''.obs;
  RxBool isLoading = true.obs;
  bool? isVerify;
  bool? isPassword;

  late FocusNode oneNode, twoNode, threeNode, fourNode;

  late TextEditingController fieldOne, fieldTwo, fieldThree, fieldFour;

  RxString fNameError = ''.obs;
  Rx<ScreenState> states = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  final otpController = TextEditingController();
  final otpNode = FocusNode();
  bool showError = false;
  final InternetController networkManager = Get.find<InternetController>();

  @override
  void onInit() {
    oneNode = FocusNode();
    twoNode = FocusNode();
    threeNode = FocusNode();
    fourNode = FocusNode();

    fieldOne = TextEditingController();
    fieldTwo = TextEditingController();
    fieldThree = TextEditingController();
    fieldFour = TextEditingController();
    fieldOne.text = '';
    fieldTwo.text = '';
    fieldThree.text = '';
    fieldFour.text = '';
    isLoading.value = false;
    fieldOne.addListener(() {
      enableSignUpButton();
    });
    fieldTwo.addListener(() {
      enableSignUpButton();
    });
    fieldThree.addListener(() {
      enableSignUpButton();
    });
    fieldFour.addListener(() {
      enableSignUpButton();
    });
    super.onInit();
  }

  @override
  void onClose() {
    fieldOne.dispose();
    fieldTwo.dispose();
    fieldThree.dispose();
    fieldFour.dispose();

    otpController.dispose();
    otpNode.dispose();
    super.onClose();
  }

  final GlobalKey<FormState> otpkey = GlobalKey<FormState>();
  RxString errorFName = ''.obs;

  String getOTP() {
    String otp = fieldOne.text.trim() +
        fieldTwo.text.trim() +
        fieldThree.text.trim() +
        fieldFour.text.trim();

    return otp;
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

  void enableSignUpButton() {
    String otp = getOTP();
    if (otp.trim().length < 4) {
      isFormInvalidate.value = false;
    } else {
      isFormInvalidate.value = true;
    }

    update();
  }

  void enableButton(value) {
    if (value.trim().length < 4) {
      isFormInvalidate.value = false;
    } else {
      isFormInvalidate.value = true;
    }

    update();
  }

  RxBool isFormStartFilling = false.obs;

  RxBool isFormInvalidate = false.obs;

  void clearFocuseNode() {
    fieldOne.clear();
    fieldTwo.clear();
    fieldThree.clear();
    fieldFour.clear();
  }

  void verifyButtonAction(context, id) async {}

  void getOtpApi(context, String otp, String mobile) async {
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

      var response = await Repository.post({
        "mobile_no": mobile,
        "otp": otpController.text,
      }, ApiUrl.getVerifyOtp);
      loadingIndicator.hide(context);
      var data = jsonDecode(response.body);
      logcat("RESPONSE", jsonEncode(data));
      if (response.statusCode == 200) {
        if (data['status'] == 1) {
          Get.to(RecoveryScreen(
            mobile: mobile,
          ));
        } else {
          showDialogForScreen(
              context, VerificationScreen.title, data['message'], callback: () {
            FocusScope.of(context).requestFocus(otpNode);
            otpController.text = "";
          });
        }
      } else {
        showDialogForScreen(context, VerificationScreen.title, data['message'],
            callback: () {
          startTimer();
          FocusScope.of(context).requestFocus(otpNode);
          otpController.text = "";
        });
      }
    } catch (e) {
      logcat("Exception", e);
      showDialogForScreen(
          context, VerificationScreen.title, ServerError.servererror,
          callback: () {});
    }
  }

  void getLoginOtpApi(context, String otp, String mobile) async {
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
      var response = await Repository.post({
        "mobile_no": mobile,
        "otp": otpController.text,
      }, ApiUrl.verifyLoginOtp);
      loadingIndicator.hide(context);
      var data = jsonDecode(response.body);
      logcat("RESPONSE", jsonEncode(data));
      if (response.statusCode == 200) {
        if (data['status'] == 1) {
          var loginData = LoginModel.fromJson(data);
          UserPreferences().saveSignInInfo(loginData.user);
          UserPreferences().setToken(loginData.user.token);
          UserPreferences().setIsGuestUser(false);
          if (loginData.user.isGuestLogin == "false") {
            logcat("isGuestLogin-1", loginData.user.isGuestLogin.toString());
            UserPreferences().setIsGuestUserFromApi(false);
          } else {
            logcat("isGuestLogin-2", loginData.user.isGuestLogin.toString());
            UserPreferences().setIsGuestUserFromApi(true);
          }
          Get.offAll(const BottomNavScreen());
        } else {
          showDialogForScreen(
              context, VerificationScreen.title, data['message'],
              callback: () {});
        }
      } else {
        showDialogForScreen(context, VerificationScreen.title, data['message'],
            callback: () {
          startTimer();
          FocusScope.of(context).requestFocus(otpNode);
          otpController.text = "";
        });
      }
    } catch (e) {
      logcat("Exception", e);
      showDialogForScreen(
          context, VerificationScreen.title, ServerError.servererror,
          callback: () {});
    }
  }

  void getForgotOtp(context, number) async {
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
      var response = await Repository.post({
        "mobile_no": number,
      }, ApiUrl.getForgotPasswordOtp);
      loadingIndicator.hide(context);
      var data = jsonDecode(response.body);
      countdown = 10.obs;
      startTimer();
      if (response.statusCode == 200) {
        if (data['status'] == 1) {
          showDialogForScreen(
              context, VerificationScreen.title, data['otp'].toString(),
              callback: () {
            otpController.text = '';
            FocusScope.of(context).requestFocus(otpNode);
            logcat('isValid', 'onCLICK');
          });
        } else {
          showDialogForScreen(
              context, VerificationScreen.title, data['message'],
              callback: () {});
        }
      } else {
        showDialogForScreen(
            context, VerificationScreen.title, ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      logcat("Exception", e);
      showDialogForScreen(
          context, VerificationScreen.title, ServerError.servererror,
          callback: () {});
    }
  }

  void getSignUpOtp(context, number) async {
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

      var response = await Repository.post({
        "mobile_no": number,
      }, ApiUrl.login, allowHeader: false);
      loadingIndicator.hide(context);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data['status'] == 1) {
          showDialogForScreen(
              context, VerificationScreen.title, data['otp'].toString(),
              callback: () {
            otpController.text = '';
            FocusScope.of(context).requestFocus(otpNode);
          });
        } else {
          showDialogForScreen(
              context, VerificationScreen.title, data['message'],
              callback: () {});
        }
      } else {
        showDialogForScreen(
            context,
            VerificationScreen.title,
            data['message'] != null && data['message'].toString().isNotEmpty
                ? data['message'].toString()
                : ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      logcat("Exception", e);
      showDialogForScreen(
          context, VerificationScreen.title, ServerError.servererror,
          callback: () {});
    }
  }

  void hideKeyboard(dynamic context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
