import 'dart:async';
import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/api_handle/Repository.dart';
import 'package:gifthamperz/componant/dialogs/customDialog.dart';
import 'package:gifthamperz/componant/dialogs/dialogs.dart';
import 'package:gifthamperz/componant/dialogs/loading_indicator.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/configs/apicall_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/models/addressModel.dart';
import 'package:gifthamperz/models/homeModel.dart';
import 'package:gifthamperz/utils/enum.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/DeliveryScreen/AddAddressScreen.dart';
import 'package:sizer/sizer.dart';
import 'internet_controller.dart';

class AddressScreenController extends GetxController {
  List pageNavigation = [];
  RxInt currentTreeView = 2.obs;
  RxBool isLiked = true.obs;
  RxBool isTreeModeVertical = true.obs;
  RxBool accessToDrawer = false.obs;
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  final InternetController networkManager = Get.find<InternetController>();
  late TabController tabController;
  RxInt currentIndex = RxInt(-1);
  RxBool isLoading = false.obs;
  RxList addressList = [].obs;
  RxString nextPageURL = "".obs;

  RxList<AddressItem> addressData = <AddressItem>[
    AddressItem("Home", '137, Last Bus Stop, Bapunagar ,ahmedabad'),
    AddressItem("Office", '510/Satva Icon, Vastral'),
    AddressItem("Parent Home", '8312 North Lake Forest St. New York, NY-10003'),
    AddressItem("Sister Home", '6524 North Lake Forest St. New York, NY-10035'),
    AddressItem(
        "Brother Home", '2541 North Lake Forest St. New York, NY-10014'),
  ].obs;

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

  void getAddressList(context, currentPage, bool hideloading) async {
    if (hideloading == true) {
      state.value = ScreenState.apiLoading;
    } else {
      isLoading.value = true;
      update();
    }

    try {
      if (networkManager.connectionType == 0) {
        showDialogForScreen(
            context, AddAddressText.addressTitle, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      //var pageURL = ApiUrl.getAddress + currentPage.toString();
      var pageURL = ApiUrl.getAddress;

      logcat("URL", pageURL.toString());
      var response = await Repository.post({
        // "city_id": 25,
      }, pageURL, allowHeader: true);

      // loadingIndicator.hide(context);
      var data = jsonDecode(response.body);
      logcat("RESPONSE", jsonEncode(data));
      logcat("StatusCode", response.statusCode.toString());
      if (response.statusCode == 200) {
        if (data['status'] == 1) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          isLoading.value = false;
          var responseData = AddressModel.fromJson(data);
          logcat("LISTEMPTY", responseData.data.data.length.toString());
          if (responseData.data.data.isNotEmpty) {
            addressList.clear();
            addressList.addAll(responseData.data.data);
            nextPageURL.value = responseData.data.nextPageUrl.toString();
          } else {
            //state.value = ScreenState.noDataFound;
          }
          logcat("NextPageURL", nextPageURL.value.toString());
          // currentPage++;
          update();
        } else {
          isLoading.value = false;
          message.value = data['message'];
          state.value = ScreenState.apiError;
          showDialogForScreen(
              context, AddAddressText.addressTitle, data['message'].toString(),
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        isLoading.value = false;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(
            context, AddAddressText.addressTitle, data['message'].toString(),
            callback: () {});
      }
    } catch (e) {
      isLoading.value = false;
      state.value = ScreenState.apiError;
      message.value = ServerError.servererror;
    }
  }

  void addDefaultAddressAPI(context, String addressId) async {
    var loadingIndicator = LoadingProgressDialog();
    loadingIndicator.show(context, '');
    try {
      if (networkManager.connectionType == 0) {
        loadingIndicator.hide(context);
        showDialogForScreen(
            context, AddAddressText.addressTitle, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      logcat('loginPassingData', {
        "address_id": addressId.toString().trim(),
      });

      var response = await Repository.post({
        "address_id": addressId.toString().trim(),
      }, ApiUrl.addDefaultAddress, allowHeader: true);
      loadingIndicator.hide(context);
      var data = jsonDecode(response.body);
      logcat("tag", data);
      if (response.statusCode == 200) {
        if (data['status'] == 1) {
          showDialogForScreen(
              context, AddAddressText.addressTitle, data['message'],
              callback: () {
            Get.back(result: true);
          });
        } else {
          showDialogForScreen(
              context, AddAddressText.addressTitle, data['message'],
              callback: () {});
        }
      } else {
        showDialogForScreen(
            context, AddAddressText.addressTitle, data['message'] ?? "",
            callback: () {});
      }
    } catch (e) {
      logcat("Exception", e);
      showDialogForScreen(
          context, AddAddressText.addressTitle, ServerError.servererror,
          callback: () {});
    }
  }

  getListItem(BuildContext context, AddressListItem data, int index) {
    return Obx(
      () {
        bool isSelected = index == currentIndex.value;
        return FadeInUp(
          child: Container(
            margin: EdgeInsets.only(
                top: 1.h, left: 5.5.w, right: 5.5.w, bottom: 1.h),
            padding: EdgeInsets.only(
                top: 1.5.h, left: 4.w, right: 4.w, bottom: 1.5.h),
            decoration: BoxDecoration(
              color: isDarkMode() ? itemDarkBackgroundColor : white,
              border: Border.all(
                color: isSelected
                    ? primaryColor
                    : transparent, // Set the border color here
                width: 2.0, // Set the border width
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: isDarkMode()
                        ? grey.withOpacity(0.2)
                        : grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0.3, 0.3)),
              ],
            ),
            child: InkWell(
              onTap: () {
                currentIndex.value = isSelected ? -1 : index;
                update();
                //controller.currentIndex = index; // Select the item
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 60.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              data.name.toString(),
                              style: TextStyle(
                                  fontSize:
                                      SizerUtil.deviceType == DeviceType.mobile
                                          ? 12.sp
                                          : 13.sp,
                                  fontFamily: fontBold,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode() ? white : black),
                            ),
                            getDynamicSizedBox(height: 0.5.h),
                            Text(
                              data.address.toString(),
                              style: TextStyle(
                                  fontSize:
                                      SizerUtil.deviceType == DeviceType.mobile
                                          ? 11.sp
                                          : 13.sp,
                                  fontFamily: fontBold,
                                  color: lableColor),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.to(AddAddressScreen(
                            isFromEdit: true,
                            itemData: data,
                          ))!
                              .then((value) {
                            logcat("value", value.toString());
                            if (value == true) {
                              getAddressList(context, 0, true);
                            }
                            Statusbar().trasparentStatusbarIsNormalScreen();
                          });
                        },
                        child: SizedBox(
                          width: 8.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.mode_edit_rounded,
                                size: 2.6.h,
                              ),
                              // Radio(
                              //   value: index,
                              //   activeColor: primaryColor,
                              //   groupValue: controller.currentIndex,
                              //   onChanged: (value) {
                              //     setState(() {
                              //       controller.currentIndex = value as int;
                              //     });
                              //   },
                              // )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  getDynamicSizedBox(height: 0.5.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Statusbar().trasparentStatusbarProfile(true);
        return const CustomRoundedDialog(); // Use your custom dialog widget
      },
    );
  }
}
