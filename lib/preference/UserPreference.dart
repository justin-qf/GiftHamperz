import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:gifthamperz/models/DashboadModel.dart';
import 'package:gifthamperz/models/loginModel.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  final box = GetStorage();
  var pref = SharedPreferences.getInstance();
  var userKey = "user";
  var tokenKey = "token";

  getPref() async {
    return await SharedPreferences.getInstance();
  }

  read() async {
    pref = SharedPreferences.getInstance();
  }

  void saveSignInInfo(UserData? data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('signIn', json.encode(data));
  }

  Future<UserData?> getSignInInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('signIn');
    if (jsonString != null) {
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      return UserData.fromJson(jsonMap);
    }
    return null;
  }

  Future<void> setIsGuestUser(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('guest', value);
  }

  Future<bool> getGuestUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('guest') ??
        true; // Default to false if the key is not found
  }

  Future<void> setToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, value);
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey) ?? "";
  }

  Future<void> setUserType(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, value);
  }

  Future<String> getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userKey) ?? "";
  }

  Future<void> setBoolValue(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('myBoolKey', value);
  }

  Future<bool> getBoolValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('myBoolKey') ??
        false; // Default to false if the key is not found
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> addToCart(CommonProductList product, int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve existing cart items
    String? cartItemsJson = prefs.getString('cartItems');
    List<CommonProductList> cartItems = [];

    if (cartItemsJson != null && cartItemsJson.isNotEmpty) {
      cartItems = (json.decode(cartItemsJson) as List<dynamic>)
          .map((item) => CommonProductList.fromJson(item))
          .toList();
    }

    // Check if the item is already in the cart
    int existingIndex = cartItems.indexWhere((item) => item.id == product.id);

    logcat("addToCart:::COUNTER", quantity.toString());
    if (existingIndex != -1) {
      logcat("Step-1", 'Dome');
      // Item already in the cart, update quantity
      if (quantity > 0) {
        logcat("Step-2", 'Dome');
        // Increment quantity
        cartItems[existingIndex].quantity!.value += 1;
      } else {
        logcat("Step-3", 'Dome');
        // Decrement quantity
        cartItems[existingIndex].quantity!.value -= 1;

        // Remove item if the quantity becomes 0
        if (cartItems[existingIndex].quantity!.value <= 0) {
          cartItems.removeAt(existingIndex);
        }
      }
    } else {
      // Item not in the cart, add it with quantity
      if (quantity > 0) {
        CommonProductList newProduct =
            product.copyWith(quantity: quantity, isInCart: true);
        cartItems.add(newProduct);
      }
    }
    // Save the updated cart back to preferences
    prefs.setString('cartItems', json.encode(cartItems));
  }

  // Future<void> addToCart(CommonProductList product, int quantity) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   // Retrieve existing cart items
  //   String? cartItemsJson = prefs.getString('cartItems');
  //   List<CommonProductList> cartItems = [];

  //   if (cartItemsJson != null && cartItemsJson.isNotEmpty) {
  //     cartItems = (json.decode(cartItemsJson) as List<dynamic>)
  //         .map((item) => CommonProductList.fromJson(item))
  //         .toList();
  //   }

  //   // Check if the item is already in the cart
  //   int existingIndex = cartItems.indexWhere((item) => item.id == product.id);

  //   logcat("addToCart:::COUNTER", quantity.toString());
  //   if (existingIndex != -1) {
  //     // Item already in the cart, increment quantity
  //     cartItems[existingIndex].quantity += 1;

  //     // Remove item if the quantity becomes 0
  //     if (cartItems[existingIndex].quantity <= 0) {
  //       cartItems.removeAt(existingIndex);
  //     }
  //   } else {
  //     // Item not in the cart, add it with quantity
  //     if (quantity > 0) {
  //       CommonProductList newProduct = product.copyWith(quantity: quantity);
  //       cartItems.add(newProduct);
  //     }
  //   }

  //   // Save the updated cart back to preferences
  //   prefs.setString('cartItems', json.encode(cartItems));
  // }

  Future<List<CommonProductList>> loadCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartItemsJson = prefs.getString('cartItems');
    List<CommonProductList> cartItems = [];

    if (cartItemsJson != null && cartItemsJson.isNotEmpty) {
      List<Map<String, dynamic>> itemsList =
          json.decode(cartItemsJson).cast<Map<String, dynamic>>();

      cartItems =
          itemsList.map((item) => CommonProductList.fromJson(item)).toList();
    }
    //logcat("CART_ITEMS_LIST:::", jsonEncode(cartItems));
    return cartItems;
  }

  Future<void> setGuestUserDialogVisible(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('guestUser', value);
  }

  Future<bool> getGuestUserDialogVisible() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('guestUser') ??
        false; // Default to false if the key is not found
  }

  //   Future<void> addToCart(CommonProductList product, int quantity) async {
  //   // Retrieve existing cart items
  //   List<Map<String, dynamic>> cartItems = box.read('cartItems') ?? [];

  //   // Check if the item is already in the cart
  //   int existingIndex = cartItems.indexWhere((item) => item["id"] == product.id);

  //   if (existingIndex != -1) {
  //     // Item already in the cart, update quantity
  //     cartItems[existingIndex]["quantity"] = quantity;

  //     // Remove item if the quantity becomes 0
  //     if (cartItems[existingIndex]["quantity"] <= 0) {
  //       cartItems.removeAt(existingIndex);
  //     }
  //   } else {
  //     // Item not in the cart, add it with quantity
  //     if (quantity > 0) {
  //       cartItems.add({
  //         ...product.toJson(),
  //         "quantity": quantity,
  //       });
  //     }
  //   }

  //   // Save the updated cart back to GetStorage
  //   box.write('cartItems', cartItems);
  // }

  // List<CommonProductList> loadCartItems() {
  //   // Retrieve existing cart items
  //   List<Map<String, dynamic>> cartItems = box.read('cartItems') ?? [];

  //   // Convert the list of maps to List<CommonProductList>
  //   List<CommonProductList> productList = cartItems
  //       .map((item) => CommonProductList.fromJson(item))
  //       .toList();

  //   return productList;
  // }
}
