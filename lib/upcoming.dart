import 'dart:developer';

import 'package:erling2020/match.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'match.dart';

class UpcomingPage extends HomePage {
  Widget _buildMatchItem(context, DocumentSnapshot document) {
    debugPrint(document.data['utcDate'] +
        " : " +
        document.data['homeTeam']['name'] +
        " - " +
        document.data['awayTeam']['name']);
    if (_isTodayAndNotStarted(document.data['utcDate'])) {
      return MatchWidget(Match(document.data['homeTeam']['name'],
          document.data['awayTeam']['name']));
    } else {
      return null;
    }
  }

  @override
  Widget buildBody(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('matches')
            .where('status', isEqualTo: 'SCHEDULED')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text("Loading...");
          return ListView.builder(
              itemBuilder: (context, index) =>
                  _buildMatchItem(context, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              itemExtent: 80.0);
        });
  }

  bool _isTodayAndNotStarted(String matchTimestamp) {
    DateTime now = DateTime.now().toUtc();
    DateTime matchTime = DateTime.parse(matchTimestamp).toUtc();
    DateTime tomorrow = new DateTime(now.year, now.month, now.day)
        .toUtc()
        .add(const Duration(days: 8));

    return matchTime.isAfter(now) && matchTime.isBefore(tomorrow);
  }
}
