import 'package:flutter/material.dart';
import 'package:gifthamperz/configs/colors_constant.dart';
import 'package:gifthamperz/configs/font_constant.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class NavItem extends StatefulWidget {
  final IconData? icon;
  final String? text;
  Function? onClick;

  NavItem({Key? key, this.icon, this.text, this.onClick}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NavItemState createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> with SingleTickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
          _controller.forward();
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
          _controller.reverse();
        });
      },
      child: GestureDetector(
        onTap: () {
          widget.onClick!();
          // Handle navigation
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.h),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Text(
                widget.text!,
                style: TextStyle(
                  fontFamily: fontMedium,
                  fontSize: 4.sp,
                  color: isHovered ? primaryColor : black,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2.0,
                width: isHovered ? 40.0 : 0.0,
                color: primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
