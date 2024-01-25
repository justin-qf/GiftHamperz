import 'dart:convert';
import 'dart:ffi';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/dialogs/customDialog.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/CartController.dart';
import 'package:gifthamperz/main.dart';
import 'package:gifthamperz/models/DashboadModel.dart';
import 'package:gifthamperz/preference/UserPreference.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/DeliveryScreen/AddressScreen.dart';
import 'package:gifthamperz/views/MainScreen/MainScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var controller = Get.put(CartScreenController());
  late List<CommonProductList> cartItems;

  @override
  void initState() {
    controller.getTotal();
    loadCartItems();
    controller.initLoginData();
    super.initState();
  }

  Future<void> loadCartItems() async {
    // Your existing logic to load cart items
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartItemsJson = prefs.getString('cartItems');
    List<CommonProductList> loadedCartItems = [];

    if (cartItemsJson != null && cartItemsJson.isNotEmpty) {
      List<Map<String, dynamic>> itemsList =
          json.decode(cartItemsJson).cast<Map<String, dynamic>>();

      loadedCartItems =
          itemsList.map((item) => CommonProductList.fromJson(item)).toList();
    }

    setState(() {
      cartItems = loadedCartItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomParentScaffold(
      onWillPop: () async {
        return true;
      },
      onTap: () {
        controller.hideKeyboard(context);
      },
      isSafeArea: false,
      isNormalScreen: true,
      body: Container(
        color: isDarkMode() ? darkBackgroundColor : transparent,
        child: Stack(
          children: [
            Column(
              children: [
                getForgetToolbar(CartScreenConstant.title, showBackButton: true,
                    callback: () {
                  Get.back();
                }),
                Expanded(
                  child: cartItems.isNotEmpty
                      ? Container(
                          padding: EdgeInsets.only(left: 6.w, right: 6.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: SizerUtil.width,
                                margin:
                                    EdgeInsets.only(right: 2.w, bottom: 2.0.h),
                                padding: EdgeInsets.only(
                                    left: 3.w,
                                    right: 3.w,
                                    top: 2.w,
                                    bottom: 2.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1.5.h),
                                  color: isDarkMode()
                                      ? primaryColor
                                      : grey.withOpacity(0.2),
                                  border: Border.all(
                                    color: isDarkMode()
                                        ? primaryColor
                                        : grey.withOpacity(
                                            0.2), // Set the border color here
                                    width: 2.0, // Set the border width
                                  ),
                                ),
                                child: Row(children: [
                                  Text("2 Items",
                                      style: TextStyle(
                                        color: isDarkMode() ? white : black,
                                        fontFamily: fontBold,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                      )),
                                  const Spacer(),
                                  Text('${'Total: '}\u20B9 120',
                                      style: TextStyle(
                                        color: isDarkMode() ? white : black,
                                        fontFamily: fontBold,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                      )),
                                ]),
                              ),
                              // controller.getLableText(
                              //     'You Have 2 items in cart',
                              //     isMainTitle: true),
                              Expanded(
                                  child: SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                              padding:
                                                  EdgeInsets.only(bottom: 32.h),
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              clipBehavior: Clip.antiAlias,
                                              itemBuilder: (context, index) {
                                                // CartItem data =
                                                //     controller.cartItems[index];
                                                CommonProductList cartItem =
                                                    cartItems[index];
                                                return getListItem(
                                                    cartItem, index, cartItems);
                                              },
                                              itemCount: cartItems.length),
                                          getDynamicSizedBox(height: 0.5.h),
                                        ],
                                      ))),
                            ],
                          ),
                        )
                      : FadeInDown(
                          child: Stack(
                            children: [
                              SizedBox(
                                height: SizerUtil.height,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 5.w),
                                      child: SvgPicture.asset(
                                        Asset.cartEmpty,
                                        fit: BoxFit.cover,
                                        height: 20.h,
                                      ),
                                    ),
                                    getDynamicSizedBox(height: 2.h),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 5.w, right: 5.w),
                                      child: Text(
                                          'Your basket is empty!!!\nAdd your item and buy what you want us',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: fontMedium,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.sp,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 2.h,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    left: 5.5.w,
                                    right: 5.w,
                                  ),
                                  child: FadeInUp(
                                      from: 50,
                                      child: getSecondaryFormButton(() {
                                        //Get.back(result: true);
                                        Get.offAll(const BottomNavScreen());
                                        // onClick!();
                                      }, AddAddressText.startShopping,
                                          isvalidate: true)),
                                ),
                              )
                            ],
                          ),
                        ),
                )
              ],
            ),
            cartItems.isNotEmpty
                ? Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        FadeInUp(
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 5.w, right: 5.w, top: 2.0.h, bottom: 2.h),
                            decoration: BoxDecoration(
                                color:
                                    isDarkMode() ? darkBackgroundColor : white,
                                boxShadow: const [
                                  BoxShadow(
                                      color: grey,
                                      blurRadius: 10.0,
                                      offset: Offset(0, 6),
                                      spreadRadius: 1.0)
                                ],
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.h),
                                    topRight: Radius.circular(5.h))),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  controller.getLableText('Payment Summery'),
                                  getDynamicSizedBox(height: 1.h),
                                  getDivider(),
                                  getDynamicSizedBox(height: 1.h),
                                  controller.getOrderText('Product Cost',
                                      '\$${controller.productCost.value}',
                                      isNormal: true),
                                  getDynamicSizedBox(height: 1.h),
                                  controller.getOrderText('Delivery',
                                      '\$${controller.deliveryCharge.value}',
                                      isNormal: true),
                                  getDynamicSizedBox(height: 1.h),
                                  controller.getOrderText('Discount',
                                      '- \$${controller.discount.value}',
                                      isNormal: true),
                                  getDynamicSizedBox(height: 1.h),
                                  controller.getOrderText(
                                      'Total', '\$${controller.total.value}',
                                      isNormal: false),
                                  getDynamicSizedBox(height: 3.h),
                                  Container(
                                      margin: EdgeInsets.only(
                                        left: 5.w,
                                        right: 5.w,
                                      ),
                                      child: FadeInUp(
                                          from: 50,
                                          child: Obx(() {
                                            return getSecondaryFormButton(
                                                () async {
                                              // bool isGuest = await UserPreferences()
                                              //     .getGuestUser();
                                              if (controller.isGuest.value ==
                                                  true) {
                                                // ignore: use_build_context_synchronously
                                                getGuestUserAlertDialog(context,
                                                    CartScreenConstant.title);
                                              } else {
                                                Get.to(const AddressScreen());
                                              }
                                            }, Button.checkOut,
                                                isvalidate: true,
                                                isEnable:
                                                    controller.isGuest.value);
                                          }))),
                                  getDynamicSizedBox(height: 0.5.h),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  getListItem(
      CommonProductList data, int index, List<CommonProductList> cartItems) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // Statusbar().trasparentStatusbarProfile(true);
            return CustomCartItemDetailDialog(
                APIImageUrl.url + data.images,
                data.name,
                data.sku.toString(),
                data.description); // Use your custom dialog widget
          },
        );
      },
      child: FadeInUp(
        child: Wrap(
          children: [
            Container(
                width: SizerUtil.width,
                margin: EdgeInsets.only(right: 2.w, bottom: 2.0.h),
                padding: EdgeInsets.only(
                    left: 1.8.w, right: 1.8.w, top: 1.8.w, bottom: 1.8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.5.h),
                  border: Border.all(
                    color: isDarkMode()
                        ? grey.withOpacity(0.4)
                        : grey.withOpacity(0.2), // Set the border color here
                    width: 2.0, // Set the border width
                  ),
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
                          child: Container(
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                height: 13.h,
                                width: 30.w,
                                imageUrl: APIImageUrl.url + data.images,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                      color: primaryColor),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  Asset.productPlaceholder,
                                  height: 13.h,
                                  width: 13.5.h,
                                  fit: BoxFit.contain,
                                ),
                                imageBuilder: (context, imageProvider) => Image(
                                  image: imageProvider,
                                  height: 13.h,
                                  width: 13.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        getDynamicSizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(data.name,
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontFamily: fontMedium,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                  )),
                              getDynamicSizedBox(height: 1.h),
                              RichText(
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.start,
                                softWrap: true,
                                textScaleFactor: 1,
                                text: TextSpan(
                                  text: '\$${data.sku}',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11.sp),
                                  children: [
                                    TextSpan(
                                      text: '',
                                      style: TextStyle(
                                          color:
                                              isDarkMode() ? lableColor : black,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ),
                              getDynamicSizedBox(height: 0.5.h),
                              Row(
                                children: [
                                  RichText(
                                    overflow: TextOverflow.clip,
                                    textAlign: TextAlign.start,
                                    softWrap: true,
                                    textScaleFactor: 1,
                                    text: TextSpan(
                                      text: 'Quantity: ',
                                      style: TextStyle(
                                          color: lableColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 8.sp),
                                      children: [
                                        TextSpan(
                                          // text: data.orderDate,
                                          text: data.quantity.toString(),
                                          style: TextStyle(
                                              color: isDarkMode()
                                                  ? lableColor
                                                  : black,
                                              fontFamily: fontBold,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w800),
                                        )
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                      padding: EdgeInsets.only(
                                          left: 2.7.w,
                                          right: 2.7.w,
                                          top: 0.4.h,
                                          bottom: 0.4.h),
                                      decoration: BoxDecoration(
                                          color: isDarkMode()
                                              ? darkBackgroundColor
                                              : white,
                                          boxShadow: [
                                            BoxShadow(
                                                color: grey.withOpacity(0.2),
                                                blurRadius: 1.0,
                                                offset: const Offset(0, 1),
                                                spreadRadius: 1.0)
                                          ],
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.h),
                                          )),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              data.quantity!.value--;
                                              if (data.quantity!.value <= 0) {
                                                cartItems.removeAt(index);
                                              }
                                              // Product already in the cart, decrement the quantity
                                              await UserPreferences().addToCart(
                                                data,
                                                -1, // Pass a negative quantity for decrement
                                              );
                                              setState(() {});
                                            },
                                            child: Icon(
                                              Icons.remove,
                                              size: 3.h,
                                            ),
                                          ),
                                          getDynamicSizedBox(width: 0.8.w),
                                          getVerticalDivider(),
                                          getDynamicSizedBox(width: 1.8.w),
                                          Text(
                                            data.quantity.toString(),
                                            style: TextStyle(
                                              //fontFamily: fontBold,
                                              color:
                                                  isDarkMode() ? white : black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: SizerUtil.deviceType ==
                                                      DeviceType.mobile
                                                  ? 12.sp
                                                  : 13.sp,
                                            ),
                                          ),
                                          getDynamicSizedBox(width: 1.8.w),
                                          getVerticalDivider(),
                                          GestureDetector(
                                            onTap: () async {
                                              data.quantity!.value += 1;
                                              await UserPreferences().addToCart(
                                                data,
                                                data.quantity!.value,
                                              );
                                              setState(() {});
                                            },
                                            child: Icon(
                                              Icons.add,
                                              size: 3.h,
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ))),
          ],
        ),
      ),
    );
  }
}
