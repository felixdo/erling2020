import 'package:erling2020/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of(context);
    if (user != null) {
      return Scaffold(
          appBar: AppBar(
            title: Text(user.displayName),
          ),
          drawer: ErlingDrawer(),
          body: buildBody(context)
      );
    }
    return Text("Not signed in");
  }

  Widget buildBody(BuildContext context);

}