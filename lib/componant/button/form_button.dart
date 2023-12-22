import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:sizer/sizer.dart';

getFormButton(Function fun, str, {required bool isWhite}) {
  return InkWell(
    onTap: () {
      fun();
    },
    child: Container(
      padding: EdgeInsets.symmetric(
          vertical: SizerUtil.deviceType == DeviceType.mobile ? 1.4.h : 1.h,
          horizontal: SizerUtil.deviceType == DeviceType.mobile ? 5.h : 6.h),
      //width: SizerUtil.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.h),
          // color: validate ? lightPrimaryColor : Colors.grey,
          // boxShadow: [
          //   BoxShadow(
          //       color: isvalidate == true
          //           ? primaryColor.withOpacity(0.3)
          //           : Colors.grey.withOpacity(0.2),
          //       blurRadius: 10.0,
          //       offset: const Offset(0, 1),
          //       spreadRadius: 3.0)
          // ],
          gradient: LinearGradient(
              colors: isWhite == true
                  ? [white, white]
                  : [secondaryColor, primaryColor],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.8, 0.0),
              stops: const [0.0, 1.0],
              tileMode: TileMode.clamp)),
      child: Text(
        str,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: isWhite == true ? lightPrimaryColor : white,
            fontFamily: fontBold,
            fontWeight: FontWeight.w900,
            fontSize: 11.sp),
      ),
    ),
  );
}

getMiniButton(Function fun, str, {bool? icon}) {
  return InkWell(
    onTap: () {
      fun();
    },
    child: Container(
      height: SizerUtil.deviceType == DeviceType.mobile ? 5.h : 4.5.h,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 1),
      width: SizerUtil.width / 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: primaryColor,
        boxShadow: [
          BoxShadow(
              color: primaryColor.withOpacity(0.2),
              blurRadius: 10.0,
              offset: const Offset(0, 1),
              spreadRadius: 3.0)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            str,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontFamily: fontBold,
                fontSize:
                    SizerUtil.deviceType == DeviceType.mobile ? 11.sp : 8.sp),
          ),
          // SizedBox(
          //   width: 2.w,
          // ),
          // icon == true
          //     ? Container(
          //         margin: EdgeInsets.only(bottom: 0.5.h),
          //         child: SvgPicture.asset(
          //           Asset.share,
          //           alignment: Alignment.center,
          //           height: 2.h,
          //           width: 2.h,
          //           color: white,
          //         ),
          //       )
          //     : Container()
        ],
      ),
    ),
  );
}

getSecondaryFormButton(Function fun, str, {isvalidate}) {
  return InkWell(
    onTap: () {
      fun();
    },
    child: Container(
      padding: EdgeInsets.symmetric(
          vertical: SizerUtil.deviceType == DeviceType.mobile ? 1.7.h : 1.h,
          horizontal: SizerUtil.deviceType == DeviceType.mobile ? 5.h : 6.h),
      width: SizerUtil.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.h),
        color: isvalidate ? lightPrimaryColor : grey,
        gradient: isvalidate
            ? const LinearGradient(
                colors: [secondaryColor, primaryColor],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(0.8, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp)
            : null,
      ),
      child: Text(
        str,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: white,
            fontFamily: fontBold,
            fontWeight: FontWeight.w900,
            fontSize: 13.sp),
      ),
    ),
  );
}

getOrderButton(Function fun) {
  return InkWell(
    onTap: () {
      fun();
    },
    child: Container(
      padding: EdgeInsets.symmetric(
          vertical: SizerUtil.deviceType == DeviceType.mobile ? 1.h : 1.h,
          horizontal: SizerUtil.deviceType == DeviceType.mobile ? 2.h : 6.h),
      // width: SizerUtil.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.h),
          color: lightPrimaryColor,
          gradient: const LinearGradient(
              colors: [secondaryColor, primaryColor],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(0.8, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp)),
      child: Text(
        "View Details",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: white,
            fontFamily: fontBold,
            fontWeight: FontWeight.w900,
            fontSize: 11.sp),
      ),
    ),
  );
}

getFormButtonForAddingData(Function fun, str, {required bool isvalidate}) {
  return InkWell(
    onTap: () {
      fun();
    },
    child: Container(
      height: 13.w,
      padding: EdgeInsets.symmetric(
          vertical: SizerUtil.deviceType == DeviceType.mobile ? 1.2.h : 1.h,
          horizontal: SizerUtil.deviceType == DeviceType.mobile ? 7.h : 6.h),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.h),
      //width: SizerUtil.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.7.h),
          // color: validate ? lightPrimaryColor : Colors.grey,
          boxShadow: [
            BoxShadow(
                color: isvalidate == true
                    ? primaryColor.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.2),
                blurRadius: 10.0,
                offset: const Offset(0, 1),
                spreadRadius: 3.0)
          ],
          gradient: LinearGradient(
              colors: isvalidate == true
                  ? [primaryColor, primaryColor.withOpacity(0.5)]
                  : [Colors.grey, Colors.grey],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: const [0.0, 1.0],
              tileMode: TileMode.clamp)),
      child: Text(
        str,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontFamily: fontBold, fontSize: 14.sp),
      ),
    ),
  );
}

getVerifyOtpButton(Function fun, str, {required bool validate}) {
  return InkWell(
    onTap: () {
      fun();
    },
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 1.2.h, horizontal: 7.h),
      //width: SizerUtil.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.7.h),
          // color: validate ? lightPrimaryColor : Colors.grey,
          boxShadow: [
            BoxShadow(
                color: validate
                    ? primaryColor.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.2),
                blurRadius: 10.0,
                offset: const Offset(0, 1),
                spreadRadius: 3.0)
          ],
          gradient: LinearGradient(
              colors: validate
                  ? [primaryColor, primaryColor.withOpacity(0.5)]
                  : [primaryColor, primaryColor.withOpacity(0.5)],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: const [0.0, 1.0],
              tileMode: TileMode.clamp)),
      child: Text(
        str,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontFamily: fontBold, fontSize: 14.sp),
      ),
    ),
  );
}

getViewProfileButton(Function fun, str, {bool? isvalidate}) {
  return InkWell(
    onTap: () {
      fun();
    },
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.h),
      //width: SizerUtil.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.7.h),
          // color: validate ? lightPrimaryColor : Colors.grey,
          boxShadow: [
            BoxShadow(
                color: primaryColor.withOpacity(0.5),
                blurRadius: 1.0,
                offset: const Offset(0, 1),
                spreadRadius: 1.0)
          ],
          gradient: LinearGradient(
              colors: [primaryColor, primaryColor.withOpacity(0.5)],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: const [0.0, 1.0],
              tileMode: TileMode.clamp)),
      child: Text(
        str,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontFamily: fontBold, fontSize: 11.2.sp),
      ),
    ),
  );
}

getButton(str, Function fun, {required bool isvalidate}) {
  return InkWell(
    onTap: () {
      fun();
    },
    child: Container(
      height: SizerUtil.deviceType == DeviceType.mobile ? 13.w : 6.h,
      alignment: Alignment.center,
      padding: EdgeInsets.only(
          top: SizerUtil.deviceType == DeviceType.mobile ? 5 : 2),
      width: SizerUtil.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.7.h),
          boxShadow: [
            BoxShadow(
                color: isvalidate == true
                    ? primaryColor.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.2),
                blurRadius: 10.0,
                offset: const Offset(0, 1),
                spreadRadius: 3.0)
          ],
          gradient: LinearGradient(
              colors: isvalidate == true
                  ? [primaryColor, primaryColor.withOpacity(0.5)]
                  : [Colors.grey, Colors.grey],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: const [0.0, 1.0],
              tileMode: TileMode.clamp)),
      child: Text(
        Button.search,
        style: TextStyle(
            color: Colors.white, fontFamily: fontBold, fontSize: 14.sp),
      ),
    ),
  );
}

commonBtn(str, Function fun, {required bool isvalidate}) {
  return InkWell(
    onTap: () {
      fun();
    },
    child: Container(
      height: SizerUtil.deviceType == DeviceType.mobile ? 13.w : 6.h,
      alignment: Alignment.center,
      padding: EdgeInsets.only(
          top: SizerUtil.deviceType == DeviceType.mobile ? 5 : 2),
      width: SizerUtil.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.7.h),
          boxShadow: [
            BoxShadow(
                color: isvalidate == true
                    ? primaryColor.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.2),
                blurRadius: 10.0,
                offset: const Offset(0, 1),
                spreadRadius: 3.0)
          ],
          gradient: LinearGradient(
              colors: isvalidate == true
                  ? [primaryColor, primaryColor.withOpacity(0.5)]
                  : [Colors.grey, Colors.grey],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: const [0.0, 1.0],
              tileMode: TileMode.clamp)),
      child: Text(
        str,
        style: TextStyle(
            color: Colors.white, fontFamily: fontBold, fontSize: 14.sp),
      ),
    ),
  );
}
