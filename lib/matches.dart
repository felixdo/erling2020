import 'package:erling2020/match.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'match.dart';

class MatchesPage extends HomePage {
  @override
  Widget buildBody(BuildContext context) {
    return Matchlist();
  }
}

class Matchlist extends StatefulWidget {
  Matchlist({
    Key key
  }) : super(key: key);

  final CollectionReference matchCollection = Firestore.instance.collection('matches');

  Widget _buildMatchItem(context, DocumentSnapshot document) {
    return MatchWidget(Match.fromJson(document.data));
  }

  _MatchlistState createState() => _MatchlistState();
}

class _MatchlistState extends State<Matchlist> {

  String competition = "BL1";
  int matchday = 26;

  @override
  void initState() {
    super.initState();
    this.competition = "EC";
  }

  void setCompetition(String competition) async {
    
    DocumentSnapshot cdoc = await Firestore.instance.collection('competitions').document(competition).snapshots().first;
    var currentMatchday = cdoc.data['currentMatchday'];

    setState(() {
      this.competition = competition;
      matchday = currentMatchday;
    });
  }

  void nextMatchDay(){
    setState(() {
      matchday++;
    });
  }

  void previousMatchDay(){
    setState(() {
      matchday--;
    });
  }


  Stream<QuerySnapshot> makeSnapshotStream(){
    if (matchday != null) {
      return widget.matchCollection.where('matchday', isEqualTo: matchday)
          .snapshots();
    } else {
      DateTime now = DateTime.now();
      DateTime _000 = now.subtract(Duration(hours: now.hour, minutes: now.minute, seconds: now.second, microseconds: now.microsecond, milliseconds: now.millisecond));
      DateTime _001 = _000.add(Duration(days: 1));
      return widget.matchCollection.where('utcDate', isGreaterThan: Timestamp.fromDate(_000)).where('ucDate', isLessThan: Timestamp.fromDate(_001)).snapshots();
    }
  }

  Widget buildList(context, AsyncSnapshot snapshot){
    return ListView.builder(
        itemBuilder: (context, index) =>
            widget._buildMatchItem(context, snapshot.data.documents[index]),
        itemCount: snapshot.data.documents.length,
        itemExtent: 80.0
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: makeSnapshotStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text("Loading...");
          if (matchday != null){
            return Column(
              children: <Widget>[
                Text(matchday.toString() + ". Spieltag"),
                Expanded(
                  child: buildList(context, snapshot)
                ),

          ButtonBar(
            alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text('Letzter Spieltag'),
                      color: Colors.blue,
                      onPressed: () => previousMatchDay()
                    ),
                    FlatButton(
                      child: Text('Naechster Spieltag'),
                      color: Colors.blue,
                      onPressed: () => nextMatchDay()
                    ),
                  ],
                )
                ],
            );
          }
        }
    );

  }
}