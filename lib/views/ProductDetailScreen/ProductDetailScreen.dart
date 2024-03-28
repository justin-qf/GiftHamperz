import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/api_handle/CommonApiStructure.dart';
import 'package:gifthamperz/api_handle/apiOtherStates.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/apicall_constant.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/productDetailController.dart';
import 'package:gifthamperz/preference/UserPreference.dart';
import 'package:gifthamperz/utils/enum.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/CartScreen/CartScreen.dart';
import 'package:gifthamperz/views/DeliveryScreen/AddressScreen.dart';
import 'package:gifthamperz/views/ReviewsScreen/ReviewsScreen.dart';
import 'package:marquee/marquee.dart';
import 'package:sizer/sizer.dart';
import '../../models/UpdateDashboardModel.dart';

// ignore: must_be_immutable
class ProductDetailScreen extends StatefulWidget {
  ProductDetailScreen(this.title, {super.key, this.data});
  CommonProductList? data;
  String title;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  var controller = Get.put(ProductDetailScreenController());

  @override
  void initState() {
    controller.pageController =
        PageController(initialPage: controller.currentPage);
    logcat("CATEFORY_ID", widget.data!.innerSubcategoryId.toString());
    Future.delayed(Duration.zero, () {
      controller.getRecentFav(context, widget.data!.innerSubcategoryId);
    });
    controller.startAutoScroll(widget.data);
    loadStoredQuantity();
    controller.getGuestUser();
    controller.getIsProductAddedToFav(widget.data!.id.toString());
    scrollController.addListener(() {
      setState(() {
        double maxScroll = 27.h - kToolbarHeight;
        double currentScroll = scrollController.offset;
        percentage = (currentScroll / maxScroll).clamp(0.0, 1.0);
      });
    });

    setState(() {});
    super.initState();
  }

  Future<void> loadStoredQuantity() async {
    // Fetch the current cart items from preferences
    List<CommonProductList> cartItems = await UserPreferences().loadCartItems();

    // Check if the product is already in the cart
    int existingIndex = cartItems.indexWhere(
      (item) => item.id == widget.data!.id,
    );

    if (existingIndex != -1) {
      // Product already in the cart, get the stored quantity
      setState(() {
        controller.quantity = cartItems[existingIndex].getStoredQuantity();
      });
    } else {
      // Product not in the cart, set storedQuantity to 0
      setState(() {
        controller.quantity = 0;
      });
    }
  }

  @override
  void dispose() {
    controller.disposePageController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbarProfile(true);
    return CustomParentScaffold(
        onWillPop: () async {
          logcat("onWillPop", "DONE");
          return true;
        },
        isSafeArea: false,
        isFormScreen: true,
        body: Container(
          color: isDarkMode() ? darkBackgroundColor : white,
          child: Obx(() {
            switch (controller.state.value) {
              case ScreenState.apiLoading:
              case ScreenState.noNetwork:
              case ScreenState.noDataFound:
              case ScreenState.apiError:
                return apiOtherStates(controller.state.value, controller,
                    controller.recentProductList, () {});
              case ScreenState.apiSuccess:
                return apiSuccess(controller.state.value);
              default:
                Container();
            }
            return Container();
          }),
        ));
  }

  final ScrollController scrollController = ScrollController();
  double? percentage;
  bool showTitle = false;
  Widget apiSuccess(ScreenState state) {
    if (state == ScreenState.apiSuccess &&
        controller.recentProductList.isNotEmpty) {
      return Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 27.h,
                centerTitle: true,
                clipBehavior: Clip.antiAlias,
                elevation: 0.2,
                floating: false,
                pinned: true,
                stretch: true,
                titleSpacing: 0,
                automaticallyImplyLeading: true,
                backgroundColor: isDarkMode()
                    ? darkBackgroundColor
                    : showTitle == true
                        ? primaryColor
                        : white,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    percentage = ((constraints.maxHeight - kToolbarHeight) /
                            (27.h - kToolbarHeight))
                        .clamp(0.0, 1.0);
                    // bool showTitle = percentage! < 1.0;
                    showTitle = percentage! <= 0.5;
                    return FlexibleSpaceBar(
                        centerTitle: true,
                        titlePadding: EdgeInsets.only(
                            top: isSmallDevice(context)
                                ? 6.3.h
                                : SizerUtil.deviceType == DeviceType.mobile
                                    ? 6.9.h
                                    : 3.2.h,
                            left: 15.w,
                            right: 15.w),
                        title: showTitle
                            ? widget.data!.name.toString().length > 9
                                ? Marquee(
                                    style: TextStyle(
                                      fontFamily: fontRegular,
                                      color: isDarkMode() ? white : black,
                                      fontSize: SizerUtil.deviceType ==
                                              DeviceType.mobile
                                          ? 14.sp
                                          : 12.sp,
                                    ),
                                    text: widget.data!.name.toString(),
                                    scrollAxis: Axis.horizontal,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    blankSpace: 20.0,
                                    velocity: 20,
                                    pauseAfterRound: const Duration(seconds: 1),
                                    accelerationDuration:
                                        const Duration(seconds: 1),
                                    accelerationCurve: Curves.linear,
                                    decelerationDuration:
                                        const Duration(milliseconds: 500),
                                    decelerationCurve: Curves.easeOut,
                                  )
                                : Text(
                                    ProductDetailScreenConstant.title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: fontRegular,
                                      color: isDarkMode() ? white : black,
                                      fontSize: 12.sp,
                                    ),
                                  )
                            : null,
                        background: Container(
                            color: isDarkMode()
                                ? darkBackgroundColor
                                : transparent,
                            child: FadeInDown(
                                child: getDetailScreenPageView(
                                    controller, widget.data!.images, (index) {
                              setState(() {
                                controller.currentPage = index;
                              });
                            })
                                // Stack(children: [
                                //   PageView.builder(
                                //     pageSnapping: true,
                                //     controller: controller.pageController,
                                //     itemCount: widget.data!.images.length,
                                //     itemBuilder: (context, index) {
                                //       return Container(
                                //           margin: EdgeInsets.only(bottom: 0.9.h),
                                //           decoration: BoxDecoration(
                                //               boxShadow: isDarkMode()
                                //                   ? null
                                //                   : [
                                //                       BoxShadow(
                                //                           color: grey
                                //                               .withOpacity(0.5),
                                //                           blurRadius: 1,
                                //                           offset:
                                //                               const Offset(0, 3),
                                //                           spreadRadius: 0.2)
                                //                     ],
                                //               borderRadius: BorderRadius.only(
                                //                   bottomLeft:
                                //                       Radius.circular(7.w),
                                //                   bottomRight:
                                //                       Radius.circular(7.w))),
                                //           child: ClipRRect(
                                //             borderRadius: BorderRadius.only(
                                //                 bottomLeft: Radius.circular(7.w),
                                //                 bottomRight:
                                //                     Radius.circular(7.w)),
                                //             child: CachedNetworkImage(
                                //               fit: BoxFit.cover,
                                //               height: 14.h,
                                //               imageUrl: ApiUrl.imageUrl +
                                //                   widget.data!.images[0],
                                //               placeholder: (context, url) =>
                                //                   const Center(
                                //                 child: CircularProgressIndicator(
                                //                     color: primaryColor),
                                //               ),
                                //               errorWidget:
                                //                   (context, url, error) =>
                                //                       Image.asset(
                                //                 Asset.placeholder,
                                //                 height: 9.h,
                                //                 fit: BoxFit.cover,
                                //               ),
                                //             ),
                                //           ));
                                //     },
                                //     onPageChanged: (index) {
                                //       setState(() {
                                //         controller.currentPage = index;
                                //       });
                                //     },
                                //   ),
                                //   Positioned(
                                //       bottom: 20,
                                //       left: 0,
                                //       right: 0,
                                //       child: Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.center,
                                //         children: List.generate(
                                //             widget.data!.images.length, (index) {
                                //           return Container(
                                //             margin: const EdgeInsets.symmetric(
                                //                 horizontal: 4.0),
                                //             width: 2.w,
                                //             height: 2.w,
                                //             decoration: BoxDecoration(
                                //               shape: BoxShape.circle,
                                //               color:
                                //                   controller.currentPage == index
                                //                       ? primaryColor
                                //                       : white,
                                //               border: Border.all(
                                //                 color: black, // Border color
                                //                 width: 0.5, // Border width
                                //               ),
                                //               boxShadow: [
                                //                 BoxShadow(
                                //                     color: grey.withOpacity(0.2),
                                //                     blurRadius: 5.0,
                                //                     offset: const Offset(0, 1),
                                //                     spreadRadius: 3.0)
                                //               ],
                                //             ),
                                //           );
                                //         }),
                                //       ))
                                // ]),

                                )));
                  },
                ),
                leading: Builder(
                  builder: (context) {
                    return Container(
                      margin: EdgeInsets.only(
                          left: SizerUtil.deviceType == DeviceType.mobile
                              ? 2.w
                              : 2.w),
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                            padding: EdgeInsets.all(
                                SizerUtil.deviceType == DeviceType.mobile
                                    ? 8
                                    : 0),
                            child: SvgPicture.asset(
                              Asset.arrowBack,
                              // ignore: deprecated_member_use
                              color: isDarkMode()
                                  ? showTitle == true
                                      ? Color.lerp(
                                          black, white, percentage ?? 0.0)
                                      : black
                                  : black,
                              height: SizerUtil.deviceType == DeviceType.mobile
                                  ? 4.h
                                  : 5.h,
                            )),
                      ),
                    );
                  },
                ),
                actions: [
                  Builder(
                    builder: (context) {
                      return Container(
                          margin: EdgeInsets.only(
                              right: SizerUtil.deviceType == DeviceType.mobile
                                  ? 2.w
                                  : 3.w),
                          child: GetBuilder<ProductDetailScreenController>(
                            builder: (controller) {
                              return GestureDetector(
                                onTap: () {
                                  if (controller.isGuest!.value == true) {
                                    getGuestUserAlertDialog(context,
                                        ProductDetailScreenConstant.title);
                                  } else {
                                    addFavouriteAPI(
                                        context,
                                        controller.networkManager,
                                        widget.data!.id.toString(),
                                        '1',
                                        ProductDetailScreenConstant.title);
                                  }
                                },
                                child: Obx(
                                  () {
                                    return Container(
                                        padding: EdgeInsets.all(
                                            SizerUtil.deviceType ==
                                                    DeviceType.mobile
                                                ? 10
                                                : 0),
                                        child: Icon(
                                            controller.isLiked!.value == true
                                                ? Icons.favorite_rounded
                                                : Icons.favorite_border,
                                            color: isDarkMode()
                                                ? showTitle == true
                                                    ? Color.lerp(black, white,
                                                        percentage ?? 0.0)
                                                    : black
                                                : black,
                                            size: 3.5.h));
                                  },
                                ),
                              );
                            },
                          ));
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: 5.w,
                        right: 5.w,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getDynamicSizedBox(height: 0.4.h),
                          controller.getLableText(widget.data!.name,
                              isMainTitle: true),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(const ReviewsScreen())!.then((value) {
                                    Statusbar()
                                        .trasparentStatusbarProfile(true);
                                  });
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    RatingBar.builder(
                                      ignoreGestures: true,
                                      initialRating:
                                          widget.data!.averageRating != null
                                              ? widget.data!.averageRating!
                                              : 0,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 4.5.w,
                                      // itemPadding:
                                      //     const EdgeInsets.symmetric(horizontal: 5.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.orange,
                                      ),
                                      onRatingUpdate: (rating) {
                                        logcat("RATING", rating);
                                      },
                                    ),
                                    getDynamicSizedBox(width: 1.w),
                                    Text(
                                        widget.data!.averageRating != null
                                            ? widget.data!.averageRating!
                                                .toString()
                                            : "0 Ratings",
                                        style: TextStyle(
                                          fontFamily: fontBold,
                                          color: isDarkMode() ? white : black,
                                          fontSize: SizerUtil.deviceType ==
                                                  DeviceType.mobile
                                              ? 12.sp
                                              : 10.sp,
                                        )),
                                    getDynamicSizedBox(width: 1.w),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: isDarkMode() ? white : black,
                                      size: 1.8.h,
                                    )
                                  ],
                                ),
                              ),
                              const Spacer(),
                              cartIncrDcrUi(
                                  qty: controller.quantity.toString(),
                                  incrementOnTap: () {
                                    controller.quantity++;
                                    logcat("COUNTER",
                                        controller.quantity.toString());
                                    incrementDecrementCartItem(
                                        isFromIcr: true,
                                        data: widget.data!,
                                        quantity: controller.quantity);
                                    percentage = 0.0;
                                    setState(() {});
                                  },
                                  decrementOnTap: () {
                                    if (controller.quantity > 0) {
                                      controller.quantity--;
                                      incrementDecrementCartItem(
                                          isFromIcr: false,
                                          data: widget.data!,
                                          quantity: controller.quantity);
                                      percentage = 0.0;
                                      setState(() {});
                                    }
                                  }),
                              // Container(
                              //   padding: EdgeInsets.only(
                              //       left: SizerUtil.deviceType ==
                              //               DeviceType.mobile
                              //           ? 2.7.w
                              //           : 2.5.w,
                              //       right: SizerUtil.deviceType ==
                              //               DeviceType.mobile
                              //           ? 2.7.w
                              //           : 2.5.w,
                              //       top: 0.4.h,
                              //       bottom: 0.4.h),
                              //   decoration: BoxDecoration(
                              //       color: isDarkMode()
                              //           ? darkBackgroundColor
                              //           : white,
                              //       boxShadow: [
                              //         BoxShadow(
                              //             color: grey.withOpacity(0.2),
                              //             blurRadius: 1.0,
                              //             offset: const Offset(0, 1),
                              //             spreadRadius: 1.0)
                              //       ],
                              //       borderRadius: BorderRadius.all(
                              //         Radius.circular(5.h),
                              //       )),
                              //   child: Row(
                              //     children: [
                              //       GestureDetector(
                              //         onTap: () async {
                              //           if (controller.quantity > 0) {
                              //             controller.quantity--;
                              //             incrementDecrementCartItem(
                              //                 isFromIcr: false,
                              //                 data: widget.data!,
                              //                 quantity: controller.quantity);
                              //             percentage = 0.0;
                              //             setState(() {});
                              //           }
                              //         },
                              //         child: Icon(
                              //           Icons.remove,
                              //           size: 3.h,
                              //         ),
                              //       ),
                              //       getDynamicSizedBox(
                              //           width: SizerUtil.deviceType ==
                              //                   DeviceType.mobile
                              //               ? 0.8.w
                              //               : 1.w),
                              //       getVerticalDivider(),
                              //       getDynamicSizedBox(
                              //           width: SizerUtil.deviceType ==
                              //                   DeviceType.mobile
                              //               ? 1.8.w
                              //               : 2.w),
                              //       Text(
                              //         controller.quantity.toString(),
                              //         style: TextStyle(
                              //             color: isDarkMode() ? white : black,
                              //             fontWeight: FontWeight.w600,
                              //             fontSize: 12.sp),
                              //       ),
                              //       getDynamicSizedBox(
                              //           width: SizerUtil.deviceType ==
                              //                   DeviceType.mobile
                              //               ? 1.8.w
                              //               : 2.w),
                              //       getVerticalDivider(),
                              //       getDynamicSizedBox(
                              //           width: SizerUtil.deviceType ==
                              //                   DeviceType.mobile
                              //               ? 1.8.w
                              //               : 1.w),
                              //       GestureDetector(
                              //         onTap: () async {
                              //           controller.quantity++;
                              //           logcat("COUNTER",
                              //               controller.quantity.toString());
                              //           incrementDecrementCartItem(
                              //               isFromIcr: true,
                              //               data: widget.data!,
                              //               quantity: controller.quantity);
                              //           percentage = 0.0;
                              //           setState(() {});
                              //         },
                              //         child: Icon(
                              //           Icons.add,
                              //           size: 3.h,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                          getDynamicSizedBox(height: 0.5.h),
                          Text(
                              '${IndiaRupeeConstant.inrCode}${widget.data!.price.toString()}',
                              //textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isDarkMode() ? white : black,
                                fontFamily: fontBold,
                                fontWeight: FontWeight.w700,
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.mobile
                                        ? 15.sp
                                        : 13.sp,
                              )),
                          getDynamicSizedBox(height: 0.5.h),
                          controller.getLableText('About', isMainTitle: false),
                          getDynamicSizedBox(height: 0.5.h),
                          controller.getCommonText(
                              widget.data!.description.toString(),
                              isHint: true),
                          getDynamicSizedBox(
                              height: SizerUtil.deviceType == DeviceType.mobile
                                  ? 1.h
                                  : 0.8.h),
                          controller.getLableText('You Might Also Like',
                              isMainTitle: false),
                          getDynamicSizedBox(height: 1.h),
                        ],
                      ),
                    ),
                    controller.recentProductList.isNotEmpty
                        ? SizedBox(
                            height: 30.h,
                            child: ListView.builder(
                                padding: EdgeInsets.only(
                                  left: 4.5.w,
                                ),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                clipBehavior: Clip.antiAlias,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  CommonProductList data =
                                      controller.recentProductList[index];
                                  return controller.getItemListItem(
                                    data,
                                    context,
                                  );
                                },
                                itemCount: controller.recentProductList.length),
                          )
                        : Container(),
                    getDynamicSizedBox(height: 3.h),
                  ],
                ),
              )
            ],
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: isDarkMode() ? darkBackgroundColor : white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    getCommonContainer('Add to Cart', true, Icons.shopping_cart,
                        addCartClick: () {
                      Get.to(const CartScreen())!.then((value) {
                        Statusbar().trasparentStatusbarProfile(true);
                        percentage = 0.0;
                        loadStoredQuantity();
                      });
                    }),
                    getCommonContainer('Buy Now', false, Icons.shopping_bag,
                        buyNowClick: () async {
                      logcat("Buy", 'Click');
                      if (controller.isGuest!.value == true) {
                        getGuestUserAlertDialog(
                            context, ProductDetailScreenConstant.title);
                      } else {
                        List<CommonProductList> cartItems =
                            await UserPreferences().loadCartItems();
                        // Check if the product is already in the cart
                        int existingIndex = cartItems.indexWhere(
                          (item) => item.id == widget.data!.id,
                        );
                        if (existingIndex != -1) {
                          // Product already in the cart
                          Get.to(AddressScreen(
                            isFromBuyNow: true,
                            id: widget.data!.id,
                          ))!
                              .then((value) {
                            Statusbar().trasparentStatusbarProfile(true);
                          });
                        } else {
                          //Product Not In Cart
                          controller.quantity++;
                          incrementDecrementCartItem(
                              isFromIcr: true,
                              data: widget.data!,
                              quantity: controller.quantity,
                              isFromBuyNow: true);
                          setState(() {});
                        }
                      }
                    }, isEnable: controller.isGuest!.value),
                  ],
                ),
              )),
        ],
      );
    } else {
      return noDataFoundWidget();
    }
  }

  // Widget apiOtherStates(state) {
  //   if (state == ScreenState.apiLoading) {
  //     return Center(
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(100),
  //         child: SizedBox(
  //           height: 30,
  //           width: 30,
  //           child: LoadingAnimationWidget.discreteCircle(
  //             color: primaryColor,
  //             size: 35,
  //           ),
  //         ),
  //       ),
  //     );
  //   }

  //   Widget? button;
  //   if (controller.recentProductList.isEmpty) {
  //     Container();
  //   }
  //   if (state == ScreenState.noDataFound) {
  //     button = getMiniButton(() {
  //       Get.back();
  //     }, BottomConstant.back);
  //   }
  //   if (state == ScreenState.noNetwork) {
  //     button = getMiniButton(() {}, BottomConstant.tryAgain);
  //   }

  //   if (state == ScreenState.apiError) {
  //     button = getMiniButton(() {
  //       Get.back();
  //     }, BottomConstant.back);
  //   }
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Container(
  //           margin: EdgeInsets.symmetric(horizontal: 20.w),
  //           child: controller.message.value.isNotEmpty
  //               ? Text(
  //                   controller.message.value,
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                       fontFamily: fontMedium,
  //                       fontSize: 12.sp,
  //                       color: isDarkMode() ? white : black),
  //                 )
  //               : button),
  //     ],
  //   );
  // }
}
