import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/input/form_inputs.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/reviewsController.dart';
import 'package:gifthamperz/models/ReviewModel.dart';
import 'package:gifthamperz/utils/enum.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  var controller = Get.put(ReviewsScreenController());

  @override
  void initState() {
    controller.reviewApiCall(context);
    super.initState();
    setState(() {});
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
        child: Stack(
          children: [
            Column(
              children: [
                getCommonToolbar(ReviewsScreenConstant.title,
                    showBackButton: true, callback: () {
                  Get.back();
                }),
                getDynamicSizedBox(height: 1.h),
                Expanded(
                  child: Stack(
                    children: [
                      RefreshIndicator(
                          color: primaryColor,
                          onRefresh: () {
                            return Future.delayed(
                              const Duration(seconds: 1),
                              () {
                                controller.getReviewList(context, 0, true,
                                    isRefress: true);
                              },
                            );
                          },
                          child: CustomScrollView(
                            physics: const BouncingScrollPhysics(),
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
                                            height: SizerUtil.height / 1.2,
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
                                                padding:
                                                    const EdgeInsets.all(10),
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
                ),
                // Expanded(
                //   child: Container(
                //       margin: EdgeInsets.only(left: 2.w, right: 2.w),
                //       child: ListView.builder(
                //           shrinkWrap: true,
                //           physics: const BouncingScrollPhysics(),
                //           padding: EdgeInsets.only(bottom: 13.h),
                //           scrollDirection: Axis.vertical,
                //           clipBehavior: Clip.antiAlias,
                //           itemBuilder: (context, index) {
                //             ReviewsList data = controller.reviewList[index];
                //             return controller.getListItem(data);
                //           },
                //           itemCount: controller.reviewList.length)),
                // ),
              ],
            ),
            // Visibility(
            //   visible: controller.isReviewvisible == false ? true : false,
            //   child: Positioned(
            //     bottom: 2.h,
            //     left: 0,
            //     right: 0,
            //     child: Container(
            //       margin: EdgeInsets.only(
            //         left: 20.w,
            //         right: 20.w,
            //       ),
            //       child: FadeInUp(
            //           from: 50,
            //           child: getSecondaryFormButton(() {
            //             //controller.getFilterUi();
            //             controller.isReviewvisible = true;
            //             setState(() {});
            //           }, ReviewsScreenConstant.btnTitle, isvalidate: true)),
            //     ),
            //   ),
            // ),
            Visibility(
              visible: controller.isReviewvisible,
              child: Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: SizerUtil.width,
                    padding: EdgeInsets.only(
                        left: 5.w, right: 5.w, top: 0.2.h, bottom: 0.2.h),
                    decoration: BoxDecoration(
                      color: isDarkMode() ? darkBackgroundColor : white,
                      boxShadow: [
                        BoxShadow(
                          color: grey.withOpacity(0.5), // Shadow color
                          spreadRadius: 5, // Spread radius
                          blurRadius: 7, // Blur radius
                          offset: const Offset(0,
                              3), // Offset in the vertical direction (adjust as needed)
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              SizerUtil.deviceType == DeviceType.mobile
                                  ? 10.w
                                  : 2.w),
                          topRight: Radius.circular(
                              SizerUtil.deviceType == DeviceType.mobile
                                  ? 10.w
                                  : 2.w)),
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 1.5.h, bottom: 1.5.h),
                                  child: Center(
                                    child: RatingBar.builder(
                                      initialRating: controller.userRating,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 8.w,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.orange,
                                      ),
                                      onRatingUpdate: (rating) {
                                        logcat("RATING", rating);
                                        setState(() {
                                          controller.userRating = rating;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    controller.isReviewvisible = false;
                                    controller.isFormInvalidate.value = false;
                                    controller.commentctr.text = "";
                                    setState(() {});
                                  },
                                  child: Stack(
                                    children: [
                                      Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding: const EdgeInsets.all(6),
                                            child: Icon(
                                              Icons.cancel,
                                              color: primaryColor,
                                              size: 22.sp,
                                            ),
                                          )),
                                    ],
                                  ))
                            ],
                          ),
                          getDivider(),
                          getDynamicSizedBox(height: 0.5.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: FadeInDown(
                                  child: AnimatedSize(
                                    duration: const Duration(milliseconds: 300),
                                    child: Obx(() {
                                      return getReactiveFormField(
                                          node: controller.commentNode,
                                          controller: controller.commentctr,
                                          hintLabel: ReviewsScreenConstant.hint,
                                          obscuretext: false,
                                          isReview: true,
                                          onChanged: (val) {
                                            if (val!.isEmpty) {
                                              controller.isFormInvalidate
                                                  .value = false;
                                            } else {
                                              controller.isFormInvalidate
                                                  .value = true;
                                            }
                                            // controller.validateComment(val);
                                          },
                                          inputType: TextInputType.text,
                                          errorText: controller
                                              .commentModel.value.error);
                                    }),
                                  ),
                                ),
                              ),
                              Obx(
                                () {
                                  return FadeInDown(
                                    child: AnimatedSize(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (controller
                                                  .isFormInvalidate.value ==
                                              true) {
                                            controller.addReviewAPI(context);
                                            controller.isReviewvisible = false;
                                            setState(() {});
                                          }
                                        },
                                        child: Icon(
                                          Icons.send,
                                          size: 4.5.h,
                                          color: controller
                                                      .isFormInvalidate.value ==
                                                  true
                                              ? primaryColor
                                              : grey,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget apiSuccess(ScreenState state) {
    // ignore: unrelated_type_equality_checks
    if (controller.state == ScreenState.apiSuccess &&
        controller.reviewList.isNotEmpty) {
      return Container(
        margin: EdgeInsets.only(left: 2.w, right: 2.w, top: 1.h),
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 3.h),
          physics: const BouncingScrollPhysics(),
          itemCount: controller.reviewList.length,
          clipBehavior: Clip.antiAlias,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            ReviewData model = controller.reviewList[index];
            return Column(
              children: [
                controller.getListItem(context, model, index),
                index == controller.reviewList.length - 1 &&
                        controller.nextPageURL.value.isNotEmpty
                    ? Container(
                        margin: EdgeInsets.only(
                            top: 2.h, left: 25.w, right: 25.w, bottom: 0.8.h),
                        child: getMiniButton(
                          () {
                            controller.isLoading.value = true;
                            controller.currentPage++;
                            controller.getReviewList(
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
        ),
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
    if (controller.reviewList.isEmpty) {
      Container();
    }
    if (state == ScreenState.noDataFound) {
      button = getMiniButton(() {
        Get.back();
      }, BottomConstant.back);
    }
    if (state == ScreenState.noNetwork) {
      button = getMiniButton(() {
        controller.getReviewList(context, 0, true);
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
                    style: TextStyle(
                        fontFamily: fontMedium,
                        fontSize: 12.sp,
                        color: isDarkMode() ? white : black),
                  )
                : button),
      ],
    );
  }
}
