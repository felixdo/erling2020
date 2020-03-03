import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './matches.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'model.dart';

void main() => runApp(MyApp());




class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>(
          create: (_) {
            return FirebaseAuth.instance.onAuthStateChanged;
          }
        ),
        ChangeNotifierProvider(
          create: (context) => Settings()
        )
      ],
      child:
          Consumer<FirebaseUser>(
            builder: (_, user, __) {
              if (user != null) {
                return MaterialApp(
                    title: 'Machs nochmal Erling - 2020',
                    theme:
                    ThemeData(
                        primarySwatch: Colors.yellow,
                        canvasColor: Colors.white
                    ),
                    initialRoute: '/matches',
                    routes: {
                      '/matches': (context) => MatchesPage(),
                    }
                );
              } else {
                signin();
                return CircularProgressIndicator();
              }
            }
          )
      );
    }

    Future<FirebaseUser> signin() async {
        GoogleSignIn _googleSignIn = GoogleSignIn();
        FirebaseAuth _auth = FirebaseAuth.instance;
        GoogleSignInAccount googleUser = await _googleSignIn.signIn();
        GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        AuthCredential credential = GoogleAuthProvider.getCredential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken
        );
        final FirebaseUser user =
            (await _auth.signInWithCredential(credential)).user;
        return user;
    }

}
