import 'package:anti_propa_gondons/domain/about/content/en.dart';
import 'package:anti_propa_gondons/domain/about/content/ru.dart';
import 'package:anti_propa_gondons/domain/about/content/ua.dart';

String replaceLargeContent(String largeContentCode) {
  const String notFound = 'CONTENT_NOT_FOUND';
  final String largeContent = {
        'LARGE_UA_CONTENT': largeUaContent,
        'LARGE_EN_CONTENT': largeEnContent,
        'LARGE_RU_CONTENT': largeRuContent,
      }[largeContentCode] ??
      notFound;
  return largeContent.isEmpty ? notFound : largeContent;
}
