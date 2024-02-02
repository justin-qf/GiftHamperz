import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/input/style.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/savedController.dart';
import 'package:gifthamperz/controller/searchController.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:sizer/sizer.dart';

setSearchBar(context, controller, String tag,
    {Function? onCancleClick, Function? onClearClick, bool? isCancle}) {
  return FadeInLeft(
    child: Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode() ? tileColour : white,
              borderRadius: BorderRadius.circular(
                  SizerUtil.deviceType == DeviceType.mobile ? 5.h : 1.2.h),
              boxShadow: [
                BoxShadow(
                    color: black.withOpacity(0.05),
                    blurRadius: 10.0,
                    offset: const Offset(0, 5))
              ],
            ),
            padding: EdgeInsets.symmetric(
              horizontal:
                  SizerUtil.deviceType == DeviceType.mobile ? 0.w : 1.2.w,
            ),
            margin: EdgeInsets.symmetric(
                horizontal: SizerUtil.deviceType == DeviceType.mobile
                    ? 3.8.w
                    : SizerUtil.deviceType == DeviceType.mobile
                        ? 5.w
                        : 6.0.w,
                vertical:
                    SizerUtil.deviceType == DeviceType.mobile ? 0.8.h : 2.h),
            child: TextFormField(
              controller: controller,
              cursorColor: primaryColor,
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.text,
              onEditingComplete: () {
                if (tag == "saved") {
                  Get.find<SavedScreenController>()
                      .setSearchQuery(controller.text.toString());
                  Get.find<SavedScreenController>().hideKeyboard(context);
                }

                if (tag == "search") {
                  logcat("onCLick", 'search');
                  Get.find<SearchScreenController>()
                      .getSearchList(context, controller.text.toString());
                  Get.find<SearchScreenController>().hideKeyboard(context);
                }
              },
              onChanged: (val) {
                if (tag == "saved") {
                  Get.find<SavedScreenController>()
                      .setSearchQuery(controller.text.toString());
                  Get.find<SavedScreenController>()
                      .applyFilter(controller.text.toString(), true);
                }
              },
              style: styleTextFormFieldText(isWhite: true),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: isDarkMode() ? black : black,
                  size: SizerUtil.deviceType == DeviceType.mobile ? 20 : 25,
                ),
                labelStyle: styleTextForFieldHint(),
                suffixIcon: GestureDetector(
                  onTap: () {
                    onClearClick!();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 1.w),
                    child: Icon(
                      Icons.cancel,
                      color: isDarkMode() ? black : black,
                      size: SizerUtil.deviceType == DeviceType.mobile ? 20 : 25,
                    ),
                  ),
                ),
                contentPadding: EdgeInsets.only(
                    top: SizerUtil.deviceType == DeviceType.mobile
                        ? 0.7.h
                        : 1.9.h,
                    bottom: SizerUtil.deviceType == DeviceType.mobile
                        ? 0.7.h
                        : 1.9.h),
                hintText: SearchConstant.hint,
                hintStyle: styleTextForFieldHint(),
                border: InputBorder.none,
                alignLabelWithHint: true,
              ),
            ),
          ),
        ),
        isCancle == true
            ? FadeInRight(
                child: GestureDetector(
                  onTap: () {
                    onCancleClick!();
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 5.w),
                    child: Text(
                      SearchConstant.cancle,
                      style: TextStyle(
                        fontFamily: fontRegular,
                        color: isDarkMode() ? white : black,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    ),
  );
}
