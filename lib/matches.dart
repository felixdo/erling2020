import 'package:erling2020/match.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';
import 'model.dart';
import 'match.dart';

class MatchesPage extends HomePage {
  @override
  Widget buildBody(BuildContext context) {
    return Matchlist();
  }

  @override
  List<Widget> buildAppBarActions(BuildContext context) {
    return [
      PopupMenuButton<Competition>(
          onSelected: (Competition result) {
            Settings settings = Provider.of(context, listen: false);
            settings.setCompetition(result);
          },
          itemBuilder: (BuildContext context) => competitions
              .map((c) => PopupMenuItem(value: c, child: Text(c.name)))
              .toList())
    ];
  }
}

class Matchlist extends StatefulWidget {
  Matchlist({Key key}) : super(key: key);

  final CollectionReference matchCollection =
      Firestore.instance.collection('matches');

  Widget _buildMatchItem(context, DocumentSnapshot matchdoc) {
    return MatchWidget(matchdoc);
  }

  _MatchlistState createState() => _MatchlistState();

}





class _MatchlistState extends State<Matchlist> {
  int matchday;

  @override
  void initState() {
    super.initState();
  }

  void nextMatchDay() {
    setState(() {
      matchday++;
    });
  }

  void previousMatchDay() {
    setState(() {
      matchday--;
    });
  }

  Future<QuerySnapshot> makeSnapshotStream(Competition competition) {
    const int hardCap = 11; // never show more than 11 games
    if (matchday != null) {
      return widget.matchCollection
          .where('matchday', isEqualTo: matchday)
          .where('competition', isEqualTo: competition.key)
          .limit(hardCap)
          .snapshots()
          .first;
    } else {
      DateTime now = DateTime.now();
      DateTime lastMidnight = new DateTime(now.year, now.month, now.hour);
      return widget.matchCollection
          .where('competition', isEqualTo: competition.key)
          .orderBy('utcDate')
          .where('utcDate', isGreaterThan: Timestamp.fromDate(lastMidnight))
          .limit(hardCap)
          .snapshots()
          .first;
    }
  }

  // TODO show dates
  List<Widget> buildList(
      context, AsyncSnapshot snapshot, Competition competition) {
    List<Widget> result = [];

    if (competition.showMatchday) {
      result.add(Text(matchday.toString() + ". Spieltag"));
    }

    result.add(Expanded(
        child: ListView.builder(
            itemBuilder: (context, index) =>
                widget._buildMatchItem(context, snapshot.data.documents[index]),
            itemCount: snapshot.data.documents.length,
            )));

    if (competition.showMatchday) {
      result.add(ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
              child: Text('Letzter Spieltag'),
              color: Colors.blue,
              onPressed: () => previousMatchDay()),
          FlatButton(
              child: Text('Naechster Spieltag'),
              color: Colors.blue,
              onPressed: () => nextMatchDay())
        ],
      ));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of(context);
    Competition competition = settings.competition;
    if (competition.showMatchday){
      if (matchday == null){
        matchday = competition.currentMatchday;
      }
    } else {
      matchday = null;
    }
    return FutureBuilder(
        future: makeSnapshotStream(competition),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text("Loading...");
          return Column(
            children: buildList(context, snapshot, competition),
          );
        });
  }
}
