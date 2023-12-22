import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/views/MainScreen/HomeScreen/HomeScreen.dart';
import 'package:gifthamperz/views/MainScreen/ProfileScreen/ProfileScreen.dart';
import 'package:gifthamperz/views/MainScreen/SavedScreen/SavedScreen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sizer/sizer.dart';
import '../../controller/mainScreenController.dart';

class BottomNavScreen extends StatelessWidget {
  const BottomNavScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var controller = Get.put(MainScreenController());
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
        const ProfileScreen(),
      ];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: pageOptions.elementAt(controller.currentPage),
      ),
      resizeToAvoidBottomInset: false,
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
        padding:
            const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
        decoration: BoxDecoration(
          color: black.withOpacity(0.8),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              spreadRadius: 3,
              color: black.withOpacity(.1),
            )
          ],
        ),
        child: FadeInUp(
          from: 50,
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 5,
            curve: Curves.bounceInOut,
            activeColor: white,
            iconSize: SizerUtil.deviceType == DeviceType.mobile ? 24 : 30,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            duration: const Duration(milliseconds: 400),
            tabBorderRadius: 15,
            tabBackgroundColor: primaryColor,
            color: primaryColor,
            tabs: const [
              GButton(
                icon: Icons.home_rounded,
                text: BottomConstant.home,
              ),
              GButton(icon: Icons.favorite_rounded, text: BottomConstant.saved),
              GButton(icon: Icons.person_rounded, text: BottomConstant.profile),
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
    );
  }

  void callback(int index) async {
    setState(() {
      controller.currentPage = index;
    });
  }
}
