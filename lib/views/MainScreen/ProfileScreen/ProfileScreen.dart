import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/get_storage_key.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/profile_controller.dart';
import 'package:gifthamperz/controller/theme_controller.dart';
import 'package:gifthamperz/models/loginModel.dart';
import 'package:gifthamperz/preference/UserPreference.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/BlogScreen/BlogScreen.dart';
import 'package:gifthamperz/views/ChangePasswordScreen/ChangePasswordScreen.dart';
import 'package:gifthamperz/views/EditProfile/EditProfileScreen.dart';
import 'package:gifthamperz/views/OrderScreen/OrderScreen.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var controller = Get.put(ProfileController());
  UserData? getUserData;

  @override
  void initState() {
    super.initState();
    setUserData();
  }

  setUserData() async {
    getUserData = await UserPreferences().getSignInInfo();
    controller.setData(getUserData!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbarProfile(false);
    return CustomParentScaffold(
      onWillPop: () async {
        logcat("onWillPop", "DONE");
        return true;
      },
      onTap: () {
        controller.hideKeyboard(context);
      },
      isSafeArea: false,
      body: Container(
        color: transparent,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: FadeInDown(
                child: SizedBox(
                  height: SizerUtil.height / 2 + SizerUtil.height / 4,
                  child: Image.asset(
                    Asset.loginBg,
                    fit: BoxFit.cover,
                    height: SizerUtil.height,
                    width: SizerUtil.width,
                  ),
                ),
              ),
            ),
            Positioned(
                left: 5.w,
                top: 30.h,
                child: SizedBox(
                  width: SizerUtil.width,
                  child: FadeInLeft(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            height: 9.h,
                            imageUrl: " item.thumbnailUrl",
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(
                                  color: primaryColor),
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              Asset.avaterTwoholder,
                              height: 9.h,
                              width: 9.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            child: Obx(
                              () {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          controller.userName.value,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 15.sp,
                                              color: black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    // SizedBox(
                                    //   height: 1.h,
                                    // ),
                                    // Text(controller.email.value,
                                    //     overflow: TextOverflow.ellipsis,
                                    //     maxLines: 1,
                                    //     style: TextStyle(
                                    //         fontSize: 10.sp,
                                    //         color: black,
                                    //         fontWeight: FontWeight.w500)),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ])),
                )),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: FadeInUp(
                child: Container(
                  height: 60.h,
                  padding: EdgeInsets.only(
                      left: 2.2.w, right: 2.2.w, top: 2.0.h, bottom: 12.h),
                  decoration: BoxDecoration(
                      color: isDarkMode() ? darkBackgroundColor : white,
                      boxShadow: [
                        BoxShadow(
                            color: grey.withOpacity(0.2),
                            blurRadius: 10.0,
                            offset: const Offset(0, 1),
                            spreadRadius: 3.0)
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.h),
                          topRight: Radius.circular(5.h))),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeInUp(
                          child: controller.getMenuListItem(
                              title: ProfileConstant.title,
                              callback: () {
                                Get.to(const EditProfileScreen())!
                                    .then((value) {
                                  Statusbar().trasparentStatusbarProfile(false);
                                });
                              },
                              color: profileOneColor,
                              iconDate: Icons.person_rounded,
                              icon: Asset.viewfamily),
                        ),
                        FadeInUp(
                          child: controller.getMenuListItem(
                              title: ProfileConstant.order,
                              callback: () {
                                Get.to(const OrderScreen())!.then((value) {
                                  Statusbar().trasparentStatusbarProfile(false);
                                });
                              },
                              color: profileTwoColor,
                              iconDate: Icons.format_list_bulleted,
                              icon: Asset.viewfamily),
                        ),
                        // FadeInUp(
                        //   child: controller.getMenuListItem(
                        //       title: ProfileConstant.payment,
                        //       callback: () {},
                        //       color: profileThreeColor,
                        //       iconDate: Icons.monetization_on_outlined,
                        //       icon: Asset.viewfamily),
                        // ),
                        // FadeInUp(
                        //   child: controller.getMenuListItem(
                        //       title: ProfileConstant.settings,
                        //       callback: () {},
                        //       color: profileFourColor,
                        //       iconDate: Icons.settings,
                        //       icon: Asset.viewfamily),
                        // ),
                        FadeInUp(
                          child: controller.getMenuListItem(
                              title: ProfileConstant.help,
                              callback: () {},
                              color: profileFiveColor,
                              iconDate: Icons.help_outline_outlined,
                              icon: Asset.viewfamily),
                        ),
                        FadeInUp(
                          child: controller.getMenuListItem(
                              title: ProfileConstant.changePassword,
                              callback: () {
                                Get.to(const ChangePasswordScreen())!
                                    .then((value) {
                                  Statusbar().trasparentStatusbarProfile(false);
                                });
                              },
                              color: profileSixColor,
                              iconDate: Icons.lock_outline_rounded,
                              icon: Asset.viewfamily),
                        ),
                        FadeInUp(
                          child: controller.getMenuListItem(
                              title: ProfileConstant.blog,
                              callback: () {
                                Get.to(const BlocgScreen())!.then((value) {
                                  Statusbar().trasparentStatusbarProfile(false);
                                });
                              },
                              color: profileSevenColor,
                              iconDate: Icons.featured_play_list_rounded,
                              icon: Asset.viewfamily),
                        ),
                        FadeInUp(
                          child: getMenuListItem(
                              title: ProfileConstant.darkMode,
                              callback: () {},
                              isDark: true,
                              color: profileEightColor,
                              iconDate: Icons.brightness_4_outlined,
                              icon: Asset.viewfamily),
                        ),
                        FadeInUp(
                          child: controller.getMenuListItem(
                              title: ProfileConstant.logout,
                              callback: () {
                                PopupDialogs(context);
                              },
                              color: profileThreeColor,
                              iconDate: Icons.logout_outlined,
                              icon: Asset.viewfamily),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                left: 0,
                right: 0,
                top: 20.h,
                child: Visibility(
                  visible: false,
                  child: FadeInUp(
                    child: SizedBox(
                      height: 20.h,
                      width: SizerUtil.width,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            width: 13.h,
                            height: 13.h,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1.w),
                              borderRadius: BorderRadius.circular(80),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5.0,
                                )
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                              child: Image.asset(
                                "assets/pngs/avtar.png",
                                height: 16.h,
                                width: 16.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

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
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.8.h),
          color: primaryColor.withOpacity(0.08),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 5.h,
              width: 5.h,
              decoration: BoxDecoration(
                color: color!,
                borderRadius: const BorderRadius.all(Radius.circular(50)),
              ),
              child: Padding(
                padding: EdgeInsets.all(1.w),
                child: Icon(
                  iconDate,
                  color: white,
                  size: 3.h,
                ),
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode() ? white : headingTextColor),
              ),
            ),
            const Spacer(),
            CupertinoSwitch(
              value: isDarkMode() ? true : false,
              onChanged: (value) async {
                controller.states = value;
                controller.isDarkModeEnable.value =
                    controller.isDarkModeEnable.value == 0 ? 1 : 0;
                setState(() {});
                await controller.getStorage.write(GetStorageKey.IS_DARK_MODE,
                    controller.isDarkModeEnable.value);
                Get.find<ThemeController>()
                    .updateState(controller.isDarkModeEnable.value);
                Get.find<ThemeController>().update();
                logcat('DarkModeStatus',
                    (controller.getStorage.read(GetStorageKey.IS_DARK_MODE)));
                setState(() {});
              },
              thumbColor: white,
              activeColor: black,
              trackColor: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
