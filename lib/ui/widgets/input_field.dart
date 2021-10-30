import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:todo/ui/size_config.dart';

import '../theme.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.title,
    required this.hint,
    this.widget,
    this.controller,
    this.validate,
  }) : super(key: key);

  final String title;
  final String hint;
  final Widget? widget;
  final TextEditingController? controller;
  final FormFieldValidator? validate;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    validator: validate,
                    controller: controller,
                    readOnly: widget != null ? true : false,
                    cursorColor:
                        Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle:
                          subTitleStyle.copyWith(color: Colors.grey[700]),
                    ),
                  ),
                ),
                widget ??
                    const SizedBox(
                      width: 0.0,
                      height: 0.0,
                    ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
