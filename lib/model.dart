import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

final List<Competition> competitions = [
  Competition('BL1', true, 25, "1. Bundesliga"),
  Competition('CL', false, 0, "Champions League"),
  Competition('EC', false, 0, "Europameisterschaft"),
];

class Competition {

  final String key;
  final bool showMatchday;
  final int currentMatchday;
  final String name;

  const Competition(this.key, this.showMatchday, this.currentMatchday, this.name);

}

class Settings with ChangeNotifier {

  Competition competition = competitions[0];

  setCompetition(Competition other){
    if (competition.key != other.key){
      competition = other;
      notifyListeners();
    }
  }
}