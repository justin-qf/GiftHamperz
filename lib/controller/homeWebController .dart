import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/apicall_constant.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/homeController.dart';
import 'package:gifthamperz/models/UpdateDashboardModel.dart';
import 'package:gifthamperz/models/webModel.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/ProductDetailScreen/ProductDetailScreen.dart';
import 'package:marquee/marquee.dart';
import 'package:sizer/sizer.dart';
import '../utils/enum.dart';

class HomeScreenWebController extends GetxController {
  RxInt currentTreeView = 2.obs;
  RxBool isExpanded = false.obs;
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  late TextEditingController searchCtr;
  RxBool isShowMoreLoading = false.obs;

  @override
  void onInit() {
    searchCtr = TextEditingController();
    super.onInit();
  }

  final List<ImageUrl> staticBannerList = [
    ImageUrl(Asset.homeBannerWeb),
    ImageUrl(Asset.homeBannerWeb),
  ];

  final List<ImageUrl> offerList = [
    ImageUrl(Asset.bestOffer),
    ImageUrl(Asset.bestOffer),
  ];
  final List<OccasionsListModel> occasionsList = [
    OccasionsListModel(Asset.birthday, 'Birthday'),
    OccasionsListModel(Asset.anniversary, 'Anniversary'),
    OccasionsListModel(Asset.engage, 'Engagement'),
    OccasionsListModel(Asset.babyShower, 'Baby Shower'),
    OccasionsListModel(Asset.wedding, 'Wedding'),
    OccasionsListModel(Asset.diwali, 'Diwali'),
  ];

  final List<OccasionsListModel> staticCategoryList = [
    OccasionsListModel(Asset.birthday, 'Flower'),
    OccasionsListModel(Asset.anniversary, 'Cake'),
    OccasionsListModel(Asset.engage, 'Chocolates'),
    OccasionsListModel(Asset.babyShower, 'Gifts'),
    OccasionsListModel(Asset.wedding, 'Anniversary'),
    OccasionsListModel(Asset.diwali, 'Occasions'),
  ];

  final List<OccasionsListModel> sellingList = [
    OccasionsListModel(Asset.birthday, 'Flower'),
    OccasionsListModel(Asset.anniversary, 'Cake'),
    OccasionsListModel(Asset.engage, 'Chocolates'),
    OccasionsListModel(Asset.babyShower, 'Hampers'),
    OccasionsListModel(Asset.birthday, 'Flower'),
    OccasionsListModel(Asset.anniversary, 'Cake'),
    OccasionsListModel(Asset.engage, 'Chocolates'),
    OccasionsListModel(Asset.babyShower, 'Hampers'),
  ];

  final List<FooterModel> popularCatList = [
    FooterModel('Staples'),
    FooterModel('Staples'),
    FooterModel('Personal Care'),
    FooterModel('Home Care'),
    FooterModel('Baby Care'),
    FooterModel('Vegetables & Fruits'),
    FooterModel('Snacks & Foods'),
    FooterModel('Dairy & Bakery'),
  ];

  final List<FooterModel> helpfullLinkList = [
    FooterModel('About Us'),
    FooterModel('Terms & Conditions'),
    FooterModel('FAQ'),
    FooterModel('Privacy Policy'),
    FooterModel('E-waste Policy'),
    FooterModel('Cancellation & Return Policy'),
  ];

  final List<FooterModel> contactList = [
    FooterModel('Whats App', subTitle: '+1 202-918-2132', icon: Asset.whatsapp),
    FooterModel('Call Us', subTitle: '+1 202-918-2132', icon: Asset.call),
  ];

  getCategoryListItem(OccasionsListModel item) {
    return FadeInUp(
        child: GestureDetector(
            onTap: () {},
            child: Container(
                width: 21.h,
                margin: EdgeInsets.only(right: 3.w),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 21.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: white,
                          border: isDarkMode()
                              ? null
                              : Border.all(
                                  color: grey, // Border color
                                  width: 0.5, // Border width
                                ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: Image.asset(
                            item.url,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      getDynamicSizedBox(height: 1.h),
                      item.title.length > 10
                          ? Expanded(
                              child: Marquee(
                                style: TextStyle(
                                  fontFamily: fontBold,
                                  color: isDarkMode() ? white : black,
                                  fontSize: 5.sp,
                                ),
                                text: item.title,
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
                              item.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: fontBold,
                                color: isDarkMode() ? white : black,
                                fontSize: 5.sp,
                              ),
                            )
                    ]))));
  }

  getListItem(
      BuildContext context,
      OccasionsListModel data,
      Function getCartCount,
      bool? isGuestUser,
      Function onCLick,
      HomeScreenController controller) {
    return Wrap(
      children: [
        FadeInUp(
          child: GestureDetector(
            onTap: () {},
            child: Container(
                decoration: BoxDecoration(
                    border: isDarkMode()
                        ? null
                        : Border.all(
                            color: grey, // Border color
                            width: 0.5, // Border width
                          ),
                    color: isDarkMode() ? tileColour : white,
                    borderRadius: BorderRadius.all(Radius.circular(2.w))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: SizerUtil.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(2.w),
                                topRight: Radius.circular(2.w)),
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
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(2.w),
                                topRight: Radius.circular(2.w)),
                            child: Image.asset(
                              data.url,
                              height: 25.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 0.6.h,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 1.w, right: 1.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          getText(
                            data.title,
                            TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontFamily: fontBold,
                                color: isDarkMode() ? black : black,
                                fontSize: 6.sp,
                                height: 1.2),
                          ),
                          getDynamicSizedBox(
                            height: 0.5.h,
                          ),
                          Row(
                            children: [
                              getText(
                                '${IndiaRupeeConstant.inrCode}${'100'}',
                                TextStyle(
                                    fontFamily: fontBold,
                                    color: primaryColor,
                                    fontSize: 5.sp,
                                    height: 1.2),
                              ),
                              const Spacer(),
                              RatingBar.builder(
                                initialRating: 0.0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 1,
                                itemSize: 2.2.w,
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
                                '0.0',
                                TextStyle(
                                  fontFamily: fontSemiBold,
                                  color: lableColor,
                                  fontWeight:
                                      isDarkMode() ? FontWeight.w600 : null,
                                  fontSize: 5.sp,
                                ),
                              ),
                            ],
                          ),
                          getDynamicSizedBox(
                            height: 0.5.h,
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ],
    );
  }

  getOccasiosListItem(
      BuildContext context,
      OccasionsListModel data,
      Function getCartCount,
      bool? isGuestUser,
      Function onCLick,
      int index,
      HomeScreenController controller) {
    return Wrap(
      children: [
        FadeInUp(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              margin:
                  EdgeInsets.only(right: index == 2 || index == 6 ? 0 : 3.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2.w),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(2.w),
                        ),
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
                        borderRadius: BorderRadius.all(
                          Radius.circular(2.w),
                        ),
                        child: Image.asset(
                          data.url,
                          width: 55.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.8),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(2.w),
                              bottomRight: Radius.circular(2.w)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 3.w, right: 3.w, top: 1.h, bottom: 1.h),
                          child: Text(
                            data.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontFamily: fontBold,
                              fontWeight: FontWeight.w900,
                              color: white,
                              fontSize: 4.sp,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
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

  getpopularDeal(
      BuildContext context,
      CommonProductList data,
      Function getCartCount,
      bool? isGuestUser,
      HomeScreenController controller) {
    return Wrap(
      children: [
        FadeInUp(
          child: GestureDetector(
            onTap: () {
              Get.to(ProductDetailScreen(
                DashboardText.trendingTitle,
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
                                imageUrl: ApiUrl.imageUrl + data.images[0],
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
                                            itemList:
                                                controller.trendingItemList,
                                            quantity: data.quantity!.value);
                                        update();
                                      }, isAddToCartClicked: data.isInCart!)
                                    : homeCartIncDecUi(
                                        qty: data.quantity.toString(),
                                        increment: () async {
                                          incrementDecrementCartItemInList(
                                              isFromIcr: true,
                                              data: data,
                                              itemList:
                                                  controller.trendingItemList,
                                              quantity: data.quantity!.value);
                                          update();
                                        },
                                        isFromPopular: true,
                                        decrement: () async {
                                          incrementDecrementCartItemInList(
                                              isFromIcr: false,
                                              data: data,
                                              itemList:
                                                  controller.trendingItemList,
                                              quantity: data.quantity!.value);
                                          update();
                                        });
                              },
                            ),
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
}
