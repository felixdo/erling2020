import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Match {
  String homeTeam, awayTeam;
  Map<String, dynamic> score;
  DateTime time;

  Match(this.homeTeam, this.awayTeam, this.score, this.time);

  Match.fromJson(Map<String, dynamic> json)
      : homeTeam = json['homeTeam']['name'],
        awayTeam = json['awayTeam']['name'],
        score = json['score'],
        time = json['utcDate'].toDate();

  String getDuration() {
    return score['duration'];
  }

  List getHalfTimeScore() {
    return _getScore('halfTime');
  }

  List getFullTimeScore() {
    return _getScore('fullTime');
  }

  List getExtraTimeScore() {
    return _getScore('extraTime');
  }

  List getPenaltyScore() {
    return _getScore('penalties');
  }

  List _getScore(String phase) {
    if (score != null) {
      if (score.containsKey(phase)) {
        return [score[phase]['homeTeam'], score[phase]['awayTeam']];
      }
    }
    return null;
  }
}

class MatchWidget extends StatelessWidget {
  static const scoreTextStyle = TextStyle(
    fontSize: 24,
  );

  final DocumentSnapshot matchDoc;
  MatchWidget(this.matchDoc);

  List<List<Widget>> buildScores() {
    List<List<Widget>> result = [];
    bool showHalfTime = true;
    Match match = Match.fromJson(matchDoc.data);
    List score = match.getPenaltyScore();
    if (score == null) {
      score = match.getExtraTimeScore();
    }
    if (score == null) {
      score = match.getFullTimeScore();
    }
    if (score == null) {
      showHalfTime = false;
      score = match.getHalfTimeScore();
    }
    if (score != null) {
      result.add(_makeScoreWidget(score));
    }
    if (showHalfTime) {
      List halfTime = match.getHalfTimeScore();
      if (halfTime != null) {
        result.add(_makeScoreWidget(halfTime));
      }
    }
    return result;
  }

  List<Widget> _makeScoreWidget(List score) {
    return <Widget>[Text(score[0].toString()), Text(score[1].toString())];
  }

  Widget makeBetButton(
      BuildContext context, DocumentReference betRef, String text) {
    return FlatButton(
      color: Colors.lightBlue,
        onPressed: () => betMatch(context, matchDoc.data['homeTeam']['name'],
            matchDoc.data['awayTeam']['name'], betRef),
        child: Text(text));
  }

  Widget _makeMyBetWidget(BuildContext context) {
    FirebaseUser user = Provider.of(context, listen: false);
    DocumentReference betRef =
        matchDoc.reference.collection('bets').document(user.uid);
    return StreamBuilder(
        stream: betRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DocumentSnapshot bet = snapshot.data;
            if (bet == null || !bet.exists) {
              if (matchDoc.data['status'] == 'SCHEDULED') {
                return makeBetButton(context, betRef, "Ergebnis Tippen");
              }
              return Text("Keinen Tipp abgegeben");
            } else {
              Widget result;
              Widget myBet = Text("Mein Tipp: " +
                  snapshot.data['homeTeam'].toString() +
                  ":" +
                  snapshot.data['awayTeam'].toString());
              // can we still update the bet?
              if (matchDoc.data['status'] != 'SCHEDULED') {
                result = myBet;
              } else {
                result = Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      myBet,
                      makeBetButton(context, betRef, "Aendern")
                    ]);
              }
              return result;
            }
          } else if (snapshot.hasError) {
            return Text(snapshot.error);
          } else {
            return Text("...");
          }
        });
  }

  Widget _makeNiceScoreWidget(List score) {
    return Container(
      color: Colors.yellow,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            score == null ? "x" : score[0].toString(),
            style: scoreTextStyle,
            textAlign: TextAlign.right,
          ),
          Text(
            ":",
            style: scoreTextStyle,
            textAlign: TextAlign.center,
          ),
          Text(
            score == null ? "x" : score[1].toString(),
            style: scoreTextStyle,
            textAlign: TextAlign.left,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> scoreRows = [];
    buildScores().forEach((List<Widget> scoreList) {
      scoreRows.add(Row(children: _makeScoreWidget(scoreList)));
    });
    scoreRows.add(_makeMyBetWidget(context));
    Match match = Match.fromJson(matchDoc.data);
    return Card(
      elevation: 5.0,
        margin: EdgeInsets.all(4),
        child: Column(children: <Widget>[
          Text(
            DateFormat("HH:mm").format(match.time),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
            ),
          ), //create it from here as designed
          Stack(children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                      decoration: new BoxDecoration(
                        image: DecorationImage(
                            image: new AssetImage('assets/login.jpeg'),
                            fit: BoxFit.scaleDown,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withAlpha(50), BlendMode.dstATop)),
                        shape: BoxShape.circle,
                      ),
                      height: 80)),
              Expanded(
                  flex: 1,
                  child: Container(
                      decoration: new BoxDecoration(
                        image: DecorationImage(
                            image: new AssetImage('assets/login.jpeg'),
                            fit: BoxFit.scaleDown,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withAlpha(50), BlendMode.dstATop)),
                        shape: BoxShape.circle,
                      ),
                      height: 80)),
            ]),
            Column(children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 4,
                      child: Text(match.homeTeam,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18))),
                  Expanded(
                      flex: 2,
                      child: _makeNiceScoreWidget(match.getFullTimeScore())),
                  Expanded(
                      flex: 4,
                      child: Text(match.awayTeam,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18))),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(flex: 4, child: Text("")),
                  Expanded(
                      flex: 2,
                      child: _makeNiceScoreWidget(match.getHalfTimeScore())),
                  Expanded(flex: 4, child: Text("")),
                ],
              )
            ]),
          ]),
          Row(
            children: <Widget>[
              _makeMyBetWidget(context)
            ],
          )
        ]));
  }

  betMatch(BuildContext context, String home, String away,
      DocumentReference betRef) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(home + " vs. " + away), content: BetForm(betRef));
        });
  }
}

// Define a custom Form widget.
class BetForm extends StatefulWidget {
  final DocumentReference bet;
  BetForm(this.bet);

  @override
  BetFormState createState() {
    return BetFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class BetFormState extends State<BetForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  int homeScore;
  int awayScore;

  String validateScore(String value) {
    int score = int.tryParse(value);
    if (score == null || score < 0) {
      return "Das ist unsinn...";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (value) => homeScore = int.parse(value),
                  keyboardType: TextInputType.number,
                  validator: validateScore,
                )),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                onSaved: (value) => awayScore = int.parse(value),
                keyboardType: TextInputType.number,
                validator: validateScore,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text("Submit"),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    widget.bet.setData({
                      'homeTeam': homeScore,
                      'awayTeam': awayScore,
                      'timestamp': FieldValue.serverTimestamp()
                    });
                    Navigator.of(context).pop();
                  }
                },
              ),
            )
          ],
        ));
  }
}
