import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/search_chat_widgets.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/homeController.dart';
import 'package:gifthamperz/models/BannerModel.dart';
import 'package:gifthamperz/models/DashboadModel.dart';
import 'package:gifthamperz/models/categoryModel.dart';
import 'package:gifthamperz/preference/UserPreference.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/CategoryScreen/CategoryScreen.dart';
import 'package:gifthamperz/views/MainScreen/HomeScreen/DetailScreen/DetailScreen.dart';
import 'package:gifthamperz/views/SearchScreen/SearchScreen.dart';
import 'package:sizer/sizer.dart';
import '../../../../configs/colors_constant.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen(this.callBack, {super.key});
  Function callBack;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var controller = Get.put(HomeScreenController());

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
  }

  void getGuestLogin() async {
    bool isGuest = await UserPreferences().getGuestUser();
    logcat('USERRRRRRRRRR:', isGuest);
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
            getToolbar(DashboardText.dashboard, () {
              // widget.callBack(1);
              Get.to(const SearchScreen());
              //controller.isSearch = !controller.isSearch;
              setState(() {});
            }),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 2.h),
                physics: const BouncingScrollPhysics(),
                child: Column(
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
                      getDynamicSizedBox(height: 2.h),
                      SizedBox(
                        height: 24.h,
                        child: Obx(() {
                          return Stack(
                            children: [
                              PageView.builder(
                                pageSnapping: true,
                                controller: controller.pageController,
                                itemCount: controller.bannerList.length,
                                itemBuilder: (context, index) {
                                  BannerList bannerItems =
                                      controller.bannerList[index];
                                  return Container(
                                      margin: EdgeInsets.only(
                                          left: 4.w, right: 4.w),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
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
                                    children: List.generate(
                                        controller.bannerList.length, (index) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
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
                      getDynamicSizedBox(height: 1.5.h),
                      SizedBox(
                        height: 17.h,
                        child: Obx(
                          () {
                            return controller.categoryList.isNotEmpty
                                ? ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    padding: EdgeInsets.only(
                                      left: 4.w,
                                    ),
                                    shrinkWrap: false,
                                    scrollDirection: Axis.horizontal,
                                    clipBehavior: Clip.antiAlias,
                                    itemBuilder: (context, index) {
                                      // CategoryItem data =
                                      //     controller.categoryList[index];
                                      // return controller.getCategoryListItem(data);
                                      CategoryData data =
                                          controller.categoryList[index];
                                      logcat(
                                          "categoryList", data.name.toString());
                                      return controller
                                          .getCategoryListItem(data);
                                    },
                                    itemCount: controller.categoryList.length)
                                : Container();
                          },
                        ),
                      ),
                      getHomeLable("Trending", () {
                        Get.to(DetailScreen(
                          title: DashboardText.trendingTitle,
                        ));
                      }),
                      getDynamicSizedBox(height: 2.h),
                      Obx(
                        () {
                          return controller.trendingItemList.isNotEmpty
                              ? SizedBox(
                                  height: 28.h,
                                  child: ListView.builder(
                                      padding: EdgeInsets.only(
                                          left: 4.w, right: 2.w),
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      clipBehavior: Clip.antiAlias,
                                      itemBuilder: (context, index) {
                                        // HomeItem data = controller.staticData[index];
                                        // return controller.getListItem(data);
                                        CommonProductList data =
                                            controller.trendingItemList[index];
                                        return controller.getListItem(data);
                                      },
                                      itemCount:
                                          controller.trendingItemList.length),
                                )
                              : Container();
                        },
                      ),
                      getDynamicSizedBox(height: 1.h),
                      getHomeLable("Popular", () {
                        Get.to(DetailScreen(
                          title: DashboardText.populerTitle,
                        ));
                      }),
                      getDynamicSizedBox(height: 2.h),
                      Obx(
                        () {
                          return controller.popularItemList.isNotEmpty
                              ? SizedBox(
                                  height: 30.h,
                                  child: ListView.builder(
                                      padding: EdgeInsets.only(
                                          left: 4.w, right: 2.w),
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      clipBehavior: Clip.antiAlias,
                                      itemBuilder: (context, index) {
                                        CommonProductList data =
                                            controller.popularItemList[index];
                                        return controller.getSpecialDeal(data);
                                      },
                                      itemCount:
                                          controller.popularItemList.length),
                                )
                              : Container();
                        },
                      ),
                      getDynamicSizedBox(height: 6.h)
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
