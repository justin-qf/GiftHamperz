import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/dialogs/dialogs.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/search_chat_widgets.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/homeController.dart';
import 'package:gifthamperz/models/UpdateDashboardModel.dart';
import 'package:gifthamperz/preference/UserPreference.dart';
import 'package:gifthamperz/utils/enum.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/CartScreen/CartScreen.dart';
import 'package:gifthamperz/views/CategoryScreen/CategoryScreen.dart';
import 'package:gifthamperz/views/MainScreen/HomeScreen/DetailScreen/DetailScreen.dart';
import 'package:gifthamperz/views/SearchScreen/SearchScreen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
  bool? isGuest = true;

  @override
  void initState() {
    super.initState();
    controller.pageController =
        PageController(initialPage: controller.currentPage);
    // controller.getHome(context);
    startAutoScroll();
    controller.getTotalProductInCart();
    showGuestUserLogin();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    try {
      if (mounted) {
        await Future.delayed(const Duration(seconds: 0)).then((value) {
          controller.getHome(context);
        });
      }
    } catch (e) {
      logcat("ERROR", e);
    }
    setState(() {});
  }

  showGuestUserLogin() async {
    isGuest = await UserPreferences().getGuestUser();
    bool isDialogVisible = await UserPreferences().getGuestUserDialogVisible();
    if (isGuest == true && !isDialogVisible) {
      UserPreferences().setGuestUserDialogVisible(true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Check if the current route is the home screen before showing the alert
        Future.delayed(const Duration(seconds: 2), () {
          getGuestUserLogin(
            context,
            DashboardText.dashboard,
          );
        });
      });
    }
    setState(() {});
  }

  void startAutoScroll() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      controller.timer =
          Timer.periodic(const Duration(seconds: 3), (Timer timer) {
        if (controller.currentPage < controller.bannerItems.length - 1) {
          controller.currentPage++;
        } else {
          controller.currentPage = 0;
        }
        if (controller.pageController.hasClients) {
          controller.pageController.animateToPage(
            controller.currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    controller.pageController.dispose();
    controller.timer.cancel();
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
            getDynamicSizedBox(height: 5.h),
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
                        child: apiOtherStates(controller.state.value),
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
    );
  }

  Widget apiSuccess(ScreenState state) {
    // ignore: unrelated_type_equality_checks
    if (controller.state == ScreenState.apiSuccess &&
        controller.homeData != null &&
        controller.homeData!.data.trendList.isNotEmpty) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getDynamicSizedBox(height: 1.h),
            if (controller.isSearch == true)
              setSearchBar(context, controller.searchCtr, 'home',
                  onCancleClick: () {
                controller.searchCtr.text = '';
                setState(() {
                  controller.isSearch = false;
                });
              }, onClearClick: () {
                controller.searchCtr.text = '';
                setState(() {});
              })
            else
              Container(),
            SizedBox(
              height: 20.h,
              child: Obx(() {
                return Stack(
                  children: [
                    PageView.builder(
                      pageSnapping: true,
                      controller: controller.pageController,
                      itemCount: controller.bannerList.length,
                      itemBuilder: (context, index) {
                        BannerList bannerItems = controller.bannerList[index];
                        return Container(
                          margin: EdgeInsets.only(
                              top: 1.h, left: 2.w, right: 3.w, bottom: 1.h),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: isDarkMode() ? black : white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  color: isDarkMode()
                                      ? white.withOpacity(0.2)
                                      : black.withOpacity(0.2),
                                  spreadRadius: 0.1,
                                  blurRadius: 10,
                                  offset: const Offset(0.5, 0.5)),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              height: 18.h,
                              imageUrl: APIImageUrl.url + bannerItems.url,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                    color: primaryColor),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                Asset.productPlaceholder,
                                height: 18.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                      onPageChanged: (index) {
                        setState(() {
                          controller.currentPage = index;
                        });
                      },
                    ),
                    Positioned(
                        bottom: 15,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(controller.bannerList.length,
                              (index) {
                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              width: 2.w,
                              height: 2.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: controller.currentPage == index
                                    ? primaryColor
                                    : grey,
                              ),
                            );
                          }),
                        ))
                  ],
                );
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
              height: SizerUtil.deviceType == DeviceType.web ? 15.h : 13.h,
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
                            return controller.getCategoryListItem(data);
                          },
                          itemCount: controller.categoryList.length)
                      : Container();
                },
              ),
            ),
            getDynamicSizedBox(height: 1.h),
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
                              }, isGuest, () async {});
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
                        height: 15.h,
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
            getDynamicSizedBox(height: 1.5.h),
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
                        height: 27.h,
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
                              }, isGuest);
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
    if (controller.bannerList.isEmpty) {
      Container();
    }
    if (state == ScreenState.noDataFound) {
      button = getMiniButton(() {
        Get.back();
      }, BottomConstant.back);
    }
    if (state == ScreenState.noNetwork) {
      button = getMiniButton(() {}, BottomConstant.tryAgain);
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
