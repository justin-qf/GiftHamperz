import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/button/form_button.dart';
import 'package:gifthamperz/componant/dialogs/dialogs.dart';
import 'package:gifthamperz/componant/input/form_inputs.dart';
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

// ignore: must_be_immutable
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
    controller.setDataInFormFields(
        context, widget.isFromEdit!, widget.itemData);
    getCity(context);
    controller.getGuestUser();
    super.initState();
  }

  void getCity(BuildContext context) async {
    try {
      if (mounted) {
        await Future.delayed(const Duration(seconds: 1)).then((value) {
          if (widget.isFromEdit == true) {
            if (widget.itemData!.cityId != "null" &&
                widget.itemData!.cityId.toString().isNotEmpty) {
              controller.getCityList(
                  context, widget.itemData!.cityId.toString());
            }
          } else {
            controller.getCityList(context, '');
          }
        });
      }
    } catch (e) {
      logcat("ERROR", e);
    }
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
            getForgetToolbar(AddressScreenTextConstant.title,
                showBackButton: true, callback: () {
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
                    Obx(
                      () {
                        return controller.isGuest.value == true
                            ? Column(
                                children: [
                                  getLable(AddressScreenTextConstant.userName),
                                  FadeInDown(
                                    child: AnimatedSize(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: Obx(() {
                                        return getReactiveFormField(
                                            node: controller.userNameNode,
                                            controller: controller.userNameCtr,
                                            hintLabel: AddressScreenTextConstant
                                                .userNameHint,
                                            onChanged: (val) {
                                              controller.validateName(val);
                                            },
                                            obscuretext: false,
                                            inputType: TextInputType.name,
                                            errorText: controller
                                                .userNameModel.value.error);
                                      }),
                                    ),
                                  ),
                                  getLable(
                                      AddressScreenTextConstant.emailAddress),
                                  FadeInDown(
                                    child: AnimatedSize(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: Obx(() {
                                        return getReactiveFormField(
                                            node: controller.emailIdNode,
                                            controller: controller.emailIdCtr,
                                            hintLabel: AddressScreenTextConstant
                                                .emailAddresValidsHint,
                                            onChanged: (val) {
                                              controller.validateEmail(val);
                                            },
                                            obscuretext: false,
                                            inputType:
                                                TextInputType.emailAddress,
                                            errorText: controller
                                                .emailIdModel.value.error);
                                      }),
                                    ),
                                  ),
                                ],
                              )
                            : Container();
                      },
                    ),
                    getLable(AddressScreenTextConstant.deliveryName),
                    FadeInDown(
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: Obx(() {
                          return getReactiveFormField(
                              node: controller.deliverynamenode,
                              controller: controller.deliverynamectr,
                              hintLabel: AddressScreenTextConstant.deliveryName,
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
                    getLable(AddressScreenTextConstant.addressline),
                    FadeInDown(
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: Obx(() {
                          return getReactiveFormField(
                              node: controller.addressLinenode,
                              controller: controller.addressLinectr,
                              hintLabel: AddressScreenTextConstant.addressHint,
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
                    getLable(AddressScreenTextConstant.street),
                    FadeInDown(
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: Obx(() {
                          return getReactiveFormField(
                              node: controller.streetnode,
                              controller: controller.streetctr,
                              hintLabel: AddressScreenTextConstant.streetHint,
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
                    getLable(AddressScreenTextConstant.landmark),
                    FadeInDown(
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: Obx(() {
                          return getReactiveFormField(
                              node: controller.landMarknode,
                              controller: controller.landMarkctr,
                              hintLabel: AddressScreenTextConstant.landmarkHint,
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
                    getLable(AddressScreenTextConstant.pincode),
                    FadeInDown(
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: Obx(() {
                          return getReactiveFormField(
                              node: controller.pinCodenode,
                              controller: controller.pincodectr,
                              hintLabel: AddressScreenTextConstant.pinCodeHint,
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
                    getLable(AddressScreenTextConstant.city),
                    SizedBox(
                      height: 1.0.h,
                    ),
                    FadeInDown(
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: Obx(() {
                          return getReactiveFormField(
                              node: controller.citynode,
                              controller: controller.cityctr,
                              hintLabel: "Select City",
                              onChanged: (val) {
                                controller.validateCity(val);
                              },
                              onTap: () {
                                controller.searchCityctr.text = "";
                                showDropdownMessage(context,
                                    controller.setCityDialog(), "City List");
                              },
                              isReadOnly: true,
                              wantSuffix: true,
                              isdown: true,
                              isEnable: true,
                              inputType: TextInputType.none,
                              errorText: controller.cityModel.value.error);
                        }),
                      ),
                    ),
                    getDynamicSizedBox(height: 2.h),
                    getLable(AddressScreenTextConstant.addressType),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Obx(
                            () {
                              return getRadio(AddressScreenTextConstant.home,
                                  controller.addressType.value, (value) {
                                controller.addressType.value = value.toString();
                                controller.apiPassingAddressType.value = "0";
                                setState(() {});
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: Obx(
                            () {
                              return getRadio(AddressScreenTextConstant.work,
                                  controller.addressType.value, (value) {
                                controller.addressType.value = value.toString();
                                controller.apiPassingAddressType.value = "1";
                                setState(() {});
                              });
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
