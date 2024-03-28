import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/nav_widget.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/device_type.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/homeController.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/views/CartScreen/CartScreen.dart';
import 'package:gifthamperz/views/MainScreen/HomeScreen/HomeScreen.dart';
import 'package:gifthamperz/views/MainScreen/ProfileScreen/ProfileScreen.dart';
import 'package:gifthamperz/views/MainScreen/SavedScreen/SavedScreen.dart';
import 'package:gifthamperz/views/SearchScreen/SearchScreen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sizer/sizer.dart';
import '../../componant/widgets/widgets.dart';
import '../../controller/mainScreenController.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var controller = Get.put(MainScreenController());
  var homeController = Get.put(HomeScreenController());

  var pageOptions = <Widget>[];

  @override
  void initState() {
    controller.currentPage = 0;
    setState(() {
      pageOptions = [
        HomeScreen(callback),
        SavedScreen(
          callback,
        ),
        ProfileScreen(callback),
      ];
    });
    super.initState();
  }

  void updateDarkMode() {
    isDarkMode();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: pageOptions.elementAt(controller.currentPage),
        ),
        resizeToAvoidBottomInset: false,
        extendBody: true,
        appBar: DeviceScreenType.isWeb(context) ? webViewAppbar() : null,
        bottomNavigationBar: DeviceScreenType.isWeb(context)
            ? Container()
            : Container(
                margin: EdgeInsets.only(
                    left: SizerUtil.deviceType == DeviceType.mobile
                        ? 10
                        : SizerUtil.width / 5,
                    right: SizerUtil.deviceType == DeviceType.mobile
                        ? 10
                        : SizerUtil.width / 5,
                    bottom: 10,
                    top: 10),
                padding: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 10, top: 10),
                decoration: BoxDecoration(
                  color: isDarkMode()
                      ? bottomMenuColor.withOpacity(0.7)
                      : white.withOpacity(0.8),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      spreadRadius: 2,
                      color: black.withOpacity(0.2),
                    )
                  ],
                ),
                child: DeviceScreenType.isWeb(context)
                    ? FadeInUp(
                        from: 50,
                        child: GNav(
                          rippleColor: Colors.grey[300]!,
                          hoverColor: Colors.grey[100]!,
                          gap: 5,
                          curve: Curves.bounceInOut,
                          activeColor: white,
                          iconSize: SizerUtil.deviceType == DeviceType.mobile
                              ? 24
                              : 30,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          duration: const Duration(milliseconds: 400),
                          tabBorderRadius: 15,
                          tabBackgroundColor: primaryColor,
                          color: primaryColor,
                          tabs: const [
                            GButton(
                              icon: Icons.home_rounded,
                              text: BottomConstant.home,
                            ),
                            GButton(
                                icon: Icons.favorite_rounded,
                                text: BottomConstant.saved),
                            GButton(
                                icon: Icons.person_rounded,
                                text: BottomConstant.profile),
                          ],
                          selectedIndex: controller.currentPage,
                          onTabChange: (index) {
                            setState(() {
                              controller.changeIndex(index);
                            });
                          },
                        ),
                      )
                    : FadeInUp(
                        from: 50,
                        child: GNav(
                          rippleColor: Colors.grey[300]!,
                          hoverColor: Colors.grey[100]!,
                          gap: 5,
                          curve: Curves.bounceInOut,
                          activeColor: white,
                          iconSize: SizerUtil.deviceType == DeviceType.mobile
                              ? 24
                              : 30,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          duration: const Duration(milliseconds: 400),
                          tabBorderRadius: 15,
                          tabBackgroundColor: primaryColor,
                          color: primaryColor,
                          tabs: const [
                            GButton(
                              icon: Icons.home_rounded,
                              text: BottomConstant.home,
                            ),
                            GButton(
                                icon: Icons.favorite_rounded,
                                text: BottomConstant.saved),
                            GButton(
                                icon: Icons.person_rounded,
                                text: BottomConstant.profile),
                          ],
                          selectedIndex: controller.currentPage,
                          onTabChange: (index) {
                            setState(() {
                              controller.changeIndex(index);
                            });
                          },
                        ),
                      ),
              ),
      ),
    );
  }

  void callback(int index) async {
    setState(() {
      controller.currentPage = index;
    });
  }

  webViewAppbar() {
    return AppBar(
      toolbarHeight: 11.h,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getLogoWithTitle(),
          const Spacer(),
          NavItem(
              icon: Icons.home_rounded,
              text: BottomConstant.home,
              onClick: () {
                callback(0);
              }),
          getDynamicSizedBox(width: 1.w),
          headerDivider(),
          getDynamicSizedBox(width: 1.w),
          NavItem(
              icon: Icons.favorite_rounded,
              text: BottomConstant.saved,
              onClick: () {
                callback(1);
              }),
          getDynamicSizedBox(width: 1.w),
          headerDivider(),
          getDynamicSizedBox(width: 1.w),
          NavItem(
              icon: Icons.person_rounded,
              text: BottomConstant.profile,
              onClick: () {
                callback(2);
              }),
          const Spacer(),
        ],
      ),
      centerTitle: true,
      backgroundColor: white,
      elevation: 1,
      automaticallyImplyLeading: true,
      actions: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.to(const SearchScreen())!.then((value) {
                  homeController.getHome(context);
                  homeController.getTotalProductInCart();
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.only(left: 2, right: 1, top: 2, bottom: 2),
                child: Icon(
                  color: isDarkMode() ? white : primaryColor,
                  Icons.search,
                  size: 5.h,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(const CartScreen())!.then((value) {
                  //homeController.getHome(context);
                  homeController.getTotalProductInCart();
                });
              },
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Container(
                      padding: const EdgeInsets.all(2),
                      child: Icon(
                        color: isDarkMode() ? white : primaryColor,
                        Icons.shopping_cart,
                        size: SizerUtil.deviceType == DeviceType.mobile
                            ? 3.3.h
                            : 4.h,
                      )),
                  Positioned(
                    right: 3,
                    top: 2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: bottomNavBackground,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 1.1.w,
                        minHeight: 2.h,
                      ),
                      child: Text(
                        '1'.toString(),
                        style: TextStyle(
                          color: isDarkMode() ? white : black,
                          fontSize: 2.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.favorite_border,
              weight: 1,
              color: primaryColor,
              size: 5.h,
            ),
            getDynamicSizedBox(width: 0.5.w),
            headerDivider(),
            getDynamicSizedBox(width: 0.5.w),
            getSignInTextWidget(homeController)
          ],
        ),
      ],
    );
  }
}
