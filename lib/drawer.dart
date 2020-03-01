import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ErlingDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.yellow,
              ),
              child: Text(
                'Erling 2020',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Standings'),
              onTap: () {}
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Scheduled Matches'),
              onTap: () => Navigator.pushNamed(context, "/matches"),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Upcoming matches'),

            ),
            ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
                onTap: () {
                  // signing out triggers onAuthStateChanged and reloads the app..
                  FirebaseAuth.instance.signOut();
                  GoogleSignIn().signOut();
                }
            )
          ]
      ),
    );
  }
}