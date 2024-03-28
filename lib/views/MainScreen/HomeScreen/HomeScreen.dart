import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/api_handle/apiOtherStates.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/search_chat_widgets.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/device_type.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/homeController.dart';
import 'package:gifthamperz/models/UpdateDashboardModel.dart';
import 'package:gifthamperz/utils/enum.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/views/CartScreen/CartScreen.dart';
import 'package:gifthamperz/views/CategoryScreen/CategoryScreen.dart';
import 'package:gifthamperz/views/MainScreen/HomeScreen/DetailScreen/DetailScreen.dart';
import 'package:gifthamperz/views/MainScreen/HomeScreen/HomeScreenWeb.dart';
import 'package:gifthamperz/views/SearchScreen/SearchScreen.dart';
import 'package:sizer/sizer.dart';
import '../../../../configs/colors_constant.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  HomeScreen(this.callBack, {super.key});
  Function callBack;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var controller = Get.put(HomeScreenController());
  //bool? isGuest = true;

  @override
  void initState() {
    super.initState();
    controller.pageController =
        PageController(initialPage: controller.currentPage);
    controller.getHome(context);
    controller.startAutoScroll();
    controller.getTotalProductInCart();
    controller.showGuestUserLogin(context);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    // try {
    //   if (mounted) {
    //     await Future.delayed(const Duration(seconds: 0)).then((value) {
    //       if (!DeviceScreenType.isWeb(context)) {
    //         controller.getHome(context);
    //       }
    //     });
    //   }
    // } catch (e) {
    //   logcat("ERROR", e);
    // }
    setState(() {});
  }

  @override
  void dispose() {
    controller.disposePageController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbarIsNormalScreen();
    return CustomParentScaffold(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      isSafeArea: false,
      body: Container(
        color: isDarkMode() ? darkBackgroundColor : white,
        child: Column(
          children: [
            getDynamicSizedBox(
                height: SizerUtil.deviceType == DeviceType.mobile
                    ? 5.h
                    : DeviceScreenType.isWeb(
                        context,
                      )
                        ? 5.h
                        : 3.h),
            DeviceScreenType.isWeb(
              context,
            )
                ? Expanded(
                    child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 3.h),
                        physics: const BouncingScrollPhysics(),
                        child: HomeScreenWeb(
                          isGuest: controller.isGuest,
                        )),
                  )
                : Expanded(
                    child: Column(
                      children: [
                        Obx(() {
                          controller.totalItemsCount.value =
                              controller.totalItemsCount.value;
                          return homeAppbar(DashboardText.dashboard, () {
                            // widget.callBack(1);
                            Get.to(const SearchScreen())!.then((value) {
                              controller.getHome(context);
                              controller.getTotalProductInCart();
                            });
                            //controller.isSearch = !controller.isSearch;
                            setState(() {});
                          }, () {
                            Get.to(const CartScreen())!.then((value) {
                              controller.getHome(context);
                              controller.getTotalProductInCart();
                            });
                          }, controller.totalItemsCount);
                        }),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.only(bottom: 3.h),
                            physics: const BouncingScrollPhysics(),
                            child: Obx(() {
                              switch (controller.state.value) {
                                case ScreenState.apiLoading:
                                case ScreenState.noNetwork:
                                case ScreenState.noDataFound:
                                case ScreenState.apiError:
                                  return SizedBox(
                                    height: SizerUtil.height / 1.3,
                                    child: apiOtherStates(
                                        controller.state.value,
                                        controller,
                                        controller.bannerList,
                                        () {}),
                                  );
                                case ScreenState.apiSuccess:
                                  return apiSuccess(controller.state.value);
                                default:
                                  Container();
                              }
                              return Container();
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget apiSuccess(ScreenState state) {
    // ignore: unrelated_type_equality_checks
    if (controller.state == ScreenState.apiSuccess &&
        controller.homeData != null) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getDynamicSizedBox(height: 1.h),
            controller.isSearch == true
                ? setSearchBar(context, controller.searchCtr, 'home',
                    onCancleClick: () {
                    controller.searchCtr.text = '';
                    setState(() {
                      controller.isSearch = false;
                    });
                  }, onClearClick: () {
                    controller.searchCtr.text = '';
                    setState(() {});
                  })
                : Container(),
            SizedBox(
              height: 20.h,
              child: Obx(() {
                return getPageView(controller, (index) {
                  setState(() {
                    controller.currentPage = index;
                  });
                });
              }),
            ),
            SizedBox(
              height: 0.5.h,
            ),
            getHomeLable(DashboardText.categoryTitle, () {
              Get.to(const CategoryScreen())!.then((value) {
                controller.getHome(context);
                controller.getTotalProductInCart();
              });
            }),
            SizedBox(
              height: SizerUtil.deviceType == DeviceType.mobile ? 13.h : 13.h,
              child: Obx(
                () {
                  return controller.categoryList.isNotEmpty
                      ? ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(
                              left: 2.w, right: 1.w, top: 0.5.h),
                          shrinkWrap: false,
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.antiAlias,
                          itemBuilder: (context, index) {
                            CategoryList data = controller.categoryList[index];
                            return controller.getCategoryListItem(
                                context, data);
                          },
                          itemCount: controller.categoryList.length)
                      : Container();
                },
              ),
            ),
            getHomeLable(DashboardText.trendingTitle, () {
              Get.to(DetailScreen(
                title: DashboardText.trendingTitle,
                isFromTrending: true,
              ))!
                  .then((value) {
                controller.getHome(context);
                controller.getTotalProductInCart();
              });
            }),
            getDynamicSizedBox(height: 1.h),
            Obx(
              () {
                return controller.trendingItemList.isNotEmpty
                    ? SizedBox(
                        height: 26.h,
                        child: ListView.builder(
                            padding: EdgeInsets.only(left: 2.w, right: 1.w),
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.antiAlias,
                            itemBuilder: (context, index) {
                              CommonProductList data =
                                  controller.trendingItemList[index];
                              return controller.getListItem(context, data,
                                  () async {
                                controller.getTotalProductInCart();
                              }, controller.isGuest, () async {});
                            },
                            itemCount: controller.trendingItemList.length),
                      )
                    : Container();
              },
            ),
            Obx(
              () {
                return controller.mainOfferrList.isNotEmpty
                    ? SizedBox(
                        height: SizerUtil.deviceType == DeviceType.mobile
                            ? 15.h
                            : 14.h,
                        child: ListView.builder(
                            padding: EdgeInsets.only(
                              left: 3.5.w,
                            ),
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.antiAlias,
                            itemBuilder: (context, index) {
                              return homeOfferBanner(
                                  controller.offerrList[index]);
                            },
                            itemCount: controller.offerrList.length),
                      )
                    : Container();
              },
            ),
            getDynamicSizedBox(
                height:
                    SizerUtil.deviceType == DeviceType.mobile ? 1.5.h : 1.0.h),
            getHomeLable(DashboardText.populerTitle, () async {
              Get.to(DetailScreen(
                title: DashboardText.populerTitle,
                isFromTrending: false,
              ))!
                  .then((value) {
                controller.getHome(context);
                controller.getTotalProductInCart();
              });
            }),
            getDynamicSizedBox(height: 1.h),
            Obx(
              () {
                return controller.popularItemList.isNotEmpty
                    ? SizedBox(
                        height: SizerUtil.deviceType == DeviceType.mobile
                            ? 27.h
                            : 28.h,
                        child: ListView.builder(
                            padding: EdgeInsets.only(left: 2.w, right: 1.w),
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.antiAlias,
                            itemBuilder: (context, index) {
                              CommonProductList data =
                                  controller.popularItemList[index];
                              return controller.getpopularDeal(context, data,
                                  () {
                                controller.getTotalProductInCart();
                              }, controller.isGuest);
                            },
                            itemCount: controller.popularItemList.length),
                      )
                    : Container();
              },
            ),
            getDynamicSizedBox(height: 6.h)
          ]);
    } else {
      return noDataFoundWidget();
    }
  }
}
