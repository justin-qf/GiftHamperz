import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/api_handle/Repository.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/dialogs/customDialog.dart';
import 'package:gifthamperz/componant/dialogs/dialogs.dart';
import 'package:gifthamperz/componant/dialogs/loading_indicator.dart';
import 'package:gifthamperz/componant/input/form_inputs.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/configs/apicall_constant.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/models/addressModel.dart';
import 'package:gifthamperz/models/homeModel.dart';
import 'package:gifthamperz/models/loginModel.dart';
import 'package:gifthamperz/models/validation_model.dart';
import 'package:gifthamperz/preference/UserPreference.dart';
import 'package:gifthamperz/utils/enum.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:gifthamperz/views/DeliveryScreen/AddAddressScreen.dart';
import 'package:gifthamperz/views/MainScreen/MainScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
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

  RxBool isGuest = false.obs;

  getGuestUser() async {
    isGuest.value = await UserPreferences().getGuestUser();
    update();
  }

  @override
  void onInit() {
    commentctr = TextEditingController();
    commentNode = FocusNode();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.onInit();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
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
    logcat("currentIndex-111", currentIndex.value.toString());
    String title;
    if (data.isOffice == 0) {
      title = '[Home]';
    } else {
      title = '[Work]';
    }
    return Obx(
      () {
        bool isSelected = index == currentIndex.value;
        return FadeInUp(
          child: Container(
            margin: EdgeInsets.only(
                top: 1.h, left: 5.5.w, right: 5.5.w, bottom: 1.h),
            padding:
                EdgeInsets.only(top: 1.h, left: 4.w, right: 4.w, bottom: 1.h),
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
                logcat("currentIndex", currentIndex.value.toString());
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
                              "${data.name} $title",
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
                                size: 2.3.h,
                              ),
                              Radio(
                                value: index,
                                activeColor: primaryColor,
                                groupValue: currentIndex.value,
                                onChanged: (value) {
                                  currentIndex.value = value as int;
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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

  late TextEditingController commentctr;
  double userRating = 3.5;
  late FocusNode commentNode;
  var commentModel = ValidationModel(null, null, isValidate: false).obs;
  RxBool isFormInvalidate = false.obs;

  Future<Future> getReviewBottomSheetDialog(BuildContext parentContext) async {
    commentctr.text = '';
    return showModalBottomSheet(
        context: parentContext,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.w),
          topRight: Radius.circular(10.w),
        )),
        constraints: BoxConstraints(
          maxWidth: SizerUtil.width, // here increase or decrease in width
        ),
        useSafeArea: true,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    color: white,
                    child: Wrap(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.w),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.8),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.w),
                                    )),
                                padding:
                                    EdgeInsets.only(top: 2.5.h, bottom: 2.h),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    ReviewsScreenConstant.title,
                                    style: TextStyle(
                                      color: white,
                                      fontSize: 16.sp,
                                      fontFamily: fontBold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 5.w,
                              bottom: 0,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                  ),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.close_rounded,
                                          color: white,
                                          size: SizerUtil.deviceType ==
                                                  DeviceType.mobile
                                              ? 25
                                              : 50,
                                        ),
                                      ]),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: 1.h,
                        ),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
                                child: Center(
                                  child: RatingBar.builder(
                                    initialRating: userRating,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 11.w,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                    ),
                                    onRatingUpdate: (rating) {
                                      logcat("RATING", rating);
                                      setState(() {
                                        userRating = rating;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 5.w, right: 5.w, top: 0.5.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Share photo',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: fontBold,
                                        color: black,
                                        fontStyle: FontStyle.normal,
                                        fontSize: SizerUtil.deviceType ==
                                                DeviceType.mobile
                                            ? 13.sp
                                            : 7.sp,
                                      ),
                                    ),
                                    getDynamicSizedBox(height: 0.8.h),
                                    Obx(
                                      () {
                                        if (uploadMorePrescriptionFile
                                            .isNotEmpty) {
                                          return SizedBox(
                                            width: SizerUtil.width,
                                            height: 9.h,
                                            child: ListView.builder(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              itemCount:
                                                  uploadMorePrescriptionFile
                                                          .length +
                                                      1,
                                              itemBuilder: (context, index) {
                                                if (index <
                                                    uploadMorePrescriptionFile
                                                        .length) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      // Handle image tap
                                                    },
                                                    child: Container(
                                                      height: 6.h,
                                                      width: 9.h,
                                                      margin: EdgeInsets.only(
                                                          right: 2.w),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        image: DecorationImage(
                                                          image: FileImage(
                                                              uploadMorePrescriptionFile[
                                                                  index]),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      selectImageFromCameraOrGallery(
                                                          context,
                                                          cameraClick: () {
                                                        actionClickUploadImage(
                                                            context, true,
                                                            isCamera: true,
                                                            multipleImage:
                                                                true);
                                                      }, galleryClick: () {
                                                        actionClickUploadImage(
                                                            context, true,
                                                            isCamera: false,
                                                            multipleImage:
                                                                true);
                                                      });
                                                    },
                                                    child: DottedBorder(
                                                      borderType:
                                                          BorderType.RRect,
                                                      color: grey,
                                                      dashPattern: const [2, 2],
                                                      radius: Radius.circular(
                                                          SizerUtil.deviceType ==
                                                                  DeviceType
                                                                      .mobile
                                                              ? 4.w
                                                              : 2.5.w),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius
                                                            .all(Radius.circular(
                                                                SizerUtil.deviceType ==
                                                                        DeviceType
                                                                            .mobile
                                                                    ? 4.w
                                                                    : 2.5.w)),
                                                        child: Container(
                                                          height: 9.h,
                                                          width: 9.h,
                                                          color: grey
                                                              .withOpacity(0.6),
                                                          padding:
                                                              EdgeInsets.all(
                                                                  0.2.h),
                                                          child: Center(
                                                            child: Icon(
                                                              Icons
                                                                  .camera_enhance,
                                                              size: 4.h,
                                                              color: white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          );
                                        } else {
                                          return GestureDetector(
                                            onTap: () {
                                              selectImageFromCameraOrGallery(
                                                  context, cameraClick: () {
                                                actionClickUploadImage(
                                                    context, true,
                                                    isCamera: true,
                                                    multipleImage: true);
                                              }, galleryClick: () {
                                                actionClickUploadImage(
                                                    context, true,
                                                    isCamera: false,
                                                    multipleImage: true);
                                              });
                                            },
                                            child: DottedBorder(
                                              borderType: BorderType.RRect,
                                              color: grey,
                                              dashPattern: const [2, 2],
                                              radius: Radius.circular(
                                                  SizerUtil.deviceType ==
                                                          DeviceType.mobile
                                                      ? 4.w
                                                      : 2.5.w),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(SizerUtil
                                                                .deviceType ==
                                                            DeviceType.mobile
                                                        ? 4.w
                                                        : 2.5.w)),
                                                child: Container(
                                                  height: 6.h,
                                                  width: double.infinity,
                                                  color: grey.withOpacity(0.6),
                                                  padding:
                                                      EdgeInsets.all(0.2.h),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.camera_enhance,
                                                      size: 4.h,
                                                      color: white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    getDynamicSizedBox(height: 1.h),
                                    Text(
                                      'Write your review',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: fontBold,
                                        color: black,
                                        fontStyle: FontStyle.normal,
                                        fontSize: SizerUtil.deviceType ==
                                                DeviceType.mobile
                                            ? 13.sp
                                            : 7.sp,
                                      ),
                                    ),
                                    getDynamicSizedBox(height: 0.2.h),
                                    FadeInDown(
                                      child: AnimatedSize(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        child: Obx(() {
                                          return getReactiveFormField(
                                              node: commentNode,
                                              controller: commentctr,
                                              hintLabel:
                                                  ReviewsScreenConstant.hint,
                                              obscuretext: false,
                                              isReview: true,
                                              isAddress: true,
                                              onChanged: (val) {
                                                if (val!.isEmpty) {
                                                  isFormInvalidate.value =
                                                      false;
                                                } else {
                                                  isFormInvalidate.value = true;
                                                }
                                                // controller.validateComment(val);
                                              },
                                              inputType:
                                                  TextInputType.multiline,
                                              errorText:
                                                  commentModel.value.error);
                                        }),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            width: SizerUtil.width,
                            margin: EdgeInsets.only(
                              top: 2.h,
                              left: 25.w,
                              right: 25.w,
                            ),
                            child: FadeInUp(
                                from: 50,
                                child: Obx(() {
                                  return commonBtn(Button.submit, () {
                                    if (isFormInvalidate.value == true) {
                                      addReviewAPI(context);
                                      setState(() {});
                                    }
                                  }, isvalidate: isFormInvalidate.value);
                                }))),
                        SizedBox(
                          height: 2.h,
                          width: double.infinity,
                        ),
                      ],
                    ),
                  ));
            },
          );
        });
  }

  RxList<File> uploadMorePrescriptionFile = <File>[].obs;
  TextEditingController addMorePresctr = TextEditingController();
  late FocusNode addMorePresNode;
  var addMorePresModel = ValidationModel(null, null, isValidate: false).obs;
  Rx<File?> uploadPrescriptionFile = null.obs;

  actionClickUploadImage(context, isUpload,
      {bool? isCamera, bool multipleImage = false}) async {
    if (isCamera == false) {
      update();
      await ImagePicker()
          .pickMultiImage(maxWidth: 1080, maxHeight: 1080, imageQuality: 100)
          .then((file) async {
        if (file.isNotEmpty) {
          for (var f in file) {
            uploadMorePrescriptionFile.add(File(f.path));
          }
          addMorePresctr.text =
              "${uploadMorePrescriptionFile.length} file selected";
          // validateUploadPrescription(presctr.text);
        }
        logcat("SELECTED_PHOTO", uploadMorePrescriptionFile.length.toString());
        logcat("SELECTED_PHOTO_LINK", uploadMorePrescriptionFile.toString());
      });
    } else {
      await ImagePicker()
          .pickImage(
              //source: ImageSource.gallery,
              source:
                  isCamera == true ? ImageSource.camera : ImageSource.gallery,
              maxWidth: 1080,
              maxHeight: 1080,
              imageQuality: 100)
          .then((file) async {
        if (file != null) {
          isUpload ? uploadPrescriptionFile = File(file.path).obs : "";
          // avatarFile.value!.path.split('/').last;
          addMorePresctr.text = file.name;
          //validateUploadPrescription(presctr.text);
          uploadMorePrescriptionFile.add(File(file.path));
        }
      });
    }
    update();
  }

  // Razor Pay
  late Razorpay _razorpay;
  String apiKey = 'rzp_test_WBQrVQz0EsLDRJ';
  String apiSecret = 'lqwRZBuPsjQlKK82Fh2gWC30';
  late BuildContext context;

  setBuildContext(BuildContext mainContext) {
    context = mainContext;
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle payment success
    logcat('Payment Success:', response.paymentId.toString());
    showCustomDialog(context);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure
    logcat('Payment Error::', '${response.code} - ${response.message}');
    PopupDialogs(context, true);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet response
    logcat('External Wallet:', response.walletName.toString());
  }

  void openCheckout() async {
    UserData? getUserData = await UserPreferences().getSignInInfo();
    var options = {
      'key': apiKey,
      'amount':
          500, // amount in the smallest currency unit (e.g., paise in India)
      'name': 'GiftHamperz',
      'description': 'Product Description',
      'prefill': {
        'contact': getUserData != null && getUserData.mobileNo.isNotEmpty
            ? getUserData.mobileNo
            : '7359792115',
        'email': getUserData != null && getUserData.emailId.isNotEmpty
            ? getUserData.emailId
            : 'querifinders@gmail.com',
      },
      'external': {
        'wallets': ['paytm'],
      },
      'theme': {
        'color': '#FF800020', // Set your desired color here
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void addReviewAPI(context) async {
    var loadingIndicator = LoadingProgressDialog();
    loadingIndicator.show(context, '');
    // try {
    if (networkManager.connectionType == 0) {
      loadingIndicator.hide(context);
      showDialogForScreen(
          context, ReviewsScreenConstant.title, Connection.noConnection,
          callback: () {
        Get.back();
      });
      return;
    }

    UserData? getUserData = await UserPreferences().getSignInInfo();

    logcat('ReviewPassingData', {
      "user_id": getUserData!.id.toString().trim(),
      "product_id": "2",
      "review": userRating.toString(),
      "comment": commentctr.text.toString().trim(),
    });

    var response = await Repository.post({
      "user_id": getUserData.id.toString().trim(),
      "product_id": "2",
      "review": userRating.toString(),
      "comment": commentctr.text.toString().trim(),
    }, ApiUrl.review, allowHeader: true);
    loadingIndicator.hide(context);
    var data = jsonDecode(response.body);
    logcat("tag", data);
    if (response.statusCode == 200) {
      if (data['status'] == 1) {
        showDialogForScreen(
            context, ReviewsScreenConstant.title, data['message'],
            callback: () {
          commentctr.text = "";
          isFormInvalidate.value = false;
          Get.offAll(const BottomNavScreen());
          update();
        });
      } else {
        showDialogForScreen(
            context, ReviewsScreenConstant.title, data['message'],
            callback: () {
          commentctr.text = "";
          isFormInvalidate.value = false;
          update();
        });
      }
    } else {
      showDialogForScreen(
          context, ReviewsScreenConstant.title, data['message'] ?? "",
          callback: () {});
    }
  }
  // catch (e) {
  //   logcat("Exception", e);
  //   showDialogForScreen(
  //       context, ReviewsScreenConstant.title, ServerError.servererror,
  //       callback: () {});
  // }
}
