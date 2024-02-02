import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/preference/UserPreference.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/views/LoginScreen/LoginScreen.dart';
import 'package:sizer/sizer.dart';
import '../../configs/string_constant.dart';

getToolbar(String title, Function onClick, Function cartOnClick, int budget) {
  return Stack(
    children: [
      Positioned(left: 0, top: 0, child: getLogo()),
      Center(
        child: FadeInDown(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: fontBold,
              color: isDarkMode() ? white : black,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
        ),
      ),
      Positioned(
        top: -5,
        right: 1.5.w,
        bottom: 0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.blueGrey,
              child: IconButton(
                alignment: Alignment.centerRight,
                icon: const Icon(Icons.search),
                color: isDarkMode() ? white : black,
                iconSize: 3.5.h,
                onPressed: () {
                  onClick();
                },
              ),
            ),
            Container(
              color: Colors.amber,
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    color: isDarkMode() ? white : black,
                    iconSize: 3.3.h,
                    onPressed: () {
                      cartOnClick();
                    },
                  ),
                  Positioned(
                    right: 3,
                    top: 5,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        budget.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

homeAppbar(String title, Function onClick, Function cartOnClick, RxInt budget) {
  return Padding(
    padding: EdgeInsets.only(left: 1.w, right: 2.w, top: 0.5.h),
    child: Row(
      children: [
        getLogo(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 1, left: 9, right: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16.5.sp,
                    color: isDarkMode() ? white : black,
                    fontFamily: fontBold,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            onClick();
          },
          child: Container(
            padding:
                const EdgeInsets.only(left: 2, right: 1, top: 2, bottom: 2),
            child: Icon(
              color: isDarkMode() ? white : primaryColor,
              Icons.search,
              size: 3.3.h,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            cartOnClick();
          },
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    color: isDarkMode() ? white : primaryColor,
                    Icons.shopping_cart,
                    size: 3.3.h,
                  )),
              Positioned(
                right: 3,
                top: 2,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: bottomNavBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 4.0.w,
                    minHeight: 0.6.h,
                  ),
                  child: Text(
                    budget.value.toString(),
                    style: TextStyle(
                      color: isDarkMode() ? white : black,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

bool isSmallDevice(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  // Retrieve the screen height
  final screenHeight = mediaQuery.size.height;
  // Define the threshold height below which the device is considered small
  const smallDeviceHeightThreshold = 700.0;
  // Check if the device is small based on the screen height
  return screenHeight < smallDeviceHeightThreshold;
}

getSizedBox() {
  return SizedBox(
    height: 1.7.h,
  );
}

getDynamicSizedBox({height, width}) {
  return SizedBox(
    height: height ?? 0,
    width: width ?? 0,
  );
}

checkInternet() {
  return Scaffold(
      body: SizedBox(
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Asset.noInternet,
            height: 20.h,
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            textAlign: TextAlign.center,
            "Please Check Your\nInternet Connection.",
            style: TextStyle(
              color: Colors.red,
              fontFamily: fontBold,
              fontSize: 18.sp,
            ),
          ),
        ],
      ),
    ),
  ));
}

getSizedBoxForDropDown() {
  return SizedBox(
    height: 0.90.h,
  );
}

getToolbarNav(
  title,
) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeInDown(
            child: Text(
              title,
              style: TextStyle(
                  fontFamily: fontBold,
                  color: headingTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp),
            ),
          ),
        ],
      ),
    ],
  );
}

getCommonToolbar(title,
    {bool showBackButton = true, bool isForget = true, Function? callback}) {
  return Row(
    children: [
      if (showBackButton) backButtonWidget(callback, fromFilter: true),
      Expanded(
        flex: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeInDown(
              child: Container(
                margin: EdgeInsets.only(right: showBackButton ? 15.w : 0),
                child: Text(
                  title,
                  style: TextStyle(
                      fontFamily: fontBold,
                      color: isDarkMode() ? white : headingTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

getDetailToolbar({
  Function? backCallback,
  Function? shareCallback,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        margin: EdgeInsets.only(
            top: SizerUtil.deviceType == DeviceType.mobile ? 3.5.h : 1.5.h,
            left: SizerUtil.deviceType == DeviceType.mobile ? 2.w : 2.w),
        child: GestureDetector(
          onTap: () {
            backCallback!();
          },
          child: Container(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                Asset.arrowBack,
                // ignore: deprecated_member_use
                color: white,
                height: SizerUtil.deviceType == DeviceType.mobile ? 4.h : 5.h,
              )),
        ),
      ),
      const Spacer(),
      Container(
        margin: EdgeInsets.only(
            top: SizerUtil.deviceType == DeviceType.mobile ? 3.5.h : 1.5.h,
            right: SizerUtil.deviceType == DeviceType.mobile ? 2.w : 3.w),
        child: GestureDetector(
          onTap: () {
            shareCallback!();
          },
          child: Container(
              padding: const EdgeInsets.all(10),
              child: Icon(
                Icons.favorite_rounded,
                color: white,
                size: SizerUtil.deviceType == DeviceType.mobile ? 3.5.h : 5.h,
              )),
        ),
      ),
    ],
  );
}

getForgetToolbar(title,
    {bool showBackButton = true, bool isList = true, Function? callback}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (showBackButton) backPressCommon(callback, isList: true),
      Expanded(
        flex: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeInDown(
              child: Container(
                margin: EdgeInsets.only(right: showBackButton ? 15.w : 0),
                child: Text(
                  title,
                  style: TextStyle(
                      fontFamily: fontBold,
                      color: isDarkMode() ? white : headingTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

getFilterToolbar(title,
    {Function? callback, Function? searchClick, bool? isFilter}) {
  return Stack(
    children: [
      Center(
        child: FadeInDown(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: fontBold,
                color: isDarkMode() ? white : headingTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp),
          ),
        ),
      ),
      Positioned(
          top: -3,
          right: 0,
          bottom: 0,
          child: FadeInDown(
            child: Row(
              children: [
                isFilter == null
                    ? GestureDetector(
                        onTap: () {
                          searchClick!();
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 5.w),
                          child: Icon(
                            Icons.search,
                            size: 3.5.h,
                            color: isDarkMode() ? white : primaryColor,
                          ),
                        ),
                      )
                    : Container(),
                // GestureDetector(
                //   onTap: () {
                //     callback!();
                //   },
                //   child: Container(
                //     margin: EdgeInsets.only(right: 5.w),
                //     child: Icon(
                //       isFilter == true ? Icons.cancel : Icons.tune_rounded,
                //       size: 3.5.h,
                //       color: isDarkMode() ? white : primaryColor,
                //     ),
                //   ),
                // ),
              ],
            ),
          )),
    ],
  );
}

// getFilterToolbar(title,
//     {Function? callback, Function? searchClick, bool? isFilter}) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: [
//       const Spacer(),
//       FadeInDown(
//         child: Container(
//           margin: EdgeInsets.only(left: 12.w),
//           child: Text(
//             title,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 fontFamily: fontBold,
//                 color: isDarkMode() ? white : headingTextColor,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18.sp),
//           ),
//         ),
//       ),
//       const Spacer(),
//       FadeInDown(
//         child: Row(
//           children: [
//             isFilter == null
//                 ? GestureDetector(
//                     onTap: () {
//                       searchClick!();
//                     },
//                     child: Container(
//                       margin: EdgeInsets.only(right: 3.w),
//                       child: Icon(
//                         Icons.search,
//                         size: 4.h,
//                         color: isDarkMode() ? white : primaryColor,
//                       ),
//                     ),
//                   )
//                 : Container(),
//             GestureDetector(
//               onTap: () {
//                 callback!();
//               },
//               child: Container(
//                 margin: EdgeInsets.only(right: 5.w),
//                 child: Icon(
//                   isFilter == true ? Icons.cancel : Icons.tune_rounded,
//                   size: 4.h,
//                   color: isDarkMode() ? white : primaryColor,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       )
//     ],
//   );
// }

getViewFamilyMember(title,
    {bool showBackButton = true, bool isForget = true, Function? callback}) {
  return Row(
    children: [
      if (showBackButton)
        isForget ? iosBackPress(callback) : backButtonWidget(callback),
      Expanded(
        flex: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeInDown(
              child: Container(
                margin: EdgeInsets.only(right: 8.w),
                child: Text(
                  title,
                  style: TextStyle(
                      fontFamily: fontBold,
                      color: headingTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

getAddPresToolbar(title, {bool showBackButton = true, Function? callback}) {
  return Row(
    children: [
      if (showBackButton) iosBackPress(callback),
      Expanded(
        flex: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeInDown(
              child: Container(
                margin: EdgeInsets.only(right: 10.w),
                child: Text(
                  title,
                  style: TextStyle(
                      fontFamily: fontBold,
                      color: headingTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

getViewMedicalHistory(title,
    {bool showBackButton = true,
    Function? callback,
    Function? filterCallback}) {
  return Row(
    children: [
      if (showBackButton) iosBackPress(callback),
      Expanded(
        flex: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showBackButton == false) const Spacer(),
            FadeInDown(
              child: Container(
                margin:
                    EdgeInsets.only(left: showBackButton == true ? 3.w : 10.w),
                child: Text(
                  title,
                  style: TextStyle(
                      fontFamily: fontBold,
                      color: headingTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp),
                ),
              ),
            ),
            const Spacer(),
            FadeInDown(
              child: GestureDetector(
                onTap: () {
                  filterCallback!();
                },
                child: Container(
                  margin: EdgeInsets.only(right: 5.w),
                  child: SvgPicture.asset(
                    Asset.filter,
                    height: 7.0.w,
                    width: 7.0.w,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

getViewUploads(title,
    {bool showBackButton = true,
    Function? callback,
    Function? filterCallback}) {
  return Row(
    children: [
      if (showBackButton) backPress(callback),
      Expanded(
        flex: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            FadeInDown(
              child: Text(
                title,
                style: TextStyle(
                    fontFamily: fontBold,
                    color: headingTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp),
              ),
            ),
            const Spacer(),
            FadeInDown(
              child: GestureDetector(
                onTap: () {
                  filterCallback!();
                },
                child: Container(
                  margin: EdgeInsets.only(
                      right: SizerUtil.deviceType == DeviceType.mobile
                          ? 6.w
                          : 5.w),
                  child: SvgPicture.asset(
                    Asset.filter,
                    height: 7.0.w,
                    width: 7.0.w,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

getViewProfile(title, {bool showBackButton = true, Function? callback}) {
  return Row(
    children: [
      if (showBackButton) iosBackPress(callback),
      Expanded(
        flex: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeInDown(
              child: Container(
                margin: EdgeInsets.only(right: 15.w),
                child: Text(
                  title,
                  style: TextStyle(
                      fontFamily: fontBold,
                      color: headingTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

getdivider() {
  return Divider(
    height: 3.5.h,
    indent: 0.1.h,
    endIndent: 0.1.h,
    thickness: 1,
    color: primaryColor.withOpacity(0.5),
  );
}

getVerticalDivider() {
  return Container(
    decoration: BoxDecoration(
        color: lableColor.withOpacity(0.2),
        boxShadow: [
          BoxShadow(
              color: grey.withOpacity(0.2),
              blurRadius: 0.0,
              offset: const Offset(0, 1),
              spreadRadius: 0.0)
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(5.h),
        )),
    width: 0.2.w, //width space of divider
    height: 1.5.h,
  );
}

getDividerForShowDialog() {
  return Divider(
    height: 0.5.h,
    indent: 0.1.h,
    endIndent: 0.1.h,
    thickness: 1,
    color: isDarkMode() ? white : primaryColor.withOpacity(0.5),
  );
}

getAddFamilyMemberToolbar(title,
    {bool showBackButton = true, Function? callback}) {
  return Row(
    children: [
      if (showBackButton) iosBackPress(callback),
      Expanded(
        flex: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeInDown(
              child: Container(
                margin: EdgeInsets.only(right: 8.w),
                child: Text(
                  title,
                  style: TextStyle(
                      fontFamily: fontBold,
                      color: headingTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

getOtpVerificationToolbar(title,
    {bool showBackButton = true, Function? callback}) {
  return Row(
    children: [
      if (showBackButton) iosBackPress(callback),
      Expanded(
        flex: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeInDown(
              child: Container(
                margin: EdgeInsets.only(right: 13.w),
                child: Text(
                  title,
                  style: TextStyle(
                      fontFamily: fontBold,
                      color: headingTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget backPress(callback) {
  return FadeInDown(
    child: GestureDetector(
      onTap: () {
        callback();
      },
      child: Container(
        margin: EdgeInsets.only(
            left: SizerUtil.deviceType == DeviceType.mobile ? 3.w : 2.3.w),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: SvgPicture.asset(
            Asset.arrowBack,
            height: SizerUtil.deviceType == DeviceType.mobile ? 4.h : 5.h,
            fit: BoxFit.contain, // Adjust this to your needs
          ),
          //  ShaderMask(
          //   child: SvgPicture.asset(
          //     Asset.arrowBack,
          //     // ignore: deprecated_member_use
          //     color: white,
          //     height: SizerUtil.deviceType == DeviceType.mobile ? 4.h : 5.h,
          //     fit: BoxFit.contain, // Adjust this to your needs
          //   ),
          //   shaderCallback: (Rect bounds) {
          //     const rect = LinearGradient(
          //       colors: [primaryColor, secondaryColor], // Adjust the colors
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //     );
          //     return rect.createShader(bounds);
          //   },
          // )
        ),
      ),
    ),
  );
}

Widget iosBackPress(callback) {
  return FadeInDown(
    child: Container(
      margin: EdgeInsets.only(
          left: SizerUtil.deviceType == DeviceType.mobile ? 3.w : 5.w),
      child: GestureDetector(
        onTap: () {
          callback();
        },
        child: Container(
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset(
              Asset.arrowBack,
              height: SizerUtil.deviceType == DeviceType.mobile ? 4.h : 5.h,
            )),
      ),
    ),
  );
}

Widget orderBackPress(callback) {
  return FadeInDown(
    child: GestureDetector(
      onTap: () {
        callback();
      },
      child: Container(
          padding: EdgeInsets.only(
            left: 5.w,
          ),
          child: SvgPicture.asset(
            Asset.arrowBack,
            // ignore: deprecated_member_use
            color: isDarkMode() ? white : black,
            height: SizerUtil.deviceType == DeviceType.mobile ? 4.h : 5.h,
          )),
    ),
  );
}

getOrderToolbar(title) {
  return Row(
    children: [
      orderBackPress(() {
        Get.back();
      }),
      Expanded(
        flex: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeInDown(
              child: Container(
                margin: EdgeInsets.only(right: 10.w),
                child: Text(
                  title,
                  style: TextStyle(
                      fontFamily: fontBold,
                      color: isDarkMode() ? white : headingTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget backPressCommon(callback, {bool? isList}) {
  return FadeInDown(
    child: GestureDetector(
      onTap: () {
        callback();
      },
      child: Container(
          padding: EdgeInsets.only(bottom: 2.w, left: 5.w),
          child: SvgPicture.asset(
            Asset.arrowBack,
            color: isDarkMode() ? white : black,
            height: SizerUtil.deviceType == DeviceType.mobile ? 4.h : 5.h,
          )),
    ),
  );
}

Widget backButtonWidget(callback, {bool? fromFilter, bool? fromReviewImage}) {
  return FadeInDown(
    child: Container(
      margin: EdgeInsets.only(
          left: SizerUtil.deviceType == DeviceType.mobile
              ? fromFilter == true
                  ? 2.w
                  : 3.w
              : 2.w),
      child: GestureDetector(
        onTap: () {
          callback();
        },
        child: Container(
            padding: EdgeInsets.only(bottom: 2.w, left: 3.w),
            child: SvgPicture.asset(
              Asset.arrowBack,
              color: fromReviewImage == true
                  ? white
                  : isDarkMode()
                      ? white
                      : black,
              height: SizerUtil.deviceType == DeviceType.mobile ? 4.h : 5.h,
            )),
      ),
    ),
  );
}

Widget getLogo() {
  return Container(
      padding: EdgeInsets.only(left: 2.5.w, right: 1.w),
      height: 3.6.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: FadeInLeft(
        child: SvgPicture.asset(
          Asset.logo,
          height: 5.h,
        ),
      ));
}

Widget notification(isNotify) {
  return GestureDetector(
    onTap: () {
      isNotify();
    },
    child: Container(
      padding: EdgeInsets.only(left: 1.w, right: 0.3.w),
      margin: EdgeInsets.only(
          right: 2.w,
          left: SizerUtil.deviceType == DeviceType.mobile ? 9.w : 11.w),
      height: 3.5.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Icon(
        Icons.notifications_outlined,
        color: Colors.black,
        size: 3.5.h,
      ),
    ),
  );
}

// ignore: non_constant_identifier_names
Future<Object?> PopupDialogs(BuildContext context, bool? isFromPayment) {
  return showGeneralDialog(
      barrierColor: black.withOpacity(0.6),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOut.transform(a1.value);
        return Transform.translate(
          offset: Offset(0, (1 - curvedValue) * 400),
          child: Opacity(
              opacity: a1.value,
              child: CupertinoAlertDialog(
                title: Text(
                  isFromPayment == true ? Payment.title : Logout.title,
                  style: TextStyle(
                    fontSize: 18,
                    color: isDarkMode() ? white : black,
                    fontFamily: fontBold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text(
                  isFromPayment == true ? Payment.heading : Logout.heading,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode() ? white : black,
                    fontFamily: fontMedium,
                  ),
                ),
                actions: [
                  if (isFromPayment != true)
                    CupertinoDialogAction(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      isDefaultAction: true,
                      isDestructiveAction: true,
                      child: Text(Logout.no,
                          style: TextStyle(
                            fontSize: 15,
                            color: isDarkMode() ? white : black,
                            fontFamily: fontBold,
                            fontWeight: FontWeight.bold,
                          )),
                    ),

                  CupertinoDialogAction(
                    onPressed: () {
                      Navigator.pop(context);
                      if (isFromPayment != true) {
                        UserPreferences().logout();
                        Get.offAll(const LoginScreen());
                      }
                    },
                    isDefaultAction: true,
                    isDestructiveAction: true,
                    child: Text(isFromPayment == true ? Payment.ok : Logout.yes,
                        style: TextStyle(
                          fontSize: 15,
                          color: isDarkMode() ? white : black,
                          fontFamily: fontBold,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  // The "No" button
                ],
              )),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      });
}

getImage(title,
    {bool showBackButton = true, bool isForget = true, Function? callback}) {
  return Row(
    children: [
      backButtonWidget(callback, fromReviewImage: true),
      Expanded(
        flex: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeInDown(
              child: Container(
                margin: EdgeInsets.only(right: 15.w),
                child: Text(
                  title,
                  style: TextStyle(
                      fontFamily: fontBold,
                      color: white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
