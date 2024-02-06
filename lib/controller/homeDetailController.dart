import 'dart:async';
import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/api_handle/Repository.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/dialogs/dialogs.dart';
import 'package:gifthamperz/componant/dialogs/loading_indicator.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/apicall_constant.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/models/UpdateDashboardModel.dart';
import 'package:gifthamperz/models/homeDetailModel.dart';
import 'package:gifthamperz/models/loginModel.dart';
import 'package:gifthamperz/preference/UserPreference.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/ProductDetailScreen/ProductDetailScreen.dart';
import 'package:sizer/sizer.dart';
import '../utils/enum.dart';
import 'internet_controller.dart';

class HomeDetailScreenController extends GetxController {
  List pageNavigation = [];
  RxInt currentTreeView = 2.obs;
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  InternetController networkManager = Get.find<InternetController>();
  var currentPage = 0;
  RxBool isShowMoreLoading = false.obs;

  @override
  void onInit() {
    logcat("onInit", 'onInit');
    super.onInit();
  }

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void addFavouriteAPI(context, String productId, String type) async {
    var loadingIndicator = LoadingProgressDialog();
    loadingIndicator.show(context, '');
    try {
      if (networkManager.connectionType == 0) {
        loadingIndicator.hide(context);
        showDialogForScreen(
            context, BottomConstant.home, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      UserData? getUserData = await UserPreferences().getSignInInfo();
      logcat('loginPassingData', {
        "user_id": getUserData!.id.toString().trim(),
        "product_id": productId.toString().trim(),
        "type": type.toString().trim(),
      });

      var response = await Repository.post({
        "user_id": getUserData.id.toString().trim(),
        "product_id": productId.toString().trim(),
        "type": type.toString().trim(),
      }, ApiUrl.addFavourite, allowHeader: true);
      loadingIndicator.hide(context);
      loadingIndicator.hide(context);
      update();
      var data = jsonDecode(response.body);
      logcat("tag", data);
      if (response.statusCode == 200) {
        if (data['status'] == 1) {
          showCustomToast(context, data['message'].toString());
        } else {
          showCustomToast(context, data['message'].toString());
        }
      } else {
        showDialogForScreen(context, BottomConstant.home, data['message'] ?? "",
            callback: () {});
        loadingIndicator.hide(context);
      }
    } catch (e) {
      logcat("Exception", e);
      showDialogForScreen(context, BottomConstant.home, ServerError.servererror,
          callback: () {});
    } finally {
      loadingIndicator.hide(context);
    }
  }

  RxList popularList = [].obs;
  RxList trendingList = [].obs;
  RxString nextPageURL = "".obs;
  RxBool isLoading = false.obs;
  void getProductDetailList(
      context, currentPage, bool hideloading, bool? isFromTrending) async {
    var loadingIndicator = LoadingProgressDialog();

    //state.value = ScreenState.apiLoading;
    if (hideloading == true) {
      state.value = ScreenState.apiLoading;
      update();
    } else {
      // isLoading.value = true;
      loadingIndicator.show(context, '');
      isLoading.value = true;
      update();
    }

    try {
      if (networkManager.connectionType == 0) {
        showDialogForScreen(
            context, ProductScreenConstant.title, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }

      var pageURL = '${ApiUrl.getHomeDetail}?page=$currentPage';
      var response = await Repository.get({}, pageURL, allowHeader: false);
      if (hideloading != true) {
        loadingIndicator.hide(
          context,
        );
      }
      // loadingIndicator.hide(context);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data['status'] == 1) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          isLoading.value = false;
          update();
          var responseData = HomeDetailModel.fromJson(data);
          // popularList.clear();
          // trendingList.clear();
          if (isFromTrending == true) {
            logcat("isFromTrending", isFromTrending.toString());
            if (responseData.data.trendList.data.isNotEmpty) {
              trendingList.addAll(responseData.data.trendList.data);

              if (responseData.data.trendList.nextPageUrl != 'null' &&
                  responseData.data.trendList.nextPageUrl != null) {
                nextPageURL.value =
                    responseData.data.trendList.nextPageUrl.toString();
                update();
              } else {
                nextPageURL.value = "";
                update();
              }
            }
          } else {
            if (responseData.data.popularList.data.isNotEmpty) {
              popularList.addAll(responseData.data.popularList.data);

              if (responseData.data.popularList.nextPageUrl != 'null' &&
                  responseData.data.popularList.nextPageUrl != null) {
                nextPageURL.value =
                    responseData.data.popularList.nextPageUrl.toString();
                update();
              } else {
                nextPageURL.value = "";
                update();
              }
            }
          }
          update();
        } else {
          isLoading.value = false;
          message.value = data['message'];
          state.value = ScreenState.apiError;
          showDialogForScreen(
              context, ProductScreenConstant.title, data['message'].toString(),
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        isLoading.value = false;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(
            context, ProductScreenConstant.title, data['message'].toString(),
            callback: () {});
      }
    } catch (e) {
      isLoading.value = false;
      if (hideloading != true) {
        loadingIndicator.hide(
          context,
        );
      }
      state.value = ScreenState.apiError;
      message.value = ServerError.servererror;
    }
  }

  getListItemDetail(
      BuildContext context, CommonProductList data, bool? isFromTrending) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Wrap(
          children: [
            FadeInUp(
              child: GestureDetector(
                onTap: () {
                  logcat('Treanding', 'DONE');
                  Get.to(ProductDetailScreen(
                    'Trending',
                    data: data,
                  ));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      SizerUtil.deviceType == DeviceType.mobile ? 4.w : 2.2.w),
                  child: Container(
                      width: 45.w,
                      margin:
                          EdgeInsets.only(bottom: 0.5.h, left: 1.w, right: 2.w),
                      padding: EdgeInsets.only(bottom: 1.h),
                      decoration: BoxDecoration(
                        border: isDarkMode()
                            ? null
                            : Border.all(
                                color: grey, // Border color
                                width: 0.5, // Border width
                              ),
                        //color: isDarkMode() ? itemDarkBackgroundColor : white,
                        color: isDarkMode() ? tileColour : white,
                        borderRadius: BorderRadius.circular(
                            SizerUtil.deviceType == DeviceType.mobile
                                ? 4.w
                                : 2.2.w),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: SizerUtil.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      SizerUtil.deviceType == DeviceType.mobile
                                          ? 3.5.w
                                          : 2.5.w),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: isDarkMode()
                                  //         ? grey.withOpacity(0.2)
                                  //         : grey.withOpacity(0.5),
                                  //     spreadRadius: 2,
                                  //     blurRadius:
                                  //         5.0, // Adjust the blur radius as needed
                                  //     offset: const Offset(0, 2),
                                  //   )
                                  // ],
                                  border: isDarkMode()
                                      ? Border.all(
                                          color: grey, // Border color
                                          width: 1, // Border width
                                        )
                                      : Border.all(
                                          color: grey, // Border color
                                          width: 0.2, // Border width
                                        ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      SizerUtil.deviceType == DeviceType.mobile
                                          ? 3.5.w
                                          : 2.5.w),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    height: 12.h,
                                    imageUrl: APIImageUrl.url + data.images[0],
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(
                                          color: primaryColor),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      Asset.productPlaceholder,
                                      height: 9.h,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              // Positioned(
                              //   right: 3.w,
                              //   top: 1.0.h,
                              //   child: GestureDetector(
                              //     onTap: () {
                              //       // data.isSelected.value =
                              //       //     !data.isSelected.value;
                              //       addFavouriteAPI(
                              //           context, item.id.toString(), "1");
                              //       //update();
                              //     },
                              //     child: Icon(
                              //       Icons.favorite_border,
                              //       size: 3.h,
                              //       color: primaryColor,
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                          SizedBox(
                            height: 0.6.h,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 1.w, right: 1.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                getText(
                                  data.name,
                                  TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: fontSemiBold,
                                      fontWeight: FontWeight.w500,
                                      color: isDarkMode() ? black : black,
                                      fontSize: SizerUtil.deviceType ==
                                              DeviceType.mobile
                                          ? 10.sp
                                          : 8.sp,
                                      height: 1.2),
                                ),
                                getDynamicSizedBox(
                                  height: 0.5.h,
                                ),
                                getText(
                                  '${IndiaRupeeConstant.inrCode}${data.price}',
                                  TextStyle(
                                      fontFamily: fontBold,
                                      color: primaryColor,
                                      fontSize: SizerUtil.deviceType ==
                                              DeviceType.mobile
                                          ? 12.sp
                                          : 7.sp,
                                      height: 1.2),
                                ),
                                getDynamicSizedBox(
                                  height: 0.5.h,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    RatingBar.builder(
                                      initialRating: 3.5,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 1,
                                      itemSize: 3.5.w,
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.orange,
                                      ),
                                      onRatingUpdate: (rating) {
                                        logcat("RATING", rating);
                                      },
                                    ),
                                    getText(
                                      "3.5",
                                      TextStyle(
                                          fontFamily: fontSemiBold,
                                          color: lableColor,
                                          fontWeight: isDarkMode()
                                              ? FontWeight.w600
                                              : null,
                                          fontSize: SizerUtil.deviceType ==
                                                  DeviceType.mobile
                                              ? 9.sp
                                              : 7.sp,
                                          height: 1.2),
                                    ),
                                    //const Spacer(),
                                    // Obx(
                                    //   () {
                                    //     return data.isInCart!.value == false
                                    //         ? getAddToCartBtn('Add to Cart',
                                    //             Icons.shopping_cart,
                                    //             addCartClick: () async {
                                    //             data.isInCart!.value = true;
                                    //             // data.quantity!.value = 1;
                                    //             incrementDecrementCartItem(
                                    //                 isFromIcr: true,
                                    //                 data: data,
                                    //                 quantity:
                                    //                     data.quantity!.value);
                                    //             update();
                                    //           },
                                    //             isAddToCartClicked:
                                    //                 data.isInCart!)
                                    //         : cartIncDecUi(
                                    //             qty: data.quantity.toString(),
                                    //             increment: () async {
                                    //               incrementDecrementCartItemInList(
                                    //                   isFromIcr: true,
                                    //                   data: data,
                                    //                   quantity:
                                    //                       data.quantity!.value);
                                    //               update();
                                    //             },
                                    //             decrement: () async {
                                    //               incrementDecrementCartItemInList(
                                    //                   isFromIcr: false,
                                    //                   data: data,
                                    //                   quantity:
                                    //                       data.quantity!.value);
                                    //               update();
                                    //             });
                                    //   },
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          ],
        ),
        nextPageURL.value != "null" && nextPageURL.value.isNotEmpty
            ? Container(
                margin: EdgeInsets.only(
                    top: 1.2.h, left: SizerUtil.width / 3, bottom: 0.8.h),
                child: getMiniButton(() {
                  isShowMoreLoading.value = true;
                  currentPage++;
                  if (isFromTrending == true) {
                    getProductDetailList(context, currentPage, true, true);
                  } else {
                    getProductDetailList(context, currentPage, true, false);
                  }
                  update();
                }, Common.viewMore),
              )
            : Container()
      ],
    );
  }

  Widget getText(title, TextStyle? style) {
    return Padding(
      padding: EdgeInsets.only(left: 0.5.w, right: 0.5.w),
      child: Text(
        title,
        style: style,
        maxLines: 2,
      ),
    );
  }
}
