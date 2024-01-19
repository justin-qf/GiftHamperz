import 'dart:async';
import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/api_handle/Repository.dart';
import 'package:gifthamperz/componant/dialogs/customDialog.dart';
import 'package:gifthamperz/componant/dialogs/dialogs.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/apicall_constant.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/models/homeModel.dart';
import 'package:gifthamperz/models/searchModel.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/CartScreen/CartScreen.dart';
import 'package:gifthamperz/views/FilterScreen/FIlterScreen.dart';
import 'package:sizer/sizer.dart';
import '../utils/enum.dart';
import 'internet_controller.dart';

class SearchScreenController extends GetxController {
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
  late TextEditingController searchCtr;
  bool isSearch = false;
  RxList<SavedItem> filterList = <SavedItem>[].obs;

  @override
  void onInit() {
    searchCtr = TextEditingController();
    super.onInit();
  }

  final RxString searchQuery = ''.obs; // For storing the search query
  RxList<SavedItem> get filteredList {
    if (searchQuery.isEmpty) {
      update();
      return staticList;
    } else {
      update();
      return staticList
          .where((item) =>
              item.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList()
          .obs;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    update();
  }

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

  RxList searchList = [].obs;
  void getSearchList(context, String searchText) async {
    state.value = ScreenState.apiLoading;
    try {
      if (networkManager.connectionType == 0) {
        showDialogForScreen(
            context, SearchScreenConstant.title, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }

      var response = await Repository.get({},
          "${ApiUrl.getSearch}?search_product=${searchText.isNotEmpty ? searchText : ""}",
          allowHeader: true);

      logcat("SEARCH_RESPONSE::", response.body);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        state.value = ScreenState.apiSuccess;
        message.value = '';
        var searchData = SearchModel.fromJson(responseData);
        searchList.clear();
        if (searchData.data.isNotEmpty) {
          searchList.addAll(searchData.data);
          update();
        }
        // if (responseData['status'] == 1) {
        //   state.value = ScreenState.apiSuccess;
        //   message.value = '';
        //   var searchData = SearchModel.fromJson(responseData);
        //   searchList.clear();
        //   if (searchData.data.isNotEmpty) {
        //     searchList.addAll(searchData.data);
        //     update();
        //   }
        // } else {
        //   message.value = responseData['message'];
        //   showDialogForScreen(
        //       context, SearchScreenConstant.title, responseData['message'],
        //       callback: () {});
        // }
      } else {
        state.value = ScreenState.apiError;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(
            context, SearchScreenConstant.title, ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      logcat("Ecxeption", e);
      state.value = ScreenState.apiError;
      message.value = ServerError.servererror;
      showDialogForScreen(
          context, SearchScreenConstant.title, ServerError.servererror,
          callback: () {});
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
            color: isDarkMode() ? darkBackgroundColor : white,
            boxShadow: [
              BoxShadow(
                color: isDarkMode()
                    ? grey.withOpacity(0.3)
                    : grey.withOpacity(0.5), // Shadow color
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
                  color: isDarkMode() ? white : black,
                  fontWeight: FontWeight.w400,
                  fontSize:
                      SizerUtil.deviceType == DeviceType.mobile ? 14.sp : 13.sp,
                ),
              ),
              getDynamicSizedBox(width: 0.5.w),
              Icon(
                Icons.tune_rounded,
                size: 3.h,
                color: isDarkMode() ? white : primaryColor,
              )
            ],
          )),
    );
  }

  getItemListItem(
      BuildContext context, SearchDataList data, bool? isGuestUser) {
    return FadeInUp(
      child: Wrap(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
                SizerUtil.deviceType == DeviceType.mobile ? 4.w : 2.2.w),
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 0.5.h, left: 1.w, right: 2.w),
              padding: EdgeInsets.only(left: 1.2.w, right: 1.2.w, top: 1.2.w),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              SizerUtil.deviceType == DeviceType.mobile
                                  ? 3.5.w
                                  : 2.5.w),
                          border: Border.all(
                            color: isDarkMode()
                                ? primaryColor.withOpacity(0.5)
                                : grey.withOpacity(
                                    0.2), // Set the border color here
                            width: 2.0, // Set the border width
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              SizerUtil.deviceType == DeviceType.mobile
                                  ? 3.5.w
                                  : 2.5.w),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            height: 15.h,
                            imageUrl: APIImageUrl.url + data.images,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(
                                  color: primaryColor),
                            ),
                            errorWidget: (context, url, error) => Image.asset(
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
                      //       update();
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
                    height: 1.h,
                  ),
                  getText(
                    data.name,
                    TextStyle(
                        fontFamily: fontSemiBold,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode() ? black : black,
                        fontSize: SizerUtil.deviceType == DeviceType.mobile
                            ? 10.sp
                            : 7.sp,
                        height: 1.2),
                  ),
                  getDynamicSizedBox(
                    height: 0.5.h,
                  ),
                  getText(
                    '${data.sku}\u20B9',
                    TextStyle(
                        fontFamily: fontBold,
                        color: primaryColor,
                        fontSize: SizerUtil.deviceType == DeviceType.mobile
                            ? 10.sp
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
                      RatingBar.builder(
                        initialRating: 3.5,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 1,
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
                      getText(
                        "3.2",
                        TextStyle(
                            fontFamily: fontSemiBold,
                            color: lableColor,
                            fontWeight: isDarkMode() ? FontWeight.w900 : null,
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? 8.sp
                                : 7.sp,
                            height: 1.2),
                      ),
                      const Spacer(),
                      getAddToCartBtn('Add to Cart', Icons.shopping_cart,
                          addCartClick: () {
                        if (isGuestUser == true) {
                          getGuestUserAlertDialog(context);
                        } else {
                          Get.to(const CartScreen())!.then((value) {
                            Statusbar().trasparentStatusbarProfile(true);
                          });
                        }
                      })
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
      ),
    );
  }

  Widget getText(title, TextStyle? style) {
    return Padding(
      padding: EdgeInsets.only(left: 0.5.w, right: 0.5.w),
      child: Text(
        title,
        maxLines: 3,
        style: style,
      ),
    );
  }
}
