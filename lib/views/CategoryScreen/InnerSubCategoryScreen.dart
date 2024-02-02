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
import 'package:gifthamperz/controller/InnerSubCategoryController.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/OrderScreen/AllScreen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import '../../utils/enum.dart';

class InnerSubCategoryScreen extends StatefulWidget {
  InnerSubCategoryScreen(
      {super.key, required this.categoryId, required this.subcategoryId});
  String? categoryId;
  String? subcategoryId;

  @override
  State<InnerSubCategoryScreen> createState() => _InnerSubCategoryScreenState();
}

class _InnerSubCategoryScreenState extends State<InnerSubCategoryScreen>
    with TickerProviderStateMixin {
  var controller = Get.put(InnerSubCategoryController());

  @override
  void initState() {
    controller.tabController =
        TabController(vsync: this, length: 4, initialIndex: 0);
    controller.getInnerSubCategoryList(
        context, widget.categoryId, widget.subcategoryId);
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
            getOrderToolbar(CategoryScreenConstant.innerSubCategorytitle),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 2.w, right: 2.w),
                child: Obx(() {
                  switch (controller.state.value) {
                    case ScreenState.apiLoading:
                    case ScreenState.noNetwork:
                    case ScreenState.noDataFound:
                    case ScreenState.apiError:
                      return apiOtherStates(controller.state.value);
                    case ScreenState.apiSuccess:
                      return apiSuccess(controller.state.value);
                    default:
                      Container();
                  }
                  return Container();
                }),
              ),
            )
          ])),
    );
  }

  Widget apiSuccess(ScreenState state) {
    // ignore: unrelated_type_equality_checks
    if (controller.state == ScreenState.apiSuccess &&
        controller.subCategoryList.isNotEmpty) {
      return getListViewItem();
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
    if (controller.subCategoryList.isEmpty) {
      Container();
    }
    if (state == ScreenState.noDataFound) {
      button = getMiniButton(() {
        Get.back();
      }, BottomConstant.back);
    }
    if (state == ScreenState.noNetwork) {
      button = getMiniButton(() {
        controller.getInnerSubCategoryList(
            context, widget.categoryId, widget.subcategoryId);
      }, BottomConstant.tryAgain);
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

  getListViewItem() {
    return DefaultTabController(
        length: controller.subCategoryList.length,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < controller.subCategoryList.length; i++)
                getTab(controller.subCategoryList[i].name,
                    controller.currentPage == i),
            ],
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: controller.tabController,
              children: [
                const AllTabScreen(),
                SizedBox(
                  height: SizerUtil.height,
                  child: const Center(child: Text("PAGE 2")),
                ),
                SizedBox(
                  height: SizerUtil.height,
                  child: const Center(child: Text("PAGE 3")),
                ),
                SizedBox(
                  height: SizerUtil.height,
                  child: const Center(child: Text("PAGE 4")),
                ),
              ],
            ),
          ),
        ]));
  }

  getTab(String str, bool isSelected) {
    return GestureDetector(
      onTap: () {
        int index = controller.subCategoryList
            .indexWhere((category) => category.name == str);
        if (index != -1) {
          controller.currentPage = index;
          if (controller.tabController.indexIsChanging == false) {
            controller.tabController.index = index;
          }
          setState(() {});
        }
      },
      child: AnimatedContainer(
        width: 21.w,
        duration: const Duration(milliseconds: 300),
        margin:
            EdgeInsets.only(top: 1.h, bottom: 1.5.h, left: 1.2.w, right: 1.2.w),
        padding: EdgeInsets.only(
            top: 1.5.h, bottom: 1.5.h, left: 1.2.w, right: 1.2.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              spreadRadius: 0.1,
              color: black.withOpacity(.1),
            )
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            str,
            maxLines: 1,
            style: TextStyle(
              fontSize: 10.sp,
              overflow: TextOverflow.ellipsis,
              fontFamily: fontBold,
              fontWeight: FontWeight.w700,
              color: isSelected ? white : black,
            ),
          ),
        ),
      ),
    );
  }
}
