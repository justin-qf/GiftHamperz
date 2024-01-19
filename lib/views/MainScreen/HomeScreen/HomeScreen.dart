import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/dialogs/customDialog.dart';
import 'package:gifthamperz/componant/dialogs/dialogs.dart';
import 'package:gifthamperz/componant/dialogs/loading_indicator.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/search_chat_widgets.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/homeController.dart';
import 'package:gifthamperz/models/BannerModel.dart';
import 'package:gifthamperz/models/DashboadModel.dart';
import 'package:gifthamperz/models/categoryModel.dart';
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
  //int? totalItemsCount = 0;
  bool dialogShown = false;
  bool? isGuest = true;

  @override
  void initState() {
    super.initState();
    getGuestLogin();
    controller.pageController =
        PageController(initialPage: controller.currentPage);
    controller.getCategoryList(context);
    controller.getBannerList(context);
    controller.getHome(context);
    startAutoScroll();
    //getTotalProductInCart();
    controller.getTotalProductInCart();
    showGuestUserLogin();
  }

  showGuestUserLogin() async {
    isGuest = await UserPreferences().getGuestUser();
    bool isDialogVisible = await UserPreferences().getGuestUserDialogVisible();

    if (isGuest == true && !isDialogVisible) {
      dialogShown = true;
      UserPreferences().setGuestUserDialogVisible(true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Check if the current route is the home screen before showing the alert
        Future.delayed(const Duration(seconds: 2), () {
          getGuestUserLogin(context);
        });
      });
    }
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Make sure to update the state if necessary
    //setState(() {});
  }

  // getTotalProductInCart() async {
  //   // Fetch the current cart items from preferences
  //   List<CommonProductList> cartItems = await UserPreferences().loadCartItems();
  //   logcat("cartItems", cartItems.length.toString());
  //   // Get the total length of the list
  //   controller.totalItemsCount.value = cartItems.length;
  //   setState(() {});
  // }

  void getGuestLogin() async {
    bool isGuest = await UserPreferences().getGuestUser();
    logcat('USER:', isGuest);
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
                Get.to(const SearchScreen());
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
                padding: EdgeInsets.only(bottom: 5.h),
                physics: const BouncingScrollPhysics(),
                child: Obx(() {
                  switch (controller.state.value) {
                    case ScreenState.apiLoading:
                    case ScreenState.noNetwork:
                    case ScreenState.noDataFound:
                    case ScreenState.apiError:
                      return SizedBox(
                        height: SizerUtil.height / 1.2,
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
        controller.bannerList.isNotEmpty) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getDynamicSizedBox(height: 1.h),
            if (controller.isSearch == true)
              setSearchBar(context, controller.searchCtr, 'home',
                  onCancleClick: () {
                controller.searchCtr.text = '';
                logcat("onCANCLE", "DONE");
                setState(() {
                  controller.isSearch = false;
                });
              }, onClearClick: () {
                controller.searchCtr.text = '';
                setState(() {});
              })
            else
              Container(),
            getDynamicSizedBox(height: 1.h),
            SizedBox(
              height: 18.h,
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
                            margin: EdgeInsets.only(left: 4.w, right: 4.w),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                APIImageUrl.url + bannerItems.url,
                                fit: BoxFit.cover,
                              ),
                            ));
                      },
                      onPageChanged: (index) {
                        setState(() {
                          controller.currentPage = index;
                        });
                      },
                    ),
                    Positioned(
                        bottom: 10,
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
              height: 2.h,
            ),
            getHomeLable("Category", () {
              Get.to(const CategoryScreen());
              // Get.to(DetailScreen(
              //   title: DashboardText.categoryTitle,
              // ));
            }),
            //getDynamicSizedBox(height: 1.0.h),
            SizedBox(
              height: 13.h,
              child: Obx(
                () {
                  return controller.categoryList.isNotEmpty
                      ? ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(left: 4.w, top: 0.5.h),
                          shrinkWrap: false,
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.antiAlias,
                          itemBuilder: (context, index) {
                            // CategoryItem data =
                            //     controller.categoryList[index];
                            // return controller.getCategoryListItem(data);
                            CategoryData data = controller.categoryList[index];
                            return controller.getCategoryListItem(data);
                          },
                          itemCount: controller.categoryList.length)
                      : Container();
                },
              ),
            ),
            getDynamicSizedBox(height: 1.h),
            getHomeLable("Trending", () {
              Get.to(DetailScreen(
                title: DashboardText.trendingTitle,
              ))!
                  .then((value) {
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
                            padding: EdgeInsets.only(left: 4.w, right: 2.w),
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.antiAlias,
                            itemBuilder: (context, index) {
                              // HomeItem data = controller.staticData[index];
                              // return controller.getListItem(data);
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
            getHomeLable(DashboardText.populerTitle, () {
              Get.to(DetailScreen(
                title: DashboardText.populerTitle,
              ))!
                  .then((value) {
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
                            padding: EdgeInsets.only(left: 4.w, right: 2.w),
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
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              Common.datanotfound,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: fontMedium, fontSize: 12.sp),
            ),
          ),
        ],
      );
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
                    style: TextStyle(fontFamily: fontMedium, fontSize: 12.sp),
                  )
                : button),
      ],
    );
  }
}
