import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/controller/homeController.dart';
import 'package:gifthamperz/models/DashboadModel.dart';
import 'package:gifthamperz/models/homeModel.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:sizer/sizer.dart';

class DetailScreen extends StatefulWidget {
  String? title;
  DetailScreen({super.key, this.title});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  var controller = Get.put(HomeScreenController());

  @override
  void initState() {
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
          getForgetToolbar(widget.title, showBackButton: true, callback: () {
            Get.back();
          }),
          getDynamicSizedBox(height: 1.5.h),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 3.w, right: 3.w),
              child: MasonryGridView.count(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: 5.h),
                crossAxisCount:
                    SizerUtil.deviceType == DeviceType.mobile ? 2 : 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 4,
                itemBuilder: (context, index) {
                  // CommonProductList data = controller.staticData[index];
                  // return controller.getListItem(data);
                  return Container();
                },
                itemCount: controller.staticData.length,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
