import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/api_handle/Repository.dart';
import 'package:gifthamperz/componant/dialogs/dialogs.dart';
import 'package:gifthamperz/configs/apicall_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/models/SubCategoryModel.dart';
import 'package:gifthamperz/models/innerSubCategoryModel.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:sizer/sizer.dart';
import '../utils/enum.dart';
import 'internet_controller.dart';

class InnerSubCategoryController extends GetxController {
  List pageNavigation = [];
  RxInt currentTreeView = 2.obs;
  RxBool isLiked = true.obs;
  RxBool isTreeModeVertical = true.obs;
  RxBool accessToDrawer = false.obs;
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  final InternetController networkManager = Get.find<InternetController>();
  late TabController tabController;
  var currentPage = 0;

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  Widget getText(title, TextStyle? style) {
    return Padding(
      padding: EdgeInsets.only(left: 0.5.w, right: 0.5.w),
      child: Text(
        title,
        style: style,
      ),
    );
  }

  RxList subCategoryList = [].obs;
  void getInnerSubCategoryList(context, categoryId, subcategoryId) async {
    state.value = ScreenState.apiLoading;
    try {
      if (networkManager.connectionType == 0) {
        showDialogForScreen(context, CategoryScreenConstant.subCategorytitle,
            Connection.noConnection, callback: () {
          Get.back();
        });
        return;
      }

      var response = await Repository.post({
        "category_id": categoryId.toString(),
        "subcategory_id": subcategoryId.toString(),
      }, ApiUrl.getSubCategory, allowHeader: true);
      logcat("RESPONSE::", response.body);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          var categoryData = InnerSubCategoryModel.fromJson(responseData);
          subCategoryList.clear();
          if (categoryData.data.isNotEmpty) {
            subCategoryList.addAll(categoryData.data);
            update();
          } else {
            subCategoryList.addAll([]);
          }
        } else {
          message.value = responseData['message'];
          showDialogForScreen(context, CategoryScreenConstant.subCategorytitle,
              responseData['message'],
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(context, CategoryScreenConstant.subCategorytitle,
            ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      logcat("Ecxeption", e);
      state.value = ScreenState.apiError;
      message.value = ServerError.servererror;
      showDialogForScreen(context, CategoryScreenConstant.subCategorytitle,
          ServerError.servererror,
          callback: () {});
    }
  }

}
