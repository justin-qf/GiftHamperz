import 'dart:async';
import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/api_handle/Repository.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/dialogs/ImageScreen.dart';
import 'package:gifthamperz/componant/dialogs/dialogs.dart';
import 'package:gifthamperz/componant/dialogs/loading_indicator.dart';
import 'package:gifthamperz/componant/input/form_inputs.dart';
import 'package:gifthamperz/componant/input/style.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/apicall_constant.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/models/ReviewModel.dart';
import 'package:gifthamperz/models/homeModel.dart';
import 'package:gifthamperz/models/validation_model.dart';
import 'package:gifthamperz/preference/UserPreference.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/FilterScreen/FIlterScreen.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../utils/enum.dart';
import 'internet_controller.dart';
import 'package:gifthamperz/models/loginModel.dart';

class ReviewsScreenController extends GetxController {
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  final InternetController networkManager = Get.find<InternetController>();
  var currentPage = 0;
  bool isReviewvisible = false;
  late TextEditingController commentctr;
  double userRating = 3.5;
  late FocusNode commentNode;
  var commentModel = ValidationModel(null, null, isValidate: false).obs;
  RxBool isFormInvalidate = false.obs;

  @override
  void onInit() {
    commentctr = TextEditingController();
    commentNode = FocusNode();
    super.onInit();
  }

  reviewApiCall(BuildContext context) {
    getReviewList(context, 0, true);
    update();
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

  getListItem(BuildContext context, ReviewData data, int index) {
    DateTime dateTime = DateTime.parse(data.createdAt);
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
    // ignore: prefer_typing_uninitialized_variables
    var name;
    if (data.firstName != null) {
      name = data.firstName;
    } else {
      name = "User Name";
    }
    return FadeInUp(
      child: Wrap(
        children: [
          Container(
            width: SizerUtil.width,
            margin: EdgeInsets.only(bottom: 1.5.h, right: 3.w, left: 3.w),
            padding:
                EdgeInsets.only(left: 1.w, right: 1.w, top: 0.5.h, bottom: 1.h),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FadeInDown(
                      child: Container(
                        margin: EdgeInsets.only(top: 0.2.h, left: 1.5.w),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            height: 7.h,
                            imageUrl:
                                APIImageUrl.url + data.profilePic.toString(),
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(
                                  color: primaryColor),
                            ),
                            errorWidget: (context, url, error) =>
                                SvgPicture.asset(
                              Asset.profile,
                              fit: BoxFit.cover,
                              // ignore: deprecated_member_use
                              color: isDarkMode() ? white : black,
                              height: 7.h,
                              width: 7.h,
                            ),
                          ),
                        ),
                      ),
                    ),
                    getDynamicSizedBox(width: 2.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 62.w,
                            child: Text(name,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: fontMedium,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16.sp,
                                )),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RatingBar.builder(
                                initialRating: double.parse(data.review),
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 4.w,
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                ),
                                onRatingUpdate: (rating) {
                                  logcat("RATING", rating);
                                },
                              ),
                              getDynamicSizedBox(width: 0.6.w),
                              Text(data.review,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: fontBold,
                                    fontSize: 12.sp,
                                  )),
                              const Spacer(),
                              Text(formattedDate,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: fontBold,
                                    fontSize: 12.sp,
                                  )),
                              getDynamicSizedBox(width: 1.w)
                            ],
                          ),
                          //getDynamicSizedBox(height: 1.0.h),
                        ],
                      ),
                    ),
                  ],
                ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(
                        SizerUtil.deviceType == DeviceType.mobile
                            ? 4.w
                            : 2.2.w),
                    child: Padding(
                      padding: EdgeInsets.only(left: 2.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          getDynamicSizedBox(height: 0.5.h),
                          getDivider(),
                          getDynamicSizedBox(height: 0.8.h),
                          Text(data.comment.toString(),
                              maxLines: 5,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: isDarkMode() ? white : black,
                                fontFamily: fontBold,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                              )),
                          getDynamicSizedBox(height: 1.h),
                          SizedBox(
                            width: SizerUtil.width,
                            height: 9.h,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: data.images.length,
                              clipBehavior: Clip.antiAlias,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: false,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    // Handle image tap
                                    Get.to(FullScreenImage(
                                      imageUrl:
                                          APIImageUrl.url + data.images[index],
                                      title: 'Review Image',
                                    ))!
                                        .then((value) => {
                                              Statusbar()
                                                  .trasparentStatusbarIsNormalScreen()
                                            });
                                  },
                                  child: Container(
                                    height: 6.h,
                                    width: 9.h,
                                    margin: EdgeInsets.only(right: 2.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
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
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        height: 9.h,
                                        imageUrl: APIImageUrl.url +
                                            data.images[index],
                                        placeholder: (context, url) => SizedBox(
                                          height: 9.h,
                                          child: const Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: CircularProgressIndicator(
                                                  color: primaryColor),
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          Asset.productPlaceholder,
                                          height: 9.h,
                                          width: 9.h,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          // getDynamicSizedBox(height: 0.6.h),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getListItems(BuildContext context, ReviewData data, int index) {
    var name;
    if (data.firstName != null) {
      name = data.firstName;
    } else {
      name = "Justin Mahida";
    }

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
                                getDynamicSizedBox(width: 20.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(name,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontFamily: fontMedium,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 15.sp,
                                              )),
                                          const Spacer(),
                                          Text(data.review,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontFamily: fontBold,
                                                fontSize: 12.sp,
                                              )),
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
                              child: Text(data.comment.toString(),
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
                          ],
                        ),
                      ))),
              Positioned(
                left: 9.w,
                child: FadeInDown(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      height: 7.h,
                      imageUrl: APIImageUrl.url,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        Asset.productPlaceholder,
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
  }

  RxList reviewList = [].obs;
  RxString nextPageURL = "".obs;
  RxBool isLoading = false.obs;
  RxString fomatedDate = "".obs;

  void getReviewList(context, currentPage, bool hideloading,
      {bool? isRefress}) async {
    var loadingIndicator = LoadingProgressDialog();
    if (hideloading == true) {
      state.value = ScreenState.apiLoading;
    } else {
      loadingIndicator.show(context, '');
      isLoading.value = true;
      update();
    }

    try {
      if (networkManager.connectionType == 0) {
        showDialogForScreen(
            context, ReviewsScreenConstant.title, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      //var pageURL = ApiUrl.getAddress + currentPage.toString();
      var pageURL = ApiUrl.listReview;
      logcat("URL", pageURL.toString());
      var response = await Repository.get({}, pageURL, allowHeader: false);
      if (hideloading != true) {
        loadingIndicator.hide(
          context,
        );
      }
      Statusbar().trasparentStatusbarIsNormalScreen();
      // loadingIndicator.hide(context);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data['status'] == 1) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          isLoading.value = false;
          update();
          var responseData = ReviewModel.fromJson(data);

          if (isRefress == true) {
            reviewList.clear();
          }
          if (responseData.data.data.isNotEmpty) {
            reviewList.addAll(responseData.data.data);
            reviewList.refresh();
          }
          if (responseData.data.nextPageUrl != 'null' &&
              responseData.data.nextPageUrl != null) {
            nextPageURL.value = responseData.data.nextPageUrl.toString();
            update();
          } else {
            nextPageURL.value = "";
            update();
          }
          update();
        } else {
          isLoading.value = false;
          message.value = data['message'];
          state.value = ScreenState.apiError;
          showDialogForScreen(
              context, ReviewsScreenConstant.title, data['message'].toString(),
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        isLoading.value = false;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(
            context, ReviewsScreenConstant.title, data['message'].toString(),
            callback: () {});
      }
    } catch (e) {
      if (hideloading != true) {
        loadingIndicator.hide(
          context,
        );
      }
      isLoading.value = false;
      state.value = ScreenState.apiError;
      message.value = ServerError.servererror;
    }
  }
}
