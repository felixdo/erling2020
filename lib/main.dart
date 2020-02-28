import 'package:erling2020/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './home.dart';
import './matches.dart';
import 'signin_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Machs nochmal Erling - 2020',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/matches': (context) => MatchesPage(),
        '/signin': (context) => SignInPage()
      }
    );
    }
  }

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<FirebaseUser> user;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then ((user) {
      var route = "/signin";
      if (user != null) {
        Navigator.pushReplacementNamed(context, "/matches", arguments: user);
      } else {
        Navigator.pushReplacementNamed(context, "/signin");
      }
    }).catchError( (error) => Navigator.pushReplacementNamed(context, "/signin"));
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator();
  }
}
