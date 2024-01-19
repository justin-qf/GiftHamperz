import 'dart:convert';

import 'package:get/get.dart';
import 'package:gifthamperz/api_handle/Repository.dart';
import 'package:gifthamperz/componant/dialogs/dialogs.dart';
import 'package:gifthamperz/componant/dialogs/loading_indicator.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/apicall_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/internet_controller.dart';
import 'package:gifthamperz/models/favouriteModel.dart';
import 'package:gifthamperz/models/loginModel.dart';
import 'package:gifthamperz/preference/UserPreference.dart';
import 'package:gifthamperz/utils/log.dart';

void addFavouriteAPI(context, InternetController networkManager,
    String productId, String type, String screenName,
    {bool? isFromList,
    FavouriteList? item,
    RxList? favouriteFilterList}) async {
  var loadingIndicator = LoadingProgressDialog();
  loadingIndicator.show(context, '');
  try {
    if (networkManager.connectionType == 0) {
      loadingIndicator.hide(context);
      showDialogForScreen(context, screenName, Connection.noConnection,
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
    var data = jsonDecode(response.body);
    logcat("tag", data);
    if (response.statusCode == 200) {
      if (data['status'] == 1) {
        if (isFromList != null && isFromList == true) {
          for (FavouriteList mo in favouriteFilterList!) {
            if (productId == mo.id.toString()) {
              favouriteFilterList.remove(mo);
            }
            break;
          }
        }
        showCustomToast(context, data['message'].toString());
      } else {
        showCustomToast(context, data['message'].toString());
      }
    } else {
      showDialogForScreen(context, screenName, data['message'] ?? "",
          callback: () {});
      loadingIndicator.hide(context);
    }
  } catch (e) {
    logcat("Exception", e);
    showDialogForScreen(context, screenName, ServerError.servererror,
        callback: () {});
  } finally {
    loadingIndicator.hide(context);
  }
}
