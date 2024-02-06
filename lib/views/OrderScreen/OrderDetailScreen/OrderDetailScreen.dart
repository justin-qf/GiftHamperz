import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:gifthamperz/models/UpdateDashboardModel.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_stepper/easy_stepper.dart';

// ignore: must_be_immutable
class OrderDetailScreen extends StatefulWidget {
  OrderDetailScreen({super.key, required this.data});
  OrderData? data;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  var controller = Get.put(OrderDetailScreenController());

  int activeStep = 3;
  double progress = 0.3;

  void increaseProgress() {
    if (progress < 1) {
      setState(() => progress += 0.3);
    } else {
      setState(() => progress = 0);
    }
  }

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
                  getDynamicSizedBox(height: 1.h),
                  SizedBox(
                    child: Obx(
                      () {
                        return controller.orderDetailList.isNotEmpty
                            ? ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsets.only(left: 4.w),
                                scrollDirection: Axis.vertical,
                                clipBehavior: Clip.antiAlias,
                                itemBuilder: (context, index) {
                                  // CategoryItem data =
                                  //     controller.categoryList[index];
                                  // return controller.getCategoryListItem(data);
                                  CommonProductList data =
                                      controller.orderDetailList[index];
                                  logcat("categoryList", data.name.toString());
                                  return controller.getListItem(data);
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
                  controller.getLableText('Delivery Status:',
                      isMainTitle: false),
                  getDynamicSizedBox(height: 0.5.h),
                  Container(
                    margin: const EdgeInsets.only(bottom: 0),
                    //color: grey,
                    child: EasyStepper(
                      activeStep: activeStep,
                      //padding: EdgeInsets.only(top: 0.5.h, bottom: 0),
                      showScrollbar: true,
                      lineStyle: LineStyle(
                          lineLength: 93,
                          lineThickness: 1,
                          lineSpace: 5,
                          activeLineColor: isDarkMode() ? white : primaryColor,
                          defaultLineColor: isDarkMode() ? white : grey),
                      stepRadius: 20,
                      activeStepTextColor: isDarkMode() ? white : primaryColor,
                      finishedStepTextColor: isDarkMode() ? grey : black,
                      alignment: Alignment.center,
                      unreachedStepIconColor: primaryColor,
                      activeStepIconColor: lightGrey,
                      finishedStepIconColor: tileColour,
                      unreachedStepBorderColor: Colors.black54,
                      unreachedStepTextColor: isDarkMode() ? grey : black,
                      finishedStepBackgroundColor: primaryColor,
                      showLoadingAnimation: false,
                      activeStepBorderColor: primaryColor,
                      steps: const [
                        EasyStep(
                          icon: Icon(
                            Icons.my_location,
                            color: secondaryColor,
                          ),
                          enabled: true,
                          title: 'Placed',
                          lineText: '1.7 KM',
                        ),
                        EasyStep(
                          icon: Icon(CupertinoIcons.cube_box),
                          title: 'On The Way',
                          lineText: '3 KM',
                          enabled: true,
                        ),
                        EasyStep(
                          icon: Icon(CupertinoIcons.flag),
                          title: 'Completed',
                          enabled: true,
                        ),
                      ],
                      onStepReached: (index) =>
                          setState(() => activeStep = index),
                    ),
                  ),
                  // Container(
                  //   color: Colors.grey.shade200,
                  //   // clipBehavior: Clip.none,
                  //   child: EasyStepper(
                  //     activeStep: activeStep,
                  //     enableStepTapping: true,
                  //     alignment: Alignment.topLeft,
                  //     direction: Axis.vertical,
                  //     lineStyle: const LineStyle(
                  //         lineLength: 100,
                  //         lineSpace: 5,
                  //         lineThickness: 1.5,
                  //         defaultLineColor: Colors.orange,
                  //         finishedLineColor: primaryColor,
                  //         lineType: LineType.normal,
                  //         unreachedLineType: LineType.dashed,
                  //         activeLineColor: primaryColor),
                  //     stepBorderRadius: 30,
                  //     stepShape: StepShape.rRectangle,
                  //     stepRadius: 20,
                  //     finishedStepBorderColor: primaryColor,
                  //     finishedStepTextColor: black,
                  //     finishedStepBackgroundColor: primaryColor,
                  //     activeStepIconColor: black,
                  //     showLoadingAnimation: false,
                  //     activeStepTextColor: black,
                  //     internalPadding: 5,
                  //     showStepBorder: true,
                  //     // activeStep: activeStep,
                  //     // alignment: Alignment.topLeft,
                  //     // direction: Axis.vertical,
                  //     // lineStyle: const LineStyle(
                  //     //   lineLength: 70,
                  //     //   lineSpace: 0,
                  //     //   lineType: LineType.normal,
                  //     //   defaultLineColor: Colors.white,
                  //     //   finishedLineColor: Colors.orange,
                  //     //   lineThickness: 1.5,
                  //     // ),
                  //     // activeStepTextColor: Colors.black87,
                  //     // finishedStepTextColor: Colors.black87,
                  //     // internalPadding: 0,
                  //     // showLoadingAnimation: false,
                  //     // stepRadius: 8,
                  //     // showStepBorder: false,
                  //     steps: [
                  //       EasyStep(
                  //         customStep: CircleAvatar(
                  //           radius: 8,
                  //           backgroundColor: tileColour,
                  //           child: CircleAvatar(
                  //             radius: 7,
                  //             backgroundColor:
                  //                 activeStep >= 0 ? secondTile : Colors.white,
                  //           ),
                  //         ),
                  //         title: 'Waiting',
                  //       ),
                  //       EasyStep(
                  //         customStep: CircleAvatar(
                  //           radius: 8,
                  //           backgroundColor: tileColour,
                  //           child: CircleAvatar(
                  //             radius: 7,
                  //             backgroundColor:
                  //                 activeStep >= 1 ? secondTile : Colors.white,
                  //           ),
                  //         ),
                  //         title: 'Order Received',
                  //         //topTitle: true,
                  //       ),
                  //       EasyStep(
                  //         customStep: CircleAvatar(
                  //           radius: 8,
                  //           backgroundColor: tileColour,
                  //           child: CircleAvatar(
                  //             radius: 7,
                  //             backgroundColor:
                  //                 activeStep >= 2 ? secondTile : black,
                  //           ),
                  //         ),
                  //         title: 'Preparing',
                  //       ),
                  //       EasyStep(
                  //         customStep: CircleAvatar(
                  //           radius: 8,
                  //           backgroundColor: tileColour,
                  //           child: CircleAvatar(
                  //             radius: 7,
                  //             backgroundColor:
                  //                 activeStep >= 3 ? secondTile : black,
                  //           ),
                  //         ),
                  //         title: 'On Way',
                  //         //topTitle: true,
                  //       ),
                  //       EasyStep(
                  //         customStep: CircleAvatar(
                  //           radius: 8,
                  //           backgroundColor: tileColour,
                  //           child: CircleAvatar(
                  //             radius: 7,
                  //             backgroundColor:
                  //                 activeStep >= 4 ? secondTile : black,
                  //           ),
                  //         ),
                  //         title: 'Delivered',
                  //       ),
                  //     ],
                  //     onStepReached: (index) =>
                  //         setState(() => activeStep = index),
                  //   ),
                  // ),
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
                  controller.getOrderText('Product Cost',
                      '${IndiaRupeeConstant.inrCode}${formatPrice(double.parse(controller.finalProductCost.value.toString()))}',
                      isNormal: true),
                  getDynamicSizedBox(height: 1.h),
                  controller.getOrderText('Shiping Charge',
                      '${IndiaRupeeConstant.inrCode}${widget.data!.shipingCharge}',
                      isNormal: true),
                  getDynamicSizedBox(height: 1.h),
                  controller.getOrderText('Discount',
                      '-${IndiaRupeeConstant.inrCode}${widget.data!.discount}',
                      isNormal: true),
                  getDynamicSizedBox(height: 1.h),
                  controller.getOrderText('Total',
                      '${IndiaRupeeConstant.inrCode}${formatPrice(double.parse(widget.data!.totalAmount))}',
                      isNormal: false),
                  //getDynamicSizedBox(height: 3.h),
                  // Container(
                  //   margin: EdgeInsets.only(
                  //     left: 5.w,
                  //     right: 5.w,
                  //   ),
                  //   child: FadeInUp(
                  //     from: 50,
                  //     child: getSecondaryFormButton(() {}, Button.check,
                  //         isvalidate: true),
                  //   ),
                  // ),
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
