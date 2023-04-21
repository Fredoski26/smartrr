import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PeriodTrackerService {
  final String uid;
  PeriodTrackerService({required this.uid});

  static final _periodTrackerBox = Hive.box("period_tracker");
  static final CollectionReference _periodTrackerCollection =
      FirebaseFirestore.instance.collection("periodTracker");

  static DateTime? get getLastPeriod => _periodTrackerBox.get("lastPeriod");

  static int? get getLutealPhaseLength =>
      _periodTrackerBox.get("lutealPhaseLength");

  static int? get getCycleLength => _periodTrackerBox.get("cycleLength");
  static int? get getPeriodLength => _periodTrackerBox.get("periodLength");
  static int? get getYearOfBirth => _periodTrackerBox.get("yearOfBirth");

  static Future setYearOfBirth(int year) async {
    _periodTrackerBox.put("yearOfBirth", year);
  }

  static Future setLutealPhaseLength(int length) async {
    await _periodTrackerBox.put("lutealPhaseLength", length);
  }

  static Future setCycleLength(int length) async {
    await _periodTrackerBox.put("cycleLength", length);
  }

  static Future setPeriodLength(int length) async {
    await _periodTrackerBox.put("periodLength", length);
  }

  static Future setLastPeriod(DateTime lastPeriod) async {
    await _periodTrackerBox.put("lastPeriod", lastPeriod);
  }

  Future updateDocument() async {
    final lastPeriod = getLastPeriod;
    final lutealPhaseLength = getLutealPhaseLength;
    final cycleLength = getCycleLength;
    final periodLength = getPeriodLength;
    final yearOfBirth = getYearOfBirth;

    HashMap<String, Object> cycleData = HashMap.from({
      "lastPeriod": lastPeriod,
      "periodLength": periodLength,
      "cycleLength": cycleLength,
      "lutealPhaseLength": lutealPhaseLength,
      "yearOfBirth": yearOfBirth,
      "uid": uid,
      "userRef": FirebaseFirestore.instance.doc("users/$uid"),
      "lastUpdated": DateTime.now(),
    });

    await _periodTrackerCollection.doc(uid).set(
          cycleData,
          SetOptions(merge: true),
        );
  }
}
