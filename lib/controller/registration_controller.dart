import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/api_handle/Repository.dart';
import 'package:gifthamperz/componant/dialogs/dialogs.dart';
import 'package:gifthamperz/componant/dialogs/loading_indicator.dart';
import 'package:gifthamperz/configs/apicall_constant.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/internet_controller.dart';
import 'package:gifthamperz/models/loginModel.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:gifthamperz/models/validation_model.dart';
import 'package:gifthamperz/preference/UserPreference.dart';
import 'package:gifthamperz/utils/enum.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/MainScreen/MainScreen.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class RegistrationController extends GetxController {
  final GlobalKey<FormState> profilekey = GlobalKey<FormState>();
  final InternetController networkManager = Get.find<InternetController>();
  RxBool isFormInvalidate = false.obs;
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  Rx<File?> avatarFile = null.obs;
  RxString profilePic = "".obs;
  RxBool obsecurePasswordText = true.obs;
  RxBool obsecureConfirmPasswordText = true.obs;

  late TextEditingController usernamectr,
      firstNamectr,
      lastnamectr,
      phonenumberctr,
      emailCtr,
      passwordctr,
      confirmCtr,
      dobCtr,
      gederCtr,
      profilePicCtr;
  late FocusNode userNamenode,
      firstNameNode,
      lastNameNode,
      phonenumberNode,
      emailnode,
      passNode,
      confirmPassNode,
      dobNode,
      genderNode,
      profilePicNode;

  var userNameModel = ValidationModel(null, null, isValidate: false).obs;
  var firstNameModel = ValidationModel(null, null, isValidate: false).obs;
  var lastNameModel = ValidationModel(null, null, isValidate: false).obs;
  var phoneNumerModel = ValidationModel(null, null, isValidate: false).obs;
  var emailModel = ValidationModel(null, null, isValidate: false).obs;
  var passModel = ValidationModel(null, null, isValidate: false).obs;
  var confirmPassModel = ValidationModel(null, null, isValidate: false).obs;
  var dobModel = ValidationModel(null, null, isValidate: false).obs;
  var genderModel = ValidationModel(null, null, isValidate: false).obs;
  var profilePicModel = ValidationModel(null, null, isValidate: false).obs;
  @override
  void onInit() {
    userNamenode = FocusNode();
    firstNameNode = FocusNode();
    lastNameNode = FocusNode();
    phonenumberNode = FocusNode();
    emailnode = FocusNode();
    passNode = FocusNode();
    confirmPassNode = FocusNode();
    dobNode = FocusNode();
    genderNode = FocusNode();
    profilePicNode = FocusNode();

    usernamectr = TextEditingController();
    firstNamectr = TextEditingController();
    lastnamectr = TextEditingController();
    phonenumberctr = TextEditingController();
    emailCtr = TextEditingController();
    passwordctr = TextEditingController();
    confirmCtr = TextEditingController();
    dobCtr = TextEditingController();
    gederCtr = TextEditingController();
    profilePicCtr = TextEditingController();

    super.onInit();
  }

  RxList imageObjectList = [].obs;
  RxString loginImgPath = "".obs;
  final RxList<String> gender = [
    'Male',
    'Female',
    'Others',
  ].obs;
  String? selectRelation;
  RxString selectGender = "".obs;
  DateTime selectedDate = DateTime.now();
  void updateDate(date) {
    dobCtr.text = date;
    update();
  }

  void validateUserName(String? val) {
    userNameModel.update((model) {
      if (val != null && val.isEmpty) {
        model!.error = "Enter Last name";
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });

    enableSignUpButton();
  }

  void validateFirstName(String? val) {
    firstNameModel.update((model) {
      if (val != null && val.isEmpty) {
        model!.error = "Enter First name";
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });

    enableSignUpButton();
  }

  void validateLastName(String? val) {
    lastNameModel.update((model) {
      if (val != null && val.isEmpty) {
        model!.error = "Enter Last name";
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });

    enableSignUpButton();
  }

  void validatePhone(String? val) {
    phoneNumerModel.update((model) {
      if (val != null && val.toString().trim().isEmpty) {
        model!.error = 'Enter Phone Number';
        model.isValidate = false;
      } else if (val.toString().trim().replaceAll(' ', '').length != 10) {
        model!.error = 'Enter Valid Phone Number';
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });

    enableSignUpButton();
  }

  void validateEmail(String? val) {
    emailModel.update((model) {
      if (val != null && val.toString().trim().isEmpty) {
        model!.error = "Enter Email Id";
        model.isValidate = false;
      } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(emailCtr.text.trim())) {
        model!.error = "Enter Valid Email Id";
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
      if (val != null && val.toString().trim().isEmpty) {
        model!.error = "Enter Password";
        model.isValidate = false;
      } else if (val.toString().trim().length <= 7) {
        model!.error = "Password Must be 8 Character";
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

    enableSignUpButton();
  }

  void validateConfirmPass(String? val) {
    confirmPassModel.update((model) {
      if (val != null && val.toString().trim().isEmpty) {
        model!.error = "Enter Confirm Password";
        model.isValidate = false;
      } else if (val.toString().trim() != passwordctr.text.toString().trim()) {
        model!.error = "Password Not Match";
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });

    enableSignUpButton();
  }

  void validatedob(String? val) {
    dobModel.update((model) {
      if (val != null && val.isEmpty) {
        model!.error = "Enter Date of Birth";
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });

    enableSignUpButton();
  }

  void validategender(String? val) {
    genderModel.update((model) {
      if (val != null && val.isEmpty) {
        model!.error = "Select a Gender";
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });

    enableSignUpButton();
  }

  void enableSignUpButton() {
    if (userNameModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (emailModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (phoneNumerModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (passModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (confirmPassModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (firstNameModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (lastNameModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (firstNameModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (genderModel.value.isValidate == false) {
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

  getImage() {
    return Stack(
      children: [
        Container(
          height: SizerUtil.deviceType == DeviceType.mobile ? 15.h : 10.8.h,
          margin: const EdgeInsets.only(right: 10),
          width: SizerUtil.deviceType == DeviceType.mobile ? 15.h : 10.8.h,
          decoration: BoxDecoration(
            border: Border.all(color: white, width: 1.w),
            borderRadius: BorderRadius.circular(100.w),
            boxShadow: [
              BoxShadow(
                color: black.withOpacity(0.1),
                blurRadius: 5.0,
              )
            ],
          ),
          child: CircleAvatar(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: avatarFile.value == null
                  ? Image.asset(
                      Asset.userholder,
                      height: 12.5.h,
                      width: 12.5.h,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      avatarFile.value!,
                      height: 12.5.h,
                      width: 12.5.h,
                      errorBuilder: (context, error, stackTrace) {
                        return SvgPicture.asset(
                          Asset.placeholder,
                          height: 12.5.h,
                          width: 12.5.h,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
            ),
          ),
        ),
        Positioned(
          right: 15,
          bottom: 1.h,
          child: Container(
            height: 3.3.h,
            width: 3.3.h,
            padding: const EdgeInsets.all(5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: primaryColor,
              border: Border.all(color: Colors.white, width: 0.6.w),
              borderRadius: BorderRadius.circular(100.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5.0,
                )
              ],
            ),
            child: SvgPicture.asset(
              Asset.add,
              height: 12.0.h,
              width: 15.0.h,
              fit: BoxFit.cover,
              // ignore: deprecated_member_use
              color: white,
            ),
          ),
        ),
      ],
    );
  }

  setImage() {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          child: Container(
            width: 12.h,
          ),
        ),
        Container(
          height: SizerUtil.deviceType == DeviceType.mobile ? 10.h : 10.8.h,
          margin: const EdgeInsets.only(right: 10),
          width: SizerUtil.deviceType == DeviceType.mobile ? 10.h : 10.8.h,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1.w),
            borderRadius: BorderRadius.circular(100.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5.0,
              )
            ],
          ),
          child: CircleAvatar(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: avatarFile.value == null && profilePic.value.isNotEmpty
                  ? Image.network(
                      profilePic.value,
                      height: 8.0.h,
                      width: 8.0.h,
                      errorBuilder: (context, error, stackTrace) {
                        return SvgPicture.asset(
                          Asset.profileimg,
                          height: 8.0.h,
                          width: 8.0.h,
                        );
                      },
                    )
                  : avatarFile.value == null
                      ? SvgPicture.asset(
                          Asset.profileimg,
                          height: 8.0.h,
                          width: 8.0.h,
                        )
                      : Image.file(
                          avatarFile.value!,
                          height: 8.0.h,
                          width: 8.0.h,
                          errorBuilder: (context, error, stackTrace) {
                            return SvgPicture.asset(
                              Asset.profileimg,
                              height: 8.0.h,
                              width: 8.0.h,
                            );
                          },
                        ),
            ),
          ),
        ),
        Positioned(
          right: 5,
          bottom: 0.5.h,
          child: Container(
            height: 3.3.h,
            width: 3.3.h,
            padding: const EdgeInsets.all(5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: primaryColor,
              border: Border.all(color: Colors.white, width: 0.6.w),
              borderRadius: BorderRadius.circular(100.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5.0,
                )
              ],
            ),
            child: SvgPicture.asset(
              Asset.add,
              height: 12.0.h,
              width: 15.0.h,
              fit: BoxFit.cover,
              color: white,
            ),
          ),
        ),
      ],
    );
  }

  actionClickUploadImage(context) async {
    try {
      await ImagePicker()
          .pickImage(
              source: ImageSource.gallery,
              maxWidth: 1080,
              maxHeight: 1080,
              imageQuality: 100)
          .then((file) async {
        if (file != null) {
          //Cropping the image
          CroppedFile? croppedFile = await ImageCropper().cropImage(
              sourcePath: file.path,
              maxWidth: 1080,
              maxHeight: 1080,
              cropStyle: CropStyle.rectangle,
              aspectRatioPresets: Platform.isAndroid
                  ? [
                      CropAspectRatioPreset.square,
                      CropAspectRatioPreset.ratio3x2,
                      CropAspectRatioPreset.original,
                      CropAspectRatioPreset.ratio4x3,
                      CropAspectRatioPreset.ratio16x9
                    ]
                  : [
                      CropAspectRatioPreset.original,
                      CropAspectRatioPreset.square,
                      CropAspectRatioPreset.ratio3x2,
                      CropAspectRatioPreset.ratio4x3,
                      CropAspectRatioPreset.ratio5x3,
                      CropAspectRatioPreset.ratio5x4,
                      CropAspectRatioPreset.ratio7x5,
                      CropAspectRatioPreset.ratio16x9
                    ],
              uiSettings: [
                AndroidUiSettings(
                    toolbarTitle: 'Crop Image',
                    cropGridColor: white,
                    toolbarColor: primaryColor,
                    statusBarColor: primaryColor,
                    toolbarWidgetColor: white,
                    activeControlsWidgetColor: primaryColor,
                    initAspectRatio: CropAspectRatioPreset.original,
                    lockAspectRatio: false),
                IOSUiSettings(
                  title: 'Crop Image',
                  cancelButtonTitle: 'Cancel',
                  doneButtonTitle: 'Done',
                  aspectRatioLockEnabled: false,
                ),
              ],
              aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1));
          if (croppedFile != null) {
            avatarFile = File(croppedFile.path).obs;
            profilePic.value = croppedFile.path;
            update();
          }
        }
      });
      update();
    } catch (e) {
      logcat("ERROR", e);
    }
  }

  void registerApi(context) async {
    var loadingIndicator = LoadingProgressDialog();
    loadingIndicator.show(context, '');
    try {
      if (networkManager.connectionType == 0) {
        loadingIndicator.hide(context);
        showDialogForScreen(
            context, RegistrationConstant.title, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }

      logcat('registerPasssingData', {
        "user_name": usernamectr.text.toString(),
        "email_id": emailCtr.text.toString().trim(),
        "mobile_no": phonenumberctr.text.toString().trim(),
        "password": passwordctr.text.toString().trim(),
        "confirm_password": confirmCtr.text.toString().trim(),
        "first_name": firstNamectr.text.toString().trim(),
        "last_name": lastnamectr.text.toString().trim(),
        "date_of_birth": dobCtr.text.toString().trim(),
        "gender": selectGender.value.toString().toLowerCase().trim(),
      });
      var response = await Repository.multiPartPost({
        "user_name": usernamectr.text.toString(),
        "email_id": emailCtr.text.toString().trim(),
        "mobile_no": phonenumberctr.text.toString().trim(),
        "password": passwordctr.text.toString().trim(),
        "confirm_password": confirmCtr.text.toString().trim(),
        "first_name": firstNamectr.text.toString().trim(),
        "last_name": lastnamectr.text.toString().trim(),
        "date_of_birth": dobCtr.text.toString().trim(),
        "gender": selectGender.value.toString().toLowerCase().trim(),
      }, ApiUrl.register,
          multiPart: avatarFile.value != null
              ? http.MultipartFile(
                  'profile_pic',
                  avatarFile.value!.readAsBytes().asStream(),
                  avatarFile.value!.lengthSync(),
                  filename: avatarFile.value!.path.split('/').last,
                )
              : null,
          allowHeader: true);
      var responseData = await response.stream.toBytes();
      loadingIndicator.hide(context);
      var result = String.fromCharCodes(responseData);
      var json = jsonDecode(result);
      logcat('UploadRespose', json);
      if (response.statusCode == 200) {
        if (json['status'] == 1) {
          var loginData = LoginModel.fromJson(json);
          UserPreferences().saveSignInInfo(loginData.user);
          Get.offAll(const BottomNavScreen());
        } else {
          showDialogForScreen(
              context, RegistrationConstant.title, json['message'],
              callback: () {});
        }
      } else {
        showDialogForScreen(
            context, RegistrationConstant.title, ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      logcat("Exception", e);
      showDialogForScreen(
          context, RegistrationConstant.title, ServerError.servererror,
          callback: () {});
    }
  }
}
