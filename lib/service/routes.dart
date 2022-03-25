import 'package:anti_propa_gondons/domain/about/about_screen.dart';
import 'package:anti_propa_gondons/domain/main/main_screen.dart';
import 'package:flutter/cupertino.dart';

abstract class Routes {
  Routes._();

  static const String main = '/';
  static const String about = '/about';

  static Map<String, WidgetBuilder> list = {
    main: _build(const MainScreen()),
    about: _build(const AboutScreen()),
  };
}

WidgetBuilder _build(Widget screen) => (BuildContext context) => screen;
