import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme.dart';

DropdownButton dropDownButton({
  Color? color,
  List? list,
  String? select,
  ValueChanged? onChanged,
}) =>
    DropdownButton(

      dropdownColor: color,
      items: list!
          .map(
            (value) => DropdownMenuItem<String>(
              value: value.toString(),
              child: Text(
                value.toString(),
                style: TextStyle(
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          )
          .toList(),
      borderRadius: BorderRadius.circular(10),
      underline: Container(),

      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      style: subTitleStyle,
      onChanged: onChanged!,
    );
