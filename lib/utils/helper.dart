import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gifthamperz/configs/apicall_constant.dart';
import 'package:gifthamperz/configs/assets_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/get_storage_key.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/controller/homeController.dart';
import 'package:gifthamperz/controller/productDetailController.dart';
import 'package:gifthamperz/preference/UserPreference.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/DeliveryScreen/AddressScreen.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../models/UpdateDashboardModel.dart';

bool isDarkMode() {
  bool isDark;
  var data = GetStorage().read(GetStorageKey.IS_DARK_MODE);
  if (data == null || data.toString().isEmpty) {
    isDark = false;
  } else if (GetStorage().read(GetStorageKey.IS_DARK_MODE) == 1) {
    isDark = false;
  } else {
    isDark = true;
  }
  return isDark;
}

Future<DateTime?> getDateTimePicker(context) async {
  DateTime? value = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100));
  return value;
}

PageRouteBuilder customPageRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

String convert24HourTo12Hour(String time24Hour) {
  DateFormat format24Hour = DateFormat('HH:mm:ss');
  DateFormat format12Hour = DateFormat('hh:mm:ss a');

  DateTime dateTime = format24Hour.parse(time24Hour);
  String time12Hour = format12Hour.format(dateTime);

  return time12Hour;
}

String getFormateDate(String date) {
  String formattedData = DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
  return formattedData;
}

incrementDecrementCartItem(
    {bool? isFromIcr,
    CommonProductList? data,
    List<CommonProductList>? itemList,
    int? quantity,
    bool? isFromBuyNow}) async {
  if (isFromIcr == true) {
    logcat("isFromIcrQuantity::", quantity.toString());
    List<CommonProductList> cartItems = await UserPreferences().loadCartItems();
    int existingIndex = cartItems.indexWhere(
      (item) => item.id == data!.id,
    );
    data!.isInCart!.value = true;
    data.quantity!.value = 1;
    if (existingIndex != -1) {
      // Product already in the cart, update the quantity
      cartItems[existingIndex].quantity!.value += 1;
      // Save the updated cart back to preferences
      await UserPreferences().addToCart(
        data,
        cartItems[existingIndex].quantity!.value,
      );
    } else {
      // Product not in the cart, add it with quantity 1
      CommonProductList newProduct = data.copyWith(quantity: 1);
      cartItems.add(newProduct);
      // Save the updated cart back to preferences
      await UserPreferences().addToCart(data, 1);
    }
  } else {
    logcat("quantity::", quantity.toString());
    // Fetch the current cart items from preferences
    List<CommonProductList> cartItems = await UserPreferences().loadCartItems();
    // Check if the product is already in the cart
    int existingIndex = cartItems.indexWhere(
      (item) => item.id == data!.id,
    );
    if (quantity! > 0) {
      logcat("isItemIsGreater", "DONE");
      quantity--;
      if (existingIndex != -1) {
        // Product already in the cart, decrement the quantity
        await UserPreferences().addToCart(
          data!,
          -1, // Pass a negative quantity for decrement
        );
      } else {
        // Product not in the cart, add it with quantity 1
        CommonProductList newProduct = data!.copyWith(quantity: 1);
        cartItems.add(newProduct);
        // Save the updated cart back to preferences
        await UserPreferences().addToCart(data, 1);
      }
    } else {
      logcat("isItemIsLess", "DONE");
      // Quantity is 0, remove the item from the cart if it exists
      if (existingIndex != -1) {
        cartItems.removeAt(existingIndex);
        // Update the cart in preferences to remove the item
        await UserPreferences().addToCart(
          data!,
          -1, // Pass a negative quantity for decrement
        );
      }
    }
  }

  if (isFromBuyNow == true) {
    Get.to(AddressScreen(
      isFromBuyNow: true,
      id: data!.id,
    ))!
        .then((value) {
      Statusbar().trasparentStatusbarProfile(true);
    });
  }

  // List<CommonProductList> cartItems = await UserPreferences().loadCartItems();
  // // Check if the product is already in the cart
  // int existingIndex = cartItems.indexWhere(
  //   (item) => item.id == data!.id,
  // );
  // if (existingIndex != 1) {
  //   // Update the corresponding item in the other list
  //   int otherListIndex = itemList!.indexWhere((item) => item.id == data!.id);
  //   if (otherListIndex != -1) {
  //     itemList[otherListIndex].quantity!.value = data!.quantity!.value;
  //     itemList[otherListIndex].isInCart!.value = data.isInCart!.value;
  //   }
  //   updateQuantityInOtherList(data, itemList);
  // }

  Get.find<HomeScreenController>().getTotalProductInCart();

  if (itemList != null) {
    // Update the corresponding item in the other list
    int otherListIndex = itemList.indexWhere((item) => item.id == data!.id);
    if (otherListIndex != -1) {
      itemList[otherListIndex].quantity!.value = data!.quantity!.value;
      itemList[otherListIndex].isInCart!.value = data.isInCart!.value;
    }
    updateQuantityInOtherList(data, itemList);
  }
}

void updateQuantityInOtherList(
    CommonProductList? data, List<CommonProductList> trendingList) {
  // Find the item in the other list with the same ID
  CommonProductList? itemInOtherList = findItemById(trendingList, data?.id);

  // Update the quantity in the other list
  itemInOtherList.quantity!.value = data?.quantity?.value ?? 0;
}

CommonProductList findItemById(List<CommonProductList> list, int? id) {
  // Find the item in the list with the specified ID
  return list.firstWhere((item) => item.id == id,
      orElse: () => [] as CommonProductList);
}

incrementDecrementCartItemInList({
  bool? isFromIcr,
  CommonProductList? data,
  List<CommonProductList>? itemList,
  int? quantity,
}) async {
  // Fetch the current cart items from preferences
  List<CommonProductList> cartItems = await UserPreferences().loadCartItems();
  // Check if the product is already in the cart
  int existingIndex = cartItems.indexWhere(
    (item) => item.id == data!.id,
  );
  if (isFromIcr == true) {
    data!.quantity!.value++;
    if (existingIndex != -1) {
      // Product already in the cart, update the quantity
      cartItems[existingIndex].quantity!.value += 1;
      // Save the updated cart back to preferences
      await UserPreferences().addToCart(
        data,
        cartItems[existingIndex].quantity!.value,
      );
    } else {
      // Product not in the cart, add it with quantity 1
      CommonProductList newProduct = data.copyWith(quantity: 1);
      cartItems.add(newProduct);
      // Save the updated cart back to preferences
      await UserPreferences().addToCart(data, 1);
    }
  } else {
    if (data!.quantity!.value == 1) {
      data.isInCart!.value = false;
      cartItems[existingIndex].quantity!.value -= 1;
      await UserPreferences().addToCart(
        data,
        -1,
      );
      updateQuantityInOtherList(data, itemList!);
      Get.find<HomeScreenController>().update();
    } else {
      if (data.quantity!.value > 0) {
        // Fetch the current cart items from preferences
        data.quantity!.value--;
        if (existingIndex != -1) {
          cartItems[existingIndex].quantity!.value -= 1;
          await UserPreferences().addToCart(
            data,
            -1,
          );
        } else {
          CommonProductList newProduct = data.copyWith(quantity: 1);
          cartItems.add(newProduct);
          // Save the updated cart back to preferences
          await UserPreferences().addToCart(data, 1);
        }
      } else {
        data.isInCart!.value = false;
      }
    }
  }

  Get.find<HomeScreenController>().getTotalProductInCart();
  // Update the corresponding item in the other list
  if (itemList != null) {
    int otherListIndex = itemList.indexWhere((item) => item.id == data.id);
    if (otherListIndex != -1) {
      itemList[otherListIndex].quantity!.value = data.quantity!.value;
      itemList[otherListIndex].isInCart!.value = data.isInCart!.value;
    }
  }
  updateQuantityInOtherList(data, itemList!);
}

String formatPrice(double price) {
  NumberFormat numberFormat = NumberFormat.currency(
    symbol: '',
    decimalDigits: 2,
    locale: 'en_IN', // Use 'en_IN' for the Indian number format
  );
  return numberFormat.format(price);
}

String getCurrentDate() {
  // Get current date
  DateTime now = DateTime.now();

  // Format the date
  return DateFormat('yyyy-MM-dd').format(now);
}

String getCurrentTime() {
  // Get current time
  DateTime now = DateTime.now();
  // Format the time
  return DateFormat('HH:mm:ss').format(now);
}

futureDelay(Function onClick) {
  return Future.delayed(
    Duration.zero,
    () => onClick(),
  );
}

getPageView(HomeScreenController controller, Function onClick) {
  return Stack(
    children: [
      PageView.builder(
        pageSnapping: true,
        controller: controller.pageController,
        itemCount: controller.bannerList.length,
        itemBuilder: (context, index) {
          BannerList bannerItems = controller.bannerList[index];
          return Container(
            margin: EdgeInsets.only(
                top: 1.h,
                left: SizerUtil.deviceType == DeviceType.mobile ? 2.w : 3.w,
                right: SizerUtil.deviceType == DeviceType.mobile ? 3.w : 3.w,
                bottom: 1.h),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isDarkMode() ? black : white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: isDarkMode()
                        ? white.withOpacity(0.2)
                        : black.withOpacity(0.2),
                    spreadRadius: 0.1,
                    blurRadius: 10,
                    offset: const Offset(0.5, 0.5)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                height: 18.h,
                imageUrl: ApiUrl.imageUrl + bannerItems.url,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(color: primaryColor),
                ),
                errorWidget: (context, url, error) => Image.asset(
                  Asset.productPlaceholder,
                  height: 18.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        onPageChanged: (index) {
          onClick(index);
        },
      ),
      Positioned(
          bottom: 15,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(controller.bannerList.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                width: 2.w,
                height: 2.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: controller.currentPage == index ? primaryColor : grey,
                ),
              );
            }),
          ))
    ],
  );
}

getDetailScreenPageView(ProductDetailScreenController controller,
    List<String> images, Function onClick) {
  return Stack(children: [
    PageView.builder(
      pageSnapping: true,
      controller: controller.pageController,
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Container(
            margin: EdgeInsets.only(bottom: 0.9.h),
            decoration: BoxDecoration(
                boxShadow: isDarkMode()
                    ? null
                    : [
                        BoxShadow(
                            color: grey.withOpacity(0.5),
                            blurRadius: 1,
                            offset: const Offset(0, 3),
                            spreadRadius: 0.2)
                      ],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(7.w),
                    bottomRight: Radius.circular(7.w))),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(7.w),
                  bottomRight: Radius.circular(7.w)),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                height: 14.h,
                imageUrl: ApiUrl.imageUrl + images[0],
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(color: primaryColor),
                ),
                errorWidget: (context, url, error) => Image.asset(
                  Asset.placeholder,
                  height: 9.h,
                  fit: BoxFit.cover,
                ),
              ),
            ));
      },
      onPageChanged: (index) {
        onClick(index);
      },
    ),
    Positioned(
        bottom: 20,
        left: 0,
        right: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(images.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              width: SizerUtil.deviceType == DeviceType.mobile ? 2.w : 1.8.w,
              height: SizerUtil.deviceType == DeviceType.mobile ? 2.w : 1.8.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: controller.currentPage == index ? primaryColor : white,
                border: Border.all(
                  color: black, // Border color
                  width: SizerUtil.deviceType == DeviceType.mobile
                      ? 0.5
                      : 1, // Border width
                ),
                boxShadow: [
                  BoxShadow(
                      color: grey.withOpacity(0.2),
                      blurRadius: 5.0,
                      offset: const Offset(0, 1),
                      spreadRadius: 3.0)
                ],
              ),
            );
          }),
        ))
  ]);
}

getDarkModeDatePicker() {
  return ThemeData.dark().copyWith(
      primaryColor: white,
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50), // Set your border radius
        ),
      ),
      colorScheme: const ColorScheme.dark(
          //   primary:
          //       primaryColor, // Set your primary color
          // )
          ));
}

getLightModeDatePicker() {
  return ThemeData.light().copyWith(
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Set your border radius
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: primaryColor, // Set your primary color
      background: white,
    ).copyWith(secondary: white), // Set date selected color to white
  );
}

screenOrientations() {
  return SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
