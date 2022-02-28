import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Case {
  String id;
  String caseNumber;
  String userId;
  String orgId;
  String orgName;
  String caseType;
  String caseDesc;
  String locationId;
  String locationName;
  Timestamp timestamp;
  int status;
  String referredBy;
  String referredByName;
  bool isVictim;
  String victimName;
  double victimAge;
  String victimPhone;
  bool victimGender;

  Case({
    @required this.id,
    @required this.caseNumber,
    @required this.userId,
    @required this.orgId,
    @required this.orgName,
    @required this.caseType,
    @required this.caseDesc,
    @required this.locationId,
    @required this.locationName,
    @required this.timestamp,
    @required this.status,
    @required this.referredBy,
    @required this.referredByName,
    @required this.isVictim,
    @required this.victimName,
    @required this.victimAge,
    @required this.victimPhone,
    @required this.victimGender,
  });
}
