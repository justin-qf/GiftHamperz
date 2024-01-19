import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/internet_controller.dart';
import 'package:gifthamperz/models/loginModel.dart';
import 'package:gifthamperz/preference/UserPreference.dart';
import 'package:gifthamperz/utils/enum.dart';
import 'package:gifthamperz/utils/helper.dart';
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
  RxBool? isGuest;

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void setData() async {
    getUserData = await UserPreferences().getSignInInfo();
    if (getUserData != null) {
      userName.value = "${getUserData!.firstName} ${getUserData!.lastName}";
      profilePic.value = APIImageUrl.url + getUserData!.profilePic.toString();
      email.value = getUserData!.emailId;
      //isGuest!.value = await UserPreferences().getGuestUser();
    }
    update();
  }

  bool states = false;
  final RxInt isDarkModeEnable = 0.obs;
  final getStorage = GetStorage();
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
}
