import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/CartController.dart';
import 'package:gifthamperz/models/homeModel.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/views/DeliveryScreen/AddressScreen.dart';
import 'package:sizer/sizer.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var controller = Get.put(CartScreenController());

  @override
  void initState() {
    controller.getTotal();

    super.initState();
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
                  child: controller.cartItems.isNotEmpty
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
                                                CartItem data =
                                                    controller.cartItems[index];
                                                return controller
                                                    .getListItem(data);
                                              },
                                              itemCount:
                                                  controller.cartItems.length),
                                          getDynamicSizedBox(height: 0.5.h),
                                        ],
                                      ))),
                            ],
                          ),
                        )
                      : FadeInDown(
                          child: SizedBox(
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
                                  padding:
                                      EdgeInsets.only(left: 5.w, right: 5.w),
                                  child: Text(
                                      'Your basket is empty\nAdd your item and buy what you want us',
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
                        ),
                )
              ],
            ),
            controller.cartItems.isNotEmpty
                ? Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        // Positioned.fill(
                        //   child: ClipRRect(
                        //     borderRadius: BorderRadius.only(
                        //         topLeft: Radius.circular(
                        //             SizerUtil.deviceType == DeviceType.mobile
                        //                 ? 3.5.w
                        //                 : 2.5.w),
                        //         topRight: Radius.circular(
                        //             SizerUtil.deviceType == DeviceType.mobile
                        //                 ? 3.5.w
                        //                 : 2.5.w)),
                        //     child: Container(
                        //       decoration: BoxDecoration(
                        //         gradient: LinearGradient(
                        //           begin: Alignment.topCenter,
                        //           end: Alignment.topCenter,
                        //           colors: [
                        //             grey.withOpacity(isDarkMode() ? 0.9 : 0.6),
                        //             grey
                        //           ],
                        //         ),
                        //         boxShadow: [
                        //           BoxShadow(
                        //             color: grey.withOpacity(0.2),
                        //             blurRadius: 10.0,
                        //             offset: const Offset(
                        //                 0, -3), // Negative offset on y-axis
                        //             spreadRadius: 3.0,
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
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
                                      child: getSecondaryFormButton(() {
                                        Get.to(const AddressScreen());
                                      }, Button.checkOut, isvalidate: true),
                                    ),
                                  ),
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
}
