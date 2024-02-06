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
import 'package:gifthamperz/controller/OrderController.dart';
import 'package:gifthamperz/models/OrderModel.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

import '../../utils/enum.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with TickerProviderStateMixin {
  var controller = Get.put(OrderScreenController());

  @override
  void initState() {
    controller.tabController =
        TabController(vsync: this, length: 4, initialIndex: 0);
    controller.getOrderList(context, 0, true);
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
          getOrderToolbar(OrderScreenConstant.title),
          getDynamicSizedBox(height: 1.0.h),
          Expanded(
            child: Stack(
              children: [
                RefreshIndicator(
                    color: primaryColor,
                    onRefresh: () {
                      return Future.delayed(
                        const Duration(seconds: 1),
                        () {
                          controller.getOrderList(context, 0, true,
                              isRefress: true);
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
                                      height: SizerUtil.height / 1.2,
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
          // getListViewItem()
        ]),
      ),
    );
  }

  Widget apiSuccess(ScreenState state) {
    // ignore: unrelated_type_equality_checks
    if (controller.state == ScreenState.apiSuccess &&
        controller.orderList.isNotEmpty) {
      return ListView.builder(
        padding: EdgeInsets.only(bottom: 2.h, top: 1.h),
        physics: const BouncingScrollPhysics(),
        itemCount: controller.orderList.length,
        clipBehavior: Clip.antiAlias,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          OrderData model = controller.orderList[index];
          return Column(
            children: [
              controller.getOrderListItem(context, model, index),
              index == controller.orderList.length - 1 &&
                      controller.nextPageURL.value.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.only(
                          top: 2.h, left: 25.w, right: 25.w, bottom: 0.8.h),
                      child: getMiniButton(
                        () {
                          controller.isLoading.value = true;
                          controller.currentPage++;
                          controller.getOrderList(
                              context, controller.currentPage, false);
                          setState(() {});
                        },
                        Common.viewMore,
                      ),
                    )
                  : Container()
            ],
          );
        },
      );
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
    if (controller.orderList.isEmpty) {
      Container();
    }
    if (state == ScreenState.noDataFound) {
      button = getMiniButton(() {
        Get.back();
      }, BottomConstant.back);
    }
    if (state == ScreenState.noNetwork) {
      button = getMiniButton(() {
        controller.getOrderList(context, 0, true);
      }, BottomConstant.tryAgain);
    }

    if (state == ScreenState.apiError) {
      button = getMiniButton(() {
        Get.back();
      }, BottomConstant.back);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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

  // getListViewItem() {
  //   return Expanded(
  //     child: Container(
  //       margin: EdgeInsets.only(
  //         left: 0.5.w,
  //       ),
  //       child: DefaultTabController(
  //           length: 4,
  //           child: Column(children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 getTab("ALL", 30, 0),
  //                 getTab("COMPLETE", 30, 1),
  //                 getTab("DELIVERIED", 30, 2),
  //                 getTab("CANCELED", 30, 3),
  //               ],
  //             ),
  //             Expanded(
  //               child: TabBarView(
  //                 physics: const NeverScrollableScrollPhysics(),
  //                 controller: controller.tabController,
  //                 children: [
  //                   const AllTabScreen(),
  //                   SizedBox(
  //                     height: SizerUtil.height,
  //                     child: const Center(child: Text("PAGE 2")),
  //                   ),
  //                   SizedBox(
  //                     height: SizerUtil.height,
  //                     child: const Center(child: Text("PAGE 3")),
  //                   ),
  //                   SizedBox(
  //                     height: SizerUtil.height,
  //                     child: const Center(child: Text("PAGE 4")),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ])),
  //     ),
  //   );
  // }

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
}
