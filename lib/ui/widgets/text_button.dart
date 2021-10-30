import 'package:flutter/material.dart';

customTextButton({
 required String text,
  required Function() onPressed,
  required Color color,
}) => TextButton(
      onPressed: onPressed,
      child:  Text(
        text,
        style: TextStyle(
          color: color,
        ),
      ),
    );
