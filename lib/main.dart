import 'package:anti_propa_gondons/domain/main/logic/main_screen_notifier.dart';
import 'package:anti_propa_gondons/service/colors.dart';
import 'package:anti_propa_gondons/service/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalo_locale/lib.dart';

void main() {
  runApp(
    MyApp(
      mainScreenNotifier: MainScreenNotifier(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    required this.mainScreenNotifier,
    Key? key,
  }) : super(key: key);

  final MainScreenNotifier mainScreenNotifier;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: mainScreenNotifier),
      ],
      child: MaterialApp(
        theme: ThemeData(primarySwatch: APGColors.uBlue),
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
        onGenerateTitle: (BuildContext context) => Messages.of(context).app.title,
        initialRoute: Routes.main,
        routes: Routes.list,
      ),
    );
  }
}
