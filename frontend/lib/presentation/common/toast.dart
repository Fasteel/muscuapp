import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toast {
  static fail(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        fontSize: 18.0);
  }

  static success(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        fontSize: 18.0);
  }
}
