import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/search_chat_widgets.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/savedController.dart';
import 'package:gifthamperz/models/UpdateDashboardModel.dart';
import 'package:gifthamperz/preference/UserPreference.dart';
import 'package:gifthamperz/utils/enum.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class SavedScreen extends StatefulWidget {
  SavedScreen(this.callBack, {super.key});
  Function callBack;
  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen>
    with TickerProviderStateMixin {
  var controller = Get.put(SavedScreenController());
  bool? isGuest;
  @override
  void initState() {
    controller.animateController = BottomSheet.createAnimationController(this);
    controller.animateController?.duration = const Duration(seconds: 1);
    controller.isSearch = false;
    apiCall();
    super.initState();
  }

  apiCall() async {
    isGuest = await UserPreferences().getGuestUser();
    logcat("isGUESTUSER", isGuest.toString());
    if (isGuest == true) {
    } else {
      // ignore: use_build_context_synchronously
      controller.getFavouriteList(context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbarIsNormalScreen();
    return CustomParentScaffold(
        onWillPop: () async {
          return false;
        },
        onTap: () {
          controller.hideKeyboard(context);
        },
        isSafeArea: false,
        body: Container(
          color: isDarkMode() ? darkBackgroundColor : transparent,
          child: Stack(children: [
            Column(
              children: [
                getDynamicSizedBox(
                    height: controller.isSearch == true ? 4.5.h : 5.h),
                if (controller.isSearch == true)
                  setSearchBar(context, controller.searchCtr, 'saved',
                      onCancleClick: () {
                    controller.isSearch = false;
                    controller.searchCtr.text = '';
                    controller.applyFilter('', false);
                    controller.setSearchQuery(controller.searchCtr.text);
                    setState(() {});
                  }, onClearClick: () {
                    controller.searchCtr.text = '';
                    controller.applyFilter('', false);
                    controller.setSearchQuery(controller.searchCtr.text);
                    setState(() {});
                  }, isCancle: true)
                else
                  getFilterToolbar(SavedScreenText.title, callback: () {
                    Statusbar().trasparentBottomsheetStatusbar();
                    controller.getFilterBottomSheet(context);
                    //Get.to(const FilterScreen());
                  }, searchClick: () {
                    controller.isSearch = true;
                    setState(() {});
                  }),

                Expanded(
                  child: isGuest != true
                      ? Stack(children: [
                          Obx(() {
                            switch (controller.state.value) {
                              case ScreenState.apiLoading:
                              case ScreenState.noNetwork:
                              case ScreenState.noDataFound:
                              case ScreenState.apiError:
                                return SizedBox(
                                  height: SizerUtil.height / 1.5,
                                  child: apiOtherStates(controller.state.value),
                                );
                              case ScreenState.apiSuccess:
                                return apiSuccess(controller.state.value);
                              default:
                                Container();
                            }
                            return Container();
                          }),
                        ])
                      : Container(
                          margin: EdgeInsets.only(bottom: 15.h),
                          child: Center(
                              child: Text(
                            "List is Empty",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: fontMedium,
                                fontSize: 12.sp,
                                color: isDarkMode() ? white : black),
                          )),
                        ),
                ),

                //   Expanded(
                //     child: Container(
                //       margin: EdgeInsets.only(left: 2.w, right: 2.w),
                //       child: Obx(
                //         () {
                //           if (controller.filteredList.isNotEmpty) {
                //             final filteredList = controller.filteredList;
                //             return MasonryGridView.count(
                //               physics: const BouncingScrollPhysics(),
                //               padding: EdgeInsets.only(bottom: 13.h),
                //               crossAxisCount:
                //                   SizerUtil.deviceType == DeviceType.mobile ? 2 : 3,
                //               mainAxisSpacing: 10,
                //               crossAxisSpacing: 4,
                //               itemBuilder: (context, index) {
                //                 SavedItem data = filteredList[index];
                //                 return controller.getItemListItem(data);
                //               },
                //               itemCount: filteredList.length,
                //             );
                //           } else {
                //             return Container(
                //               margin: EdgeInsets.only(bottom: 15.h),
                //               child: Center(
                //                 child: Text(
                //                   APIResponseHandleText.emptylist,
                //                   style: TextStyle(
                //                     fontFamily: fontMedium,
                //                     color: isDarkMode() ? white : black,
                //                     fontSize:
                //                         SizerUtil.deviceType == DeviceType.mobile
                //                             ? 10.sp
                //                             : 7.sp,
                //                   ),
                //                 ),
                //               ),
                //             );
                //           }
                //         },
                //       ),
                //     ),
                //   ),
                // ]),
                Visibility(
                  visible: false,
                  child: Positioned(
                      left: 0,
                      bottom: 13.h,
                      child: SizedBox(
                        width: SizerUtil.width,
                        child: Center(
                          child: controller.getFilterUi(),
                        ),
                      )),
                ),
              ],
            ),
          ]),
        ));
  }

  Widget apiSuccess(ScreenState state) {
    // ignore: unrelated_type_equality_checks
    if (controller.state == ScreenState.apiSuccess &&
        controller.favouriteFilterList.isNotEmpty) {
      return MasonryGridView.count(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
            bottom: 13.h,
            left: 3.w,
            top: controller.favouriteFilterList.isNotEmpty ? 2.h : 0.0),
        crossAxisCount: SizerUtil.deviceType == DeviceType.mobile ? 2 : 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          CommonProductList data = controller.favouriteFilterList[index];
          return controller.getItemListItem(context, data);
        },
        itemCount: controller.favouriteFilterList.length,
      );
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
    if (controller.favouriteFilterList.isEmpty) {
      Container();
    }
    if (state == ScreenState.noDataFound) {
      button = getMiniButton(() {
        Get.back();
      }, BottomConstant.back);
    }
    if (state == ScreenState.noNetwork) {
      button = getMiniButton(() {
        controller.getFavouriteList(context);
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
}
