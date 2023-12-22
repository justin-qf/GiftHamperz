import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/controller/OrderController.dart';
import 'package:gifthamperz/models/homeModel.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/views/OrderScreen/OrderDetailScreen/OrderDetailScreen.dart';
import 'package:sizer/sizer.dart';

class AllTabScreen extends StatefulWidget {
  const AllTabScreen({super.key});

  @override
  State<AllTabScreen> createState() => _AllTabScreenState();
}

class _AllTabScreenState extends State<AllTabScreen> {
  var controller = Get.put(OrderScreenController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return ListView.builder(
            shrinkWrap: false,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              bottom: 1.5.h,
              top: 1.h,
            ),
            clipBehavior: Clip.antiAlias,
            itemBuilder: (context, index) {
              OrderItem data = controller.staticData[index];
              return FadeInUp(
                child: Container(
                  margin: EdgeInsets.only(
                      top: 1.h, left: 4.w, right: 4.w, bottom: 1.h),
                  padding: EdgeInsets.only(
                      top: 1.5.h, left: 4.w, right: 4.w, bottom: 1.5.h),
                  decoration: BoxDecoration(
                    border: isDarkMode()
                        ? null
                        : Border.all(
                            color: grey, // Border color
                            width: 0.5, // Border width
                          ),
                    color: isDarkMode() ? itemDarkBackgroundColor : white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: isDarkMode()
                              ? grey.withOpacity(0.2)
                              : grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: const Offset(0.3, 0.3)),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.to(OrderDetailScreen(
                        data: null,
                      ));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Text(
                                data.title.toString(),
                                style: TextStyle(
                                    fontSize: SizerUtil.deviceType ==
                                            DeviceType.mobile
                                        ? 13.sp
                                        : 6.sp,
                                    fontFamily: fontBold,
                                    fontWeight: FontWeight.w700,
                                    color: isDarkMode() ? white : black),
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.more_horiz)
                          ],
                        ),
                        getDynamicSizedBox(height: 0.5.h),
                        Text(
                          data.status.toString(),
                          style: TextStyle(
                              fontSize:
                                  SizerUtil.deviceType == DeviceType.mobile
                                      ? 12.sp
                                      : 6.sp,
                              fontFamily: fontRegular,
                              fontWeight: FontWeight.w600,
                              color: primaryColor),
                        ),
                        getDynamicSizedBox(height: 0.5.h),
                        Row(
                          children: [
                            Text(
                              data.orderDate.toString(),
                              style: TextStyle(
                                  fontSize:
                                      SizerUtil.deviceType == DeviceType.mobile
                                          ? 12.sp
                                          : 6.sp,
                                  fontFamily: fontRegular,
                                  fontWeight:
                                      isDarkMode() ? FontWeight.w900 : null,
                                  color: isDarkMode()
                                      ? itemTextBackgroundColor
                                      : lableColor),
                            ),
                            const Spacer(),
                            Text(
                              data.price.toString(),
                              style: TextStyle(
                                  fontSize:
                                      SizerUtil.deviceType == DeviceType.mobile
                                          ? 12.sp
                                          : 6.sp,
                                  fontFamily: fontRegular,
                                  color: primaryColor),
                            ),
                            const SizedBox(
                              width: 18, // Set the desired width
                              height: 22.0, // Set the desired height
                              child: Icon(
                                Icons.chevron_right_sharp,
                                size: 20,
                                color: primaryColor,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: controller.staticData.length);
      },
    );
  }
}
