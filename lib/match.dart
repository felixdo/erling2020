import 'package:flutter/cupertino.dart';

import './score.dart';

class Match {
  String homeTeam, awayTeam;

  Match(this.homeTeam, this.awayTeam);
  //factory Match.fromJSON(Map<dynamic, dynamic> match) => Match(homeTeam: match["homeTeam"]["name"], awayTeam: match["awayTeam"]["name"], score: Score.fromJSON(match["score"]));
}

class MatchWidget extends StatelessWidget {

  final Match match;
  MatchWidget(this.match);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: <Widget>[
        Row(children: <Widget>[ Text(match.homeTeam), Text(match.awayTeam)]),
        //Row(children: <Widget>[ Text(match.score.full["homeTeam"].toString()), Text(match.score.full["awayTeam"].toString())])
      ])
    );
  }

}