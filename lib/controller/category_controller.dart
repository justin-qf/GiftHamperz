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
import 'package:gifthamperz/controller/internet_controller.dart';
import 'package:gifthamperz/models/categoryModel.dart';
import 'package:gifthamperz/models/homeModel.dart';
import 'package:gifthamperz/utils/enum.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/CategoryScreen/SubCategoryScreen.dart';
import 'package:sizer/sizer.dart';

class CategoryController extends GetxController {
  final InternetController networkManager = Get.find<InternetController>();
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  Rx<ScreenState> states = ScreenState.apiLoading.obs;
  RxString mobile = "".obs;
  RxString message = "".obs;

  final RxList<SavedItem> staticList = <SavedItem>[
    SavedItem(
        icon: Image.asset(
          Asset.itemOne,
          fit: BoxFit.cover,
        ),
        price: '\$19.99 -\$29.99',
        name: 'Unicorn Roses -12 Long Stemmed tie Dyed Roses'),
    SavedItem(
        icon: Image.asset(
          Asset.itemTwo,
          fit: BoxFit.cover,
        ),
        price: '\$30.99 -\$29.99',
        name: 'Birthday\nGifts'),
    SavedItem(
        icon: Image.asset(
          Asset.itemThree,
          fit: BoxFit.cover,
        ),
        price: '\$35.99 -\$29.99',
        name: "Unicorn Roses -12 Long Stemmed tie Dyed Roses"),
    SavedItem(
        icon: Image.asset(
          Asset.itemFour,
          fit: BoxFit.cover,
        ),
        price: '\$50.99 -\$29.99',
        name: "Flower\nLovers"),
    SavedItem(
        icon: Image.asset(
          Asset.itemFive,
          fit: BoxFit.cover,
        ),
        price: '\$60.99 -\$29.99',
        name: 'Unicorn Roses -12 Long Stemmed tie Dyed Roses'),
    SavedItem(
        icon: Image.asset(
          Asset.itemOne,
          fit: BoxFit.cover,
        ),
        price: '\$70.99 -\$29.99',
        name: "Occations"),
    SavedItem(
        icon: Image.asset(
          Asset.itemFour,
          fit: BoxFit.cover,
        ),
        price: '\$90.99 -\$29.99',
        name: "Flower\nLovers")
  ].obs;

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  RxList categoryList = [].obs;
  void getCategoryList(context) async {
    state.value = ScreenState.apiLoading;
    try {
      if (networkManager.connectionType == 0) {
        showDialogForScreen(
            context, CategoryScreenConstant.title, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      var response = await Repository.get({}, ApiUrl.getCategory, list: true);
      logcat("RESPONSE::", response.body);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          var categoryData = CategoryModel.fromJson(responseData);
          categoryList.clear();
          if (categoryData.data.data != null) {
            categoryList.addAll(categoryData.data.data);
            update();
          } else {
            categoryList.addAll([]);
          }
        } else {
          message.value = responseData['message'];
          showDialogForScreen(
              context, CategoryScreenConstant.title, responseData['message'],
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(
            context, CategoryScreenConstant.title, ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      logcat("Ecxeption", e);
      state.value = ScreenState.apiError;
      message.value = ServerError.servererror;
      showDialogForScreen(
          context, CategoryScreenConstant.title, ServerError.servererror,
          callback: () {});
    }
  }

  getListItem(CategoryData data) {
    return Wrap(
      children: [
        FadeInUp(
          child: GestureDetector(
            onTap: () {
              Get.to(SubCategoryScreen(
                categoryId: data.id.toString(),
              ));
              // Get.to(ProductDetailScreen('Trending'));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  SizerUtil.deviceType == DeviceType.mobile ? 4.w : 2.2.w),
              child: Container(
                width: 45.w,
                margin: EdgeInsets.only(right: 2.w),
                padding: EdgeInsets.all(
                  1.w,
                ),
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
                ),
                child: Stack(children: [
                  // Background Image
                  SizedBox(
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          SizerUtil.deviceType == DeviceType.mobile
                              ? 3.5.w
                              : 2.5.w),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        height: 18.h,
                        imageUrl: APIImageUrl.url + data.thumbnailUrl,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          Asset.placeholder,
                          height: 10.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Fog Shadow
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          SizerUtil.deviceType == DeviceType.mobile
                              ? 3.5.w
                              : 2.5.w),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              black.withOpacity(isDarkMode() ? 0.7 : 0.6),
                              transparent
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Title at Bottom Center
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding:
                          EdgeInsets.only(left: 2.w, right: 2.w, bottom: 0.5.h),
                      child: Text(
                        data.name,
                        style: TextStyle(
                            fontFamily: fontSemiBold,
                            fontWeight: FontWeight.w500,
                            color: white,
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? 12.sp
                                : 7.sp,
                            height: 1.2),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        )
      ],
    );
  }

  getOldListItem(CategoryData data) {
    return Wrap(
      children: [
        FadeInUp(
          child: GestureDetector(
            onTap: () {
              Get.to(SubCategoryScreen(
                categoryId: data.id.toString(),
              ));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  SizerUtil.deviceType == DeviceType.mobile ? 4.w : 2.2.w),
              child: Container(
                  width: 45.w,
                  margin: EdgeInsets.only(bottom: 0.5.h, left: 1.w, right: 2.w),
                  padding: EdgeInsets.only(
                      left: 1.2.w, right: 1.2.w, top: 1.2.w, bottom: 1.h),
                  decoration: BoxDecoration(
                    border: isDarkMode()
                        ? Border.all(
                            color: grey, // Border color
                            width: 0.2, // Border width
                          )
                        : Border.all(
                            color: grey, // Border color
                            width: 0.5, // Border width
                          ),
                    color: isDarkMode() ? itemDarkBackgroundColor : white,
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
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: isDarkMode()
                                  ? Border.all(
                                      color: grey, // Border color
                                      width: 0.4, // Border width
                                    )
                                  : Border.all(
                                      color: grey, // Border color
                                      width: 0.5, // Border width
                                    ),
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
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: APIImageUrl.url + data.thumbnailUrl,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                      color: primaryColor),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  Asset.placeholder,
                                  height: 9.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.0.h,
                      ),
                      getText(
                        data.name,
                        TextStyle(
                            fontFamily: fontSemiBold,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode() ? white : black,
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? 12.sp
                                : 7.sp,
                            height: 1.2),
                      ),
                      getDynamicSizedBox(
                        height: 0.2.h,
                      ),
                      // getText(
                      //   data.name,
                      //   TextStyle(
                      //       fontFamily: fontBold,
                      //       color: primaryColor,
                      //       fontSize: SizerUtil.deviceType == DeviceType.mobile
                      //           ? 10.sp
                      //           : 7.sp,
                      //       height: 1.2),
                      // ),
                      // getDynamicSizedBox(
                      //   height: 0.5.h,
                      // ),
                    ],
                  )),
            ),
          ),
        ),
      ],
    );
  }

  Widget getText(title, TextStyle? style) {
    return Center(
      child: Text(
        title,
        style: style,
      ),
    );
  }
}
