import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) => false,
    );

toast({
  required String message,
  required ToastState state,
}) => Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: choseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0
);

enum ToastState {ERROR, SUCCESS, WARNING}

Color choseToastColor (ToastState state) {
  Color color;
  switch(state) {
    case ToastState.ERROR:
      color = Colors.red;
      break;
    case ToastState.SUCCESS:
      color = Colors.green;
      break;
    case ToastState.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

Widget separator() => Padding(
  padding: const EdgeInsets.only(left: 12, right: 12),
  child:   Container(
    height: 1,
    width: double.infinity,
    color: Colors.grey.shade300,
  ),
);