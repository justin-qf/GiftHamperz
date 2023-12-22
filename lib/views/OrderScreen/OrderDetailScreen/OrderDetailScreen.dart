import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/OrderDetailController.dart';
import 'package:gifthamperz/models/OrderModel.dart';
import 'package:gifthamperz/models/homeModel.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:sizer/sizer.dart';

class OrderDetailScreen extends StatefulWidget {
  OrderDetailScreen({super.key, required this.data});
  OrderData? data;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  var controller = Get.put(OrderDetailScreenController());

  @override
  void initState() {
    controller.orderDetailList.addAll(widget.data!.orderDetails);
    controller.setOrderTotalAmount(widget.data);
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbarIsNormalScreen();
    return CustomParentScaffold(
      onWillPop: () async {
        logcat("onWillPop", "DONE");
        return true;
      },
      isSafeArea: false,
      isNormalScreen: true,
      body: Container(
        color: isDarkMode() ? darkBackgroundColor : transparent,
        child: Column(children: [
          getOrderToolbar(
            OrderDetailScreenConstant.title,
          ),
          getDynamicSizedBox(height: 2.5.h),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  controller.getLableText('Order ID:  ${widget.data!.orderId}',
                      isMainTitle: true),
                  //controller.getColorText('Delivered'),
                  controller.getCommonText(
                      'Order Date: ${getFormateDate(widget.data!.dateOfOrder.toString())}'),
                  getDynamicSizedBox(height: 2.h),
                  controller.getLableText('Your Orders List',
                      isMainTitle: false),
                  getDynamicSizedBox(height: 0.5.h),
                  SizedBox(
                    height: 25.h,
                    child: Obx(
                      () {
                        return controller.orderDetailList.isNotEmpty
                            ? ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: false,
                                padding: EdgeInsets.only(left: 4.w),
                                scrollDirection: Axis.horizontal,
                                clipBehavior: Clip.antiAlias,
                                itemBuilder: (context, index) {
                                  // CategoryItem data =
                                  //     controller.categoryList[index];
                                  // return controller.getCategoryListItem(data);
                                  OrderDetail data =
                                      controller.orderDetailList[index];
                                  logcat("categoryList", data.name.toString());
                                  return controller
                                      .getOrderDetailItemList(data);
                                },
                                itemCount: controller.orderDetailList.length)
                            : Container();
                      },
                    ),
                  ),
                  // Obx(
                  //   () {
                  //     return ListView.builder(
                  //         shrinkWrap: true,
                  //         physics: const NeverScrollableScrollPhysics(),
                  //         scrollDirection: Axis.horizontal,
                  //         clipBehavior: Clip.antiAlias,
                  //         itemBuilder: (context, index) {
                  //           OrderDetail data =
                  //               controller.orderDetailList[index];
                  //           if (controller.orderDetailList.length > 2) {
                  //             return controller.getOrderDetailItemList(data);
                  //           } else {
                  //             return controller.getOrderDetailItemList(data);
                  //           }
                  //           // return controller.getOrderDetailItemList(data);
                  //         },
                  //         itemCount: controller.orderList.length);
                  //   },
                  // ),
                  getDynamicSizedBox(height: 0.5.h),
                  // controller.getLableText('Gift Cards', isMainTitle: false),
                  // getDynamicSizedBox(height: 0.5.h),
                  // ListView.builder(
                  //     physics: const NeverScrollableScrollPhysics(),
                  //     shrinkWrap: true,
                  //     scrollDirection: Axis.vertical,
                  //     clipBehavior: Clip.antiAlias,
                  //     itemBuilder: (context, index) {
                  //       OrderItem data = controller.orderList[index];
                  //       return controller.getGiftListItem(data);
                  //     },
                  //     itemCount: 1),
                  controller.getLableText('Delivery Informations',
                      isMainTitle: false),
                  getDynamicSizedBox(height: 0.5.h),
                  controller.getCommonText('Delivery Address'),
                  getDynamicSizedBox(height: 0.5.h),
                  controller.getCommonText(
                      '${widget.data!.address}. ${widget.data!.shippingAddressPincode}'),
                  // getDynamicSizedBox(height: 1.h),
                  // controller
                  //     .getCommonText('Additional instruction to Driver'),
                  // getDynamicSizedBox(height: 1.h),
                  // controller.getCommonText(
                  //     'Lorenm ipsum doler sit amet, consectur adipiscing elite. Phasellus lacus massa, Placerat eu sapien sed, bibendum eleifend libera.',
                  //     isHint: true),
                  getDynamicSizedBox(height: 1.h),
                  controller.getCommonText(
                      'Delivery Date: ${getFormateDate(widget.data!.dateOfDelivery.toString())}'),
                  getDynamicSizedBox(height: 1.h),
                  controller.getCommonText(
                      'Delivery Time: ${convert24HourTo12Hour(widget.data!.timeOfDelivery.toString())}'),
                  getDynamicSizedBox(height: 1.h),
                  controller.getLableText('Order Summary'),
                  getDynamicSizedBox(height: 1.h),
                  controller.getOrderText(
                      'Product Cost', '\u{20B9}${widget.data!.totalAmount}',
                      isNormal: true),
                  getDynamicSizedBox(height: 1.h),
                  controller.getOrderText(
                      'Shiping Charge', '\u{20B9}${widget.data!.shipingCharge}',
                      isNormal: true),
                  getDynamicSizedBox(height: 1.h),
                  controller.getOrderText(
                      'Discount', '-\u{20B9}${widget.data!.discount}',
                      isNormal: true),
                  getDynamicSizedBox(height: 1.h),
                  controller.getOrderText(
                      'Total', '\u{20B9}${controller.totalAmount}',
                      isNormal: false),
                  getDynamicSizedBox(height: 3.h),
                  Container(
                    margin: EdgeInsets.only(
                      left: 5.w,
                      right: 5.w,
                    ),
                    child: FadeInUp(
                      from: 50,
                      child: getSecondaryFormButton(() {}, Button.check,
                          isvalidate: true),
                    ),
                  ),
                  getDynamicSizedBox(height: 3.h),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
