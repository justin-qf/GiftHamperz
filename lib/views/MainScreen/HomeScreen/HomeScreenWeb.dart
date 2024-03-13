import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/homeController.dart';
import 'package:gifthamperz/controller/homeWebController%20.dart';
import 'package:gifthamperz/models/webModel.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class HomeScreenWeb extends StatefulWidget {
  HomeScreenWeb({super.key, this.isGuest});
  bool? isGuest = true;

  @override
  State<HomeScreenWeb> createState() => _HomeScreenWebState();
}

class _HomeScreenWebState extends State<HomeScreenWeb> {
  var homeController = Get.put(HomeScreenController());
  var controller = Get.put(HomeScreenWebController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: SizerUtil.width,
            padding: EdgeInsets.only(left: 4.w, right: 4.w),
            height: 30.h,
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                // padding: EdgeInsets.only(left: 2.w, right: 1.w, top: 0.5.h),
                shrinkWrap: false,
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.antiAlias,
                itemBuilder: (context, index) {
                  OccasionsListModel data =
                      controller.staticCategoryList[index];
                  return controller.getCategoryListItem(data);
                },
                itemCount: controller.staticCategoryList.length)),
        Container(
            height: 40.h,
            padding: EdgeInsets.only(left: 4.w, right: 4.w),
            child: Stack(
              children: [
                PageView.builder(
                  pageSnapping: true,
                  controller: homeController.pageController,
                  itemCount: controller.staticBannerList.length,
                  itemBuilder: (context, index) {
                    // BannerList bannerItems = homeController.bannerList[index];
                    ImageUrl bannerItems = controller.staticBannerList[index];
                    return Container(
                      margin:
                          EdgeInsets.only(left: 2.w, right: 3.w, bottom: 1.h),
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isDarkMode() ? black : white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            bannerItems.url,
                            fit: BoxFit.cover,
                          )),
                    );
                  },
                  onPageChanged: (index) {
                    setState(() {
                      homeController.currentPage = index;
                    });
                  },
                ),
                getBannerLeftRightSwiper(true),
                getBannerLeftRightSwiper(false),
              ],
            )),
        Container(
            margin: EdgeInsets.only(
              top: 3.h,
            ),
            height: 12.h,
            width: double.infinity,
            padding: EdgeInsets.only(left: 3.7.w, right: 6.w),
            color: bglightGreyColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                getPoliciesWeb(DashboardTextWeb.policyTxtOne, Asset.policyGift),
                getDynamicSizedBox(width: 1.1.w),
                headerDivider(),
                getDynamicSizedBox(width: 0.4.w),
                getPoliciesWeb(
                    DashboardTextWeb.policyTxtTwo, Asset.policyReturn),
                getDynamicSizedBox(width: 1.1.w),
                headerDivider(),
                getDynamicSizedBox(width: 0.4.w),
                getPoliciesWeb(
                    DashboardTextWeb.policyTxtThree, Asset.policyLocation),
                getDynamicSizedBox(width: 1.1.w),
                headerDivider(),
                getDynamicSizedBox(width: 0.4.w),
                getPoliciesWeb(
                    DashboardTextWeb.policyTxtFour, Asset.policyPayment)
              ],
            )),
        Container(
          margin: EdgeInsets.only(
            top: 3.h,
          ),
          height: MediaQuery.of(context).size.height * 1,
          width: SizerUtil.width,
          color: bglightGreyColor,
          child: Stack(children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: Image.asset(
                Asset.sellingBgWeb,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 6.w,
                right: 6.w,
                top: 3.h,
              ),
              child: Column(
                children: [
                  getHomeLableWeb(DashboardTextWeb.sellingTitle, () {}),
                  SizedBox(
                      height: 85.h,
                      child: MasonryGridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(top: 5.h),
                        crossAxisCount: 4,
                        mainAxisSpacing: 2.h,
                        crossAxisSpacing: 2.w,
                        shrinkWrap: true,
                        itemCount: controller.sellingList.length,
                        itemBuilder: (context, index) {
                          OccasionsListModel data =
                              controller.sellingList[index];
                          return Container(
                              margin: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.width > 600
                                          ? 5.h
                                          : 10.h),
                              child: controller.getListItem(context, data,
                                  () async {
                                homeController.getTotalProductInCart();
                              }, widget.isGuest, () async {}, homeController));
                        },
                      )

                      //  GridView.builder(
                      //   padding: EdgeInsets.only(top: 5.h),
                      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //     crossAxisCount: 4, // Number of columns
                      //     crossAxisSpacing: 3.w, // Spacing between columns
                      //   ),
                      //   itemCount: controller.sellingList.length,
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   shrinkWrap: false,
                      //   itemBuilder: (context, index) {
                      //     OccasionsListModel data =
                      //         controller.sellingList[index];
                      //     return Container(
                      //         margin: EdgeInsets.only(
                      //             bottom:
                      //                 MediaQuery.of(context).size.width > 600
                      //                     ? 5.h
                      //                     : 10.h),
                      //         child: controller.getListItem(context, data,
                      //             () async {
                      //           homeController.getTotalProductInCart();
                      //         }, widget.isGuest, () async {}, homeController));
                      //   },
                      // )

                      )
                ],
              ),
            )
          ]),
        ),
        getDynamicSizedBox(height: 5.h),
        Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: SizerUtil.width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Image.asset(
              Asset.helpWeb,
              fit: BoxFit.cover,
            )),
        getDynamicSizedBox(height: 5.h),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: SizerUtil.width,
          color: bglightGreyColor,
          child: Stack(children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: Image.asset(
                Asset.sellingBgWeb,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 6.w,
                right: 6.w,
                top: 3.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  getHomeLableWeb(DashboardTextWeb.offerTitle, () {}),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: SizerUtil.width,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.offerList.length,
                      padding: EdgeInsets.only(top: 3.h),
                      itemBuilder: (BuildContext context, int index) {
                        ImageUrl data = controller.offerList[index];
                        return Container(
                          margin: EdgeInsets.only(
                              right: index == controller.offerList.length - 1
                                  ? 0
                                  : 1.w),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                            child: Image.asset(
                              data.url.toString(),
                              fit: BoxFit.cover,
                              width: 43.3.w,
                              errorBuilder: (context, error, stackTrace) {
                                // Handle potential errors, e.g., display a placeholder image
                                return Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: SizedBox(
                                      height: 30,
                                      width: 30,
                                      child:
                                          LoadingAnimationWidget.discreteCircle(
                                        color: primaryColor,
                                        size: 35,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 3.h,
          ),
          height: MediaQuery.of(context).size.height * 1.3,
          width: SizerUtil.width,
          color: bglightGreyColor,
          child: Stack(children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: Image.asset(
                Asset.occasions,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(left: 0, top: 0, child: getBgDividerWeb(secondaryColor)),
            Positioned(
                left: 0, bottom: 0, child: getBgDividerWeb(secondaryColor)),
            Padding(
              padding: EdgeInsets.only(
                left: 6.w,
                right: 6.w,
                top: 3.h,
              ),
              child: Column(
                children: [
                  getHomeLableWeb(DashboardTextWeb.occasionstitle, () {}),
                  MasonryGridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: 5.h),
                    crossAxisCount: 3,
                    mainAxisSpacing: 5.h,
                    shrinkWrap: true,
                    itemCount: controller.occasionsList.length,
                    itemBuilder: (context, index) {
                      bool isEven = index == 2 || index == 5 ? true : false;
                      logcat("isEven", isEven.toString());
                      OccasionsListModel occasionsList =
                          controller.occasionsList[index];
                      return controller.getOccasiosListItem(
                          context, occasionsList, () async {
                        homeController.getTotalProductInCart();
                      }, widget.isGuest, () async {}, index, homeController);
                    },
                  )
                ],
              ),
            ),
          ]),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 3.h,
          ),
          height: 65.h,
          width: SizerUtil.width,
          color: footerColor,
          child: Stack(children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: Image.asset(
                Asset.occasions,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(left: 0, top: 0, child: getBgDividerWeb(secondaryColor)),
            Positioned(
                left: 0, bottom: 0, child: getBgDividerWeb(secondaryColor)),
            Padding(
              padding: EdgeInsets.only(
                left: 6.w,
                right: 3.w,
                top: 10.h,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            getFooterLogoWeb(),
                            Container(
                              margin: EdgeInsets.only(top: 1.h),
                              width: 22.w,
                              child: Text(
                                DashboardTextWeb.footerDesc,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 3.sp,
                                  color: isDarkMode() ? white : black,
                                  fontFamily: fontBold,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        getDynamicSizedBox(width: 2.w),
                        footerCommonUi(DashboardTextWeb.popularCatTitle,
                            controller.popularCatList, 14.w,
                            isContactList: false),
                        getDynamicSizedBox(width: 1.5.w),
                        footerCommonUi(DashboardTextWeb.helpfulLinkTitle,
                            controller.helpfullLinkList, 10.w,
                            isContactList: false),
                        getDynamicSizedBox(width: 1.5.w),
                        footerCommonUi(DashboardTextWeb.contactusTitle,
                            controller.contactList, 10.w,
                            isContactList: true)
                      ],
                    ),
                  ),
                  getBgDividerWeb(black, size: SizerUtil.width),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 2.h,
                    ),
                    child: Text(
                      DashboardTextWeb.rightsTxt,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 4.sp,
                        color: isDarkMode() ? white : black,
                        fontFamily: fontBold,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
