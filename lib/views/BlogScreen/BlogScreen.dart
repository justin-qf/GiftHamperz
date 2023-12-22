import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/BlogScreenController.dart';
import 'package:gifthamperz/models/BlogModel.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:marquee/marquee.dart';
import 'package:sizer/sizer.dart';

import '../../utils/enum.dart';

class BlocgScreen extends StatefulWidget {
  const BlocgScreen({super.key});

  @override
  State<BlocgScreen> createState() => _BlocgScreenState();
}

class _BlocgScreenState extends State<BlocgScreen>
    with TickerProviderStateMixin {
  var controller = Get.put(BlogScreenController());

  @override
  void initState() {
    controller.tabController =
        TabController(vsync: this, length: 4, initialIndex: 0);
    controller.getBlogTypeList(context);
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
          getOrderToolbar(BlogScreenConstant.title),
          getDynamicSizedBox(height: 2.0.h),
          Expanded(
            child: Stack(
              children: [
                RefreshIndicator(
                    color: primaryColor,
                    onRefresh: () {
                      return Future.delayed(
                        const Duration(seconds: 1),
                        () {
                          controller.getBlogList(
                              context, 1, controller.selectedBlogTypeId!, true);
                        },
                      );
                    },
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Obx(() {
                            return Stack(children: [
                              Obx(() {
                                switch (controller.state.value) {
                                  case ScreenState.apiLoading:
                                  case ScreenState.noNetwork:
                                  case ScreenState.noDataFound:
                                  case ScreenState.apiError:
                                    return SizedBox(
                                      height: SizerUtil.height,
                                      child: Center(
                                        child: apiOtherStates(
                                            controller.state.value),
                                      ),
                                    );
                                  case ScreenState.apiSuccess:
                                    return apiSuccess(controller.state.value);
                                  default:
                                    Container();
                                }
                                return Container();
                              }),
                              if (controller.isShowMoreLoading.value == true)
                                SizedBox(
                                    height: SizerUtil.height,
                                    width: SizerUtil.width,
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: white,
                                          ),
                                          height: 50,
                                          width: 50,
                                          padding: const EdgeInsets.all(10),
                                          child: LoadingAnimationWidget
                                              .discreteCircle(
                                            color: primaryColor,
                                            size: 35,
                                          ),
                                        ),
                                      ),
                                    )),
                            ]);
                          }),
                        )
                      ],
                    )),
              ],
            ),
          )
          // getListViewItem()
        ]),
      ),
    );
  }

  Widget apiSuccess(ScreenState state) {
    // ignore: unrelated_type_equality_checks
    if (controller.state == ScreenState.apiSuccess &&
        controller.blogTypeList.isNotEmpty) {
      return getListViewItem();
    } else {
      return Container(
        margin: EdgeInsets.only(bottom: 5.h),
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

  getListViewItem() {
    return DefaultTabController(
        length: controller.blogTypeList.length,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < controller.blogTypeList.length; i++)
                getTab(controller.blogTypeList[i].name,
                    controller.currentPage == i),
            ],
          ),
          getDynamicSizedBox(height: 1.h),
          apiResponseUi()
        ]));
  }

  Widget apiOtherStates(state) {
    if (state == ScreenState.apiLoading) {
      return Container(
        padding: EdgeInsets.only(bottom: 15.h),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LoadingAnimationWidget.discreteCircle(
              color: primaryColor,
              size: 30,
            ),
          ),
        ),
      );
    }

    Widget? button;
    if (controller.blogList.isEmpty) {
      Container();
    }
    if (state == ScreenState.noDataFound) {
      button = getMiniButton(() {
        Get.back();
      }, BottomConstant.back);
    }
    if (state == ScreenState.noNetwork) {
      button = getMiniButton(() {
        controller.getBlogList(
            context, 1, controller.selectedBlogTypeId!, false);
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

  Widget apiResponseUi() {
    // ignore: unrelated_type_equality_checks
    if (controller.isLoading == true) {
      return Container(
          height: SizerUtil.height,
          width: SizerUtil.width,
          padding: EdgeInsets.only(bottom: 30.h),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: white,
                ),
                height: 50,
                width: 50,
                padding: const EdgeInsets.all(10),
                child: LoadingAnimationWidget.discreteCircle(
                  color: primaryColor,
                  size: 35,
                ),
              ),
            ),
          ));
    } else if (controller.isLoading == false &&
        controller.blogList.isNotEmpty) {
      return ListView.builder(
        padding: EdgeInsets.only(bottom: 2.h),
        physics: const BouncingScrollPhysics(),
        itemCount: controller.blogList.length,
        clipBehavior: Clip.antiAlias,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          BlogDataList model = controller.blogList[index];
          return controller.getBlogListItem(context, model, index);
        },
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

  getTab(String str, bool isSelected) {
    return GestureDetector(
      onTap: () {
        int index = controller.blogTypeList
            .indexWhere((category) => category.name == str);
        if (index != -1) {
          controller.currentPage = index;
          if (controller.tabController.indexIsChanging == false) {
            controller.tabController.index = index;
          }
          setState(() {});
        }
        if (index >= 0 && index < controller.blogTypeList.length) {
          controller.selectedBlogTypeId =
              controller.blogTypeList[index].id.toString();
          controller.getBlogList(
              context, 1, controller.selectedBlogTypeId!, false);
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
