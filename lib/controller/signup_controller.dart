import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/api_handle/Repository.dart';
import 'package:gifthamperz/componant/dialogs/loading_indicator.dart';
import 'package:gifthamperz/configs/apicall_constant.dart';
import 'package:gifthamperz/controller/internet_controller.dart';
import 'package:gifthamperz/models/validation_model.dart';
import 'package:gifthamperz/utils/enum.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/OtpScreen/OtpScreen.dart';
import '../../configs/string_constant.dart';
import '../../componant/dialogs/dialogs.dart';

class SignUpController extends GetxController {
  final GlobalKey<FormState> signupkey = GlobalKey<FormState>();
  final InternetController networkManager = Get.find<InternetController>();
  late TextEditingController mobileCtr, passwordctr, confirmpassCtr;
  late FocusNode mobileNode, passNode, confirmNode;
  var mobileModel = ValidationModel(null, null, isValidate: false).obs;
  var passModel = ValidationModel(null, null, isValidate: false).obs;
  var confirmpassModel = ValidationModel(null, null, isValidate: false).obs;
  RxBool isFormInvalidate = false.obs;
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  String getPass = "";
  RxString getImagePath = "".obs;
  RxBool obsecureText = true.obs;
  bool? isVerify;

  @override
  void onInit() {
    mobileNode = FocusNode();
    passNode = FocusNode();
    confirmNode = FocusNode();
    mobileCtr = TextEditingController();
    passwordctr = TextEditingController();
    confirmpassCtr = TextEditingController();
    super.onInit();
  }

  RxList imageObjectList = [].obs;
  RxString loginImgPath = "".obs;

  void validateMobile(String? val) {
    mobileModel.update((model) {
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
    // if (emailModel.value.isValidate == false) {
    //   isFormInvalidate.value = false;
    // } else if (passModel.value.isValidate == false) {
    //   isFormInvalidate.value = false;
    // } else {
    //   isFormInvalidate.value = true;
    // }
    if (mobileModel.value.isValidate == false) {
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

  void getSignUpOtp(context, number) async {
    var loadingIndicator = LoadingProgressDialog();
    loadingIndicator.show(context, '');
    try {
      if (networkManager.connectionType == 0) {
        loadingIndicator.hide(context);
        showDialogForScreen(
            context, SignupConstant.title, Connection.noConnection,
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
              context, SignupConstant.title, data['otp'].toString(),
              callback: () {
            Get.to(OtpScreen(
              mobile: number.toString().trim(),
              otp: data['otp'].toString(),
              isFromSignUp: true,
            ));
          });
        } else {
          showDialogForScreen(context, SignupConstant.title, data['message'],
              callback: () {});
        }
      } else {
        showDialogForScreen(
            context,
            SignupConstant.title,
            data['message'] != null && data['message'].toString().isNotEmpty
                ? data['message'].toString()
                : ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      logcat("Exception", e);
      showDialogForScreen(
          context, SignupConstant.title, ServerError.servererror,
          callback: () {});
    }
  }
}
