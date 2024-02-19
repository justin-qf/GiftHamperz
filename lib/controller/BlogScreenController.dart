import 'dart:async';
import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/models/BlogModel.dart';
import 'package:gifthamperz/models/blogTypeModel.dart';
import 'package:gifthamperz/models/homeModel.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/BlogScreen/BlogDetailScreen.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';
import '../utils/enum.dart';
import 'internet_controller.dart';

class BlogScreenController extends GetxController {
  List pageNavigation = [];
  RxInt currentTreeView = 2.obs;
  RxBool isLiked = true.obs;
  RxBool isTreeModeVertical = true.obs;
  RxBool accessToDrawer = false.obs;
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  RxBool isLoading = false.obs;
  RxBool isShowMoreLoading = false.obs;
  final InternetController networkManager = Get.find<InternetController>();
  late TabController tabController;
  var currentPage = 0;
  String? selectedBlogTypeId;

  RxList<OrderItem> staticData = <OrderItem>[
    OrderItem(
        title: "Order #0012",
        status: "On its day",
        orderDate: "4/4/2023",
        price: "\$128.69"),
    OrderItem(
        title: "Order #0013",
        status: "Canceled",
        orderDate: "5/4/2023",
        price: "\$128.69"),
    OrderItem(
        title: "Order #0014",
        status: "Delivered",
        orderDate: "6/4/2023",
        price: "\$128.69"),
    OrderItem(
        title: "Order #0015",
        status: "Delivered",
        orderDate: "7/4/2023",
        price: "\$128.69"),
    OrderItem(
        title: "Order #0016",
        status: "Delivered",
        orderDate: "8/4/2023",
        price: "\$128.69"),
    OrderItem(
        title: "Order #0017",
        status: "Delivered",
        orderDate: "9/4/2023",
        price: "\$128.69"),
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

  RxList blogTypeList = [].obs;
  void getBlogTypeList(context) async {
    state.value = ScreenState.apiLoading;
    try {
      if (networkManager.connectionType == 0) {
        state.value = ScreenState.apiSuccess;
        showDialogForScreen(
            context, BlogScreenConstant.title, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      var response =
          await Repository.get({}, ApiUrl.getBlogTypeList, allowHeader: false);
      logcat("RESPONSE::", response.body);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          var blogTypeData = BlogTypeModel.fromJson(responseData);
          blogTypeList.clear();
          if (blogTypeData.data.isNotEmpty) {
            blogTypeList.addAll(blogTypeData.data);
            update();
          }
          if (blogTypeList.isNotEmpty) {
            String firstSubCategoryId = blogTypeList.first.id.toString();
            selectedBlogTypeId = firstSubCategoryId.toString();
            getBlogList(context, 0, firstSubCategoryId, false);
          }
        } else {
          message.value = responseData['message'];
          showDialogForScreen(
              context, BlogScreenConstant.title, responseData['message'],
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(
            context, BlogScreenConstant.title, ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      logcat("Ecxeption", e);
      state.value = ScreenState.apiError;
      message.value = ServerError.servererror;
      showDialogForScreen(
          context, BlogScreenConstant.title, ServerError.servererror,
          callback: () {});
    }
  }

  RxList blogList = [].obs;
  RxString nextPageURL = "".obs;

  void getBlogList(
    context,
    currentPage,
    String blogTypeId,
    bool hideloading, {
    bool? showMoreloading,
    bool? isRefress,
  }) async {
    var loadingIndicator = LoadingProgressDialog();
    if (hideloading == true) {
      state.value = ScreenState.apiLoading;
    } else if (showMoreloading == true) {
      showMoreloading = true;
      update();
    } else {
      loadingIndicator.show(context, '');
      // isLoading.value = true;
      update();
    }

    try {
      if (networkManager.connectionType == 0) {
        showDialogForScreen(
            context, BlogScreenConstant.title, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      var pageURL = '${ApiUrl.getBlogList}?page=$currentPage';
      logcat("URL", pageURL.toString());
      var response = await Repository.post(
          {"blog_type_id": int.parse(blogTypeId)}, pageURL,
          allowHeader: false);
      Statusbar().trasparentStatusbarIsNormalScreen();
      //isLoading.value = false;
      if (hideloading != true) {
        loadingIndicator.hide(
          context,
        );
      }
      // loadingIndicator.hide(context);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data['status'] == 1) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          update();
          var responseData = BlogModel.fromJson(data);

          if (isRefress == true) {
            blogList.clear();
          }
          if (responseData.data.data.isNotEmpty) {
            blogList.addAll(responseData.data.data);
            blogList.refresh();
          }
          if (responseData.data.nextPageUrl != 'null' &&
              responseData.data.nextPageUrl != null) {
            nextPageURL.value = responseData.data.nextPageUrl.toString();
            update();
          } else {
            nextPageURL.value = "";
            update();
          }
          update();
        } else {
          isLoading.value = false;
          message.value = data['message'];
          state.value = ScreenState.apiError;
          showDialogForScreen(
              context, BlogScreenConstant.title, data['message'].toString(),
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        isLoading.value = false;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(
            context, BlogScreenConstant.title, data['message'].toString(),
            callback: () {});
      }
    } catch (e) {
      if (hideloading != true) {
        loadingIndicator.hide(
          context,
        );
      }
      isLoading.value = false;
      state.value = ScreenState.apiError;
      message.value = ServerError.servererror;
    }
  }

  getBlogListItemUi(
      BuildContext context, BlogDataList data, int index, bool isRight) {
    return FadeInUp(
      child: GestureDetector(
        onTap: () {
          Get.to(BlogDetailScreen(
            data: data,
          ));
        },
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 18.h,
                margin: EdgeInsets.only(
                    top: 1.h,
                    bottom: 1.h,
                    left: isRight ? 4.w : 18.w,
                    right: isRight ? 18.w : 4.w),
                padding: EdgeInsets.only(
                    top: 2.h,
                    bottom: 2.h,
                    left: isRight ? 3.w : 19.w,
                    right: isRight ? 20.w : 2.w),
                decoration: BoxDecoration(
                  border: isDarkMode()
                      ? null
                      : Border.all(
                          color: grey,
                          width: 0.5,
                        ),
                  color: isDarkMode() ? itemDarkBackgroundColor : white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode()
                          ? grey.withOpacity(0.0)
                          : grey.withOpacity(0.1),
                      spreadRadius: isDarkMode() ? 0 : 2,
                      blurRadius: isDarkMode() ? 0 : 6,
                      offset: const Offset(0.3, 0.3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(
                            data.title.toString(),
                            maxLines: 2,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize:
                                  SizerUtil.deviceType == DeviceType.mobile
                                      ? 13.sp
                                      : 6.sp,
                              fontFamily: fontBold,
                              fontWeight: FontWeight.w700,
                              color: isDarkMode() ? black : black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    getDynamicSizedBox(height: 0.5.h),
                    AbsorbPointer(
                        absorbing: true,
                        child: ReadMoreText(
                          data.shortDescription.toString(),
                          textAlign: TextAlign.start,
                          trimLines: 3,
                          callback: (val) {
                            logcat("ONTAP", val.toString());
                          },
                          colorClickableText: isDarkMode()
                              ? black
                              : primaryColor, // Customize link color if desired
                          trimMode: TrimMode.Line,
                          trimCollapsedText:
                              '...Show more', // Add your custom "Show More" text
                          trimExpandedText:
                              '', // Set this to an empty string to hide "Show Less" text
                          delimiter:
                              ' ', // Or use another character as your delimiter
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? 11.sp
                                : 10.sp,
                            fontFamily: fontRegular,
                            fontWeight: isDarkMode() ? FontWeight.w900 : null,
                            color: isDarkMode() ? grey : lableColor,
                          ),
                          lessStyle: TextStyle(
                            fontFamily: fontMedium,
                            fontSize: 1.2.h,
                          ), // Customize style for collapsed text
                          moreStyle: TextStyle(
                              fontFamily: fontBold,
                              fontSize: 1.5.h,
                              color:
                                  primaryColor), // Customize style for expanded text
                        )),
                    getDynamicSizedBox(height: 0.5.h),
                  ],
                ),
              ),
            ),
            Positioned(
              right: isRight ? 4.w : null,
              left: isRight ? null : 4.w,
              top: 3.h,
              bottom: 3.h,
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode() ? itemDarkBackgroundColor : white,
                  border: isDarkMode()
                      ? null
                      : Border.all(
                          color: grey,
                          width: 0.2,
                        ),
                  borderRadius: BorderRadius.circular(
                    SizerUtil.deviceType == DeviceType.mobile ? 3.5.w : 2.5.w,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    SizerUtil.deviceType == DeviceType.mobile ? 3.5.w : 2.5.w,
                  ),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: 30.w,
                    height: 20.h,
                    imageUrl: APIImageUrl.url + data.imgUrl,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      Asset.placeholder,
                      height: 9.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Object?> showRequestCatDialod(BuildContext context, text) {
    return showGeneralDialog(
      barrierLabel: "showMore",
      barrierDismissible: false,
      barrierColor: transparent.withOpacity(0.7),
      transitionDuration: const Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            // color: isDarkMode() ? darkBackgroundColor : white,
            height: SizerUtil.height / 2.5,
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7),
            margin: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
            child: SizedBox.expand(
                child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: isDarkMode() ? darkBackgroundColor : white,
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 1.h, bottom: 1.h, left: 5.w, right: 5.w),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              Center(
                                child: Text('Blog',
                                    style: TextStyle(
                                      fontSize: 2.5.h,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: fontBold,
                                      color: isDarkMode() ? white : black,
                                    )),
                              ),
                              const Spacer(),
                              GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Stack(
                                    children: [
                                      Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding: const EdgeInsets.all(6),
                                            child: Icon(
                                              Icons.cancel,
                                              color: primaryColor,
                                              size: 22.sp,
                                            ),
                                          )),
                                    ],
                                  ))
                            ],
                          ),
                          Divider(
                            height: 1.h,
                            color: isDarkMode() ? white : black,
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(text,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: fontRegular,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ))),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }

  Widget getBlogListItem(BuildContext context, BlogDataList data, int index) {
    if (index.isEven) {
      return getBlogListItemUi(context, data, index, false);
    } else {
      return getBlogListItemUi(context, data, index, true);
    }
  }
}
