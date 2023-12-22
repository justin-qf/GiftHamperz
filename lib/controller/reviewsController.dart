import 'dart:async';
import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/api_handle/Repository.dart';
import 'package:gifthamperz/componant/dialogs/dialogs.dart';
import 'package:gifthamperz/componant/dialogs/loading_indicator.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/apicall_constant.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/models/homeModel.dart';
import 'package:gifthamperz/models/validation_model.dart';
import 'package:gifthamperz/preference/UserPreference.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/FilterScreen/FIlterScreen.dart';
import 'package:sizer/sizer.dart';
import '../utils/enum.dart';
import 'internet_controller.dart';
import 'package:gifthamperz/models/loginModel.dart';

class ReviewsScreenController extends GetxController {
  List pageNavigation = [];
  RxInt currentTreeView = 2.obs;
  RxBool isLiked = true.obs;
  RxBool isTreeModeVertical = true.obs;
  RxBool accessToDrawer = false.obs;
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  final InternetController networkManager = Get.find<InternetController>();
  RxList treeList = [].obs;
  var pageController = PageController();
  var currentPage = 0;
  late Timer timer;
  bool isReviewvisible = false;
  late TextEditingController commentctr;
  double userRating = 3.5;
  RxList<ReviewsList> reviewList = <ReviewsList>[
    ReviewsList(
        title: "Ashwini Prajapati",
        desc: 'OMG those lights!',
        likeCount: "2",
        hours: '2 hours ago',
        placeHolder: Asset.avaterOneholder,
        isSelected: false),
    ReviewsList(
        title: "Sachin Lakhara",
        desc: 'Love it! i want to join now!',
        likeCount: "10",
        hours: '5 hours ago',
        placeHolder: Asset.avaterTwoholder,
        isSelected: true),
    ReviewsList(
        title: "Dhabudi Patel",
        desc: 'Awesome!!!',
        likeCount: "20",
        hours: '3 hours ago',
        placeHolder: Asset.avaterThreeholder,
        isSelected: true),
    ReviewsList(
        title: "Yuvraj babariya",
        desc: 'Gajab,Ek Number,Kach jevu!!!',
        likeCount: "30",
        hours: '1 hours ago',
        placeHolder: Asset.avaterFourholder,
        isSelected: false),
    ReviewsList(
        title: "Bhoomi Makwana",
        desc: 'Delighfull..!!',
        likeCount: "30",
        hours: '1 hours ago',
        placeHolder: Asset.avaterFiveholder,
        isSelected: false),
  ].obs;
  late FocusNode commentNode;
  var commentModel = ValidationModel(null, null, isValidate: false).obs;
  RxBool isFormInvalidate = false.obs;

  @override
  void onInit() {
    commentctr = TextEditingController();
    commentNode = FocusNode();
    super.onInit();
  }

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void addReviewAPI(context) async {
    var loadingIndicator = LoadingProgressDialog();
    loadingIndicator.show(context, '');
    try {
      if (networkManager.connectionType == 0) {
        loadingIndicator.hide(context);
        showDialogForScreen(
            context, ReviewsScreenConstant.title, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }

      UserData? getUserData = await UserPreferences().getSignInInfo();
      logcat('ReviewPassingData', {
        "user_id": getUserData!.id.toString().trim(),
        "product_id": "2",
        "review": userRating.toString(),
        "comment": commentctr.text.toString().trim(),
      });

      var response = await Repository.post({
        "user_id": getUserData.id.toString().trim(),
        "product_id": "2",
        "review": userRating.toString(),
        "comment": commentctr.text.toString().trim(),
      }, ApiUrl.review, allowHeader: true);
      loadingIndicator.hide(context);
      var data = jsonDecode(response.body);
      logcat("tag", data);
      if (response.statusCode == 200) {
        if (data['status'] == 1) {
          showDialogForScreen(
              context, ReviewsScreenConstant.title, data['message'],
              callback: () {
            commentctr.text = "";
            isFormInvalidate.value = false;
            update();
          });
        } else {
          showDialogForScreen(
              context, ReviewsScreenConstant.title, data['message'],
              callback: () {
            commentctr.text = "";
            isFormInvalidate.value = false;
            update();
          });
        }
      } else {
        showDialogForScreen(
            context, ReviewsScreenConstant.title, data['message'] ?? "",
            callback: () {});
      }
    } catch (e) {
      logcat("Exception", e);
      showDialogForScreen(
          context, ReviewsScreenConstant.title, ServerError.servererror,
          callback: () {});
    }
  }

  void validateComment(String? val) {
    commentModel.update((model) {
      if (val == null || val.toString().trim().isEmpty) {
        model!.error = "Enter Password";
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });
    enableSignUpButton();
  }

  void enableSignUpButton() {
    if (commentModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else {
      isFormInvalidate.value = true;
    }
  }

  getFilterUi() {
    return GestureDetector(
      onTap: () {
        Get.to(const FilterScreen());
      },
      child: Container(
          width: 30.w,
          height: 5.5.h,
          decoration: BoxDecoration(
            color: white,
            boxShadow: [
              BoxShadow(
                  color: grey.withOpacity(0.8),
                  blurRadius: 2.0,
                  offset: const Offset(0, 1),
                  spreadRadius: 3.0)
            ],
            borderRadius: BorderRadius.circular(
                SizerUtil.deviceType == DeviceType.mobile ? 10.w : 2.2.w),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Filter",
                style: TextStyle(
                  color: black,
                  fontWeight: FontWeight.w400,
                  fontSize:
                      SizerUtil.deviceType == DeviceType.mobile ? 14.sp : 13.sp,
                ),
              ),
              getDynamicSizedBox(width: 0.5.w),
              Icon(
                Icons.tune_rounded,
                size: 3.h,
                color: black,
              )
            ],
          )),
    );
  }

  getItemListItem(SavedItem data) {
    return Obx(
      () {
        return Wrap(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                  SizerUtil.deviceType == DeviceType.mobile ? 4.w : 2.2.w),
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 0.5.h, left: 1.w, right: 2.w),
                padding: EdgeInsets.only(left: 1.2.w, right: 1.2.w, top: 1.2.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                      SizerUtil.deviceType == DeviceType.mobile ? 4.w : 2.2.w),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10.0,
                        offset: const Offset(0, 5))
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            SizerUtil.deviceType == DeviceType.mobile
                                ? 3.5.w
                                : 2.5.w),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            SizerUtil.deviceType == DeviceType.mobile
                                ? 3.5.w
                                : 2.5.w),
                        child: data.icon,
                      ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    getText(
                      data.name,
                      TextStyle(
                          fontFamily: fontMedium,
                          color: black,
                          fontSize: SizerUtil.deviceType == DeviceType.mobile
                              ? 10.sp
                              : 7.sp,
                          height: 1.2),
                    ),
                    getDynamicSizedBox(
                      height: 0.5.h,
                    ),
                    getText(
                      data.price,
                      TextStyle(
                          fontFamily: fontMedium,
                          color: primaryColor,
                          fontSize: SizerUtil.deviceType == DeviceType.mobile
                              ? 9.sp
                              : 7.sp,
                          height: 1.2),
                    ),
                    getDynamicSizedBox(
                      height: 0.5.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: RatingBar.builder(
                            initialRating: 3.5,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 3.5.w,
                            // itemPadding:
                            //     const EdgeInsets.symmetric(horizontal: 5.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.orange,
                            ),
                            onRatingUpdate: (rating) {
                              logcat("RATING", rating);
                            },
                          ),
                        ),
                        Expanded(
                          child: getText(
                            "35 Reviews",
                            TextStyle(
                                fontFamily: fontMedium,
                                color: lableColor,
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.mobile
                                        ? 8.sp
                                        : 7.sp,
                                height: 1.2),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            data.isSelected.value = !data.isSelected.value;
                            update();
                          },
                          child: Icon(
                            data.isSelected.value
                                ? Icons.favorite_rounded
                                : Icons.favorite_border,
                            size: 3.h,
                            color: primaryColor,
                          ),
                        )
                      ],
                    ),
                    getDynamicSizedBox(
                      height: 1.h,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget getText(title, TextStyle? style) {
    return Padding(
      padding: EdgeInsets.only(left: 0.5.w, right: 0.5.w),
      child: Text(
        title,
        style: style,
      ),
    );
  }

  getListItem(ReviewsList data) {
    return Obx(
      () {
        return FadeInUp(
          child: Wrap(
            children: [
              Stack(
                children: [
                  Container(
                      width: SizerUtil.width,
                      margin: EdgeInsets.only(
                          top: 3.h, left: 3.w, right: 3.w, bottom: 2.0.h),
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        //color: grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(1.7.h),
                        border: isDarkMode()
                            ? Border.all(
                                color: grey, // Border color
                                width: 0.5, // Border width
                              )
                            : Border.all(
                                color: grey, // Border color
                                width: 0.5, // Border width
                              ),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              SizerUtil.deviceType == DeviceType.mobile
                                  ? 4.w
                                  : 2.2.w),
                          child: Padding(
                            padding: EdgeInsets.only(left: 1.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // FadeInDown(
                                    //   child: ClipRRect(
                                    //     borderRadius: const BorderRadius.all(
                                    //         Radius.circular(50)),
                                    //     child: Image.asset(
                                    //       data.placeHolder,
                                    //       height: 7.h,
                                    //       width: 7.h,
                                    //       fit: BoxFit.cover,
                                    //     ),
                                    //   ),
                                    // ),
                                    getDynamicSizedBox(width: 20.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(data.title,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontFamily: fontMedium,
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 15.sp,
                                                  )),
                                              const Spacer(),
                                              Text(data.likeCount,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontFamily: fontBold,
                                                    fontSize: 12.sp,
                                                  )),
                                              getDynamicSizedBox(width: 0.6.w),
                                              GestureDetector(
                                                onTap: () {
                                                  data.isSelected.value =
                                                      !data.isSelected.value;
                                                  update();
                                                },
                                                child: Icon(
                                                  data.isSelected.value
                                                      ? Icons.favorite_rounded
                                                      : Icons.favorite_border,
                                                  size: 3.h,
                                                  color: primaryColor,
                                                ),
                                              ),
                                              getDynamicSizedBox(width: 0.6.w),
                                            ],
                                          ),
                                          getDynamicSizedBox(height: 0.6.h),
                                          //getDynamicSizedBox(height: 1.0.h),
                                          // getDivider()
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                RatingBar.builder(
                                  initialRating: 3.5,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 3.5.w,
                                  // itemPadding:
                                  //     const EdgeInsets.symmetric(horizontal: 5.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                  ),
                                  onRatingUpdate: (rating) {
                                    logcat("RATING", rating);
                                  },
                                ),
                                getDynamicSizedBox(height: 0.6.h),
                                SizedBox(
                                  width: 53.w,
                                  child: Text(data.desc,
                                      maxLines: 3,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: lableColor,
                                        fontFamily: fontBold,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.sp,
                                      )),
                                ),
                                getDynamicSizedBox(height: 0.6.h),
                                Row(
                                  children: [
                                    Text(data.hours,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: lableColor,
                                          fontFamily: fontBold,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11.sp,
                                        )),
                                    getDynamicSizedBox(width: 3.w),
                                    Text('1 Reply',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: lableColor,
                                          fontFamily: fontBold,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp,
                                        )),
                                    getDynamicSizedBox(width: 3.w),
                                    Text('Reply',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: lableColor,
                                          fontFamily: fontBold,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11.sp,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ))),
                  Positioned(
                    left: 9.w,
                    child: FadeInDown(
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          height: 7.h,
                          imageUrl: APIImageUrl.url,
                          placeholder: (context, url) => const Center(
                            child:
                                CircularProgressIndicator(color: primaryColor),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            data.placeHolder,
                            height: 7.h,
                            width: 7.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
