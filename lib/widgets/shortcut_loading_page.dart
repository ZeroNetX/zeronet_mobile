import 'package:flutter/material.dart';

class ShortcutLoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/logo.png'),
          Padding(
            padding: EdgeInsets.all(24.0),
          ),
          Text(
            'Loading...',
            style: TextStyle(
              fontSize: 24.0,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
