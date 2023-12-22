import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/dialogs/dialogs.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:gifthamperz/models/validation_model.dart';
import 'package:gifthamperz/utils/enum.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class EditProfileController extends GetxController {
  final GlobalKey<FormState> profilekey = GlobalKey<FormState>();
  late TextEditingController fullnamectr, phonenumberctr, emailCtr, passwordctr;
  late FocusNode phonenumbernode, passNode, fullnamenode, emailnode;
  var emailModel = ValidationModel(null, null, isValidate: false).obs;
  var passModel = ValidationModel(null, null, isValidate: false).obs;
  var phonemodel = ValidationModel(null, null, isValidate: false).obs;
  var fullnamemodel = ValidationModel(null, null, isValidate: false).obs;
  RxBool isFormInvalidate = false.obs;
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  String getPass = "";
  RxString getImagePath = "".obs;
  RxBool obsecureText = true.obs;
  bool? isVerify;
  Rx<File?> avatarFile = null.obs;
  RxString profilePic = "".obs;

  @override
  void onInit() {
    emailnode = FocusNode();
    fullnamenode = FocusNode();
    phonenumbernode = FocusNode();
    passNode = FocusNode();
    emailCtr = TextEditingController();
    passwordctr = TextEditingController();
    phonenumberctr = TextEditingController();
    fullnamectr = TextEditingController();
    super.onInit();
  }

  RxList imageObjectList = [].obs;
  RxString loginImgPath = "".obs;

  void validateFullName(String? val) {
    fullnamemodel.update((model) {
      if (val != null && val.isEmpty) {
        model!.error = "Enter Full name";
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });

    enableSignUpButton();
  }

  void validatePhone(String? val) {
    phonemodel.update((model) {
      if (val != null && val.isEmpty) {
        model!.error = "Enter Phone Number";
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
    if (fullnamemodel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (emailModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (passModel.value.isValidate == false) {
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

  showDialogForScreen(context, String message, {Function? callback}) {
    showMessage(
        context: context,
        callback: () {
          if (callback != null) {
            callback();
          }
          return true;
        },
        message: message,
        title: LoginConst.signIn,
        negativeButton: '',
        positiveButton: Common.continues);
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
}
