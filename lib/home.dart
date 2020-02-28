import 'package:erling2020/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

abstract class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final FirebaseUser user = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(user.displayName),
      ),
      drawer: ErlingDrawer(),
      body: buildBody(context)
    );
  }

  Widget buildBody(BuildContext context);

}