import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/SubCategoryController.dart';
import 'package:gifthamperz/models/innerSubCategoryModel.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:marquee/marquee.dart';
import 'package:sizer/sizer.dart';

import '../../utils/enum.dart';

// ignore: must_be_immutable
class SubCategoryScreen extends StatefulWidget {
  SubCategoryScreen({super.key, required this.categoryId});
  String? categoryId;

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen>
    with TickerProviderStateMixin {
  var controller = Get.put(SubCategoryController());

  @override
  void initState() {
    controller.tabController =
        TabController(vsync: this, length: 4, initialIndex: 0);
    controller.getSubCategoryList(context, widget.categoryId);
    super.initState();
  }

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
      body: Container(
          color: isDarkMode() ? darkBackgroundColor : transparent,
          child: Column(children: [
            getOrderToolbar(CategoryScreenConstant.subCategorytitle),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 2.w, right: 2.w),
                child: Obx(() {
                  switch (controller.state.value) {
                    case ScreenState.apiLoading:
                    case ScreenState.noNetwork:
                    case ScreenState.noDataFound:
                    case ScreenState.apiError:
                      return apiOtherStates(controller.state.value);
                    case ScreenState.apiSuccess:
                      return apiSuccess(controller.state.value);
                    default:
                      Container();
                  }
                  return Container();
                }),
              ),
            )
          ])),
    );
  }

  Widget apiSuccess(ScreenState state) {
    // ignore: unrelated_type_equality_checks
    if (controller.state == ScreenState.apiSuccess &&
        controller.subCategoryList.isNotEmpty) {
      return getListViewItem();
    } else {
      return noDataFoundWidget();
    }
  }

  Widget apiOtherStates(state) {
    if (state == ScreenState.apiLoading) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: SizedBox(
            height: 30,
            width: 30,
            child: LoadingAnimationWidget.discreteCircle(
              color: primaryColor,
              size: 35,
            ),
          ),
        ),
      );
    }

    Widget? button;
    if (controller.subCategoryList.isEmpty) {
      Container();
    }
    if (state == ScreenState.noDataFound) {
      button = getMiniButton(() {
        Get.back();
      }, BottomConstant.back);
    }
    if (state == ScreenState.noNetwork) {
      button = getMiniButton(() {
        controller.getSubCategoryList(context, widget.categoryId);
      }, BottomConstant.tryAgain);
    }

    if (state == ScreenState.apiError) {
      button = getMiniButton(() {
        Get.back();
      }, BottomConstant.back);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            child: controller.message.value.isNotEmpty
                ? Text(
                    controller.message.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: fontMedium, fontSize: 12.sp),
                  )
                : button),
      ],
    );
  }

  getListViewItem() {
    return DefaultTabController(
        length: controller.subCategoryList.length,
        child: Column(children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     getTab("ALL", 30, 0),
          //     getTab("COMPLETE", 30, 1),
          //     getTab("DELIVERIED", 30, 2),
          //     getTab("CANCELED", 30, 3),
          //   ],
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < controller.subCategoryList.length; i++)
                getTab(controller.subCategoryList[i].name,
                    controller.currentPage == i),
            ],
          ),
          getDynamicSizedBox(height: 1.h),
          Expanded(child: apiResponseUi())
          // Expanded(
          //   child: TabBarView(
          //     physics: const NeverScrollableScrollPhysics(),
          //     controller: controller.tabController,
          //     children: [
          //       const AllTabScreen(),
          //       SizedBox(
          //         height: SizerUtil.height,
          //         child: const Center(child: Text("PAGE 2")),
          //       ),
          //       SizedBox(
          //         height: SizerUtil.height,
          //         child: const Center(child: Text("PAGE 3")),
          //       ),
          //       SizedBox(
          //         height: SizerUtil.height,
          //         child: const Center(child: Text("PAGE 4")),
          //       ),
          //     ],
          //   ),
          // ),
        ]));
  }

  Widget apiResponseUi() {
    // ignore: unrelated_type_equality_checks
    if (controller.isLoading == true) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: SizedBox(
            height: 30,
            width: 30,
            child: LoadingAnimationWidget.discreteCircle(
              color: primaryColor,
              size: 35,
            ),
          ),
        ),
      );
    } else if (controller.isLoading.value == false &&
        controller.innerSubCategoryList.isNotEmpty) {
      return MasonryGridView.count(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 5.h, left: 1.5.w, right: 1.5.w),
        crossAxisCount: SizerUtil.deviceType == DeviceType.mobile ? 2 : 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          //Api Call
          InnerSubCategoryData data = controller.innerSubCategoryList[index];
          return controller.getListItem(
              data, widget.categoryId, controller.isSelectedSubCategoryId);
        },
        itemCount: controller.innerSubCategoryList.length,
      );
    } else {
      return Container(
        margin: EdgeInsets.only(bottom: 15.h),
        child: Center(
          child: Text(
            APIResponseHandleText.emptylist,
            style: TextStyle(
              fontFamily: fontMedium,
              color: isDarkMode() ? white : black,
              fontSize:
                  SizerUtil.deviceType == DeviceType.mobile ? 10.sp : 7.sp,
            ),
          ),
        ),
      );
    }
  }

  // getTab(str, pad, index) {
  //   return GestureDetector(
  //     onTap: (() {
  //       controller.currentPage = index;
  //       if (controller.tabController.indexIsChanging == false) {
  //         controller.tabController.index = index;
  //       }
  //       setState(() {});
  //     }),
  //     child: AnimatedContainer(
  //       width: 21.w,
  //       duration: const Duration(milliseconds: 300),
  //       margin:
  //           EdgeInsets.only(top: 1.h, bottom: 1.5.h, left: 1.2.w, right: 1.2.w),
  //       padding: EdgeInsets.only(top: 1.5.h, bottom: 1.5.h),
  //       alignment: Alignment.center,
  //       decoration: BoxDecoration(
  //           color: controller.currentPage == index ? primaryColor : white,
  //           boxShadow: [
  //             BoxShadow(
  //               blurRadius: 10,
  //               spreadRadius: 0.1,
  //               color: black.withOpacity(.1),
  //             )
  //           ],
  //           borderRadius: BorderRadius.circular(50)),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Text(str,
  //               style: TextStyle(
  //                 fontSize: 8.sp,
  //                 fontFamily: fontBold,
  //                 fontWeight: FontWeight.w700,
  //                 color: controller.currentPage == index ? white : black,
  //               )),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  getTab(String str, bool isSelected) {
    return GestureDetector(
      onTap: () {
        int index = controller.subCategoryList
            .indexWhere((category) => category.name == str);
        if (index != -1) {
          controller.currentPage = index;
          if (controller.tabController.indexIsChanging == false) {
            controller.tabController.index = index;
          }
          setState(() {});
        }
        if (index >= 0 && index < controller.subCategoryList.length) {
          int selectedCategoryId = controller.subCategoryList[index].id;
          controller.isSelectedSubCategoryId = selectedCategoryId.toString();
          controller.getInnerSubCategoryList(
              context, widget.categoryId, selectedCategoryId);
        }
      },
      child: AnimatedContainer(
        width: 25.w,
        duration: const Duration(milliseconds: 300),
        margin:
            EdgeInsets.only(top: 1.h, bottom: 1.5.h, left: 1.2.w, right: 1.2.w),
        padding: EdgeInsets.only(
            top: 1.5.h, bottom: 1.5.h, left: 1.2.w, right: 1.2.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              spreadRadius: 0.1,
              color: black.withOpacity(.1),
            )
          ],
          border: isDarkMode()
              ? null
              : Border.all(
                  color: grey, // Border color
                  width: 0.2, // Border width
                ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: str.length > 9
              ? SizedBox(
                  height: 2.2.h,
                  child: Marquee(
                    style: TextStyle(
                      fontFamily: fontRegular,
                      color: isSelected ? white : black,
                      fontSize: 11.sp,
                    ),
                    text: str,
                    scrollAxis: Axis
                        .horizontal, // Use Axis.vertical for vertical scrolling
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Adjust as needed
                    blankSpace:
                        20.0, // Adjust the space between text repetitions
                    velocity: 50.0, // Adjust the scrolling speed
                    pauseAfterRound: const Duration(
                        seconds: 1), // Time to pause after each scroll
                    startPadding: 2.0, // Adjust the initial padding
                    accelerationDuration:
                        const Duration(seconds: 1), // Duration for acceleration
                    accelerationCurve: Curves.linear, // Acceleration curve
                    decelerationDuration: const Duration(
                        milliseconds: 500), // Duration for deceleration
                    decelerationCurve: Curves.easeOut, // Deceleration curve
                  ),
                )
              : Text(
                  str,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 11.sp,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: fontBold,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? white : black,
                  ),
                ),
        ),
      ),
    );
  }
}
