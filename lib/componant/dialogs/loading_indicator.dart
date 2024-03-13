import 'package:flutter/material.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/statusbar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

// class LoadingProgressDialog {
//   show(BuildContext context, message) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         Statusbar().trasparentStatusbarProfile(true);
//         return Center(
//             child: Material(
//           color: transparent,
//           child: Container(
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               color: transparent,
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(100),
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: white,
//                     ),
//                     height: 50,
//                     width: 50,
//                     padding: const EdgeInsets.all(10),
//                     child: LoadingAnimationWidget.discreteCircle(
//                       color: primaryColor,
//                       size: 35,
//                     ),
//                   ),
//                 ),
//                 Text(message)
//               ],
//             ),
//           ),
//         ));
//       },
//     );
//   }

//   hide(BuildContext context) {
//     Navigator.pop(context);
//   }
// }

class LoadingProgressDialog {
  final GlobalKey<State> _key = GlobalKey<State>();
  OverlayEntry? _overlayEntry;

  show(BuildContext context, message) {
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        Statusbar().trasparentStatusbar();
        return Container(
          height: SizerUtil.height,
          width: SizerUtil.width,
          color: black.withOpacity(0.3),
          child: Center(
            child: Material(
              color: transparent,
              child: Container(
                key: _key,
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
                    Text(message),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  hide(BuildContext context) {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }
}

apiResponseLoader(bool isVisible) {
  return isVisible == true
      ? Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: SizedBox(
              height: 30,
              width: 30,
              child: LoadingAnimationWidget.discreteCircle(
                color: primaryColor,
                size: 35,
              ),
            ),
          ),
        )
      : Container();
}
