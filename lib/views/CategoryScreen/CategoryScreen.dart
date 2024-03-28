import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/api_handle/apiOtherStates.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/category_controller.dart';
import 'package:gifthamperz/models/categoryModel.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import '../../utils/enum.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  var controller = Get.put(CategoryController());

  @override
  void initState() {
    controller.getCategoryList(context, 0, true);
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
      onTap: () {
        controller.hideKeyboard(context);
      },
      isSafeArea: false,
      isNormalScreen: true,
      body: Container(
        color: isDarkMode() ? darkBackgroundColor : transparent,
        child: Column(
          children: [
            getForgetToolbar(CategoryScreenConstant.title, showBackButton: true,
                callback: () {
              Get.back();
            }),
            Expanded(
              child: Obx(() {
                switch (controller.state.value) {
                  case ScreenState.apiLoading:
                  case ScreenState.noNetwork:
                  case ScreenState.noDataFound:
                  case ScreenState.apiError:
                    return apiOtherStates(controller.state.value, controller,
                        controller.categoryList, () {
                      controller.getCategoryList(
                          context, controller.currentPage, true);
                    });
                  case ScreenState.apiSuccess:
                    return apiSuccess(controller.state.value);
                  default:
                    Container();
                }
                return Container();
              }),
            )
          ],
        ),
      ),
    );
  }

  Widget apiSuccess(ScreenState state) {
    // ignore: unrelated_type_equality_checks
    if (controller.state == ScreenState.apiSuccess &&
        controller.categoryList.isNotEmpty) {
      return MasonryGridView.count(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 2.h, left: 5.w, right: 5.w, top: 2.h),
        crossAxisCount: SizerUtil.deviceType == DeviceType.mobile ? 2 : 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          CategoryData data = controller.categoryList[index];
          return Column(
            children: [
              controller.getOldListItem(data),
              index == controller.categoryList.length - 1 &&
                      controller.nextPageURL.value.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.only(
                          top: 2.h, left: 25.w, right: 25.w, bottom: 0.8.h),
                      child: getMiniButton(
                        () {
                          controller.currentPage++;
                          controller.getCategoryList(
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
        itemCount: controller.categoryList.length,
      );
    } else {
      return noDataFoundWidget();
    }
  }

  // Widget apiOtherStates(state) {
  //   if (state == ScreenState.apiLoading) {
  //     return Center(
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(100),
  //         child: SizedBox(
  //           height: 30,
  //           width: 30,
  //           child: LoadingAnimationWidget.discreteCircle(
  //             color: primaryColor,
  //             size: 35,
  //           ),
  //         ),
  //       ),
  //     );
  //   }

  //   Widget? button;
  //   if (controller.categoryList.isEmpty) {
  //     Container();
  //   }
  //   if (state == ScreenState.noDataFound) {
  //     button = getMiniButton(() {
  //       Get.back();
  //     }, BottomConstant.back);
  //   }
  //   if (state == ScreenState.noNetwork) {
  //     button = getMiniButton(() {
  //       controller.getCategoryList(context, controller.currentPage, true);
  //     }, BottomConstant.tryAgain);
  //   }

  //   if (state == ScreenState.apiError) {
  //     button = getMiniButton(() {
  //       Get.back();
  //     }, BottomConstant.back);
  //   }
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Container(
  //           margin: EdgeInsets.symmetric(horizontal: 20.w),
  //           child: controller.message.value.isNotEmpty
  //               ? Text(
  //                   controller.message.value,
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                       fontFamily: fontMedium,
  //                       fontSize: 12.sp,
  //                       color: isDarkMode() ? white : black),
  //                 )
  //               : button),
  //     ],
  //   );
  // }
}
