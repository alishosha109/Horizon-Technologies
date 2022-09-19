import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:horizonuser/db/crud.dart';
import 'package:horizonuser/localization/demo_localization.dart';
import 'package:horizonuser/pages/account.dart';
import 'dart:async';
import 'package:horizonuser/pages/home.dart';

// my own import
import 'package:horizonuser/pages/login.dart';
import 'package:progress_indicators/progress_indicators.dart';

import 'localization/localization_constants.dart';
// import 'package:device_preview/device_preview.dart';

/*void main() async{

  runApp(
    MaterialApp(debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.red.shade900
      ),
      home: Splash(),
    ),

  );
}*/
/*
void main()=>runApp(DevicePreview(
  builder: (context)=>Splash(),
  enabled: !kReleaseMode,
));*/

void main() => runApp(Splash());

class Splash extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _SplashState state = context.findAncestorStateOfType<_SplashState>();
    state.setLocale(locale);
  }

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Locale _locale;
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  Methods crudobj = new Methods();
  bool signed;
  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  void initState() {
    crudobj.checkusertoken().then((result) {
      setState(() {
        signed = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_locale == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: _locale,
        supportedLocales: [
          Locale("en", "US"),
          Locale("ar", "SA"),
        ],
        localizationsDelegates: [
          DemoLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          for (var locale in supportedLocales) {
            if (locale.languageCode == deviceLocale.languageCode &&
                locale.countryCode == deviceLocale.countryCode) {
              return deviceLocale;
            }
          }
          return supportedLocales.first;
        },
        home: signed == null
            ? Scaffold(
                body: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(color: Color(0xFF73AEF5)),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.laptop,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                ),
                                Text(
                                  "Horizon",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              JumpingDotsProgressIndicator(
                                color: Colors.white,
                                fontSize: 40.0,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20.0),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            : signed
                ? MyHomePage()
                : Loginpage(),
      );
    }
  }
}
