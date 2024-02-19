import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:sizer/sizer.dart';

setActionButton(context, String tag, bool? isEnable,
    {Function? onActionClick, Function? onClick}) {
  return Column(
    children: [
      SizedBox(
        width: SizerUtil.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            GestureDetector(
              onTap: () {
                onActionClick!();
              },
              child: Container(
                margin: EdgeInsets.only(
                  right: 5.5.w,
                ),
                padding: EdgeInsets.all(2.h),
                decoration: BoxDecoration(
                  color: isDarkMode()
                      ? darkBackgroundColor
                      : white, // Change the background color
                  shape: BoxShape.circle, // Half of the height
                  boxShadow: [
                    BoxShadow(
                        color: grey.withOpacity(0.2),
                        blurRadius: 5.0,
                        offset: const Offset(0, 1),
                        spreadRadius: 2)
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      size: 4.h, // Size of the icon
                      color: isDarkMode() ? white : black,
                    ),
                    getDynamicSizedBox(height: 0.1.h),
                    Text(
                      tag,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            isDarkMode() ? white : black, // Color of the text
                        fontSize: 10.sp, // Font size of the text
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      getDynamicSizedBox(height: 2.h),
      Container(
        margin: EdgeInsets.only(
          left: 5.5.w,
          right: 5.w,
        ),
        child: FadeInUp(
            from: 50,
            child: getAddressButton(() {
              onClick!();
            }, AddressScreenTextConstant.payment, isvalidate: isEnable)),
      ),
    ],
  );
}
