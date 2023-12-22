import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/models/OrderModel.dart';
import 'package:gifthamperz/models/homeModel.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/ProductDetailScreen/ProductDetailScreen.dart';
import 'package:sizer/sizer.dart';
import '../utils/enum.dart';
import 'internet_controller.dart';

class OrderDetailScreenController extends GetxController {
  List pageNavigation = [];
  RxInt currentTreeView = 2.obs;
  RxBool isLiked = true.obs;
  RxBool isTreeModeVertical = true.obs;
  RxBool accessToDrawer = false.obs;
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  final InternetController etworkManager = Get.find<InternetController>();
  late TabController tabController;
  var currentPage = 0;
  RxList orderDetailList = [].obs;
  RxString totalAmount = "".obs;

  setOrderTotalAmount(OrderData? data) {
    //totalAmount.value = data!.totalAmount + data.shipingCharge + data.discount;
    // Convert string variables to double
    try {
      double totalAmountValue = double.tryParse(data!.totalAmount) ?? 0.0;
      double shippingChargeValue = double.tryParse(data.shipingCharge) ?? 0.0;
      double discountValue = double.tryParse(data.discount) ?? 0.0;
      double result = totalAmountValue + discountValue + shippingChargeValue;
      totalAmount.value = result.toString();
    } catch (e) {
      logcat("ERROR", e.toString());
    }
  }

  RxList<OrderItem> orderList = <OrderItem>[
    OrderItem(
        title: "Unicorn Roses - 12 Long Stemmed Tie Dyned Roses",
        status: "Deluxe",
        orderDate: "1",
        icone: Asset.itemFour,
        price: "\$128.69"),
    OrderItem(
        title: "12 Handmade Easter Chocolate Brownie Pops",
        status: "Canceled",
        orderDate: "1",
        icone: Asset.itemTwo,
        price: "\$49.69"),
  ].obs;

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

  Widget getLableText(text, {isMainTitle}) {
    return Container(
      margin: EdgeInsets.only(left: 5.w, right: 5.w),
      child: FadeInUp(
        child: Text(text,
            style: TextStyle(
              color: isDarkMode() ? white : black,
              fontFamily: fontBold,
              fontWeight: FontWeight.w800,
              fontSize: isMainTitle == true ? 18.sp : 15.sp,
            )),
      ),
    );
  }

  Widget getColorText(title, {bool? isReviews}) {
    return FadeInUp(
      child: Text(title,
          style: TextStyle(
            //fontFamily: fontBold,
            fontWeight: FontWeight.w600,
            color: isReviews == true ? primaryColor : Colors.green,
            fontSize: SizerUtil.deviceType == DeviceType.mobile ? 10.sp : 7.sp,
          )),
    );
  }

  Widget getCommonText(title, {bool? isHint}) {
    return Container(
      margin: EdgeInsets.only(left: 5.w, right: 5.w),
      child: FadeInUp(
        child: Text(
          title,
          style: isHint == true
              ? TextStyle(
                  fontFamily: fontRegular,
                  color: lableColor,
                  fontSize:
                      SizerUtil.deviceType == DeviceType.mobile ? 9.sp : 10.sp,
                )
              : TextStyle(
                  fontFamily: fontBold,
                  color: isDarkMode() ? lableColor : black,
                  fontSize:
                      SizerUtil.deviceType == DeviceType.mobile ? 10.sp : 7.sp,
                ),
        ),
      ),
    );
  }

  Widget getOrderText(title, desc, {bool? isNormal}) {
    return Container(
      margin: EdgeInsets.only(left: 5.w, right: 5.w),
      child: FadeInUp(
        child: Row(
          children: [
            Text(
              title,
              style: isNormal == true
                  ? TextStyle(
                      //fontFamily: fontRegular,
                      color: isDarkMode() ? lableColor : black,
                      fontWeight: FontWeight.w400,
                      fontSize: SizerUtil.deviceType == DeviceType.mobile
                          ? 9.sp
                          : 10.sp,
                    )
                  : TextStyle(
                      //fontFamily: fontBold,
                      color: isDarkMode() ? lableColor : black,
                      fontWeight: FontWeight.w600,
                      fontSize: SizerUtil.deviceType == DeviceType.mobile
                          ? 12.sp
                          : 13.sp,
                    ),
            ),
            const Spacer(),
            Text(
              desc,
              style: isNormal == true
                  ? TextStyle(
                      //fontFamily: fontRegular,
                      color: isDarkMode() ? lableColor : black,
                      fontWeight: FontWeight.w400,
                      fontSize: SizerUtil.deviceType == DeviceType.mobile
                          ? 9.sp
                          : 10.sp,
                    )
                  : TextStyle(
                      //fontFamily: fontBold,
                      color: primaryColor,
                      fontWeight: FontWeight.w800,
                      fontSize: SizerUtil.deviceType == DeviceType.mobile
                          ? 10.sp
                          : 7.sp,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  getListItem(OrderDetail data) {
    return FadeInUp(
      child: Wrap(
        children: [
          Container(
              width: SizerUtil.width,
              margin: EdgeInsets.only(right: 2.w, bottom: 2.0.h),
              padding: EdgeInsets.only(right: 2.w, top: 2.w),
              decoration: BoxDecoration(
                //color: grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(1.5.h),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      SizerUtil.deviceType == DeviceType.mobile
                          ? 1.5.w
                          : 2.2.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FadeInDown(
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: APIImageUrl.url + data.images,
                            height: 15.h,
                            width: 13.5.h,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(
                                  color: primaryColor),
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              Asset.placeholder,
                              height: 9.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Image.asset(
                          //   data.images,
                          //   height: 15.h,
                          //   width: 13.5.h,
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                      ),
                      getDynamicSizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(data.name,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: fontBold,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12.sp,
                                )),
                            getDynamicSizedBox(height: 1.h),
                            RichText(
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.center,
                              softWrap: true,
                              textScaleFactor: 1,
                              text: TextSpan(
                                text: '\u{20B9}${data.price} | ',
                                style: TextStyle(
                                    color: primaryColor,
                                    fontFamily: fontRegular,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.sp),
                                children: [
                                  TextSpan(
                                    text: data.tags,
                                    style: TextStyle(
                                        fontFamily: fontBold,
                                        color:
                                            isDarkMode() ? lableColor : black,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                            getDynamicSizedBox(height: 0.5.h),
                            RichText(
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.start,
                              softWrap: true,
                              textScaleFactor: 1,
                              text: TextSpan(
                                text: 'Quantity:',
                                style: TextStyle(
                                    color: lableColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.sp),
                                children: [
                                  TextSpan(
                                    text: data.minQty.toString(),
                                    style: TextStyle(
                                        color:
                                            isDarkMode() ? lableColor : black,
                                        fontFamily: fontBold,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w800),
                                  )
                                ],
                              ),
                            ),
                            getDynamicSizedBox(height: 1.h),
                            getDivider()
                          ],
                        ),
                      )
                    ],
                  ))),
        ],
      ),
    );
  }

  getOrderDetailItemList(OrderDetail data) {
    return FadeInUp(
      child: GestureDetector(
        onTap: () {},
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
              SizerUtil.deviceType == DeviceType.mobile ? 4.w : 2.2.w),
          child: Container(
              width: 45.w,
              margin: EdgeInsets.only(bottom: 1.h, left: 1.w, right: 2.w),
              padding: EdgeInsets.only(
                  left: 1.2.w, right: 1.2.w, top: 1.2.w, bottom: 1.h),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
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
                              Asset.placeholder,
                              height: 9.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 3.w,
                        top: 1.0.h,
                        child: GestureDetector(
                          onTap: () {
                            // data.isSelected.value =
                            //     !data.isSelected.value;
                            update();
                          },
                          child: Icon(
                            Icons.favorite_border,
                            size: 3.h,
                            color: primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 1.0.h,
                  ),
                  getText(
                    data.name,
                    TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontFamily: fontSemiBold,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode() ? white : black,
                        fontSize: SizerUtil.deviceType == DeviceType.mobile
                            ? 10.sp
                            : 8.sp,
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
                      Expanded(
                        child: RatingBar.builder(
                          initialRating: 3.5,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 3.5.w,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.orange,
                          ),
                          onRatingUpdate: (rating) {
                            logcat("RATING", rating);
                          },
                        ),
                      ),
                      getText(
                        "35 Reviews",
                        TextStyle(
                            fontFamily: fontSemiBold,
                            color: lableColor,
                            fontWeight: isDarkMode() ? FontWeight.w600 : null,
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? 9.sp
                                : 7.sp,
                            height: 1.2),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  getGiftListItem(OrderItem data) {
    return FadeInUp(
      child: Wrap(
        children: [
          Container(
              width: SizerUtil.width,
              margin: EdgeInsets.only(right: 2.w, bottom: 2.0.h),
              padding: EdgeInsets.only(right: 2.w, top: 2.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1.h),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      SizerUtil.deviceType == DeviceType.mobile ? 1.w : 2.2.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FadeInDown(
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          child: Image.asset(
                            data.icone!,
                            height: 20.h,
                            width: 18.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      getDynamicSizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Write on Card',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: lableColor,
                                  fontFamily: fontMedium,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12.sp,
                                )),
                            getDynamicSizedBox(height: 1.5.h),
                            Text('Julie, hope you have a happy 27th Love ya..!',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: fontMedium,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12.sp,
                                )),
                            getDynamicSizedBox(height: 1.h),
                          ],
                        ),
                      )
                    ],
                  ))),
        ],
      ),
    );
  }
}
