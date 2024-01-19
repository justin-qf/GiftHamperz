import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/models/DashboadModel.dart';
import 'package:gifthamperz/models/homeModel.dart';
import 'package:gifthamperz/preference/UserPreference.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:sizer/sizer.dart';
import '../utils/enum.dart';
import 'internet_controller.dart';

class CartScreenController extends GetxController {
  var currentPage = 0;

  List pageNavigation = [];
  RxInt currentTreeView = 2.obs;

  RxBool isExpanded = false.obs;
  RxBool isTreeModeVertical = true.obs;

  RxBool accessToDrawer = false.obs;
  DateTime selectedValue = DateTime.now();

  RxString picDate = "".obs;
  RxList treeList = [].obs;
  RxDouble productCost = 178.38.obs;
  RxDouble deliveryCharge = 5.00.obs;
  RxDouble discount = 10.00.obs;
  RxDouble total = 0.0.obs;

  final GlobalKey<ScaffoldState> key = GlobalKey();

  changeIndex(int index) async {
    currentPage = index;
    update();
  }

  getTotal() {
    total.value = (productCost.value + deliveryCharge.value) - discount.value;
    logcat("Difference", total.value.toString());
  }

  void updateDate(date) {
    picDate.value = date;
    update();
  }

  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  final InternetController etworkManager = Get.find<InternetController>();

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  RxList<CartItem> cartItems = <CartItem>[
    CartItem(
        title: "Unicorn Roses - 12 Long Stemmed Tie Dyned Roses",
        status: "Deluxe",
        orderDate: "1",
        icone: 'assets/pngs/home_three.jpg',
        initialQuantity: 1,
        price: 128.69),
    CartItem(
        title: "12 Handmade Easter Chocolate Brownie Pops",
        status: "Canceled",
        orderDate: "1",
        icone: 'assets/pngs/home_one.jpg',
        initialQuantity: 1,
        price: 49.69),
    CartItem(
        title: "12 Handmade Easter Chocolate Brownie Pops",
        status: "Canceled",
        orderDate: "1",
        icone: 'assets/pngs/home_one.jpg',
        initialQuantity: 1,
        price: 49.69),
    CartItem(
        title: "12 Handmade Easter Chocolate Brownie Pops",
        status: "Canceled",
        orderDate: "1",
        icone: 'assets/pngs/home_one.jpg',
        initialQuantity: 1,
        price: 49.69),
  ].obs;

  void removeItemFromCart(CartItem item) {
    cartItems.remove(item);
    update();
  }

  Widget getLableText(text, {isMainTitle}) {
    return FadeInUp(
      child: Text(text,
          style: TextStyle(
            color: isDarkMode() ? white : black,
            fontFamily: isMainTitle == true ? fontBold : null,
            fontWeight: isMainTitle == true ? FontWeight.w600 : FontWeight.w500,
            fontSize: isMainTitle == true ? 15.sp : 14.sp,
          )),
    );
  }

  getListItem(
      CommonProductList data, int index, List<CommonProductList> cartItems) {
    return FadeInUp(
      child: Wrap(
        children: [
          Container(
              width: SizerUtil.width,
              margin: EdgeInsets.only(right: 2.w, bottom: 2.0.h),
              padding: EdgeInsets.only(
                  left: 1.8.w, right: 1.8.w, top: 1.8.w, bottom: 1.8.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1.5.h),
                border: Border.all(
                  color: isDarkMode()
                      ? grey.withOpacity(0.4)
                      : grey.withOpacity(0.2), // Set the border color here
                  width: 2.0, // Set the border width
                ),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      SizerUtil.deviceType == DeviceType.mobile
                          ? 1.5.w
                          : 2.2.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FadeInDown(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                SizerUtil.deviceType == DeviceType.mobile
                                    ? 3.5.w
                                    : 2.5.w),
                            border: Border.all(
                              color: isDarkMode()
                                  ? primaryColor.withOpacity(0.5)
                                  : grey.withOpacity(
                                      0.2), // Set the border color here
                              width: 2.0, // Set the border width
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              height: 13.h,
                              width: 30.w,
                              imageUrl: APIImageUrl.url + data.images,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                    color: primaryColor),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                Asset.productPlaceholder,
                                height: 13.h,
                                width: 13.5.h,
                                fit: BoxFit.contain,
                              ),
                              imageBuilder: (context, imageProvider) => Image(
                                image: imageProvider,
                                height: 13.h,
                                width: 13.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      getDynamicSizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(data.name,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: fontMedium,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                )),
                            getDynamicSizedBox(height: 1.h),
                            RichText(
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.start,
                              softWrap: true,
                              textScaleFactor: 1,
                              text: TextSpan(
                                text: '\$${data.sku}',
                                style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.sp),
                                children: [
                                  TextSpan(
                                    text: '',
                                    style: TextStyle(
                                        color:
                                            isDarkMode() ? lableColor : black,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                            getDynamicSizedBox(height: 0.5.h),
                            Row(
                              children: [
                                RichText(
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.start,
                                  softWrap: true,
                                  textScaleFactor: 1,
                                  text: TextSpan(
                                    text: 'Quantity: ',
                                    style: TextStyle(
                                        color: lableColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 8.sp),
                                    children: [
                                      TextSpan(
                                        // text: data.orderDate,
                                        text: data.quantity.toString(),
                                        style: TextStyle(
                                            color: isDarkMode()
                                                ? lableColor
                                                : black,
                                            fontFamily: fontBold,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w800),
                                      )
                                    ],
                                  ),
                                ),
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
                                            data.quantity!.value--;
                                            if (data.quantity!.value <= 0) {
                                              cartItems.removeAt(index);
                                            }
                                            // Product already in the cart, decrement the quantity
                                            await UserPreferences().addToCart(
                                              data,
                                              -1, // Pass a negative quantity for decrement
                                            );
                                            update();
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
                                          data.quantity.toString(),
                                          style: TextStyle(
                                            //fontFamily: fontBold,
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
                                            data.quantity!.value += 1;
                                            await UserPreferences().addToCart(
                                              data,
                                              data.quantity!.value,
                                            );
                                            update();
                                          },
                                          child: Icon(
                                            Icons.add,
                                            size: 3.h,
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))),
        ],
      ),
    );
  }

  Widget getOrderText(title, desc, {bool? isNormal}) {
    return FadeInUp(
      child: Row(
        children: [
          Text(
            title,
            style: isNormal == true
                ? TextStyle(
                    fontFamily: fontRegular,
                    color: isDarkMode() ? white : black,
                    fontWeight: FontWeight.w400,
                    fontSize: SizerUtil.deviceType == DeviceType.mobile
                        ? 10.sp
                        : 10.sp,
                  )
                : TextStyle(
                    fontFamily: fontBold,
                    color: isDarkMode() ? lableColor : black,
                    fontWeight: FontWeight.w900,
                    fontSize: SizerUtil.deviceType == DeviceType.mobile
                        ? 14.sp
                        : 13.sp,
                  ),
          ),
          const Spacer(),
          Text(
            desc,
            style: isNormal == true
                ? TextStyle(
                    fontFamily: fontRegular,
                    color: isDarkMode() ? white : black,
                    fontWeight: FontWeight.w400,
                    fontSize: SizerUtil.deviceType == DeviceType.mobile
                        ? 10.sp
                        : 10.sp,
                  )
                : TextStyle(
                    fontFamily: fontBold,
                    color: primaryColor,
                    fontWeight: FontWeight.w800,
                    fontSize: SizerUtil.deviceType == DeviceType.mobile
                        ? 14.sp
                        : 7.sp,
                  ),
          ),
        ],
      ),
    );
  }

  // /// when the user press on delete icon
  // onDeletePressed(int productId) {
  //   var product = DummyHelper.products.firstWhere((p) => p.id == productId);
  //   product.quantity = 0;
  //   getCartProducts();
  // }

  // /// get the cart products from the product list
  // getCartProducts() {
  //   products = DummyHelper.products.where((p) => p.quantity! > 0).toList();
  //   // calculate the total price
  //   total = products.fold<double>(0, (p, c) => p + c.price! * c.quantity!);
  //   update();
  // }
}
