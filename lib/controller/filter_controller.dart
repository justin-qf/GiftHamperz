import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/models/homeModel.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class FilterController extends GetxController {
  RxInt currentPage = 0.obs;
  RxBool isLoading = false.obs;
  SfRangeValues values = const SfRangeValues(40.0, 80.0);
  double startValue = 0.0;
  double endValue = 200.0;

  RxList<FlowerType> flowersList = [
    FlowerType(title: 'All Flower', isSelected: false),
    FlowerType(title: 'Rose', isSelected: false),
    FlowerType(title: 'Best Sellers', isSelected: true),
    FlowerType(title: 'Mixed', isSelected: false),
    FlowerType(title: 'Lilies', isSelected: true),
    FlowerType(title: 'Orchids', isSelected: true),
    FlowerType(title: 'Sunflowers', isSelected: false),
    FlowerType(title: 'Plnants', isSelected: false),
    FlowerType(title: 'Succulents', isSelected: false),
    FlowerType(title: 'Carnations', isSelected: false),
  ].obs;
  RxList<FlowerType> occassionList = [
    FlowerType(title: 'All Days', isSelected: false),
    FlowerType(title: 'Birthday', isSelected: false),
    FlowerType(title: 'Just Beacuse', isSelected: true),
    FlowerType(title: 'Same-Day', isSelected: false),
    FlowerType(title: 'Love & Romance', isSelected: true),
    FlowerType(title: 'Easter', isSelected: true),
    FlowerType(title: 'Sympathy', isSelected: false),
    FlowerType(title: 'Mothers Day', isSelected: false),
  ].obs;
  RxList<ColorsList> colorsList = [
    ColorsList(title: 'Blues', color: Colors.blueAccent, isSelected: false),
    ColorsList(title: 'Reds', color: Colors.red, isSelected: false),
    ColorsList(title: 'Pinks', color: Colors.pink, isSelected: false),
    ColorsList(title: 'Yellows', color: Colors.yellow, isSelected: false),
    ColorsList(title: 'Greens', color: Colors.green, isSelected: false),
    ColorsList(title: 'Purples', color: Colors.purple, isSelected: false),
    ColorsList(title: 'Orages', color: Colors.orange, isSelected: false),
    ColorsList(title: 'Whites', color: white, isSelected: false),
  ].obs;

  RxList<ReviewsList> color = [
    ReviewsList(title: 'Blue', isSelected: false),
    ReviewsList(title: 'Red', isSelected: false),
    ReviewsList(title: 'Pink', isSelected: false),
    ReviewsList(title: 'Yellow', isSelected: false),
    ReviewsList(title: 'Green', isSelected: false),
    ReviewsList(title: 'Purple', isSelected: false),
    ReviewsList(title: 'Orange', isSelected: false),
    ReviewsList(title: 'White', isSelected: false),
    ReviewsList(title: 'Black', isSelected: false),
    ReviewsList(title: 'Grey', isSelected: false),
  ].obs;

  RxList<ReviewsList> review = [
    ReviewsList(title: '1.0 & above', isSelected: false),
    ReviewsList(title: '2.0 & above', isSelected: false),
    ReviewsList(title: '3.0 & above', isSelected: false),
    ReviewsList(title: '4.0 & above', isSelected: false),
  ].obs;

  getBlackOverlayGradient() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFffffff),
        gradient: LinearGradient(
          colors: [
            black,
            black.withOpacity(0.4),
            black.withOpacity(0.0),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: const [0.0, 0.7, 1.0],
        ),
      ),
    );
  }

  getOverlayGradient() {
    return Positioned(
      top: 20.h,
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFffffff),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.8),
              Colors.white.withOpacity(0.0),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: const [0.0, 0.7, 1.0],
          ),
        ),
      ),
    );
  }

  RxBool isChecked = false.obs;

  getReviewCheckBox(ReviewsList colorsList) {
    return Theme(
      data: ThemeData(
          checkboxTheme: CheckboxThemeData(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)))),
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: isDarkMode() ? white : black,
        checkColor: isDarkMode() ? black : white,
        //visualDensity: const VisualDensity(horizontal: -1, vertical: -1),
        contentPadding: const EdgeInsets.only(top: 0.5, bottom: 0.5),
        value: colorsList.isSelected.value,
        onChanged: (bool? value) {
          colorsList.isSelected.value = value!;
        },
        title: Text(
          colorsList.title,
          style: TextStyle(
              color: isDarkMode() ? white : black,
              fontFamily: fontBold,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  getRoundShapCheckBox(FlowerType flowersList) {
    return FadeInUp(
      child: Center(
          child: InkWell(
        borderRadius:
            BorderRadius.circular(20.0), // Adjust the radius as needed
        onTap: () {
          flowersList.isSelected.value = !flowersList.isSelected.value;
          update();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 3.h,
              height: 3.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    flowersList.isSelected.value ? primaryColor : selectColor,
                border: Border.all(
                  width: 2.0,
                  color: flowersList.isSelected.value ? primaryColor : grey,
                ),
              ),
              child: flowersList.isSelected.value
                  ? Icon(
                      Icons.check,
                      size: 2.h,
                      color: white,
                    )
                  : Icon(
                      Icons.check,
                      size: 2.h,
                      color: grey,
                    ),
            ),
            getDynamicSizedBox(width: 3.w),
            Text(
              flowersList.title,
              style: TextStyle(
                fontSize: 10.sp,
                fontFamily: fontBold,
                fontWeight: FontWeight.bold,
                color: isDarkMode() ? white : black,
              ),
            ),
          ],
        ),
      )),
    );
  }

  getRoundShapCheckBoxWithColors(ColorsList colorsList) {
    return FadeInUp(
      child: Center(
          child: InkWell(
        borderRadius:
            BorderRadius.circular(20.0), // Adjust the radius as needed
        onTap: () {
          colorsList.isSelected.value = !colorsList.isSelected.value;
          update();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 3.h,
              height: 3.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorsList.color,
                border: Border.all(
                  width: 2.0,
                  color: colorsList.isSelected.value ? primaryColor : grey,
                ),
              ),
              child: colorsList.isSelected.value
                  ? Icon(
                      Icons.check,
                      size: 2.h,
                      color: white,
                    )
                  : null,
            ),
            getDynamicSizedBox(width: 3.w),
            Text(
              colorsList.title,
              style: TextStyle(
                color: isDarkMode() ? white : black,
                fontSize: 10.sp,
                fontFamily: fontBold,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      )),
    );
  }
}
