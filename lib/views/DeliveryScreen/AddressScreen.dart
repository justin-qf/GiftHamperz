import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/action_button.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/AddressController.dart';
import 'package:gifthamperz/models/addressModel.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/DeliveryScreen/AddAddressScreen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

import '../../utils/enum.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  var controller = Get.put(AddressScreenController());

  @override
  void initState() {
    apiCalls();
    super.initState();
  }

  void apiCalls() async {
    // ignore: use_build_context_synchronously
    controller.getAddressList(context, 0, true);
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbarIsNormalScreen();
    return CustomParentScaffold(
      onWillPop: () async {
        return true;
      },
      isSafeArea: false,
      isNormalScreen: true,
      body: Container(
        color: isDarkMode() ? darkBackgroundColor : transparent,
        child: Stack(children: [
          Column(
            children: [
              getForgetToolbar(AddAddressText.addressTitle,
                  isList: true, showBackButton: true, callback: () {
                Get.back();
              }),
              Expanded(
                child: Stack(
                  children: [
                    RefreshIndicator(
                        color: primaryColor,
                        onRefresh: () {
                          return Future.delayed(
                            const Duration(seconds: 1),
                            () {
                              controller.getAddressList(context, 0, true);
                            },
                          );
                        },
                        child: CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: Obx(() {
                                return Stack(children: [
                                  Obx(() {
                                    switch (controller.state.value) {
                                      case ScreenState.apiLoading:
                                      case ScreenState.noNetwork:
                                      case ScreenState.noDataFound:
                                      case ScreenState.apiError:
                                        return SizedBox(
                                          height: SizerUtil.height / 1.5,
                                          child: apiOtherStates(
                                              controller.state.value),
                                        );
                                      case ScreenState.apiSuccess:
                                        return apiSuccess(
                                            controller.state.value);
                                      default:
                                        Container();
                                    }
                                    return Container();
                                  }),
                                  if (controller.isLoading.value == true)
                                    SizedBox(
                                        height: SizerUtil.height,
                                        width: SizerUtil.width,
                                        child: Center(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: white,
                                              ),
                                              height: 50,
                                              width: 50,
                                              padding: const EdgeInsets.all(10),
                                              child: LoadingAnimationWidget
                                                  .discreteCircle(
                                                color: primaryColor,
                                                size: 35,
                                              ),
                                            ),
                                          ),
                                        )),
                                ]);
                              }),
                            )
                          ],
                        )),
                  ],
                ),
              )
              // Expanded(child: Obx(
              //   () {
              //     return Container(
              //       margin: EdgeInsets.only(bottom: 10.h),
              //       child: ListView.builder(
              //           shrinkWrap: true,
              //           physics: const BouncingScrollPhysics(),
              //           padding: EdgeInsets.only(
              //               top: 1.h, left: 3.w, right: 3.w, bottom: 1.5.h),
              //           clipBehavior: Clip.antiAlias,
              //           itemBuilder: (context, index) {
              //             AddressItem data = controller.addressData[index];
              //             var isSelected = index == controller.currentIndex;
              //             return FadeInUp(
              //               child: Container(
              //                 margin: EdgeInsets.only(
              //                     top: 1.h, left: 4.w, right: 4.w, bottom: 1.h),
              //                 padding: EdgeInsets.only(
              //                     top: 1.5.h,
              //                     left: 4.w,
              //                     right: 4.w,
              //                     bottom: 1.5.h),
              //                 decoration: BoxDecoration(
              //                   color: isDarkMode()
              //                       ? itemDarkBackgroundColor
              //                       : white,
              //                   border: Border.all(
              //                     color: isSelected
              //                         ? primaryColor
              //                         : transparent, // Set the border color here
              //                     width: 2.0, // Set the border width
              //                   ),
              //                   borderRadius:
              //                       const BorderRadius.all(Radius.circular(10)),
              //                   boxShadow: [
              //                     BoxShadow(
              //                         color: isDarkMode()
              //                             ? grey.withOpacity(0.2)
              //                             : grey.withOpacity(0.3),
              //                         spreadRadius: 2,
              //                         blurRadius: 6,
              //                         offset: const Offset(0.3, 0.3)),
              //                   ],
              //                 ),
              //                 child: InkWell(
              //                   onTap: () {
              //                     setState(() {
              //                       controller.currentIndex =
              //                           index; // Select the item
              //                     });
              //                   },
              //                   child: Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     mainAxisAlignment:
              //                         MainAxisAlignment.spaceAround,
              //                     children: [
              //                       Row(
              //                         children: [
              //                           SizedBox(
              //                             width: 60.w,
              //                             child: Column(
              //                               crossAxisAlignment:
              //                                   CrossAxisAlignment.start,
              //                               mainAxisAlignment:
              //                                   MainAxisAlignment.start,
              //                               children: [
              //                                 Text(
              //                                   data.title.toString(),
              //                                   style: TextStyle(
              //                                       fontSize: SizerUtil
              //                                                   .deviceType ==
              //                                               DeviceType.mobile
              //                                           ? 12.sp
              //                                           : 13.sp,
              //                                       fontFamily: fontBold,
              //                                       fontWeight: FontWeight.bold,
              //                                       color: isDarkMode()
              //                                           ? white
              //                                           : black),
              //                                 ),
              //                                 getDynamicSizedBox(height: 0.5.h),
              //                                 Text(
              //                                   data.address.toString(),
              //                                   style: TextStyle(
              //                                       fontSize: SizerUtil
              //                                                   .deviceType ==
              //                                               DeviceType.mobile
              //                                           ? 11.sp
              //                                           : 13.sp,
              //                                       fontFamily: fontBold,
              //                                       color: lableColor),
              //                                 ),
              //                               ],
              //                             ),
              //                           ),
              //                           const Spacer(),
              //                           SizedBox(
              //                             width: 8.w,
              //                             child: Column(
              //                               crossAxisAlignment:
              //                                   CrossAxisAlignment.center,
              //                               children: [
              //                                 Icon(
              //                                   Icons.mode_edit_rounded,
              //                                   size: 2.6.h,
              //                                 ),
              //                                 Radio(
              //                                   value: index,
              //                                   activeColor: primaryColor,
              //                                   groupValue:
              //                                       controller.currentIndex,
              //                                   onChanged: (value) {
              //                                     setState(() {
              //                                       controller.currentIndex =
              //                                           value as int;
              //                                     });
              //                                   },
              //                                 )
              //                               ],
              //                             ),
              //                           ),
              //                         ],
              //                       ),
              //                       getDynamicSizedBox(height: 0.5.h),
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //             );
              //           },
              //           itemCount: controller.addressData.length),
              //     );
              //   },
              // ))
            ],
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 3.h,
              child: setActionButton(context, AddAddressText.add,
                  onActionClick: () {
                Get.to(AddAddressScreen(
                  isFromEdit: false,
                  itemData: null,
                ))!
                    .then((value) {
                  logcat("AddAddressScreen:::", value.toString());
                  if (value == true) {
                    apiCalls();
                  }
                  Statusbar().trasparentStatusbarIsNormalScreen();
                });
              }, onClick: () {
                controller.showCustomDialog(context);
              }))
        ]),
      ),
    );
  }

  Widget apiSuccess(ScreenState state) {
    // ignore: unrelated_type_equality_checks
    if (controller.state == ScreenState.apiSuccess &&
        controller.addressList.isNotEmpty) {
      return ListView.builder(
        padding: EdgeInsets.only(bottom: 2.h),
        physics: const BouncingScrollPhysics(),
        itemCount: controller.addressList.length,
        clipBehavior: Clip.antiAlias,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var model = controller.addressList[index] as AddressListItem;
          return controller.getListItem(context, model, index);
        },
      );
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
    if (controller.addressList.isEmpty) {
      Container();
    }
    if (state == ScreenState.noDataFound) {
      button = getMiniButton(() {
        Get.back();
      }, BottomConstant.back);
    }
    if (state == ScreenState.noNetwork) {
      button = getMiniButton(() {
        controller.getAddressList(context, 0, true);
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
