import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gifthamperz/configs/get_storage_key.dart';
import 'package:intl/intl.dart';

bool isDarkMode() {
  bool isDark;
  var data = GetStorage().read(GetStorageKey.IS_DARK_MODE);
  if (data == null || data.toString().isEmpty) {
    isDark = false;
    //logcat('IsDarkModeEMPTY', isDark);
  } else if (GetStorage().read(GetStorageKey.IS_DARK_MODE) == 1) {
    isDark = false;
    //logcat('IsLIGHTModeEMPTY', isDark);
  } else {
    isDark = true;
    //logcat('IsDarkMode', isDark);
  }
  return isDark;
}

Future<DateTime?> getDateTimePicker(context) async {
  DateTime? value = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100));
  return value;
}

PageRouteBuilder customPageRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

String convert24HourTo12Hour(String time24Hour) {
  DateFormat format24Hour = DateFormat('HH:mm:ss');
  DateFormat format12Hour = DateFormat('hh:mm:ss a');

  DateTime dateTime = format24Hour.parse(time24Hour);
  String time12Hour = format12Hour.format(dateTime);

  return time12Hour;
}

String getFormateDate(String date) {
  String formattedData = DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
  return formattedData;
}
