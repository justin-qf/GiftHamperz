import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          getDynamicSizedBox(
              height:
                  SizerUtil.deviceType == DeviceType.mobile ? 2.5.h : 1.8.h),
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
                                  CommonProductList data =
                                      controller.orderDetailList[index];
                                  return controller.getListItem(data);
                                },
                                itemCount: controller.orderDetailList.length)
                            : Container();
                      },
                    ),
                  ),
                  getDynamicSizedBox(height: 0.5.h),
                  controller.getLableText('Delivery Status:',
                      isMainTitle: false),
                  getDynamicSizedBox(height: 0.5.h),
                  Container(
                    margin: const EdgeInsets.only(bottom: 0),
                    child: EasyStepper(
                      activeStep: activeStep,
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
                  controller.getLableText('Delivery Informations',
                      isMainTitle: false),
                  getDynamicSizedBox(height: 0.5.h),
                  controller.getCommonText('Delivery Address:'),
                  getDynamicSizedBox(height: 0.5.h),
                  controller.getCommonText(controller.userName!.toUpperCase(),
                      isfromAddressName: true),
                  getDynamicSizedBox(height: 0.5.h),
                  controller.getCommonText(
                      '${widget.data!.address}. ${widget.data!.shippingAddressPincode}'),
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
