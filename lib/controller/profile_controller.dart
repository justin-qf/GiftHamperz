import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gifthamperz/api_handle/Repository.dart';
import 'package:gifthamperz/componant/dialogs/dialogs.dart';
import 'package:gifthamperz/componant/dialogs/loading_indicator.dart';
import 'package:gifthamperz/configs/apicall_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/internet_controller.dart';
import 'package:gifthamperz/models/UserModel.dart';
import 'package:gifthamperz/models/loginModel.dart';
import 'package:gifthamperz/preference/UserPreference.dart';
import 'package:gifthamperz/utils/enum.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:sizer/sizer.dart';

class ProfileController extends GetxController {
  final GlobalKey<FormState> signinkey = GlobalKey<FormState>();
  final InternetController networkManager = Get.find<InternetController>();
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  RxString getImagePath = "".obs;
  RxBool obsecureText = true.obs;
  RxList imageObjectList = [].obs;
  RxString loginImgPath = "".obs;
  RxString userName = "".obs;
  RxString profilePic = "".obs;
  RxString email = "".obs;
  UserData? getUserData;
  RxBool isGuest = false.obs;

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void setData() async {
    getUserData = await UserPreferences().getSignInInfo();
    isGuest.value = await UserPreferences().getGuestUser();
    if (getUserData != null) {
      userName.value = "${getUserData!.firstName} ${getUserData!.lastName}";
      profilePic.value = APIImageUrl.url + getUserData!.profilePic.toString();
      email.value = getUserData!.emailId;
    }
    update();
  }

  bool states = false;
  final RxInt isDarkModeEnable = 1.obs;
  final getStorage = GetStorage();
  UserDetailData? loginData;

  Widget getMenuListItem(
      {String icon = "",
      IconData? iconDate,
      String title = "",
      Color? color,
      bool? isDark = false,
      Function? callback}) {
    return GestureDetector(
      onTap: () {
        if (callback != null) callback();
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: 3.w,
            vertical:
                SizerUtil.deviceType == DeviceType.mobile ? 0.6.h : 0.8.h),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.5.h),
          color: tileColour,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 4.5.h,
              width: 4.5.h,
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: Padding(
                padding: EdgeInsets.all(1.w),
                child: Icon(
                  iconDate,
                  color: tileColour,
                  size: 2.5.h,
                ),
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode() ? black : headingTextColor),
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
            Row(
              children: [
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDarkMode()
                      ? rightMenuDarkBackgroundColor
                      : primaryColor,
                  size: 5.w,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void getUserById(context) async {
    var loadingIndicator = LoadingProgressDialog();
    loadingIndicator.show(context, '');
    try {
      if (networkManager.connectionType == 0) {
        state.value = ScreenState.apiSuccess;
        loadingIndicator.hide(context);
        showDialogForScreen(
            context, BottomConstant.profile, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      var response = await Repository.get(
          {}, "${ApiUrl.getUser}/${getUserData!.id}",
          allowHeader: true);
      loadingIndicator.hide(context);
      logcat("RESPONSE::", response.body);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          loginData = UserDetailData.fromJson(responseData['data']);
          userName.value = loginData!.userName.toString();
          profilePic.value = APIImageUrl.url + loginData!.profilePic.toString();
          update();
        } else {
          message.value = responseData['message'];
          showDialogForScreen(
              context, BottomConstant.profile, responseData['message'],
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(
            context, BottomConstant.profile, ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      logcat("Ecxeption", e);
      state.value = ScreenState.apiError;
      message.value = ServerError.servererror;
      loadingIndicator.hide(context);
    }
  }
}
