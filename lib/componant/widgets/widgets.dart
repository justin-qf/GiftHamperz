import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
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
          color: isDarkMode() ? primaryColor : lableColor,
          fontWeight: FontWeight.w500,
          fontSize: 11.sp),
      children: [
        TextSpan(
          text: isLogin == true
              ? " ${LoginConst.signup}"
              : " ${LoginConst.signIn}",
          style: TextStyle(
              fontFamily: fontBold,
              color: primaryColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w800),
        )
      ],
    ),
  );
}

Widget getHomeLable(String title, Function onCLick) {
  return FadeInRight(
    child: Container(
      margin: EdgeInsets.only(left: 5.w, right: 2.w),
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
            color: primaryColor,
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
      margin: EdgeInsets.only(left: 8.w),
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
        Text("\$$startPrice",
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
        Text("\$$endPrice",
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
    {Function? AddCartClick, Function? BuyNowClick}) {
  return Expanded(
    child: GestureDetector(
      onTap: () {
        isFromAddCart == true ? AddCartClick!() : BuyNowClick!();
      },
      child: Container(
        decoration: BoxDecoration(
          color: isFromAddCart == true
              ? secondaryColor.withOpacity(0.9)
              : primaryColor,
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
              Icon(icon),
              getDynamicSizedBox(width: 2.w),
              Text(
                title,
                style: TextStyle(
                  color: isDarkMode() ? white : black,
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
      border: Border.all(color: Colors.transparent),
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
