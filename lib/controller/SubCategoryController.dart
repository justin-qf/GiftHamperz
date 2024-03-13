import 'dart:async';
import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/api_handle/Repository.dart';
import 'package:gifthamperz/componant/dialogs/dialogs.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/configs/apicall_constant.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/models/SubCategoryModel.dart';
import 'package:gifthamperz/models/innerSubCategoryModel.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/ProductScreen/ProductScreen.dart';
import 'package:sizer/sizer.dart';
import '../utils/enum.dart';
import 'internet_controller.dart';

class SubCategoryController extends GetxController {
  RxInt currentTreeView = 2.obs;
  RxBool isLiked = true.obs;
  RxBool isTreeModeVertical = true.obs;
  RxBool accessToDrawer = false.obs;
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  final InternetController networkManager = Get.find<InternetController>();
  late TabController tabController;
  var currentPage = 0;
  RxBool isLoading = false.obs;
  String isSelectedSubCategoryId = "";

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  Widget getText(title, TextStyle? style) {
    return Center(
      child: Text(
        title,
        style: style,
      ),
    );
  }

  RxList subCategoryList = [].obs;
  void getSubCategoryList(context, categoryId) async {
    state.value = ScreenState.apiLoading;
    try {
      if (networkManager.connectionType == 0) {
        state.value = ScreenState.apiSuccess;
        showDialogForScreen(context, CategoryScreenConstant.subCategorytitle,
            Connection.noConnection, callback: () {
          Get.back();
        });
        return;
      }
      var response = await Repository.post({
        "category_id": categoryId.toString(),
      }, ApiUrl.getSubCategory, allowHeader: true);
      logcat("RESPONSE::", response.body);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          var categoryData = SubCategoryModel.fromJson(responseData);
          subCategoryList.clear();
          if (categoryData.data.isNotEmpty) {
            subCategoryList.addAll(categoryData.data);
            if (subCategoryList.isNotEmpty) {
              int firstSubCategoryId = subCategoryList.first.id;
              isSelectedSubCategoryId = firstSubCategoryId.toString();
              getInnerSubCategoryList(context, categoryId, firstSubCategoryId);
            }
            update();
          } else {
            subCategoryList.addAll([]);
          }
        } else {
          message.value = responseData['message'];
          showDialogForScreen(context, CategoryScreenConstant.subCategorytitle,
              responseData['message'],
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(context, CategoryScreenConstant.subCategorytitle,
            ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      logcat("Ecxeption", e);
      state.value = ScreenState.apiError;
      message.value = ServerError.servererror;
      showDialogForScreen(context, CategoryScreenConstant.subCategorytitle,
          ServerError.servererror,
          callback: () {});
    }
  }

  RxList innerSubCategoryList = [].obs;
  void getInnerSubCategoryList(context, categoryId, subcategoryId) async {
    //state.value = ScreenState.apiLoading;
    isLoading.value = true;
    update();
    try {
      if (networkManager.connectionType == 0) {
        isLoading.value = false;
        showDialogForScreen(context, CategoryScreenConstant.subCategorytitle,
            Connection.noConnection, callback: () {
          Get.back();
        });
        return;
      }

      var response = await Repository.post({
        "category_id": categoryId.toString(),
        "subcategory_id": subcategoryId.toString(),
      }, ApiUrl.getInnerSubCategory, allowHeader: true);
      logcat("RESPONSE::", response.body);
      isLoading.value = false;
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          // state.value = ScreenState.apiSuccess;
          message.value = '';
          var categoryData = InnerSubCategoryModel.fromJson(responseData);
          innerSubCategoryList.clear();
          if (categoryData.data.isNotEmpty) {
            innerSubCategoryList.addAll(categoryData.data);
            update();
          } else {
            innerSubCategoryList.addAll([]);
          }
        } else {
          message.value = responseData['message'];
          showDialogForScreen(context, CategoryScreenConstant.subCategorytitle,
              responseData['message'],
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(context, CategoryScreenConstant.subCategorytitle,
            ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      logcat("Ecxeption", e);
      state.value = ScreenState.apiError;
      message.value = ServerError.servererror;
      showDialogForScreen(context, CategoryScreenConstant.subCategorytitle,
          ServerError.servererror,
          callback: () {});
    }
  }

  getListItem(InnerSubCategoryData data, categoryId, subCategoryId) {
    return Wrap(
      children: [
        FadeInUp(
          child: GestureDetector(
            onTap: () {
              Get.to(ProductScreen(
                categoryId: data.categoryId.toString(),
                subcategoryId: data.subcategoryId.toString(),
                innerSubcategoryId: data.id.toString(),
                brandId: "4",
              ));
              // Get.to(ProductDetailScreen('Trending'));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  SizerUtil.deviceType == DeviceType.mobile ? 4.w : 2.2.w),
              child: Container(
                width: 45.w,
                margin: EdgeInsets.only(left: 1.w, right: 2.w),
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
                        imageUrl: ApiUrl.imageUrl + data.thumbnailUrl,
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

              //  Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Container(
              //       width: double.infinity,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(
              //             SizerUtil.deviceType == DeviceType.mobile
              //                 ? 3.5.w
              //                 : 2.5.w),
              //       ),
              //       child: ClipRRect(
              //         borderRadius: BorderRadius.circular(
              //             SizerUtil.deviceType == DeviceType.mobile
              //                 ? 3.5.w
              //                 : 2.5.w),
              //         child: CachedNetworkImage(
              //           fit: BoxFit.contain,
              //           height: 18.h,
              //           imageUrl: APIImageUrl.url + data.thumbnailUrl,
              //           placeholder: (context, url) => const Center(
              //             child: CircularProgressIndicator(
              //                 color: primaryColor),
              //           ),
              //           errorWidget: (context, url, error) => Image.asset(
              //             Asset.placeholder,
              //             height: 9.h,
              //             fit: BoxFit.cover,
              //           ),
              //         ),
              //       ),
              //     ),
              //     SizedBox(
              //       height: 1.0.h,
              //     ),
              //     getText(
              //       data.name,
              //       TextStyle(
              //           fontFamily: fontSemiBold,
              //           fontWeight: FontWeight.w500,
              //           color: isDarkMode() ? white : black,
              //           fontSize:
              //               SizerUtil.deviceType == DeviceType.mobile
              //                   ? 12.sp
              //                   : 7.sp,
              //           height: 1.2),
              //     ),
              //     getDynamicSizedBox(
              //       height: 0.2.h,
              //     ),
              //   ],
              // ))
            ),
          ),
        )
      ],
    );
  }
}
