import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;

  const CustomScaffold({
    super.key,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      backgroundColor: Colors.white,
      body: body,
      // Stack(
      //   children: [
      //     SizedBox(
      //       height: double.infinity,
      //       width: double.infinity,
      //       child: isDarkMode()
      //           ? SvgPicture.asset(
      //               Asset.dark_bg,
      //               fit: BoxFit.cover,
      //             )
      //           : SvgPicture.asset(
      //               Asset.bg,
      //               fit: BoxFit.cover,
      //             ),
      //     ),
      //     Scaffold(
      //       backgroundColor:
      //           transparent, // Make the Scaffold's background transparent
      //       body: body,
      //     ),
      //   ],
      // ),
    );
  }
}
