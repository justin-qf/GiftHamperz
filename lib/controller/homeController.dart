import 'dart:async';
import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/api_handle/Repository.dart';
import 'package:gifthamperz/componant/dialogs/dialogs.dart';
import 'package:gifthamperz/componant/dialogs/loading_indicator.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/apicall_constant.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/models/BannerModel.dart';
import 'package:gifthamperz/models/UpdateDashboardModel.dart';
import 'package:gifthamperz/models/homeModel.dart';
import 'package:gifthamperz/models/loginModel.dart';
import 'package:gifthamperz/preference/UserPreference.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/CategoryScreen/SubCategoryScreen.dart';
import 'package:gifthamperz/views/ProductDetailScreen/ProductDetailScreen.dart';
import 'package:marquee/marquee.dart';
import 'package:sizer/sizer.dart';
import '../models/categoryModel.dart';
import '../utils/enum.dart';
import 'internet_controller.dart';

class HomeScreenController extends GetxController {
  List pageNavigation = [];
  RxInt currentTreeView = 2.obs;
  RxBool isExpanded = false.obs;
  RxBool isTreeModeVertical = true.obs;
  RxBool accessToDrawer = false.obs;
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  InternetController networkManager = Get.find<InternetController>();
  RxList treeList = [].obs;
  var pageController = PageController();
  var currentPage = 0;
  late Timer timer;
  late TextEditingController searchCtr;
  bool isSearch = false;
  RxInt totalItemsCount = 0.obs;
  RxBool isShowMoreLoading = false.obs;
  // Use a Map to store the quantity for each product ID
  final Map<String, int> productQuantities = <String, int>{};

  // Method to update the quantity for a product
  void updateQuantity(String productId, int quantity) {
    productQuantities[productId] = quantity;
    logcat("ItemISIInCART:::", productQuantities[productId].toString());
    update(); // Notify listeners
  }

  @override
  void onInit() {
    searchCtr = TextEditingController();
    super.onInit();
  }

  List<HomeItem> staticData = <HomeItem>[
    HomeItem(
        icon: Image.asset(
          Asset.itemOne,
          height: 15.h,
          width: 15.h,
          fit: BoxFit.cover,
        ),
        price: '\$19.99 -\$29.99',
        name: 'Flower Lovers'),
    HomeItem(
        icon: Image.asset(
          height: 15.h,
          width: 15.h,
          Asset.itemTwo,
          fit: BoxFit.cover,
        ),
        price: '\$30.99 -\$29.99',
        name: 'Birthday Gifts'),
    HomeItem(
        icon: Image.asset(
          height: 15.h,
          width: 15.h,
          Asset.itemThree,
          fit: BoxFit.cover,
        ),
        price: '\$85.99 -\$90.99',
        name: "Occations"),
    HomeItem(
        icon: Image.asset(
          height: 15.h,
          width: 15.h,
          Asset.itemFour,
          fit: BoxFit.cover,
        ),
        price: '\$35.99 -\$55.99',
        name: "Flower Lovers"),
    HomeItem(
        icon: Image.asset(
          height: 15.h,
          width: 15.h,
          Asset.itemFive,
          fit: BoxFit.cover,
        ),
        price: '\$39.99 -\$54.99',
        name: 'Birthday Gifts'),
    HomeItem(
        icon: Image.asset(
          height: 15.h,
          width: 15.h,
          Asset.itemFour,
          fit: BoxFit.cover,
        ),
        price: '\$58.99 -\$62.99',
        name: "Occations"),
    HomeItem(
        icon: Image.asset(
          height: 15.h,
          width: 15.h,
          Asset.itemSix,
          fit: BoxFit.cover,
        ),
        price: '\$87.99 -\$67.99',
        name: "Flower Lovers")
  ];

  List<Widget> bannerItems = [
    Image.asset(
      Asset.homeSlideOne,
      fit: BoxFit.cover,
    ),
    Image.asset(
      Asset.homeSlideTwo,
      fit: BoxFit.cover,
    ),
    Image.asset(
      Asset.homeSlideThree,
      fit: BoxFit.cover,
    ),
    Image.asset(
      Asset.homeSlideFour,
      fit: BoxFit.cover,
    ),
  ];

  // List<CategoryItem> categoryList = <CategoryItem>[
  //   CategoryItem(
  //       icon: Image.asset(
  //         'assets/pngs/Birthday_gift.jpg',
  //         height: 11.h,
  //         width: 11.h,
  //         fit: BoxFit.cover,
  //       ),
  //       title: 'Birthdays'),
  //   CategoryItem(
  //       icon: Image.asset(
  //         height: 11.h,
  //         width: 11.h,
  //         'assets/pngs/Anniversary_gift.jpg',
  //         fit: BoxFit.cover,
  //       ),
  //       title: 'Anniversaries'),
  //   CategoryItem(
  //       icon: Image.asset(
  //         height: 11.h,
  //         width: 11.h,
  //         'assets/pngs/wedding_gift.jpg',
  //         fit: BoxFit.cover,
  //       ),
  //       title: "Weddings"),
  //   CategoryItem(
  //       icon: Image.asset(
  //         height: 11.h,
  //         width: 11.h,
  //         'assets/pngs/babyshower_gift.png',
  //         fit: BoxFit.cover,
  //       ),
  //       title: "Baby Showers"),
  //   CategoryItem(
  //       icon: Image.asset(
  //         height: 11.h,
  //         width: 11.h,
  //         'assets/pngs/Engagement_gift.jpg',
  //         fit: BoxFit.cover,
  //       ),
  //       title: 'Engagements'),
  //   CategoryItem(
  //       icon: Image.asset(
  //         height: 11.h,
  //         width: 11.h,
  //         'assets/pngs/graduation_gift.jpeg',
  //         fit: BoxFit.cover,
  //       ),
  //       title: "Graduations"),
  //   CategoryItem(
  //       icon: Image.asset(
  //         height: 11.h,
  //         width: 11.h,
  //         'assets/pngs/valentine_gift.png',
  //         fit: BoxFit.cover,
  //       ),
  //       title: "Valentine's Day")
  // ];

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  getCategoryListItem(CategoryList item) {
    return FadeInUp(
        child: GestureDetector(
            onTap: () {
              Get.to(SubCategoryScreen(
                categoryId: item.id.toString(),
              ));
            },
            child: Container(
                width: 8.h,
                margin: EdgeInsets.only(right: 4.w),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: white,
                          //color: Colors.grey[300],
                          border: isDarkMode()
                              ? null
                              : Border.all(
                                  color: grey, // Border color
                                  width: 0.5, // Border width
                                ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              height: 7.h,
                              imageUrl: APIImageUrl.url + item.thumbnailUrl,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                    color: primaryColor),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                Asset.productPlaceholder,
                                height: 7.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      item.name.length > 9
                          ? Expanded(
                              child: Marquee(
                                style: TextStyle(
                                  fontFamily: fontRegular,
                                  color: isDarkMode() ? white : black,
                                  fontSize: 12.sp,
                                ),
                                text: item.name,
                                scrollAxis: Axis
                                    .horizontal, // Use Axis.vertical for vertical scrolling
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Adjust as needed
                                blankSpace:
                                    20.0, // Adjust the space between text repetitions
                                velocity: 50.0, // Adjust the scrolling speed
                                pauseAfterRound: const Duration(
                                    seconds:
                                        1), // Time to pause after each scroll
                                startPadding:
                                    10.0, // Adjust the initial padding
                                accelerationDuration: const Duration(
                                    seconds: 1), // Duration for acceleration
                                accelerationCurve:
                                    Curves.linear, // Acceleration curve
                                decelerationDuration: const Duration(
                                    milliseconds:
                                        500), // Duration for deceleration
                                decelerationCurve:
                                    Curves.easeOut, // Deceleration curve
                              ),
                            )
                          : Text(
                              item.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: fontRegular,
                                color: isDarkMode() ? white : black,
                                fontSize: 12.sp,
                              ),
                            )
                    ]))));
  }

  getTotalProductInCart() async {
    // Fetch the current cart items from preferences
    List<CommonProductList> cartItems = await UserPreferences().loadCartItems();
    logcat("cartItems", cartItems.length.toString());
    // Get the total length of the list
    totalItemsCount.value = cartItems.length;
    logcat("cartItems", totalItemsCount.value.toString());
    update();
  }

  getListItem(BuildContext context, CommonProductList data,
      Function getCartCount, bool? isGuestUser, Function onCLick) {
    return Wrap(
      children: [
        FadeInUp(
          child: GestureDetector(
            onTap: () {
              logcat('Treanding', 'DONE');
              Get.to(
                ProductDetailScreen(
                  'Trending',
                  data: data,
                ),
                transition: Transition.fadeIn,
                curve: Curves.easeInOut,
              )!
                  .then((value) {
                getCartCount();
                getHome(context);
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  SizerUtil.deviceType == DeviceType.mobile ? 4.w : 2.2.w),
              child: Container(
                  width: 35.w,
                  margin: EdgeInsets.only(bottom: 1.h, left: 1.w, right: 2.w),
                  padding: EdgeInsets.only(bottom: 1.h),
                  decoration: BoxDecoration(
                    border: isDarkMode()
                        ? null
                        : Border.all(
                            color: grey, // Border color
                            width: 0.5, // Border width
                          ),
                    //color: isDarkMode() ? itemDarkBackgroundColor : white,
                    color: isDarkMode() ? tileColour : white,
                    borderRadius: BorderRadius.circular(
                        SizerUtil.deviceType == DeviceType.mobile
                            ? 4.w
                            : 2.2.w),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: SizerUtil.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  SizerUtil.deviceType == DeviceType.mobile
                                      ? 3.5.w
                                      : 2.5.w),
                              border: isDarkMode()
                                  ? Border.all(
                                      color: grey, // Border color
                                      width: 1, // Border width
                                    )
                                  : Border.all(
                                      color: grey, // Border color
                                      width: 0.2, // Border width
                                    ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  SizerUtil.deviceType == DeviceType.mobile
                                      ? 3.5.w
                                      : 2.5.w),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                height: 12.h,
                                imageUrl: APIImageUrl.url + data.images[0],
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                      color: primaryColor),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  Asset.productPlaceholder,
                                  height: 9.h,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          // Positioned(
                          //   right: 3.w,
                          //   top: 1.0.h,
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       // data.isSelected.value =
                          //       //     !data.isSelected.value;
                          //       addFavouriteAPI(
                          //           context, item.id.toString(), "1");
                          //       //update();
                          //     },
                          //     child: Icon(
                          //       Icons.favorite_border,
                          //       size: 3.h,
                          //       color: primaryColor,
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                      SizedBox(
                        height: 0.6.h,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 1.w, right: 1.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getText(
                              data.name,
                              TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: fontSemiBold,
                                  fontWeight: FontWeight.w500,
                                  color: isDarkMode() ? black : black,
                                  fontSize:
                                      SizerUtil.deviceType == DeviceType.mobile
                                          ? 10.sp
                                          : 8.sp,
                                  height: 1.2),
                            ),
                            getDynamicSizedBox(
                              height: 0.5.h,
                            ),
                            Row(
                              children: [
                                getText(
                                  '${IndiaRupeeConstant.inrCode}${data.sku}',
                                  TextStyle(
                                      fontFamily: fontBold,
                                      color: primaryColor,
                                      fontSize: SizerUtil.deviceType ==
                                              DeviceType.mobile
                                          ? 12.sp
                                          : 7.sp,
                                      height: 1.2),
                                ),
                                const Spacer(),
                                RatingBar.builder(
                                  initialRating: data.averageRating ?? 0.0,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 1,
                                  itemSize: 3.5.w,
                                  unratedColor: Colors.orange,
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                  ),
                                  onRatingUpdate: (rating) {
                                    logcat("RATING", rating);
                                  },
                                ),
                                getText(
                                  data.averageRating != null
                                      ? data.averageRating.toString()
                                      : '0.0',
                                  TextStyle(
                                      fontFamily: fontSemiBold,
                                      color: lableColor,
                                      fontWeight:
                                          isDarkMode() ? FontWeight.w600 : null,
                                      fontSize: SizerUtil.deviceType ==
                                              DeviceType.mobile
                                          ? 9.sp
                                          : 7.sp,
                                      height: 1.2),
                                ),
                              ],
                            ),
                            getDynamicSizedBox(
                              height: 0.5.h,
                            ),
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   children: [
                            //     RatingBar.builder(
                            //       initialRating: 3.5,
                            //       minRating: 1,
                            //       direction: Axis.horizontal,
                            //       allowHalfRating: true,
                            //       itemCount: 1,
                            //       itemSize: 3.5.w,
                            //       itemBuilder: (context, _) => const Icon(
                            //         Icons.star,
                            //         color: Colors.orange,
                            //       ),
                            //       onRatingUpdate: (rating) {
                            //         logcat("RATING", rating);
                            //       },
                            //     ),
                            //     getText(
                            //       "3.5",
                            //       TextStyle(
                            //           fontFamily: fontSemiBold,
                            //           color: lableColor,
                            //           fontWeight:
                            //               isDarkMode() ? FontWeight.w600 : null,
                            //           fontSize: SizerUtil.deviceType ==
                            //                   DeviceType.mobile
                            //               ? 9.sp
                            //               : 7.sp,
                            //           height: 1.2),
                            //     ),
                            //     const Spacer(),
                            //     // Obx(
                            //     //   () {
                            //     //     return data.isInCart!.value == false
                            //     //         ? getAddToCartBtn(
                            //     //             'Add to Cart', Icons.shopping_cart,
                            //     //             addCartClick: () async {
                            //     //             data.isInCart!.value = true;
                            //     //             // data.quantity!.value = 1;
                            //     //             incrementDecrementCartItem(
                            //     //                 isFromIcr: true,
                            //     //                 data: data,
                            //     //                 itemList: popularItemList,
                            //     //                 quantity: data.quantity!.value);

                            //     //             update();
                            //     //           }, isAddToCartClicked: data.isInCart!)
                            //     //         : cartIncDecUi(
                            //     //             qty: data.quantity.toString(),
                            //     //             increment: () async {
                            //     //               incrementDecrementCartItemInList(
                            //     //                   isFromIcr: true,
                            //     //                   data: data,
                            //     //                   itemList: popularItemList,
                            //     //                   quantity:
                            //     //                       data.quantity!.value);

                            //     //               update();
                            //     //             },
                            //     //             decrement: () async {
                            //     //               incrementDecrementCartItemInList(
                            //     //                   isFromIcr: false,
                            //     //                   data: data,
                            //     //                   itemList: popularItemList,
                            //     //                   quantity:
                            //     //                       data.quantity!.value);
                            //     //               update();
                            //     //             });
                            //     //   },
                            //     // ),
                            //   ],
                            // ),
                            getDynamicSizedBox(height: 0.3.h),
                            Obx(
                              () {
                                return data.isInCart!.value == false
                                    ? getAddToCartBtn(
                                        'Add to Cart', Icons.shopping_cart,
                                        addCartClick: () async {
                                        data.isInCart!.value = true;
                                        // data.quantity!.value = 1;
                                        incrementDecrementCartItem(
                                            isFromIcr: true,
                                            data: data,
                                            itemList: popularItemList,
                                            quantity: data.quantity!.value);

                                        update();
                                      }, isAddToCartClicked: data.isInCart!)
                                    : homeCartIncDecUi(
                                        qty: data.quantity.toString(),
                                        increment: () async {
                                          incrementDecrementCartItemInList(
                                              isFromIcr: true,
                                              data: data,
                                              itemList: popularItemList,
                                              quantity: data.quantity!.value);

                                          update();
                                        },
                                        isFromPopular: false,
                                        decrement: () async {
                                          incrementDecrementCartItemInList(
                                              isFromIcr: false,
                                              data: data,
                                              itemList: popularItemList,
                                              quantity: data.quantity!.value);
                                          update();
                                        });
                              },
                            ),
                          ],
                        ),
                      ),
                      //getDynamicSizedBox(height: 1.h),
                      // getAddToCartBtn('Add to Cart', Icons.shopping_cart,
                      //     addCartClick: () {
                      //   Get.to(const CartScreen())!.then((value) {
                      //     Statusbar().trasparentStatusbarProfile(true);
                      //   });
                      // })
                    ],
                  )),
            ),
          ),
        ),
      ],
    );
  }

  Widget getText(title, TextStyle? style) {
    return Padding(
      padding: EdgeInsets.only(left: 0.5.w, right: 0.5.w),
      child: Text(
        title,
        style: style,
        maxLines: 2,
      ),
    );
  }

  getpopularDeal(BuildContext context, CommonProductList data,
      Function getCartCount, bool? isGuestUser) {
    return Wrap(
      children: [
        FadeInUp(
          child: GestureDetector(
            onTap: () {
              Get.to(ProductDetailScreen(
                'Trending',
                data: data,
              ))!
                  .then((value) {
                getCartCount();
                //getTotalProductInCart();
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  SizerUtil.deviceType == DeviceType.mobile ? 4.w : 2.2.w),
              child: Container(
                  width: 48.w,
                  margin: EdgeInsets.only(bottom: 1.h, left: 1.w, right: 2.w),
                  padding: EdgeInsets.only(bottom: 1.h),
                  decoration: BoxDecoration(
                    border: isDarkMode()
                        ? null
                        : Border.all(
                            color: grey, // Border color
                            width: 0.5, // Border width
                          ),
                    color: isDarkMode() ? tileColour : white,
                    borderRadius: BorderRadius.circular(
                        SizerUtil.deviceType == DeviceType.mobile
                            ? 4.w
                            : 2.2.w),
                    // boxShadow: [
                    //   BoxShadow(
                    //       color: Colors.black.withOpacity(0.05),
                    //       blurRadius: 10.0,
                    //       offset: const Offset(0, 5))
                    // ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  SizerUtil.deviceType == DeviceType.mobile
                                      ? 4.w
                                      : 2.2.w),
                              border: isDarkMode()
                                  ? Border.all(
                                      color: grey, // Border color
                                      width: 1, // Border width
                                    )
                                  : null,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  SizerUtil.deviceType == DeviceType.mobile
                                      ? 4.w
                                      : 2.2.w),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                height: 12.h,
                                imageUrl: APIImageUrl.url + data.images[0],
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                      color: primaryColor),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  Asset.productPlaceholder,
                                  height: 12.h,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          // Positioned(
                          //   right: 3.w,
                          //   top: 1.0.h,
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       // data.isSelected.value =
                          //       //     !data.isSelected.value;
                          //       update();
                          //     },
                          //     child: Icon(
                          //       Icons.favorite_border,
                          //       size: 3.h,
                          //       color: primaryColor,
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                      SizedBox(
                        height: 1.0.h,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 1.w, right: 1.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getText(
                              data.name,
                              TextStyle(
                                  fontFamily: fontSemiBold,
                                  fontWeight: FontWeight.w500,
                                  color: isDarkMode() ? black : black,
                                  fontSize:
                                      SizerUtil.deviceType == DeviceType.mobile
                                          ? 12.sp
                                          : 7.sp,
                                  height: 1.2),
                            ),
                            getDynamicSizedBox(
                              height: 0.5.h,
                            ),
                            Row(
                              children: [
                                getText(
                                  '${IndiaRupeeConstant.inrCode}${data.price}',
                                  TextStyle(
                                      fontFamily: fontBold,
                                      color: primaryColor,
                                      fontSize: SizerUtil.deviceType ==
                                              DeviceType.mobile
                                          ? 12.sp
                                          : 7.sp,
                                      height: 1.2),
                                ),
                                const Spacer(),
                                RatingBar.builder(
                                  initialRating: data.averageRating ?? 0.0,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 1,
                                  itemSize: 3.5.w,
                                  unratedColor: Colors.orange,
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                  ),
                                  onRatingUpdate: (rating) {
                                    logcat("RATING", rating);
                                  },
                                ),
                                getText(
                                  data.averageRating != null
                                      ? data.averageRating.toString()
                                      : '0.0',
                                  TextStyle(
                                      fontFamily: fontSemiBold,
                                      color: lableColor,
                                      fontWeight:
                                          isDarkMode() ? FontWeight.w600 : null,
                                      fontSize: SizerUtil.deviceType ==
                                              DeviceType.mobile
                                          ? 9.sp
                                          : 7.sp,
                                      height: 1.2),
                                ),
                              ],
                            ),
                            getDynamicSizedBox(height: 0.5.h),
                            Obx(
                              () {
                                return data.isInCart!.value == false
                                    ? getAddToCartBtn(
                                        'Add to Cart', Icons.shopping_cart,
                                        addCartClick: () async {
                                        data.isInCart!.value = true;
                                        // data.quantity!.value = 1;
                                        incrementDecrementCartItem(
                                            isFromIcr: true,
                                            data: data,
                                            itemList: trendingItemList,
                                            quantity: data.quantity!.value);
                                        update();
                                      }, isAddToCartClicked: data.isInCart!)
                                    : homeCartIncDecUi(
                                        qty: data.quantity.toString(),
                                        increment: () async {
                                          incrementDecrementCartItemInList(
                                              isFromIcr: true,
                                              data: data,
                                              itemList: trendingItemList,
                                              quantity: data.quantity!.value);
                                          update();
                                        },
                                        isFromPopular: true,
                                        decrement: () async {
                                          incrementDecrementCartItemInList(
                                              isFromIcr: false,
                                              data: data,
                                              itemList: trendingItemList,
                                              quantity: data.quantity!.value);
                                          update();
                                        });
                              },
                            ),
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     RatingBar.builder(
                            //       initialRating: 3.5,
                            //       minRating: 1,
                            //       direction: Axis.horizontal,
                            //       allowHalfRating: true,
                            //       itemCount: 1,
                            //       itemSize: 3.5.w,
                            //       itemBuilder: (context, _) => const Icon(
                            //         Icons.star,
                            //         color: Colors.orange,
                            //       ),
                            //       onRatingUpdate: (rating) {
                            //         logcat("RATING", rating);
                            //       },
                            //     ),
                            //     getText(
                            //       "3.5",
                            //       TextStyle(
                            //           fontFamily: fontSemiBold,
                            //           color: lableColor,
                            //           fontWeight:
                            //               isDarkMode() ? FontWeight.w600 : null,
                            //           fontSize: SizerUtil.deviceType ==
                            //                   DeviceType.mobile
                            //               ? 9.sp
                            //               : 7.sp,
                            //           height: 1.2),
                            //     ),
                            //     const Spacer(),
                            //     // getAddToCartBtn(
                            //     //     'Add to Cart', Icons.shopping_cart,
                            //     //     addCartClick: () {
                            //     //   if (isGuestUser == true) {
                            //     //     getGuestUserAlertDialog(
                            //     //         context, DashboardText.dashboard);
                            //     //   } else {
                            //     //     Get.to(const CartScreen())!.then((value) {
                            //     //       Statusbar()
                            //     //           .trasparentStatusbarProfile(true);
                            //     //     });
                            //     //   }
                            //     // })
                            //     Obx(
                            //       () {
                            //         return data.isInCart!.value == false
                            //             ? getAddToCartBtn(
                            //                 'Add to Cart', Icons.shopping_cart,
                            //                 addCartClick: () async {
                            //                 data.isInCart!.value = true;
                            //                 // data.quantity!.value = 1;
                            //                 incrementDecrementCartItem(
                            //                     isFromIcr: true,
                            //                     data: data,
                            //                     itemList: trendingItemList,
                            //                     quantity: data.quantity!.value);
                            //                 update();
                            //               }, isAddToCartClicked: data.isInCart!)
                            //             : cartIncDecUi(
                            //                 qty: data.quantity.toString(),
                            //                 increment: () async {
                            //                   incrementDecrementCartItemInList(
                            //                       isFromIcr: true,
                            //                       data: data,
                            //                       itemList: trendingItemList,
                            //                       quantity:
                            //                           data.quantity!.value);
                            //                   update();
                            //                 },
                            //                 decrement: () async {
                            //                   incrementDecrementCartItemInList(
                            //                       isFromIcr: false,
                            //                       data: data,
                            //                       itemList: trendingItemList,
                            //                       quantity:
                            //                           data.quantity!.value);
                            //                   update();
                            //                 });
                            //       },
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ],
    );
  }

  void getCategoryList(context) async {
    state.value = ScreenState.apiLoading;
    try {
      if (networkManager.connectionType == 0) {
        showDialogForScreen(
            context, CategoryScreenConstant.title, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      var response =
          await Repository.get({}, ApiUrl.getCategory, allowHeader: true);
      logcat("RESPONSE::", response.body);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          var categoryData = CategoryModel.fromJson(responseData);
          categoryList.clear();
          if (categoryData.data.data.isNotEmpty) {
            categoryList.addAll(categoryData.data.data);
            update();
          }
        } else {
          message.value = responseData['message'];
          showDialogForScreen(
              context, CategoryScreenConstant.title, responseData['message'],
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(
            context, CategoryScreenConstant.title, ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      logcat("Ecxeption", e);
      state.value = ScreenState.apiError;
      message.value = ServerError.servererror;
      showDialogForScreen(
          context, CategoryScreenConstant.title, ServerError.servererror,
          callback: () {});
    }
  }

  void getBannerList(context) async {
    state.value = ScreenState.apiLoading;
    try {
      if (networkManager.connectionType == 0) {
        showDialogForScreen(
            context, BottomConstant.home, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      var response = await Repository.get({}, ApiUrl.banner, allowHeader: true);
      logcat("BANNER_RESPONSE::", response.body);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          var bannerData = BannerModel.fromJson(responseData);
          bannerList.clear();
          if (bannerData.data.isNotEmpty) {
            bannerList.addAll(bannerData.data);
            update();
          }
        } else {
          message.value = responseData['message'];
          showDialogForScreen(
              context, BottomConstant.home, responseData['message'],
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(
            context, BottomConstant.home, ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      logcat("Ecxeption", e);
      state.value = ScreenState.apiError;
      message.value = ServerError.servererror;
      showDialogForScreen(context, BottomConstant.home, ServerError.servererror,
          callback: () {});
    }
  }

  RxList topItemList = [].obs;
  RxList bannerList = [].obs;

  RxList<CommonProductList> popularItemList = <CommonProductList>[].obs;
  RxList<CommonProductList> trendingItemList = <CommonProductList>[].obs;

  RxList categoryList = [].obs;

  // ignore: prefer_typing_uninitialized_variables
  HomeModel? homeData;

  void getHome(context) async {
    state.value = ScreenState.apiLoading;
    try {
      if (networkManager.connectionType == 0) {
        showDialogForScreen(
            context, BottomConstant.home, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      var response =
          await Repository.get({}, ApiUrl.getHome, allowHeader: true);
      logcat("HOME_RESPONSE::", response.body);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          homeData = HomeModel.fromJson(responseData);
          trendingItemList.clear();
          topItemList.clear();
          popularItemList.clear();
          bannerList.clear();
          categoryList.clear();

          if (homeData!.data.trendList.isNotEmpty) {
            trendingItemList.addAll(homeData!.data.trendList);
            update();
          }

          if (homeData!.data.categoryList.isNotEmpty) {
            categoryList.addAll(homeData!.data.categoryList);
            update();
          }
          if (homeData!.data.bannerList.isNotEmpty) {
            bannerList.addAll(homeData!.data.bannerList);
            update();
          }

          List<CommonProductList> cartItems =
              await UserPreferences().loadCartItems();

          for (CommonProductList item in homeData!.data.trendList) {
            int existingIndex =
                cartItems.indexWhere((cartItem) => cartItem.id == item.id);
            if (existingIndex != -1) {
              item.isInCart!.value = true;
              item.quantity!.value = cartItems[existingIndex].quantity!.value;
            } else {
              item.isInCart!.value = false;
              item.quantity!.value = 0;
            }
          }

          if (homeData!.data.topList.isNotEmpty) {
            topItemList.addAll(homeData!.data.topList);
            update();
          }
          if (homeData!.data.popularList.isNotEmpty) {
            popularItemList.addAll(homeData!.data.popularList);
            update();
          }

          for (CommonProductList item in homeData!.data.popularList) {
            int existingIndex =
                cartItems.indexWhere((cartItem) => cartItem.id == item.id);
            if (existingIndex != -1) {
              item.isInCart!.value = true;
              item.quantity!.value = cartItems[existingIndex].quantity!.value;
            } else {
              item.isInCart!.value = false;
              item.quantity!.value = 0;
            }
          }
        } else {
          message.value = responseData['message'];
          showDialogForScreen(
              context, BottomConstant.home, responseData['message'],
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(
            context, BottomConstant.home, ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      logcat("Ecxeption", e);
      state.value = ScreenState.apiError;
      message.value = ServerError.servererror;
      showDialogForScreen(context, BottomConstant.home, ServerError.servererror,
          callback: () {});
    }
  }

  void addFavouriteAPI(context, String productId, String type) async {
    var loadingIndicator = LoadingProgressDialog();
    loadingIndicator.show(context, '');
    try {
      if (networkManager.connectionType == 0) {
        loadingIndicator.hide(context);
        showDialogForScreen(
            context, BottomConstant.home, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      UserData? getUserData = await UserPreferences().getSignInInfo();
      logcat('loginPassingData', {
        "user_id": getUserData!.id.toString().trim(),
        "product_id": productId.toString().trim(),
        "type": type.toString().trim(),
      });

      var response = await Repository.post({
        "user_id": getUserData.id.toString().trim(),
        "product_id": productId.toString().trim(),
        "type": type.toString().trim(),
      }, ApiUrl.addFavourite, allowHeader: true);
      loadingIndicator.hide(context);
      loadingIndicator.hide(context);
      update();
      var data = jsonDecode(response.body);
      logcat("tag", data);
      if (response.statusCode == 200) {
        if (data['status'] == 1) {
          showCustomToast(context, data['message'].toString());
        } else {
          showCustomToast(context, data['message'].toString());
        }
      } else {
        showDialogForScreen(context, BottomConstant.home, data['message'] ?? "",
            callback: () {});
        loadingIndicator.hide(context);
      }
    } catch (e) {
      logcat("Exception", e);
      showDialogForScreen(context, BottomConstant.home, ServerError.servererror,
          callback: () {});
    } finally {
      loadingIndicator.hide(context);
    }
  }
}
