import 'package:flutter/material.dart';

class UtilFunctions {
  void navigateTo(BuildContext context, Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

  void navigateBack(BuildContext context) {
    Navigator.of(context).pop();
  }
}
