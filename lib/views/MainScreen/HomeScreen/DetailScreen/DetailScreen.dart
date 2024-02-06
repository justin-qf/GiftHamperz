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
import 'package:gifthamperz/controller/homeController.dart';
import 'package:gifthamperz/controller/homeDetailController.dart';
import 'package:gifthamperz/models/UpdateDashboardModel.dart';
import 'package:gifthamperz/utils/enum.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class DetailScreen extends StatefulWidget {
  String? title;
  bool? isFromTrending;
  DetailScreen({super.key, this.title, this.isFromTrending});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  var controller = Get.put(HomeDetailScreenController());

  @override
  void initState() {
    apiCall();
    super.initState();
  }

  apiCall() {
    logcat("isFromTrending", widget.isFromTrending.toString());
    // return Future.delayed(
    //   const Duration(seconds: 1),
    //   () {
    //     if (widget.isFromTrending == true) {
    //       controller.getProductDetailList(context, 0, true, true);
    //     } else {
    //       controller.getProductDetailList(context, 0, true, false);
    //     }
    //   },
    // );
    if (widget.isFromTrending == true) {
      controller.getProductDetailList(context, 0, true, true);
    } else {
      controller.getProductDetailList(context, 0, true, false);
    }
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
          getForgetToolbar(widget.title, showBackButton: true, callback: () {
            Get.back();
          }),
          getDynamicSizedBox(height: 1.5.h),
          Expanded(
            child: Stack(
              children: [
                RefreshIndicator(
                    color: primaryColor,
                    onRefresh: () {
                      return Future.delayed(
                        const Duration(seconds: 1),
                        () {
                          apiCall();
                        },
                      );
                    },
                    child: CustomScrollView(
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
                                      height: SizerUtil.height / 1.5,
                                      child: apiOtherStates(
                                          controller.state.value),
                                    );
                                  case ScreenState.apiSuccess:
                                    return apiSuccess(controller.state.value);
                                  default:
                                    Container();
                                }
                                return Container();
                              }),
                              if (controller.isLoading.value == true)
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
          // Expanded(
          //   child: Container(
          //     margin: EdgeInsets.only(left: 3.w, right: 3.w),
          //     child: MasonryGridView.count(
          //       physics: const BouncingScrollPhysics(),
          //       padding: EdgeInsets.only(bottom: 5.h),
          //       crossAxisCount:
          //           SizerUtil.deviceType == DeviceType.mobile ? 2 : 3,
          //       mainAxisSpacing: 10,
          //       crossAxisSpacing: 4,
          //       itemBuilder: (context, index) {
          //         // CommonProductList data = controller.staticData[index];
          //         // return controller.getListItem(data);
          //         return Container();
          //       },
          //       itemCount: controller.staticData.length,
          //     ),
          //   ),
          // ),
        ]),
      ),
    );
  }

  Widget apiSuccess(ScreenState state) {
    logcat("apiSuccess", '1');
    // ignore: unrelated_type_equality_checks
    if (widget.isFromTrending == true) {
      if (state == ScreenState.apiSuccess &&
          controller.trendingList.isNotEmpty) {
        return getListViewItem();
      } else {
        return noDataFoundWidget();
      }
    } else {
      logcat("Step-2", '2');
      if (state == ScreenState.apiSuccess &&
          controller.popularList.isNotEmpty) {
        return getListViewItem();
      } else {
        return noDataFoundWidget();
      }
    }
  }

  Widget getListViewItem() {
    // ignore: unrelated_type_equality_checks
    if (controller.isLoading.value == false) {
      if (widget.isFromTrending == true && controller.trendingList.isNotEmpty) {
        return MasonryGridView.count(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(left: 5.w, right: 5.w),
          crossAxisCount: SizerUtil.deviceType == DeviceType.mobile ? 2 : 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 4,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            CommonProductList model = controller.trendingList[index];
            return Column(
              children: [
                controller.getListItemDetail(context, model, true),
                index == controller.trendingList.length - 1 &&
                        controller.nextPageURL.value.isNotEmpty
                    ? Container(
                        margin: EdgeInsets.only(
                            top: 2.h, left: 25.w, right: 25.w, bottom: 0.8.h),
                        child: getMiniButton(
                          () {
                            controller.isLoading.value = true;
                            controller.currentPage++;
                            controller.getProductDetailList(
                                context, controller.currentPage, true, true);
                            setState(() {});
                          },
                          Common.viewMore,
                        ),
                      )
                    : Container()
              ],
            );
          },
          itemCount: controller.trendingList.length,
        );
      } else {
        return MasonryGridView.count(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 3.h, left: 5.w, right: 5.w),
          crossAxisCount: SizerUtil.deviceType == DeviceType.mobile ? 2 : 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 4,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            CommonProductList model = controller.popularList[index];
            return Column(
              children: [
                controller.getListItemDetail(context, model, false),
                index == controller.trendingList.length - 1 &&
                        controller.nextPageURL.value.isNotEmpty
                    ? Container(
                        margin: EdgeInsets.only(
                            top: 2.h, left: 25.w, right: 25.w, bottom: 0.8.h),
                        child: getMiniButton(
                          () {
                            controller.isLoading.value = true;
                            controller.currentPage++;
                            controller.getProductDetailList(
                                context, controller.currentPage, true, false);
                            setState(() {});
                          },
                          Common.viewMore,
                        ),
                      )
                    : Container()
              ],
            );
          },
          itemCount: controller.popularList.length,
        );
      }
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
    if (widget.isFromTrending == true) {
      if (controller.trendingList.isEmpty) {
        Container();
      }
    } else {
      if (controller.popularList.isEmpty) {
        Container();
      }
    }

    if (state == ScreenState.noDataFound) {
      button = getMiniButton(() {
        Get.back();
      }, BottomConstant.back);
    }
    if (state == ScreenState.noNetwork) {
      button = getMiniButton(() {
        apiCall();
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
                    style: TextStyle(
                        fontFamily: fontMedium,
                        fontSize: 12.sp,
                        color: isDarkMode() ? white : black),
                  )
                : button),
      ],
    );
  }
}
