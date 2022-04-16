import 'package:flutter/material.dart';
import 'dart:math';

class Constants {
  static String? name = "";
  static const Color? mainAccent = Color(0xFF2C3E50);
  static String? mail = "";
  static const Color? senderAccent = Color(0xFF90A4AE);
  static const Color? receiverAccent = Color(0xFFE0E0E0);

  Color generateRandomColor() {
    Random random = Random();
    double randomDouble = random.nextDouble();
    return Color((randomDouble * 0xFFFFFF).toInt()).withOpacity(1.0);
  }
}
