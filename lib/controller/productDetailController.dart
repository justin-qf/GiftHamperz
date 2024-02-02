import 'dart:async';
import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/api_handle/Repository.dart';
import 'package:gifthamperz/componant/dialogs/dialogs.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/configs/apicall_constant.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/models/homeModel.dart';
import 'package:gifthamperz/models/recentFavProduct.dart';
import 'package:gifthamperz/preference/UserPreference.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/FilterScreen/FIlterScreen.dart';
import 'package:sizer/sizer.dart';
import '../models/UpdateDashboardModel.dart';
import '../utils/enum.dart';
import 'internet_controller.dart';

class ProductDetailScreenController extends GetxController {
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  final InternetController networkManager = Get.find<InternetController>();
  var pageController = PageController();
  var currentPage = 0;
  var quantity = 0;
  late Timer timer;
  RxList<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[].obs;
  RxBool? isGuest = true.obs;

  // Future<void> saveCartItems() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String cartItemsJson = cartItems.map((item) => item.toString()).join(',');
  //   await prefs.setString('cartItems', cartItemsJson);
  // }

  getGuestUser() async {
    isGuest!.value = await UserPreferences().getGuestUser();
    update();
  }

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
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
                color: grey.withOpacity(0.5), // Shadow color
                spreadRadius: 5, // Spread radius
                blurRadius: 7, // Blur radius
                offset: const Offset(0,
                    3), // Offset in the vertical direction (adjust as needed)
              ),
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
                color: primaryColor,
              )
            ],
          )),
    );
  }

  RxList recentProductList = [].obs;

  void getRecentFav(context, int innerCatId) async {
    state.value = ScreenState.apiLoading;
    try {
      if (networkManager.connectionType == 0) {
        showDialogForScreen(
            context, BottomConstant.home, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      var response = await Repository.get({}, '${ApiUrl.recentFav}/$innerCatId',
          allowHeader: false);
      logcat("RECENT_FAV_RESPONSE::", response.body);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          var homeData = RecentFavModel.fromJson(responseData);
          recentProductList.clear();

          if (homeData.data.isNotEmpty) {
            recentProductList.addAll(homeData.data);
            update();
          }
        } else {
          message.value = responseData['message'];
          showDialogForScreen(
              context, BottomConstant.home, responseData['message'],
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(
            context, BottomConstant.home, ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      logcat("Ecxeption", e);
      state.value = ScreenState.apiError;
      message.value = ServerError.servererror;
      showDialogForScreen(context, BottomConstant.home, ServerError.servererror,
          callback: () {});
    }
  }

  getItemListItem(CommonProductList data) {
    return Wrap(
      children: [
        FadeInUp(
          child: Container(
              width: 50.w,
              margin: EdgeInsets.only(right: 4.5.w),
              // padding: EdgeInsets.only(
              //     left: 5.w, right: 5.w, top: 5.w, bottom: 10.w),
              decoration: BoxDecoration(
                border: isDarkMode()
                    ? null
                    : Border.all(
                        color: grey, // Border color
                        width: 0.5, // Border width
                      ),
                color: isDarkMode() ? itemDarkBackgroundColor : white,
                borderRadius: BorderRadius.circular(
                    SizerUtil.deviceType == DeviceType.mobile ? 4.w : 2.2.w),
                // boxShadow: [
                //   BoxShadow(
                //       color: black.withOpacity(0.05),
                //       blurRadius: 10.0,
                //       offset: const Offset(0, 5))
                // ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    SizerUtil.deviceType == DeviceType.mobile ? 4.w : 2.2.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: SizerUtil.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            SizerUtil.deviceType == DeviceType.mobile
                                ? 3.5.w
                                : 2.5.w),
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
                            child:
                                CircularProgressIndicator(color: primaryColor),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            Asset.productPlaceholder,
                            height: 9.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.0.h,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 1.w, right: 1.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getText(
                            data.name,
                            TextStyle(
                                fontFamily: fontSemiBold,
                                color: isDarkMode() ? black : black,
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.mobile
                                        ? 12.sp
                                        : 7.sp,
                                height: 1.2),
                          ),
                          getDynamicSizedBox(
                            height: 0.5.h,
                          ),
                          getText(
                            '\u20B9${'100'}',
                            TextStyle(
                                fontFamily: fontBold,
                                color: primaryColor,
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.mobile
                                        ? 12.sp
                                        : 7.sp,
                                height: 1.2),
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
                                    fontWeight:
                                        isDarkMode() ? FontWeight.w600 : null,
                                    fontSize: SizerUtil.deviceType ==
                                            DeviceType.mobile
                                        ? 9.sp
                                        : 7.sp,
                                    height: 1.2),
                              ),
                              // const Spacer(),
                              // GestureDetector(
                              //   onTap: () {
                              //     data.isSelected.value =
                              //         !data.isSelected.value;
                              //     update();
                              //   },
                              //   child: Icon(
                              //     data.isSelected.value
                              //         ? Icons.favorite_rounded
                              //         : Icons.favorite_border,
                              //     size: 3.h,
                              //     color: primaryColor,
                              //   ),
                              // )
                            ],
                          ),
                          getDynamicSizedBox(
                            height: 0.5.h,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }

  Widget getText(title, TextStyle? style) {
    return Padding(
      padding: EdgeInsets.only(left: 0.5.w, right: 0.5.w),
      child: Text(
        title,
        style: style,
        softWrap: true,
        maxLines: 2,
      ),
    );
  }

  Widget getLableText(text, {isMainTitle}) {
    return Text(text,
        //textAlign: TextAlign.center,
        style: TextStyle(
          color: isDarkMode() ? white : black,
          fontFamily: isMainTitle == true ? fontBold : null,
          fontWeight: isMainTitle == true ? FontWeight.w900 : FontWeight.w500,
          fontSize: isMainTitle == true ? 15.sp : 12.sp,
        ));
  }

  

  Widget getCommonText(title, {bool? isHint}) {
    return Text(
      title,
      style: isHint == true
          ? TextStyle(
              //fontFamily: fontRegular,
              color: lableColor,
              fontSize:
                  SizerUtil.deviceType == DeviceType.mobile ? 9.sp : 10.sp,
            )
          : TextStyle(
              //fontFamily: fontBold,
              color: black,
              fontSize:
                  SizerUtil.deviceType == DeviceType.mobile ? 10.sp : 7.sp,
            ),
    );
  }

  Widget getColorText(title, {bool? isReviews}) {
    return Text(title,
        style: TextStyle(
          //fontFamily: fontBold,
          fontWeight: FontWeight.w400,
          color: isReviews == true ? primaryColor : Colors.green,
          fontSize: SizerUtil.deviceType == DeviceType.mobile ? 10.sp : 7.sp,
        ));
  }

  getListItem(HomeItem data) {
    return Container(
        width: 65.w,
        margin: EdgeInsets.only(left: 3.w, right: 3.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.7.h),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
              SizerUtil.deviceType == DeviceType.mobile ? 4.w : 2.2.w),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      SizerUtil.deviceType == DeviceType.mobile
                          ? 3.5.w
                          : 2.5.w),
                ),
                child: data.icon,
              ),
              Positioned(
                top: 2.h,
                left: 5.w,
                child: FadeInUp(
                  child: Text(data.name,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: fontMedium,
                        fontWeight: FontWeight.w900,
                        fontSize: 15.sp,
                      )),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> loadStoredQuantity(CommonProductList? data) async {
    // Fetch the current cart items from preferences
    List<CommonProductList> cartItems = await UserPreferences().loadCartItems();

    // Check if the product is already in the cart
    int existingIndex = cartItems.indexWhere(
      (item) => item.id == data!.id,
    );

    if (existingIndex != -1) {
      // Product already in the cart, get the stored quantity
      quantity = cartItems[existingIndex].getStoredQuantity();
      update();
    } else {
      // Product not in the cart, set storedQuantity to 0
      quantity = 0;
      update();
    }
  }
}
