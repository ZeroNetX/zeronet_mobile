import 'package:flutter/material.dart';

import 'package:flutter_mobx/flutter_mobx.dart';

import '../mobx/varstore.dart';
import 'loading_page.dart';
import 'myhome_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZeroNet Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Observer(
        builder: (context) {
          if (varStore.zeroNetInstalled) return MyHomePage();
          return Loading();
        },
      ),
    );
  }
}
