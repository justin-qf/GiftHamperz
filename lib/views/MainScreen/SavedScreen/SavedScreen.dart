import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:gifthamperz/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:gifthamperz/componant/toolbar/toolbar.dart';
import 'package:gifthamperz/componant/widgets/search_chat_widgets.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:gifthamperz/configs/string_constant.dart';
import 'package:gifthamperz/controller/savedController.dart';
import 'package:gifthamperz/models/homeModel.dart';
import 'package:gifthamperz/utils/helper.dart';
import 'package:gifthamperz/utils/log.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class SavedScreen extends StatefulWidget {
  SavedScreen(this.callBack, {super.key});
  Function callBack;
  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen>
    with TickerProviderStateMixin {
  var controller = Get.put(SavedScreenController());
  @override
  void initState() {
    controller.animateController = BottomSheet.createAnimationController(this);
    controller.animateController?.duration = const Duration(seconds: 1);
    controller.isSearch = false;
    logcat('SAVED_LENGTH', controller.filteredList.length.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbarIsNormalScreen();
    return CustomParentScaffold(
      onWillPop: () async {
        return false;
      },
      onTap: () {
        controller.hideKeyboard(context);
      },
      isSafeArea: false,
      body: Container(
        color: isDarkMode() ? darkBackgroundColor : transparent,
        child: Stack(
          children: [
            Column(children: [
              getDynamicSizedBox(
                  height: controller.isSearch == true ? 4.h : 5.h),
              if (controller.isSearch == true)
                setSearchBar(context, controller.searchCtr, 'saved',
                    onCancleClick: () {
                  controller.isSearch = false;
                  controller.searchCtr.text = '';
                  controller.setSearchQuery(controller.searchCtr.text);
                  setState(() {});
                }, onClearClick: () {
                  controller.searchCtr.text = '';
                  controller.setSearchQuery(controller.searchCtr.text);
                  setState(() {});
                }, isCancle: true)
              else
                getFilterToolbar(SavedScreenText.title, callback: () {
                  Statusbar().trasparentBottomsheetStatusbar();
                  controller.getFilterBottomSheet(context);
                  //Get.to(const FilterScreen());
                }, searchClick: () {
                  controller.isSearch = true;
                  setState(() {});
                }),
              getDynamicSizedBox(
                  height: controller.filteredList.isNotEmpty ? 2.h : 0.0),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 2.w, right: 2.w),
                  child: Obx(
                    () {
                      if (controller.filteredList.isNotEmpty) {
                        final filteredList = controller.filteredList;
                        return MasonryGridView.count(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(bottom: 13.h),
                          crossAxisCount:
                              SizerUtil.deviceType == DeviceType.mobile ? 2 : 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 4,
                          itemBuilder: (context, index) {
                            SavedItem data = filteredList[index];
                            return controller.getItemListItem(data);
                          },
                          itemCount: filteredList.length,
                        );
                      } else {
                        return Container(
                          margin: EdgeInsets.only(bottom: 15.h),
                          child: Center(
                            child: Text(
                              APIResponseHandleText.emptylist,
                              style: TextStyle(
                                fontFamily: fontMedium,
                                color: isDarkMode() ? white : black,
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.mobile
                                        ? 10.sp
                                        : 7.sp,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ]),
            Visibility(
              visible: false,
              child: Positioned(
                  left: 0,
                  bottom: 13.h,
                  child: SizedBox(
                    width: SizerUtil.width,
                    child: Center(
                      child: controller.getFilterUi(),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
