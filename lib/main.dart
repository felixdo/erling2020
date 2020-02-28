import 'package:erling2020/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './home.dart';

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
        '/history': (context) => HistoryPage(),
        '/standings': (context) => StandingsPage(),
        '/schedule': (context) => SchedulePage(),
      }
    );
    }
  }

class SplashScreen extends StatefulWidget {

  SplashScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<FirebaseUser> user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<FirebaseUser>(
        future: user,
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          Widget result;
          if (snapshot.hasData) {
            result = HomePage(snapshot.data);
          } else if (snapshot.hasError) {
            result = Text(snapshot.error.toString());
          } else {
            result = SignInPage();
          }
          return result;
        }
    );
  }
}
