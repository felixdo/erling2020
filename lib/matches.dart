import 'package:erling2020/match.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home.dart';
import 'match.dart';

class MatchesPage extends HomePage {

  Widget _buildMatchItem(context, DocumentSnapshot document) {
    return MatchWidget(Match(document.data['homeTeam']['name'], document.data['awayTeam']['name']));
  }

  @override
  Widget buildBody(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('matches').where('status', isEqualTo: 'SCHEDULED').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text("Loading...");
          return ListView.builder(
              itemBuilder: (context, index) =>
                  _buildMatchItem(context, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              itemExtent: 80.0
          );
        }
    );

    }
}