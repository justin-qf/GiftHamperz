import 'dart:ui';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

class HomeItem {
  // ignore: prefer_typing_uninitialized_variables
  final icon;
  final String name;
  final String? price;
  RxBool isSelected;

  HomeItem(
      {required this.icon,
      required this.name,
      this.price,
      bool isSelected = false})
      : isSelected = isSelected.obs;
}

class CategoryItem {
  // ignore: prefer_typing_uninitialized_variables
  final icon;
  final String title;

  CategoryItem({
    required this.icon,
    required this.title,
  });
}

class SavedItem {
  // ignore: prefer_typing_uninitialized_variables
  final icon;
  final String name;
  final String? price;
  RxBool isSelected;

  SavedItem(
      {required this.icon,
      required this.name,
      this.price,
      bool isSelected = false})
      : isSelected = isSelected.obs;
}

class FlowerType {
  // ignore: prefer_typing_uninitialized_variables
  final title;
  RxBool isSelected;

  FlowerType({required this.title, bool isSelected = false})
      : isSelected = isSelected.obs;
}

class ColorsList {
  // ignore: prefer_typing_uninitialized_variables
  final title;
  RxBool isSelected;
  Color? color;

  ColorsList(
      {required this.title, required this.color, bool isSelected = false})
      : isSelected = isSelected.obs;
}

class ReviewsList {
  // ignore: prefer_typing_uninitialized_variables
  String title;
  RxBool isSelected;

  ReviewsList({required this.title, bool isSelected = false})
      : isSelected = isSelected.obs;
}

class OrderItem {
  String? title;
  String? status;
  String? orderDate;
  String? price;
  String? icone;
  OrderItem(
      {required this.title,
      required this.status,
      required this.orderDate,
      this.icone,
      required this.price});
}

class AddressItem {
  String? title;
  String? address;
  bool isSelected;

  AddressItem(this.title, this.address, {this.isSelected = false});
}

class CartItem {
  String? title;
  String? status;
  String? orderDate;
  double? price;
  String? icone;
  RxInt quantity;

  CartItem({
    required this.title,
    required this.status,
    required this.orderDate,
    required this.price,
    required this.icone,
    required int initialQuantity,
  }) : quantity = initialQuantity.obs;
}
