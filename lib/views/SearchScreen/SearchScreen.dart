import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/api_handle/apiOtherStates.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/search_chat_widgets.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/searchController.dart';
import 'package:gifthamperz/models/UpdateDashboardModel.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import '../../utils/enum.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var controller = Get.put(SearchScreenController());
  @override
  void initState() {
    controller.isSearch = false;
    controller.getSearchList(context, controller.searchCtr.text.toString());
    controller.getGuestLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbarIsNormalScreen();
    return CustomParentScaffold(
      onWillPop: () async {
        Get.back(result: true);
        return false;
      },
      onTap: () {
        controller.hideKeyboard(context);
      },
      isSafeArea: false,
      isNormalScreen: true,
      body: Container(
        color: isDarkMode() ? darkBackgroundColor : transparent,
        child: Stack(
          children: [
            getForgetToolbar(SearchScreenConstant.title,
                isList: true, showBackButton: true, callback: () {
              Get.back(result: true);
            }),
            Column(children: [
              getDynamicSizedBox(height: 5.h),
              setSearchBar(context, controller.searchCtr, 'search',
                  onCancleClick: () {
                controller.isSearch = false;
                controller.searchCtr.text = '';
                setState(() {});
              }, onClearClick: () {
                if (controller.searchCtr.text.isNotEmpty) {
                  controller.getSearchList(context, "");
                }
                controller.searchCtr.text = '';
                setState(() {});
              }, isCancle: false),
              getDynamicSizedBox(height: 2.h),
              Expanded(
                  child: Container(
                      margin: EdgeInsets.only(left: 2.w, right: 2.w),
                      child: Stack(children: [
                        Obx(() {
                          switch (controller.state.value) {
                            case ScreenState.apiLoading:
                            case ScreenState.noNetwork:
                            case ScreenState.noDataFound:
                            case ScreenState.apiError:
                              return SizedBox(
                                height: SizerUtil.height / 1.5,
                                child: apiOtherStates(controller.state.value,
                                    controller, controller.searchList, () {
                                  controller.getSearchList(context,
                                      controller.searchCtr.text.toString());
                                }),
                              );
                            case ScreenState.apiSuccess:
                              return apiSuccess(controller.state.value);
                            default:
                              Container();
                          }
                          return Container();
                        }),
                      ]))

                  //  Obx(
                  //   () {
                  //     if (controller.searchList.isNotEmpty) {
                  //       final filteredList = controller.searchList;
                  //       return MasonryGridView.count(
                  //         physics: const BouncingScrollPhysics(),
                  //         padding: EdgeInsets.only(bottom: 13.h),
                  //         crossAxisCount:
                  //             SizerUtil.deviceType == DeviceType.mobile ? 2 : 3,
                  //         mainAxisSpacing: 10,
                  //         crossAxisSpacing: 4,
                  //         itemBuilder: (context, index) {
                  //           SearchDataList data = filteredList[index];
                  //           return controller.getItemListItem(data);
                  //         },
                  //         itemCount: controller.searchList.length,
                  //       );
                  //     } else {
                  //       return Container(
                  //         margin: EdgeInsets.only(bottom: 15.h),
                  //         child: Center(
                  //           child: Text(
                  //             APIResponseHandleText.emptylist,
                  //             style: TextStyle(
                  //               fontFamily: fontMedium,
                  //               color: isDarkMode() ? white : black,
                  //               fontSize:
                  //                   SizerUtil.deviceType == DeviceType.mobile
                  //                       ? 10.sp
                  //                       : 7.sp,
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     }
                  //   },
                  // ),
                  ),
            ]),
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
      ),
    );
  }

  Widget apiSuccess(ScreenState state) {
    // ignore: unrelated_type_equality_checks
    if (controller.state == ScreenState.apiSuccess &&
        controller.searchList.isNotEmpty) {
      return MasonryGridView.count(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 3.h, top: 1.h, left: 2.w, right: 2.w),
        crossAxisCount: SizerUtil.deviceType == DeviceType.mobile ? 2 : 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          CommonProductList data = controller.searchList[index];
          return controller.getItemListItem(
              context, data, controller.isGuest!.value);
        },
        itemCount: controller.searchList.length,
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
  //   if (controller.searchList.isEmpty) {
  //     Container();
  //   }
  //   if (state == ScreenState.noDataFound) {
  //     button = getMiniButton(() {
  //       Get.back();
  //     }, BottomConstant.back);
  //   }
  //   if (state == ScreenState.noNetwork) {
  //     button = getMiniButton(() {
  //       controller.getSearchList(context, controller.searchCtr.text.toString());
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
