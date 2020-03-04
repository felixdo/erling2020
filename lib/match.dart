import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class Match {
  String homeTeam, awayTeam;
  Map<String, dynamic> score;

  Match(this.homeTeam, this.awayTeam, this.score);

  Match.fromJson(Map<String, dynamic> json)
      : homeTeam = json['homeTeam']['name'],
        awayTeam = json['awayTeam']['name'],
        score = json['score'];

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

  Widget _makeMyBetWidget(BuildContext context){
    FirebaseUser user = Provider.of(context, listen: false);
    DocumentReference betRef = matchDoc.reference.collection('bets').document(user.uid);
    return FutureBuilder(
        future: betRef.get(),
        builder: (context, snapshot) {
          if (snapshot.hasData){
            DocumentSnapshot bet = snapshot.data;
            if (bet == null || !bet.exists ) {
              return RaisedButton(
                  onPressed: () => betMatch(context, betRef),
                  child: Text("Ergebnis tippen"));
            } else {
              return Text(bet.data.toString());
            }
          } else if (snapshot.hasError){
            return Text(snapshot.error);
          } else {
            return Text("...");
          }
        }
    );
  }

  Widget _makeNiceScoreWidget(List score) {
    return Container(
      color: Colors.yellow,
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Text(score == null ? "x" : score[0].toString(),
              style: scoreTextStyle),
          Text(":", style: scoreTextStyle),
          Text(score == null ? "x" : score[1].toString(), style: scoreTextStyle)
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
        margin: EdgeInsets.all(4),
        child: Column(children: <Widget>[
          ListTile(
              title: Row(
                children: <Widget>[
                  Expanded(flex: 4, child: Text(match.homeTeam)),
                  Expanded(
                      flex: 2,
                      child: Row(children: <Widget>[
                        _makeNiceScoreWidget(match.getFullTimeScore())
                      ])),
                  Expanded(flex: 4, child: Text(match.awayTeam))
                ],
              ),
              subtitle: Column(children: scoreRows))
        ]));
  }

  betMatch(BuildContext context, DocumentReference betRef) {
    Random rand = new Random();
    Map<String, int> bet = { 'homeTeam' : rand.nextInt(5),
            'awayTeam' : rand.nextInt(5)
    };
    betRef.setData(bet);
  }
}
