import 'dart:async';
import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/api_handle/Repository.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/dialogs/dialogs.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/configs/apicall_constant.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/internet_controller.dart';
import 'package:gifthamperz/models/ProductModel.dart';
import 'package:gifthamperz/models/UpdateDashboardModel.dart';
import 'package:gifthamperz/models/brandModel.dart';
import 'package:gifthamperz/utils/enum.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/ProductDetailScreen/ProductDetailScreen.dart';
import 'package:sizer/sizer.dart';

class ProductScreenController extends GetxController {
  List pageNavigation = [];
  RxInt currentTreeView = 2.obs;
  RxBool isExpanded = false.obs;
  RxBool isTreeModeVertical = true.obs;
  RxBool accessToDrawer = false.obs;
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  final InternetController networkManager = Get.find<InternetController>();
  RxList treeList = [].obs;
  var pageController = PageController();
  var currentPage = 0;
  late Timer timer;
  late TextEditingController searchCtr;
  bool isSearch = false;
  late TabController tabController;
  RxBool isShowMoreLoading = false.obs;

  @override
  void onInit() {
    searchCtr = TextEditingController();
    super.onInit();
  }

  RxList brandList = [].obs;
  String? selectedBrandId;

  void getBrandList(
    context,
    bool hideloading,
    categoryId,
    subcategoryId,
    innerSubcategoryId,
  ) async {
    state.value = ScreenState.apiLoading;
    try {
      if (networkManager.connectionType == 0) {
        state.value = ScreenState.apiSuccess;
        showDialogForScreen(
            context, ProductScreenConstant.title, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      var response =
          await Repository.get({}, ApiUrl.getBrandList, allowHeader: false);
      logcat("BRANDLIST_RESPONSE::", response.body);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          var blogTypeData = BrandModel.fromJson(responseData);
          brandList.clear();
          if (blogTypeData.data.isNotEmpty) {
            brandList.addAll(blogTypeData.data);
            update();
          }
          if (brandList.isNotEmpty) {
            selectedBrandId = brandList.first.id.toString();
            getProductList(context, 1, true, categoryId, subcategoryId,
                innerSubcategoryId, selectedBrandId.toString());
          }
        } else {
          message.value = responseData['message'];
          showDialogForScreen(
              context, ProductScreenConstant.title, responseData['message'],
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(
            context, ProductScreenConstant.title, ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      logcat("Ecxeption", e);
      state.value = ScreenState.apiError;
      message.value = ServerError.servererror;
      showDialogForScreen(
          context, ProductScreenConstant.title, ServerError.servererror,
          callback: () {});
    }
  }

  RxList productList = [].obs;
  RxString nextPageURL = "".obs;
  RxBool isLoading = false.obs;

  void getProductList(context, currentPage, bool hideloading, categoryId,
      subcategoryId, innerSubcategoryId, String brandId) async {
    if (hideloading == true) {
      state.value = ScreenState.apiLoading;
    } else {
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
      logcat("ProductPassingData:::", {
        "category_id": categoryId,
        "subcategory_id": subcategoryId,
        "inner_subcategory_id": innerSubcategoryId,
        "brand_id": brandId
      });
      var response = await Repository.post({
        "category_id": categoryId,
        "subcategory_id": subcategoryId,
        "inner_subcategory_id": innerSubcategoryId,
        "brand_id": brandId
      }, ApiUrl.getProductList, allowHeader: false);
      // loadingIndicator.hide(context);
      var data = jsonDecode(response.body);
      logcat("RESPONSE", data.toString());
      if (response.statusCode == 200) {
        if (data['status'] == 1) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          isLoading.value = false;
          update();
          var responseData = ProductModel.fromJson(data);
          productList.clear();
          if (responseData.data.data.isNotEmpty) {
            productList.addAll(responseData.data.data);
            nextPageURL.value = responseData.data.nextPageUrl.toString();
          } else {
            //state.value = ScreenState.noDataFound;
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
      state.value = ScreenState.apiError;
      message.value = ServerError.servererror;
    }
  }

  getListItem(
    BuildContext context,
    CommonProductList data,
    categoryId,
    subcategoryId,
    innerSubcategoryId,
  ) {
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
                          EdgeInsets.only(bottom: 1.h, left: 1.w, right: 2.w),
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
                                  '\u20B9${data.price}',
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
                          //getDynamicSizedBox(height: 1.h),
                          // getAddToCartBtn('Add to Cart', Icons.shopping_cart,
                          //     addCartClick: () {
                          //   Get.to(const CartScreen())!.then((value) {
                          //     Statusbar().trasparentStatusbarProfile(true);
                          //   });
                          // })
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
                  getProductList(context, currentPage, true, categoryId,
                      subcategoryId, innerSubcategoryId, selectedBrandId!);
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
        maxLines: 2,
        style: style,
      ),
    );
  }
}
