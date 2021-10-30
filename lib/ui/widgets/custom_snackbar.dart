import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/ui/theme.dart';

customSnackBar({required String title, required String message}) =>
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
      colorText: Get.isDarkMode ? Colors.grey[100] : darkGreyClr,
    );
