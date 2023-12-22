import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/api_handle/Repository.dart';
import 'package:gifthamperz/componant/dialogs/loading_indicator.dart';
import 'package:gifthamperz/configs/apicall_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/models/validation_model.dart';
import 'package:gifthamperz/utils/enum.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/LoginScreen/LoginScreen.dart';
import '../../componant/dialogs/dialogs.dart';
import 'internet_controller.dart';

class ResetpassController extends GetxController {
  final InternetController networkManager = Get.find<InternetController>();
  final resetpasskey = GlobalKey<FormState>();

  late FocusNode currentpassNode;
  late FocusNode newpassNode;
  late FocusNode confirmpassNode;

  late TextEditingController currentCtr;
  late TextEditingController newpassCtr;
  late TextEditingController confirmCtr;

  var currentPassModel = ValidationModel(null, null, isValidate: false).obs;
  var newPassModel = ValidationModel(null, null, isValidate: false).obs;
  var confirmPassModel = ValidationModel(null, null, isValidate: false).obs;

  Rx<ScreenState> states = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  RxString mobile = "".obs;

  RxBool isFormInvalidate = false.obs;
  RxBool isForgotPasswordValidate = false.obs;
  RxBool isObsecureText = true.obs;

  RxBool obsecureOldPasswordText = true.obs;
  RxBool obsecureNewPasswordText = true.obs;
  RxBool obsecureConfirmPasswordText = true.obs;

  @override
  void onInit() {
    currentpassNode = FocusNode();
    newpassNode = FocusNode();
    confirmpassNode = FocusNode();
    currentCtr = TextEditingController();
    newpassCtr = TextEditingController();
    confirmCtr = TextEditingController();
    super.onInit();
  }

  void validateNewPass(String? val) {
    newPassModel.update((model) {
      if (val != null && val.toString().trim().isEmpty) {
        model!.error = "Enter New Password";
        model.isValidate = false;
      } else if (val.toString().trim().length <= 7) {
        model!.error = "Enter Valid Password";
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
      if (confirmCtr.text.toString().isNotEmpty) {
        if (val.toString().trim() != confirmCtr.text.toString().trim()) {
          confirmPassModel.update((model1) {
            model1!.error = "Password Not Match";
            model1.isValidate = false;
          });
        } else {
          confirmPassModel.update((model1) {
            model1!.error = null;
            model1.isValidate = true;
          });
        }
      }
    });

    enableForgotButton();
  }

  void validateConfirmPass(String? val) {
    confirmPassModel.update((model) {
      if (val != null && val.toString().trim().isEmpty) {
        model!.error = "Enter Confirm Password";
        model.isValidate = false;
      } else if (val.toString().trim() != newpassCtr.text.toString().trim()) {
        model!.error = "Password Not Match";
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });

    enableForgotButton();
  }

  void enableForgotButton() {
    if (newPassModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (confirmPassModel.value.isValidate == false) {
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

  void getForgotPass(context, String mobile) async {
    var loadingIndicator = LoadingProgressDialog();
    loadingIndicator.show(context, 'RESET PASSWORD');

    try {
      if (networkManager.connectionType == 0) {
        showDialogForScreen(
            context, ResetPasstext.title, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      var response = await Repository.post({
        "mobile_no": mobile,
        "new_password": newpassCtr.text.toString().trim(),
        "confirmation_password": confirmCtr.text.toString().trim()
      }, ApiUrl.updateForgotPassword);
      loadingIndicator.hide(context);
      logcat("PasswordResponse", response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data['status'] == 1) {
          showDialogForScreen(
              context, ResetPasstext.title, data['message'].toString(),
              callback: () {
            Get.to(const LoginScreen());
          });
        } else {
          showDialogForScreen(
              context, ResetPasstext.title, data['message'].toString(),
              callback: () {});
        }
      } else {
        states.value = ScreenState.apiError;
        showDialogForScreen(
            context, ResetPasstext.title, ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      logcat("Exception", e);
      showDialogForScreen(context, ResetPasstext.title, ServerError.servererror,
          callback: () {});
    }
  }
}
