import 'package:alminshawy/statefull/start_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'account/Account.dart';
import 'localization/localHelper.dart';
import 'localization/localizations.dart';
import 'mobx/QuranMobx.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
   MobileAds.instance.initialize();
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
        tagForChildDirectedTreatment:
        TagForChildDirectedTreatment.unspecified,
        testDeviceIds: <String>["9450204315685041D5A6E38F35D3C17E"]),
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  Future.delayed(
      Duration(milliseconds: 50),
          () => runApp(
        MyApp(),
      ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SpecificLocalizationsDelegate _delegate;

  var image;

  onChangeLocale(Locale locale) {
    setState(() {
      _delegate = new SpecificLocalizationsDelegate(locale);
    });
  }

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {

    account.getPreferences();



    helper.onChangeLocale = onChangeLocale;
    super.initState();
    helper.onChangeLocale(new Locale("ar"));
    account.language="ar";
  }



  @override
  Widget build(BuildContext context) {



    return MultiProvider(
        providers: [
          Provider<QuranMobx>(create: (_) => QuranController()),
        ],


        child :  MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            _delegate,
          ],
          locale: _delegate.overriddenLocale,
          supportedLocales: [Locale("ar") ],
          // for testing ocr call MyHomePage
          theme: new ThemeData(primarySwatch: Colors.green),
          home: new StartPage(),
          navigatorKey: navigatorKey,

        )
    );



  }
}
