import 'package:flutter/material.dart';

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
        return [score['phase']['homeTeam'], score[phase]['awayTeam']];
      }
    }
    return null;
  }
}

class MatchWidget extends StatelessWidget {
  static const scoreTextStyle = TextStyle(
    fontSize: 24,
  );

  final Match match;
  MatchWidget(this.match);

  List<List<Widget>> buildScores() {
    List<List<Widget>> result = [];
    bool showHalfTime = true;
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

  Widget _makeNiceScoreWidget(List score) {
    return Container(
      color: Colors.yellow,
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Text(score == null ? "x" : score[0], style: scoreTextStyle),
          Text(":", style: scoreTextStyle),
          Text(score == null ? "x" : score[1], style: scoreTextStyle)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Row> scoreRows = [];
    buildScores().forEach((List<Widget> scoreList) {
      scoreRows.add(Row(children: _makeScoreWidget(scoreList)));
    });

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
}
