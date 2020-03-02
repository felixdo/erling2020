import 'package:flutter/cupertino.dart';


class Match {
  String homeTeam, awayTeam;
  Map<String, dynamic> score;

  Match(this.homeTeam, this.awayTeam, this.score);

  Match.fromJson(Map<String, dynamic> json)
      : homeTeam = json['homeTeam']['name'],
        awayTeam = json['awayTeam']['name'],
        score = json['score'];

  String getDuration(){
    return score['duration'];
  }

  List getHalfTimeScore(){
    return _getScore('halfTime');
  }

  List getFullTimeScore(){
    return _getScore('fullTime');
  }

  List getExtraTimeScore(){
    return _getScore('extraTime');
  }
  
  List getPenaltyScore(){
    return _getScore('penalties');
  }

  List _getScore(String phase){
    if (score != null) {
      if (score.containsKey(phase)) {
        return [score['phase']['homeTeam'], score[phase]['awayTeam']];
      }
    }
    return null;
  }
}

class MatchWidget extends StatelessWidget {

  final Match match;
  MatchWidget(this.match);

  List<List<Widget>> buildScores(){
    List<List<Widget>> result = [];
    bool showHalfTime = true;
    List score = match.getPenaltyScore();
    if (score == null){
      score = match.getExtraTimeScore();
    }
    if (score == null){
      score = match.getFullTimeScore();
    }
    if (score == null){
      showHalfTime = false;
      score = match.getHalfTimeScore();
    }
    if (score != null){
      result.add(_makeScoreWidget(score));
    }
    if (showHalfTime){
      List halfTime = match.getHalfTimeScore();
      if (halfTime != null){
        result.add(_makeScoreWidget(halfTime));
      }
    }
    return result;
  }

  List<Widget> _makeScoreWidget(List score){
    return <Widget>[Text(score[0].toString()), Text(score[1].toString())];
  }

  @override
  Widget build(BuildContext context) {

    var teams = [Text(match.homeTeam), Text(match.awayTeam)];
    Row teamsRow = Row(children: teams);

    List<Row> rows = [teamsRow];
    buildScores().forEach( (List<Widget> scoreList) {
      rows.add(Row(children: _makeScoreWidget(scoreList)));
    });

    return Center(
      child: Column(children: rows)
    );
  }


}