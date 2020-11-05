import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';

import 'common_data.dart';
import 'home_compras.dart';

void main() {
  runApp(
    MaterialApp(
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('pt', 'BR'),
      ],
      title: 'MyShopList',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeApp(),
    ),
  );
}

class HomeApp extends StatelessWidget {
  @override
  Widget build(context) {
    return FutureBuilder<Compras>(
      future: getDados(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          comprasDados = snapshot.data;
          return HomeCompra();
        } else {
          return Container(
            color: Colors.white,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
