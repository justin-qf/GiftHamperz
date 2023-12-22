import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/filter_controller.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  var controller = Get.put(FilterController());
  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbarIsNormalScreen();
    return CustomParentScaffold(
        onWillPop: () async {
          logcat("onWillPop", "DONE");
          return true;
        },
        isSafeArea: false,
        isNormalScreen: true,
        body:
         Container(
          color: isDarkMode() ? darkBackgroundColor : transparent,
          child: Column(
            children: [
              getCommonToolbar(FilterScreenConstant.title, showBackButton: true,
                  callback: () {
                Get.back();
              }),
              Expanded(
                  child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    getDynamicSizedBox(height: 1.h),
                    getLable(FilterScreenConstant.type, isFromFilter: true),
                    getDynamicSizedBox(height: 2.h),
                    Obx(
                      () {
                        return Container(
                          margin: EdgeInsets.only(left: 7.w, right: 7.w),
                          child: GridView.count(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              childAspectRatio: 4,
                              crossAxisCount: 2,
                              children: List.generate(
                                  controller.flowersList.length, (index) {
                                return controller.getRoundShapCheckBox(
                                    controller.flowersList[index]);
                              })),
                        );
                      },
                    ),
                    getDynamicSizedBox(height: 1.h),
                    getLable(FilterScreenConstant.occassions,
                        isFromFilter: true),
                    getDynamicSizedBox(height: 2.h),
                    Obx(
                      () {
                        return Container(
                          margin: EdgeInsets.only(left: 7.w, right: 7.w),
                          child: GridView.count(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              childAspectRatio: 4,
                              crossAxisCount: 2,
                              children: List.generate(
                                  controller.occassionList.length, (index) {
                                return controller.getRoundShapCheckBox(
                                    controller.occassionList[index]);
                              })),
                        );
                      },
                    ),
                    getDynamicSizedBox(height: 1.h),
                    getLable(FilterScreenConstant.color, isFromFilter: true),
                    getDynamicSizedBox(height: 2.h),
                    Obx(
                      () {
                        return Container(
                          margin: EdgeInsets.only(left: 7.w, right: 7.w),
                          child: GridView.count(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              childAspectRatio: 4,
                              crossAxisCount: 2,
                              children: List.generate(
                                  controller.colorsList.length, (index) {
                                return controller
                                    .getRoundShapCheckBoxWithColors(
                                        controller.colorsList[index]);
                              })),
                        );
                      },
                    ),
                    getDynamicSizedBox(height: 1.h),
                    getPriceLable(
                        controller.startValue.toStringAsFixed(2).toString(),
                        controller.endValue.toStringAsFixed(2).toString()),
                    Container(
                        margin: EdgeInsets.only(left: 2.w, right: 2.w),
                        child: SfRangeSliderTheme(
                          data: SfRangeSliderThemeData(
                            activeLabelStyle: TextStyle(
                              color: isDarkMode()
                                  ? priceRangeBackgroundColor
                                  : grey,
                              fontSize: 12.sp,
                              fontFamily: fontBold,
                            ),
                            inactiveLabelStyle: TextStyle(
                              color: isDarkMode()
                                  ? priceRangeBackgroundColor.withOpacity(0.5)
                                  : grey,
                              fontFamily: fontBold,
                              fontSize: 12.sp,
                            ),
                          ),
                          child: SfRangeSlider(
                            min: 0.0,
                            max: 200,
                            values: controller.values,
                            interval: 50,
                            showTicks: true,
                            showLabels: true,
                            enableTooltip: true,
                            minorTicksPerInterval: 1,
                            inactiveColor:
                                isDarkMode() ? priceRangeBackgroundColor : grey,
                            activeColor: primaryColor,
                            onChanged: (SfRangeValues values) {
                              setState(() {
                                controller.startValue = values.start;
                                controller.endValue = values.end;
                                controller.values = values;
                              });
                            },
                          ),
                        )),
                    getDynamicSizedBox(height: 5.h),
                    Container(
                      margin: EdgeInsets.only(
                        left: 8.w,
                        right: 8.w,
                      ),
                      child: FadeInUp(
                          from: 50,
                          child: getSecondaryFormButton(() {}, Button.update,
                              isvalidate: true)),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                  ],
                ),
              )),
            ],
          ),
        )
        
        );
  
  }
}
