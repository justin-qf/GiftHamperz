import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/BlogScreenController.dart';
import 'package:gifthamperz/models/BlogModel.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:sizer/sizer.dart';

class BlogDetailScreen extends StatefulWidget {
  BlogDetailScreen({super.key, required this.data});
  BlogDataList data;

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  var controller = Get.put(BlogScreenController());

  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbarIsNormalScreen();
    return CustomParentScaffold(
      onWillPop: () async {
        logcat("onWillPop", "DONE");
        return true;
      },
      onTap: () {
        controller.hideKeyboard(context);
      },
      isSafeArea: false,
      isNormalScreen: true,
      body: Container(
        color: isDarkMode() ? darkBackgroundColor : transparent,
        child: Column(children: [
          getOrderToolbar(BlogScreenConstant.title),
          getDynamicSizedBox(height: 2.0.h),
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: 10.h,
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: FadeInUp(
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 1.h, left: 4.w, right: 4.w, bottom: 1.h),
                      padding: EdgeInsets.only(
                          top: 16.h, left: 4.w, right: 4.w, bottom: 1.h),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.data.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: isDarkMode() ? white : black,
                                fontFamily: fontBold,
                                fontWeight: FontWeight.w900,
                                fontSize: 13.sp),
                          ),
                          getDynamicSizedBox(height: 1.h),
                          Container(
                            width: 40.w,
                            height: 0.3.h,
                            decoration: const BoxDecoration(
                                color: primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                          ),
                          getDynamicSizedBox(height: 1.h),
                          Expanded(
                            child: Scrollbar(
                              trackVisibility: true,
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    widget.data.description,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: isDarkMode() ? white : black,
                                        fontFamily: fontRegular,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11.sp),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 10.w,
                  left: 10.w,
                  child: FadeInDown(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        height: 25.h,
                        imageUrl: APIImageUrl.url + widget.data.imgUrl,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          Asset.productPlaceholder,
                          height: 25.h,
                          width: 25.h,
                          fit: BoxFit.cover,
                        ),
                        imageBuilder: (context, imageProvider) => Image(
                          image: imageProvider,
                          height: 25.h,
                          width: 25.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
