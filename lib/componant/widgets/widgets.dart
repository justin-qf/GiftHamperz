import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:gifthamperz/componant/dialogs/customDialog.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:pinput/pinput.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';
import '../../configs/colors_constant.dart';
import '../../configs/font_constant.dart';

Widget getRow(title, desc, {isComplaint = false}) {
  return Container(
    margin: EdgeInsets.only(left: 2.w, right: 2.w),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 30.w,
          child: Text(
            title,
            style: TextStyle(
                fontFamily: fontMedium,
                fontSize: 11.sp,
                fontWeight: FontWeight.w900),
          ),
        ),
        Text(
          ":",
          style: TextStyle(
              fontFamily: fontMedium,
              fontSize: 11.sp,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          width: 1.w,
        ),
        isComplaint
            ? Expanded(
                child: ReadMoreText(
                  desc,
                  trimLines: 3,
                  colorClickableText: Colors.pink,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Show more',
                  trimExpandedText: 'Show less',
                  style: TextStyle(
                      fontFamily: fontMedium,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400),
                  lessStyle: TextStyle(
                      color: primaryColor,
                      fontFamily: fontMedium,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold),
                  moreStyle: TextStyle(
                      color: primaryColor,
                      fontFamily: fontMedium,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold),
                ),
              )
            : Expanded(
                child: Text(
                  desc,
                  style: TextStyle(
                      fontFamily: fontMedium,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400),
                ),
              ),
      ],
    ),
  );
}

Widget getLoginFooter() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        LoginConst.dontHaveAccount,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: headingTextColor,
            fontWeight: FontWeight.w500,
            fontSize: 11.sp),
      ),
      SizedBox(
        width: 1.h,
      ),
      Text(
        LoginConst.signup,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: headingTextColor,
            fontWeight: FontWeight.w600,
            fontSize: 12.sp),
      ),
    ],
  );
}

void showCustomToast(BuildContext context, String message) {
  OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 10.h,
      width: SizerUtil.width,
      child: Material(
        color: transparent,
        child: Container(
          margin: EdgeInsets.only(left: 10.w, right: 10.w),
          padding:
              EdgeInsets.only(top: 1.5.h, bottom: 1.5.h, left: 5.w, right: 5.w),
          decoration: BoxDecoration(
            color: isDarkMode() ? darkBackgroundColor : primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: isDarkMode() ? white : white,
                fontSize:
                    SizerUtil.deviceType == DeviceType.mobile ? 12.sp : 10.sp),
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry);
  // Close the overlay after a certain duration
  Future.delayed(const Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}

Widget getRadio(String title, String groupValue, Function onChange) {
  return RadioListTile(
    activeColor: primaryColor,
    contentPadding: EdgeInsets.only(
        left: SizerUtil.deviceType == DeviceType.mobile ? 5.5.w : 15.w),
    visualDensity: const VisualDensity(horizontal: -4),
    title: Text(
      title,
      style: TextStyle(
          fontSize: SizerUtil.deviceType == DeviceType.mobile ? 12.sp : 10.sp),
    ),
    value: title,
    groupValue: groupValue,
    onChanged: (value) {
      onChange(value);
    },
  );
}

Widget getFooter(isLogin) {
  return RichText(
    overflow: TextOverflow.clip,
    textAlign: TextAlign.start,
    softWrap: true,
    textScaleFactor: 1,
    text: TextSpan(
      text: isLogin == true
          ? LoginConst.dontHaveAccount
          : SignupConstant.haveAnAccount,
      style: TextStyle(
          color: isDarkMode() ? grey : lableColor,
          fontWeight: FontWeight.w500,
          fontSize: 11.sp),
      children: [
        TextSpan(
          text: isLogin == true
              ? " ${LoginConst.signup}"
              : " ${LoginConst.signIn}",
          style: TextStyle(
              fontFamily: fontBold,
              color: isDarkMode() ? white : primaryColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w800),
        )
      ],
    ),
  );
}

Widget getRichText(title, desc) {
  return RichText(
    overflow: TextOverflow.clip,
    textAlign: TextAlign.start,
    softWrap: true,
    textScaleFactor: 1,
    maxLines: 16,
    text: TextSpan(
      text: title,
      style: TextStyle(
          overflow: TextOverflow.ellipsis,
          color: isDarkMode() ? black : black,
          fontFamily: fontExtraBold,
          fontSize: 11.sp),
      children: [
        TextSpan(
          text: desc,
          style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontFamily: fontRegular,
              color: isDarkMode() ? black : black,
              fontSize: 10.sp,
              fontWeight: FontWeight.w400),
        )
      ],
    ),
  );
}

Widget getHomeLable(String title, Function onCLick) {
  return FadeInRight(
    child: Container(
      margin: EdgeInsets.only(left: 3.w, right: 2.w),
      width: SizerUtil.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              style: TextStyle(
                color: isDarkMode() ? white : black,
                fontFamily: fontBold,
                fontWeight: FontWeight.w800,
                fontSize: 16.sp,
              )),
          const Spacer(),
          GestureDetector(
            onTap: () {
              onCLick();
            },
            child: Text("See All",
                style: TextStyle(
                  color: isDarkMode() ? white : primaryColor,
                  fontFamily: fontRegular,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                )),
          ),
          getDynamicSizedBox(width: 0.3.w),
          Icon(
            Icons.chevron_right_sharp,
            color: isDarkMode() ? white : primaryColor,
            size: 6.w,
          )
        ],
      ),
    ),
  );
}

Widget getLable(String title, {bool? isFromFilter}) {
  return FadeInDown(
    child: Container(
      margin: EdgeInsets.only(left: 5.w),
      width: SizerUtil.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 0.2.h,
          ),
          Text(title,
              style: TextStyle(
                color: isDarkMode()
                    ? white
                    : isFromFilter == true
                        ? black
                        : black,
                fontFamily: isFromFilter == true ? fontExtraBold : fontBold,
                fontWeight: FontWeight.w500,
                fontSize: isFromFilter == true ? 13.sp : 11.sp,
              )),
        ],
      ),
    ),
  );
}

Widget getLogo(islogo) {
  return Container(
    margin: EdgeInsets.only(left: 3.w),
    child: GestureDetector(
      onTap: () {
        islogo();
      },
      child: Container(
          padding: EdgeInsets.only(left: 1.w, right: 1.w),
          margin: EdgeInsets.only(right: 5.w, left: 4.w),
          height: 3.5.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          // gradient: LinearGradient(
          //     colors: [primaryColor, primaryColor.withOpacity(0.5)],
          //     begin: const FractionalOffset(1.0, 0.0),
          //     end: const FractionalOffset(0.0, 0.0),
          //     stops: const [0.0, 1.0],
          //     tileMode: TileMode.clamp)),
          child: const Image(image: AssetImage(Asset.logoIcon))),
    ),
  );
}

Widget getPriceLable(String startPrice, String endPrice) {
  return Container(
    margin: EdgeInsets.only(left: 5.5.w),
    width: SizerUtil.width,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('Prices: ',
            style: TextStyle(
              color: isDarkMode() ? white : black,
              fontFamily: fontBold,
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
            )),
        getDynamicSizedBox(width: 1.w),
        Text("${IndiaRupeeConstant.inrCode}$startPrice",
            style: TextStyle(
              color: primaryColor,
              fontFamily: fontBold,
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            )),
        Text("-",
            style: TextStyle(
              color: primaryColor,
              fontFamily: fontRegular,
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            )),
        Text("${IndiaRupeeConstant.inrCode}$endPrice",
            style: TextStyle(
              color: primaryColor,
              fontFamily: fontBold,
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            )),
      ],
    ),
  );
}

Widget getDivider() {
  return Divider(
    height: 0.1.h,
    color: grey,
  );
}

Widget getComplaintRow(title, desc) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
            fontFamily: fontMedium,
            fontSize: 11.sp,
            fontWeight: FontWeight.w900),
      ),
      Text(
        ":",
        style: TextStyle(
            fontFamily: fontMedium,
            fontSize: 11.sp,
            fontWeight: FontWeight.w400),
      ),
      SizedBox(
        width: 1.w,
      ),
      ReadMoreText(
        desc,
        trimLines: 3,
        colorClickableText: Colors.pink,
        trimMode: TrimMode.Line,
        trimCollapsedText: 'Show more',
        trimExpandedText: 'Show less',
        style: TextStyle(
            fontFamily: fontMedium,
            fontSize: 11.sp,
            fontWeight: FontWeight.w400),
        lessStyle: TextStyle(
            color: primaryColor,
            fontFamily: fontMedium,
            fontSize: 11.sp,
            fontWeight: FontWeight.bold),
        moreStyle: TextStyle(
            color: primaryColor,
            fontFamily: fontMedium,
            fontSize: 11.sp,
            fontWeight: FontWeight.bold),
      )
    ],
  );
}

Widget getCommonContainer(title, isFromAddCart, icon,
    {Function? addCartClick, Function? buyNowClick, bool? isEnable}) {
  return Expanded(
    child: GestureDetector(
      onTap: () {
        isFromAddCart == true ? addCartClick!() : buyNowClick!();
      },
      child: Container(
        decoration: BoxDecoration(
          color: isFromAddCart == true ? secondaryColor : white,
          boxShadow: [
            BoxShadow(
              color: grey.withOpacity(0.6),
              blurRadius: 2.0, // Adjust the blur radius as needed
              offset:
                  const Offset(0, -2), // Negative offset to create a top shadow
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: isFromAddCart == true
                ? Radius.circular(7.w)
                : const Radius.circular(0),
            topRight: isFromAddCart == true
                ? const Radius.circular(0)
                : Radius.circular(7.w),
          ),
        ),
        padding: EdgeInsets.only(top: 1.8.h, bottom: 1.8.h),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isDarkMode() ? black : black,
              ),
              getDynamicSizedBox(width: 2.w),
              Text(
                title,
                style: TextStyle(
                  color: isDarkMode() ? black : black,
                  fontFamily: fontBold,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5.sp,
                ),
              ),
            ]),
      ),
    ),
  );
}

Widget getAddToCartBtn(title, icon,
    {Function? addCartClick, RxBool? isAddToCartClicked, bool? isEnable}) {
  return GestureDetector(
    onTap: () {
      addCartClick!();
    },
    child: Container(
      decoration: BoxDecoration(
        color: isAddToCartClicked != null && isAddToCartClicked.value == true
            ? grey
            : bottomNavBackground,
        borderRadius: BorderRadius.all(
          Radius.circular(7.w),
        ),
      ),
      margin: EdgeInsets.only(left: 0.2.w, right: 0.2.w),
      padding:
          EdgeInsets.only(top: 0.6.h, bottom: 0.6.h, left: 1.5.w, right: 1.5.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 1.5.h,
            color: isDarkMode() ? black : black,
          ),
          getDynamicSizedBox(width: 0.5.w),
          Text(
            title,
            style: TextStyle(
              color: isDarkMode() ? black : black,
              fontFamily: fontBold,
              fontWeight: FontWeight.w700,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    ),
  );
}

// getGuestUserAlertDialog(BuildContext context, String screenName) {
//   return showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return CustomLoginAlertRoundedDialog(
//           screenName); // Use your custom dialog widget
//     },
//   );
// }

getGuestUserAlertDialog(BuildContext context, String screenName) async {
  return await showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 600),
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: CustomLoginAlertRoundedDialog(screenName),
      );
    },
    transitionBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}

getPinTheme() {
  return PinTheme(
    width: 56,
    height: 60,
    textStyle: TextStyle(
      fontFamily: fontMedium,
      fontSize: 18.sp,
      color: isDarkMode() ? black : const Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
      color: isDarkMode() ? white : const Color.fromRGBO(222, 231, 240, .57),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: isDarkMode() ? black : transparent),
    ),
  );
}

Widget getCounterUi() {
  return Container(
      padding:
          EdgeInsets.only(left: 2.7.w, right: 2.7.w, top: 0.4.h, bottom: 0.4.h),
      decoration: BoxDecoration(
          color: isDarkMode() ? darkBackgroundColor : white,
          boxShadow: [
            BoxShadow(
                color: grey.withOpacity(0.2),
                blurRadius: 1.0,
                offset: const Offset(0, 1),
                spreadRadius: 1.0)
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(5.h),
          )),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // if (data.quantity.value > 1) {
              //   data.quantity--;
              // }
              // update();
            },
            child: Icon(
              Icons.remove,
              size: 3.h,
            ),
          ),
          getDynamicSizedBox(width: 0.8.w),
          getVerticalDivider(),
          getDynamicSizedBox(width: 1.8.w),
          Text(
            "data.quantity.toString()",
            style: TextStyle(
              //fontFamily: fontBold,
              color: isDarkMode() ? white : black,
              fontWeight: FontWeight.w600,
              fontSize:
                  SizerUtil.deviceType == DeviceType.mobile ? 12.sp : 13.sp,
            ),
          ),
          getDynamicSizedBox(width: 1.8.w),
          getVerticalDivider(),
          GestureDetector(
            onTap: () {
              // data.quantity++;
            },
            child: Icon(
              Icons.add,
              size: 3.h,
            ),
          ),
        ],
      ));
}

Widget cartIncDecUi({String? qty, Function? increment, Function? decrement}) {
  return Container(
    padding:
        EdgeInsets.only(left: 2.5.w, right: 2.5.w, top: 0.3.h, bottom: 0.3.h),
    decoration: BoxDecoration(
        color: isDarkMode() ? darkBackgroundColor : darkGrey,
        boxShadow: [
          BoxShadow(
              color: grey.withOpacity(0.2),
              blurRadius: 1.0,
              offset: const Offset(0, 1),
              spreadRadius: 1.0)
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(5.h),
        )),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            decrement!();
          },
          child: Icon(
            Icons.remove,
            size: 2.h,
            color: isDarkMode() ? white : black,
          ),
        ),
        getDynamicSizedBox(width: 0.8.w),
        getVerticalDivider(),
        getDynamicSizedBox(width: 1.5.w),
        Text(
          qty.toString(),
          style: TextStyle(
            color: isDarkMode() ? white : black,
            fontWeight: FontWeight.w600,
            fontSize: SizerUtil.deviceType == DeviceType.mobile ? 12.sp : 13.sp,
          ),
        ),
        getDynamicSizedBox(width: 2.w),
        getVerticalDivider(),
        getDynamicSizedBox(width: 0.5.w),
        GestureDetector(
          onTap: () async {
            increment!();
          },
          child: Icon(
            Icons.add,
            size: 2.h,
            color: isDarkMode() ? white : black,
          ),
        ),
      ],
    ),
  );
}

Widget homeCartIncDecUi(
    {String? qty,
    Function? increment,
    Function? decrement,
    bool? isFromPopular}) {
  return Center(
    child: Container(
      margin: EdgeInsets.only(
          left: isFromPopular == true ? 5.w : 2.w,
          right: isFromPopular == true ? 5.w : 2.w),
      padding: EdgeInsets.only(
          left: isFromPopular == true ? 2.w : 1.5.w,
          right: isFromPopular == true ? 2.w : 1.5.w,
          top: 0.2.h,
          bottom: 0.2.h),
      decoration: BoxDecoration(
          color: isDarkMode() ? darkBackgroundColor : darkGrey,
          boxShadow: [
            BoxShadow(
                color: grey.withOpacity(0.2),
                blurRadius: 1.0,
                offset: const Offset(0, 1),
                spreadRadius: 1.0)
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(5.h),
          )),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              decrement!();
            },
            child: Icon(
              Icons.remove,
              size: 3.h,
              color: isDarkMode() ? white : black,
            ),
          ),
          getDynamicSizedBox(width: isFromPopular == true ? 3.w : 2.w),
          getVerticalDivider(),
          getDynamicSizedBox(width: isFromPopular == true ? 3.w : 2.w),
          Text(
            qty.toString(),
            style: TextStyle(
              color: isDarkMode() ? white : black,
              fontWeight: FontWeight.w600,
              fontSize:
                  SizerUtil.deviceType == DeviceType.mobile ? 12.sp : 13.sp,
            ),
          ),
          getDynamicSizedBox(width: isFromPopular == true ? 3.w : 2.w),
          getVerticalDivider(),
          getDynamicSizedBox(width: isFromPopular == true ? 3.w : 2.w),
          GestureDetector(
            onTap: () async {
              increment!();
            },
            child: Icon(
              Icons.add,
              size: 3.h,
              color: isDarkMode() ? white : black,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget noDataFoundWidget({bool? isFromBlog}) {
  return SizedBox(
    height:
        isFromBlog == true ? SizerUtil.height / 1.4 : SizerUtil.height / 1.2,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            Common.datanotfound,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: fontMedium,
                fontSize: 12.sp,
                color: isDarkMode() ? white : black),
          ),
        ],
      ),
    ),
  );
}

Widget homeOfferBanner() {
  return Container(
    width: SizerUtil.width,
    height: 15.h,
    padding: EdgeInsets.all(0.2.h),
    margin: EdgeInsets.only(left: 3.5.w, right: 3.w),
    decoration: BoxDecoration(
        color: isDarkMode() ? darkBackgroundColor : white,
        boxShadow: [
          BoxShadow(
              color: isDarkMode() ? white : grey,
              blurRadius: 1.0,
              offset: const Offset(0, 2),
              spreadRadius: 0.5)
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(2.h),
        )),
    child: ClipRRect(
        borderRadius: BorderRadius.circular(2.h),
        child: Image.asset(
          Asset.homeBanner,
          fit: BoxFit.cover,
        )),
  );
}
