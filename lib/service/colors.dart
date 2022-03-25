import 'package:flutter/material.dart';

abstract class APGColors {
  APGColors._();

  // static const MaterialColor uBlue = Color(0xFF0058b5);
  static const MaterialColor uBlue = MaterialColor(0xFF0058b5, {
    50: Color(0xFF0058b5),
    100: Color(0xFF0058b5),
    200: Color(0xFF0058b5),
    300: Color(0xFF0058b5),
    400: Color(0xFF0058b5),
    500: Color(0xFF0058b5),
    600: Color(0xFF0058b5),
    700: Color(0xFF0058b5),
    800: Color(0xFF0058b5),
    900: Color(0xFF0058b5),
  });
  static const Color uYellow = Color(0xFFf7ce00);
  static const Color success = Color(0xFF00C747);
  static const Color error = Color(0xFFCC0000);
  static const Color text = Color(0xFF212121);
}
