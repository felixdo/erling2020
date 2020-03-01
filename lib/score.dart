
enum Duration {
  REGULAR
}
class Score {
  Duration duration;
  Map<String,int> full;
  Map<String,int> halftime;
  Score({this.duration, this.full, this.halftime});
  factory Score.fromJSON(Map<dynamic, dynamic> score) => Score(duration: score["Duration"], full: score["fullTime"], halftime: score["halfTime"]);
}