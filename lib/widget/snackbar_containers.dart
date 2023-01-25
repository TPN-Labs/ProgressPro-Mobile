import 'package:flutter/material.dart';

void showErrorSnackBar(BuildContext context, String message) async {
  final snackBar = SnackBar(
    content: Text(message),
    duration: const Duration(milliseconds: 3500),
    width: 380.0,
    padding: const EdgeInsets.symmetric(
      vertical: 15.0,
      horizontal: 10.0,
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.redAccent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSuccessSnackBar(BuildContext context, String message) async {
  final snackBar = SnackBar(
    content: Text(message),
    duration: const Duration(milliseconds: 3500),
    width: 380.0,
    padding: const EdgeInsets.symmetric(
      vertical: 15.0,
      horizontal: 10.0,
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: const Color(0xFF258628),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
