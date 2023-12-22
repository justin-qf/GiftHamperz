import 'package:flutter/material.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingProgressDialog {
  show(BuildContext context, message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Statusbar().trasparentStatusbarProfile(true);
        return Center(
            child: Material(
          color: transparent,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: transparent,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: white,
                    ),
                    height: 50,
                    width: 50,
                    padding: const EdgeInsets.all(10),
                    child: LoadingAnimationWidget.discreteCircle(
                      color: primaryColor,
                      size: 35,
                    ),
                  ),
                ),
                Text(message)
              ],
            ),
          ),
        ));
      },
    );
  }

  hide(BuildContext context) {
    Navigator.pop(context);
  }
}
