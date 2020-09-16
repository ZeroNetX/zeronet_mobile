import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:zeronet/mobx/varstore.dart';
import 'package:zeronet/widgets/common.dart';

class ZeroNetLogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.all(24)),
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0),
          child: Column(
            children: <Widget>[
              ZeroNetAppBar(),
              Padding(
                padding: EdgeInsets.only(bottom: 30),
              ),
              SingleChildScrollView(
                child: Observer(
                  builder: (_) => Text(varStore.zeroNetLog),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
