import 'package:animate_do/animate_do.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/input/form_inputs.dart';
import 'package:gifthamperz/componant/input/style.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/widgets.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/AddAddressController.dart';
import 'package:gifthamperz/models/addressModel.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:sizer/sizer.dart';

class AddAddressScreen extends StatefulWidget {
  AddAddressScreen({
    super.key,
    required this.isFromEdit,
    required this.itemData,
  });
  bool? isFromEdit;
  AddressListItem? itemData;

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  var controller = Get.put(AddAddressController());

  @override
  void initState() {
    setState(() {});
    logcat("widget.isFromEdit", widget.isFromEdit.toString());
    controller.setDataInFormFields(widget.isFromEdit!, widget.itemData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomParentScaffold(
      onWillPop: () async {
        return true;
      },
      onTap: () {
        controller.hideKeyboard(context);
      },
      isSafeArea: false,
      isNormalScreen: true,
      body: Container(
        color: isDarkMode() ? darkBackgroundColor : transparent,
        child: Column(
          children: [
            getForgetToolbar(AddAddressText.title, showBackButton: true,
                callback: () {
              Get.back(result: false);
            }),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(
                      height: 1.0.h,
                    ),
                    getLable(AddAddressText.deliveryName),
                    FadeInDown(
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: Obx(() {
                          return getReactiveFormField(
                              node: controller.deliverynamenode,
                              controller: controller.deliverynamectr,
                              hintLabel: AddAddressText.deliveryName,
                              onChanged: (val) {
                                controller.validateDeliveryName(val);
                              },
                              obscuretext: false,
                              inputType: TextInputType.name,
                              errorText: controller.deliveryModel.value.error);
                        }),
                      ),
                    ),
                    SizedBox(height: 1.0.h),
                    getLable(AddAddressText.addressline),
                    FadeInDown(
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: Obx(() {
                          return getReactiveFormField(
                              node: controller.addressLinenode,
                              controller: controller.addressLinectr,
                              hintLabel: AddAddressText.addressHint,
                              onChanged: (val) {
                                controller.validateAddressline(val);
                              },
                              obscuretext: false,
                              inputType: TextInputType.emailAddress,
                              errorText:
                                  controller.addressLineModel.value.error);
                        }),
                      ),
                    ),
                    SizedBox(
                      height: 1.0.h,
                    ),
                    getLable(AddAddressText.street),
                    FadeInDown(
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: Obx(() {
                          return getReactiveFormField(
                              node: controller.streetnode,
                              controller: controller.streetctr,
                              hintLabel: AddAddressText.streetHint,
                              onChanged: (val) {
                                controller.validateStreet(val);
                              },
                              obscuretext: false,
                              inputType: TextInputType.emailAddress,
                              errorText: controller.streetModel.value.error);
                        }),
                      ),
                    ),
                    SizedBox(
                      height: 1.0.h,
                    ),
                    getLable(AddAddressText.landmark),
                    FadeInDown(
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: Obx(() {
                          return getReactiveFormField(
                              node: controller.landMarknode,
                              controller: controller.landMarkctr,
                              hintLabel: AddAddressText.landmarkHint,
                              onChanged: (val) {
                                controller.validateLandMark(val);
                              },
                              obscuretext: false,
                              inputType: TextInputType.name,
                              errorText: controller.landMarkModel.value.error);
                        }),
                      ),
                    ),
                    SizedBox(
                      height: 1.0.h,
                    ),
                    getLable(AddAddressText.pincode),
                    FadeInDown(
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: Obx(() {
                          return getReactiveFormField(
                              node: controller.pinCodenode,
                              controller: controller.pincodectr,
                              hintLabel: AddAddressText.pinCodeHint,
                              onChanged: (val) {
                                controller.validatePinCode(val);
                              },
                              obscuretext: false,
                              inputType: TextInputType.number,
                              errorText: controller.pinCodeModel.value.error);
                        }),
                      ),
                    ),
                    SizedBox(
                      height: 1.0.h,
                    ),
                    getLable(AddAddressText.city),
                    SizedBox(
                      height: 1.0.h,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 7.w, right: 7.w),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          buttonPadding: EdgeInsets.only(
                              left: 1.w,
                              top: SizerUtil.deviceType == DeviceType.mobile
                                  ? 0.5.h
                                  : 1.2.w,
                              bottom: SizerUtil.deviceType == DeviceType.mobile
                                  ? 0.5.h
                                  : 1.2.w),
                          isExpanded: true,
                          buttonDecoration: BoxDecoration(
                            border: Border.all(color: inputBorderColor),
                            borderRadius: BorderRadius.circular(1.5.h),
                          ),
                          hint: Text(
                            AddFamilylist.city,
                            style: styleTextForFieldHint(),
                          ),
                          items: controller.city
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: SizerUtil.deviceType ==
                                            DeviceType.mobile
                                        ? Text(
                                            item,
                                            style: styleTextFormFieldText(),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15, bottom: 15, left: 10),
                                            child: Text(
                                              item,
                                              style: styleTextFormFieldText(),
                                            ),
                                          ),
                                  ))
                              .toList(),
                          value: controller.selectCity,
                          onChanged: (value) {
                            //controller.validategender(value);
                            setState(() {
                              controller.selectCity = value as String;
                            });
                          },
                          itemHeight: SizerUtil.deviceType == DeviceType.mobile
                              ? 30
                              : 60,
                          dropdownMaxHeight:
                              SizerUtil.deviceType == DeviceType.mobile
                                  ? SizerUtil.height / 2
                                  : SizerUtil.height / 1,
                          dropdownDecoration: BoxDecoration(
                            color: isDarkMode() ? darkBackgroundColor : white,
                            borderRadius: BorderRadius.circular(2.h),
                            boxShadow: [
                              BoxShadow(
                                  color: grey.withOpacity(0.2),
                                  blurRadius: 10.0,
                                  offset: const Offset(0, 1),
                                  spreadRadius: 3.0)
                            ],
                          ),
                          icon: Container(
                            padding: EdgeInsets.only(right: 1.h),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: SizerUtil.deviceType == DeviceType.mobile
                                  ? 40
                                  : 40,
                              color: isDarkMode()
                                  ? rightMenuDarkBackgroundColor
                                  : grey.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    getLable(AddAddressText.addressType),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Obx(
                            () {
                              return RadioListTile(
                                activeColor: primaryColor,
                                contentPadding: EdgeInsets.only(
                                    left: SizerUtil.deviceType ==
                                            DeviceType.mobile
                                        ? 5.5.w
                                        : 15.w),
                                visualDensity:
                                    const VisualDensity(horizontal: -4),
                                title: Text(
                                  "HOME",
                                  style: TextStyle(
                                      fontSize: SizerUtil.deviceType ==
                                              DeviceType.mobile
                                          ? 12.sp
                                          : 10.sp),
                                ),
                                value: "HOME",
                                groupValue: controller.addressType.value,
                                onChanged: (value) {
                                  controller.addressType.value =
                                      value.toString();
                                  controller.apiPassingAddressType.value = "1";
                                  setState(() {});
                                },
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: Obx(
                            () {
                              return RadioListTile(
                                activeColor: primaryColor,
                                contentPadding: EdgeInsets.only(
                                    left: SizerUtil.deviceType ==
                                            DeviceType.mobile
                                        ? 5.5.w
                                        : 15.w),
                                visualDensity:
                                    const VisualDensity(horizontal: -4),
                                title: Text(
                                  "WORK",
                                  style: TextStyle(
                                      fontSize: SizerUtil.deviceType ==
                                              DeviceType.mobile
                                          ? 12.sp
                                          : 10.sp),
                                ),
                                value: "WORK",
                                groupValue: controller.addressType.value,
                                onChanged: (value) {
                                  controller.addressType.value =
                                      value.toString();
                                  controller.apiPassingAddressType.value = "0";
                                  setState(() {});
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 8.w,
                        right: 8.w,
                      ),
                      child: FadeInUp(
                        from: 50,
                        child: Obx(() {
                          return getSecondaryFormButton(() {
                            if (controller.isFormInvalidate.value == true) {
                              if (widget.isFromEdit == true) {
                                controller.updateAddressAPI(
                                    context, widget.itemData!.id);
                              } else {
                                controller.addAddressAPI(context);
                              }
                            }
                          }, Button.save,
                              isvalidate: controller.isFormInvalidate.value);
                        }),
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
