import 'dart:async';
import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/api_handle/CommonApiStructure.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/productDetailController.dart';
import 'package:gifthamperz/models/DashboadModel.dart';
import 'package:gifthamperz/preference/UserPreference.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/CartScreen/CartScreen.dart';
import 'package:gifthamperz/views/ReviewsScreen/ReviewsScreen.dart';
import 'package:marquee/marquee.dart';
import 'package:sizer/sizer.dart';

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
  bool? isGuest = true;

  @override
  void initState() {
    controller.pageController =
        PageController(initialPage: controller.currentPage);
    startAutoScroll();
    loadStoredQuantity();
    getGuestUser();
    //controller.loadStoredQuantity(widget.data);
    super.initState();
  }

  getGuestUser() async {
    isGuest = await UserPreferences().getGuestUser();
    setState(() {});
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

  void startAutoScroll() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      controller.timer =
          Timer.periodic(const Duration(seconds: 3), (Timer timer) {
        if (controller.currentPage < controller.bannerItems.length - 1) {
          controller.currentPage++;
        } else {
          controller.currentPage = 0;
        }
        if (controller.pageController.hasClients) {
          controller.pageController.animateToPage(
            controller.currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    controller.pageController.dispose();
    controller.timer.cancel();
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
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 28.h,
                    centerTitle: true,
                    clipBehavior: Clip.antiAlias,
                    elevation: 0.2,
                    floating: false,
                    pinned: true,
                    stretch: true,
                    backgroundColor: isDarkMode() ? darkBackgroundColor : white,
                    flexibleSpace: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        double percentage =
                            ((constraints.maxHeight - kToolbarHeight) /
                                    (28.h - kToolbarHeight))
                                .clamp(0.0, 1.0);
                        bool showTitle = percentage < 1.0;
                        return FlexibleSpaceBar(
                            centerTitle: true,
                            title: showTitle
                                ? widget.data!.name.toString().length > 9
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            top: isSmallDevice(context)
                                                ? 6.3.h
                                                : 7.h,
                                            left: 15.w,
                                            right: 15.w),
                                        child: Marquee(
                                          style: TextStyle(
                                            fontFamily: fontRegular,
                                            color: isDarkMode() ? white : black,
                                            fontSize: 14.sp,
                                          ),
                                          text: widget.data!.name.toString(),
                                          scrollAxis: Axis.horizontal,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          blankSpace: 20.0,
                                          velocity: 20,
                                          pauseAfterRound:
                                              const Duration(seconds: 1),
                                          startPadding: 10.w,
                                          accelerationDuration:
                                              const Duration(seconds: 1),
                                          accelerationCurve: Curves.linear,
                                          decelerationDuration:
                                              const Duration(milliseconds: 500),
                                          decelerationCurve: Curves.easeOut,
                                        ),
                                      )
                                    : Text(
                                        'Product Detail',
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
                                  child: SizedBox(
                                      height: 30.h,
                                      child: Stack(children: [
                                        PageView.builder(
                                          pageSnapping: true,
                                          controller: controller.pageController,
                                          itemCount:
                                              controller.bannerItems.length,
                                          itemBuilder: (context, index) {
                                            return ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(7.w),
                                                    bottomRight:
                                                        Radius.circular(7.w)),
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  height: 15.h,
                                                  imageUrl: APIImageUrl.url +
                                                      widget.data!.images,
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                            color:
                                                                primaryColor),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Image.asset(
                                                    Asset.placeholder,
                                                    height: 9.h,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ));
                                          },
                                          onPageChanged: (index) {
                                            setState(() {
                                              controller.currentPage = index;
                                            });
                                          },
                                        ),
                                        Positioned(
                                            bottom: 10,
                                            left: 0,
                                            right: 0,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: List.generate(
                                                  controller.bannerItems.length,
                                                  (index) {
                                                return Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 4.0),
                                                  width: 2.w,
                                                  height: 2.w,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: controller
                                                                .currentPage ==
                                                            index
                                                        ? primaryColor
                                                        : white,
                                                    border: Border.all(
                                                      color:
                                                          black, // Border color
                                                      width:
                                                          0.5, // Border width
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: grey
                                                              .withOpacity(0.2),
                                                          blurRadius: 5.0,
                                                          offset: const Offset(
                                                              0, 1),
                                                          spreadRadius: 3.0)
                                                    ],
                                                  ),
                                                );
                                              }),
                                            ))
                                      ])),
                                )));
                      },
                    ),
                    leading: Container(
                      margin: EdgeInsets.only(
                          left: SizerUtil.deviceType == DeviceType.mobile
                              ? 2.w
                              : 2.w),
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            child: SvgPicture.asset(
                              Asset.arrowBack,
                              // ignore: deprecated_member_use
                              color: isDarkMode() ? black : black,
                              height: SizerUtil.deviceType == DeviceType.mobile
                                  ? 4.h
                                  : 5.h,
                            )),
                      ),
                    ),
                    actions: [
                      Container(
                        margin: EdgeInsets.only(
                            right: SizerUtil.deviceType == DeviceType.mobile
                                ? 2.w
                                : 3.w),
                        child: GestureDetector(
                          onTap: () {
                            if (isGuest == true) {
                              getGuestUserAlertDialog(context);
                            } else {
                              addFavouriteAPI(
                                  context,
                                  controller.networkManager,
                                  widget.data!.id.toString(),
                                  '1',
                                  ProductDetailScreenConstant.title);
                            }
                          },
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                Icons.favorite_rounded,
                                color: isDarkMode() ? black : black,
                                size: SizerUtil.deviceType == DeviceType.mobile
                                    ? 3.5.h
                                    : 5.h,
                              )),
                        ),
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
                              getDynamicSizedBox(height: 1.h),
                              controller.getLableText(widget.data!.name,
                                  isMainTitle: true),
                              getDynamicSizedBox(height: 0.5.h),
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
                                      initialRating: 3.5,
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
                                    getDynamicSizedBox(width: 0.5.w),
                                    controller.getCommonText("35 Reviews",
                                        isHint: true),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        controller.getColorText(
                                            "Write a Reviews",
                                            isReviews: true),
                                        const SizedBox(
                                          width: 18, // Set the desired width
                                          height:
                                              22.0, // Set the desired height
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
                              getDynamicSizedBox(height: 1.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  controller.getColorText(
                                      "125 bought this in the last 4 hours",
                                      isReviews: false),
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
                                            if (controller.quantity > 0) {
                                              controller.quantity--;
                                              incrementDecrementCartItem(
                                                  isFromIcr: false,
                                                  data: widget.data!,
                                                  quantity:
                                                      controller.quantity);
                                              setState(() {});
                                            }
                                            // // Fetch the current cart items from preferences
                                            // List<CommonProductList> cartItems =
                                            //     await UserPreferences()
                                            //         .loadCartItems();
                                            // // Check if the product is already in the cart
                                            // int existingIndex =
                                            //     cartItems.indexWhere(
                                            //   (item) =>
                                            //       item.id == widget.data!.id,
                                            // );
                                            // if (controller.quantity > 0) {
                                            //   controller.quantity--;
                                            //   if (existingIndex != -1) {
                                            //     // Product already in the cart, decrement the quantity
                                            //     await UserPreferences()
                                            //         .addToCart(
                                            //       widget.data!,
                                            //       -1, // Pass a negative quantity for decrement
                                            //     );
                                            //   } else {
                                            //     // Product not in the cart, add it with quantity 1
                                            //     CommonProductList newProduct =
                                            //         widget.data!
                                            //             .copyWith(quantity: 1);
                                            //     cartItems.add(newProduct);

                                            //     // Save the updated cart back to preferences
                                            //     await UserPreferences()
                                            //         .addToCart(widget.data!, 1);
                                            //   }
                                            //   // Update your UI
                                            //
                                            // }
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
                                          controller.quantity.toString(),
                                          style: TextStyle(
                                            color: isDarkMode() ? white : black,
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
                                            controller.quantity++;
                                            logcat("COUNTER",
                                                controller.quantity.toString());
                                            incrementDecrementCartItem(
                                                isFromIcr: true,
                                                data: widget.data!,
                                                quantity: controller.quantity);

                                            // // Fetch the current cart items from preferences
                                            // List<CommonProductList> cartItems =
                                            //     await UserPreferences()
                                            //         .loadCartItems();

                                            // // Check if the product is already in the cart
                                            // int existingIndex =
                                            //     cartItems.indexWhere(
                                            //   (item) =>
                                            //       item.id == widget.data!.id,
                                            // );
                                            // if (existingIndex != -1) {
                                            //   // Product already in the cart, update the quantity
                                            //   cartItems[existingIndex]
                                            //       .quantity!
                                            //       .value += 1;
                                            //   setState(() {
                                            //     controller.quantity =
                                            //         cartItems[existingIndex]
                                            //             .quantity!
                                            //             .value;
                                            //   });
                                            //   // Save the updated cart back to preferences
                                            //   await UserPreferences().addToCart(
                                            //     widget.data!,
                                            //     cartItems[existingIndex]
                                            //         .quantity!
                                            //         .value,
                                            //   );
                                            //   // Update your UI if needed
                                            //   setState(() {});
                                            // } else {
                                            //   // Product not in the cart, add it with quantity 1
                                            //   CommonProductList newProduct =
                                            //       widget.data!
                                            //           .copyWith(quantity: 1);
                                            //   cartItems.add(newProduct);

                                            //   // Save the updated cart back to preferences
                                            //   await UserPreferences()
                                            //       .addToCart(widget.data!, 1);
                                            //   // Update your UI
                                            //   setState(() {
                                            //     controller.quantity = 1;
                                            //   });
                                            // }
                                            setState(() {});
                                          },
                                          child: Icon(
                                            Icons.add,
                                            size: 3.h,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              getDynamicSizedBox(height: 1.h),
                              controller.getLableText('About',
                                  isMainTitle: false),
                              getDynamicSizedBox(height: 0.5.h),
                              controller.getCommonText(
                                  widget.data!.description.toString(),
                                  isHint: true),
                              getDynamicSizedBox(height: 1.h),
                              controller.getLableText('Specifications:',
                                  isMainTitle: false),
                              SizedBox(
                                width: 27.w,
                                child: Divider(
                                  height: 0.1.h,
                                  color: grey.withOpacity(0.5),
                                ),
                              ),
                              getDynamicSizedBox(height: 1.5.h),
                              controller.getLableText('Recommend Target',
                                  isMainTitle: false),
                              getDynamicSizedBox(height: 0.5.h),
                              controller.getCommonText(
                                  "For Him, Her, Dear Family",
                                  isHint: true),
                              getDynamicSizedBox(height: 1.5.h),
                              controller.getLableText('Occasions',
                                  isMainTitle: false),
                              getDynamicSizedBox(height: 0.5.h),
                              controller.getCommonText(
                                  "Anniversary, Happy Graduation, Birthday, Proposal Suprises",
                                  isHint: true),
                              getDynamicSizedBox(height: 1.5.h),
                              controller.getLableText('Earliest Local Delivery',
                                  isMainTitle: false),
                              getDynamicSizedBox(height: 0.5.h),
                              controller.getCommonText("Today, 22 Fri,2023",
                                  isHint: true),
                              getDynamicSizedBox(height: 1.h),
                              controller.getLableText('Details',
                                  isMainTitle: false),
                              getDynamicSizedBox(height: 0.5.h),
                              controller.getCommonText(
                                  "- One dazen long stemmed tie dyned roses",
                                  isHint: true),
                              controller.getCommonText(
                                  "- Stands approximately 20 tall",
                                  isHint: true),
                              controller.getCommonText(
                                  "- Ship in custom ProFlowers packaging and gift box.",
                                  isHint: true),
                              getDynamicSizedBox(height: 3.h),
                              controller.getLableText('You Might Also Like',
                                  isMainTitle: false),
                              getDynamicSizedBox(height: 2.h),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5.w, bottom: 6.h),
                            child: Row(
                              children:
                                  controller.staticData.map<Widget>((data) {
                                return controller.getItemListItem(data)
                                    as Widget; // Convert each item to a Widget
                              }).toList(),
                            ),
                          ),
                        ),
                        // Row(
                        //   children: [
                        //     ListView.builder(
                        //         padding: EdgeInsets.only(
                        //           left: 4.5.w,
                        //         ),
                        //         shrinkWrap: true,
                        //         scrollDirection: Axis.horizontal,
                        //         clipBehavior: Clip.antiAlias,
                        //         itemBuilder: (context, index) {
                        //           SavedItem data =
                        //               controller.staticData[index];
                        //           return controller.getItemListItem(data);
                        //         },
                        //         itemCount: controller.staticData.length),
                        //   ],
                        // ),
                        getDynamicSizedBox(height: 3.h),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      getCommonContainer(
                          'Add to Cart', true, Icons.shopping_cart,
                          addCartClick: () {
                        Get.to(const CartScreen())!.then((value) {
                          Statusbar().trasparentStatusbarProfile(true);
                          loadStoredQuantity();
                        });
                      }),
                      getCommonContainer('Buy Now', false, Icons.shopping_bag,
                          buyNowClick: () {
                        logcat("Buy", 'Click');
                        if (isGuest == true) {
                          getGuestUserAlertDialog(context);
                        } else {
                          Get.to(const CartScreen())!.then((value) {
                            Statusbar().trasparentStatusbarProfile(true);
                          });
                        }
                      }),
                    ],
                  )),
            ],
          ),
        ));
  }
}
