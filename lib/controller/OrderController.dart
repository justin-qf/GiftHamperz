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
import 'package:gifthamperz/configs/apicall_constant.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/models/OrderModel.dart';
import 'package:gifthamperz/models/homeModel.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/OrderScreen/OrderDetailScreen/OrderDetailScreen.dart';
import 'package:sizer/sizer.dart';
import '../utils/enum.dart';
import 'internet_controller.dart';

class OrderScreenController extends GetxController {
  List pageNavigation = [];
  RxInt currentTreeView = 2.obs;
  RxBool isLiked = true.obs;
  RxBool isTreeModeVertical = true.obs;
  RxBool accessToDrawer = false.obs;
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  RxBool isLoading = false.obs;
  final InternetController networkManager = Get.find<InternetController>();
  late TabController tabController;
  var currentPage = 0;

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
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

  RxList orderList = [].obs;
  RxString nextPageURL = "".obs;

  void getOrderList(
    context,
    currentPage,
    bool hideloading, {
    bool? isRefress,
  }) async {
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
            context, OrderScreenConstant.title, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      var pageURL = '${ApiUrl.getOrderList}?page=$currentPage';
      //var pageURL = ApiUrl.getOrderList;

      logcat("URL", pageURL.toString());
      var response = await Repository.post({}, pageURL, allowHeader: true);
      if (hideloading != true) {
        loadingIndicator.hide(
          context,
        );
      }
      // loadingIndicator.hide(context);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data['status'] == 1) {
          var responseData = OrderModel.fromJson(data);
          state.value = ScreenState.apiSuccess;
          message.value = '';
          isLoading.value = false;
          update();
          if (responseData.data.data.isNotEmpty) {
            orderList.addAll(responseData.data.data);
            orderList.refresh();
          }
          if (responseData.data.nextPageUrl != 'null' &&
              responseData.data.nextPageUrl != null) {
            nextPageURL.value = responseData.data.nextPageUrl.toString();
            update();
          } else {
            nextPageURL.value = "";
            update();
          }
          if (isRefress == true) {
            return;
          } else {
            currentPage++;
          }
          update();
        } else {
          isLoading.value = false;
          message.value = data['message'];
          state.value = ScreenState.apiError;
          showDialogForScreen(
              context, AddAddressText.addressTitle, data['message'].toString(),
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        isLoading.value = false;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(
            context, AddAddressText.addressTitle, data['message'].toString(),
            callback: () {});
      }
    } catch (e) {
      isLoading.value = false;
      state.value = ScreenState.apiError;
      message.value = ServerError.servererror;
    }
  }

  Widget getOrderListItem(BuildContext context, OrderData data, int index) {
    return FadeInUp(
      child: GestureDetector(
        onTap: () {
          Get.to(OrderDetailScreen(
            data: data,
          ));
        },
        child: Container(
          margin: EdgeInsets.only(top: 1.h, left: 4.w, right: 4.w, bottom: 1.h),
          padding:
              EdgeInsets.only(top: 1.h, left: 2.w, right: 2.w, bottom: 1.h),
          decoration: BoxDecoration(
            border: isDarkMode()
                ? Border.all(
                    color: grey, // Border color
                    width: 0.5, // Border width
                  )
                : null,
            color: isDarkMode() ? itemDarkBackgroundColor : white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: grey.withOpacity(0.5),
                  blurRadius: 3.0,
                  offset: const Offset(0, 3),
                  spreadRadius: 0.5)
            ],
          ),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                  right: 3.w,
                ),
                padding: const EdgeInsets.all(0.5),
                decoration: BoxDecoration(
                  border: isDarkMode()
                      ? Border.all(
                          color: isDarkMode() ? grey : grey, // Border color
                          width: 0.2, // Border width
                        )
                      : Border.all(
                          color: grey, // Border color
                          width: 0.6, // Border width
                        ),
                  color: isDarkMode() ? itemDarkBackgroundColor : white,
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
                    height: 12.h,
                    width: 12.h,
                    imageUrl: APIImageUrl.url +
                        data.orderDetails[0].images[0].toString(),
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      Asset.productPlaceholder,
                      height: 12.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                              color: Colors.green, shape: BoxShape.circle),
                        ),
                        getDynamicSizedBox(width: 1.w),
                        Text(
                          'Delivered',
                          style: TextStyle(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? 10.sp
                                : 6.sp,
                            fontFamily: fontSemiBold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    getDynamicSizedBox(height: 0.5.h),
                    Text(
                      ('Order Id: ${data.orderId.toString()}'),
                      style: TextStyle(
                          fontSize: SizerUtil.deviceType == DeviceType.mobile
                              ? 13.sp
                              : 6.sp,
                          fontFamily: fontBold,
                          fontWeight: FontWeight.w700,
                          color: isDarkMode() ? black : black),
                    ),
                    getDynamicSizedBox(height: 0.5.h),
                    Text(
                      ('Order Date: ${getFormateDate(data.dateOfOrder.toString())}'),
                      style: TextStyle(
                          fontSize: SizerUtil.deviceType == DeviceType.mobile
                              ? 10.sp
                              : 6.sp,
                          fontFamily: fontRegular,
                          fontWeight: isDarkMode() ? FontWeight.w600 : null,
                          color: isDarkMode() ? grey : lableColor),
                    ),
                    getDynamicSizedBox(height: 0.5.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ('\u{20B9}${formatPrice(double.parse(data.totalAmount.toString()))}'),
                          style: TextStyle(
                              fontSize:
                                  SizerUtil.deviceType == DeviceType.mobile
                                      ? 12.sp
                                      : 10.sp,
                              fontFamily: fontExtraBold,
                              color: isDarkMode() ? black : black),
                        ),
                        const Spacer(),
                        Text(
                          ('View Details'),
                          style: TextStyle(
                              fontSize:
                                  SizerUtil.deviceType == DeviceType.mobile
                                      ? 10.sp
                                      : 8.sp,
                              decoration: TextDecoration.underline,
                              fontFamily: fontExtraBold,
                              color: isDarkMode() ? black : black),
                        ),
                        // getOrderButton(() {
                        //   Get.to(OrderDetailScreen(
                        //     data: data,
                        //   ));
                        // })
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
