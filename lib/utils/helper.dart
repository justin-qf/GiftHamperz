import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/get_storage_key.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/controller/homeController.dart';
import 'package:gifthamperz/models/DashboadModel.dart';
import 'package:gifthamperz/preference/UserPreference.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/DeliveryScreen/AddressScreen.dart';
import 'package:intl/intl.dart';

import '../models/UpdateDashboardModel.dart';

bool isDarkMode() {
  bool isDark;
  var data = GetStorage().read(GetStorageKey.IS_DARK_MODE);
  if (data == null || data.toString().isEmpty) {
    isDark = false;
    //logcat('IsDarkModeEMPTY', isDark);
  } else if (GetStorage().read(GetStorageKey.IS_DARK_MODE) == 1) {
    isDark = false;
    //logcat('IsLIGHTModeEMPTY', isDark);
  } else {
    isDark = true;
    //logcat('IsDarkMode', isDark);
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
    List<CommonProductList> cartItems = await UserPreferences().loadCartItems();
    int existingIndex = cartItems.indexWhere(
      (item) => item.id == data!.id,
    );
    data!.isInCart!.value = true;
    data.quantity!.value = 1;
    if (existingIndex != -1) {
      logcat("existingIndex", 'InCARTTTTT');
      // Product already in the cart, update the quantity
      cartItems[existingIndex].quantity!.value += 1;
      // Save the updated cart back to preferences
      await UserPreferences().addToCart(
        data,
        cartItems[existingIndex].quantity!.value,
      );
    } else {
      logcat("existingIndex", 'ItemNotInCart');
      // Product not in the cart, add it with quantity 1
      CommonProductList newProduct = data.copyWith(quantity: 1);
      cartItems.add(newProduct);
      // Save the updated cart back to preferences
      await UserPreferences().addToCart(data, 1);
    }
  } else {
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
    logcat("isItemIsLessssss", "DONE");

    if (data!.quantity!.value == 1) {
      logcat("Quanity::::::", data.quantity!.value.toString());
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

getDarkModeDatePicker() {
  return ThemeData.dark().copyWith(
      primaryColor: white,
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50), // Set your border radius
        ),
      ),
      useMaterial3: true,
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
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primaryColor, // Set your primary color
      background: white,
    ).copyWith(secondary: white), // Set date selected color to white
  );
}
