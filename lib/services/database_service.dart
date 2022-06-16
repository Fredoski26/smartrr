import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartrr/generated/l10n.dart';
import 'package:smartrr/models/location.dart';
import 'package:smartrr/utils/utils.dart';

class DatabaseService {
  final String uId;

  DatabaseService({this.uId = ""});

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  CollectionReference stateCollection =
      FirebaseFirestore.instance.collection("state");

  Future updateUser(Map update) async {
    try {
      HashMap<String, Object> userData = HashMap.from(update);
      final id = await userCollection
          .where("uId", isEqualTo: uId)
          .get()
          .then((value) => value.docs[0].id);

      await userCollection.doc(id).set(userData, SetOptions(merge: true));
    } catch (e) {
      return null;
    }
  }

  Future getUser() async {
    try {
      String userId = uId;
      if (uId.isEmpty) {
        userId = await getUserIdPref();
      }
      final data = await userCollection
          .where("uId", isEqualTo: userId)
          .get()
          .then((snapshot) => snapshot.docs[0].data());

      return data;
    } catch (e) {
      return null;
    }
  }

  Future getLocations(String state) async {
    return stateCollection
        .where("sName", isEqualTo: state)
        .get()
        .then((states) {
      if (states.docs.length > 0) {
        final stateId = states.docs[0].id;

        return stateCollection
            .doc(stateId)
            .collection("locations")
            .get()
            .then((locations) {
          return locations.docs
              .map((location) =>
                  MyLocation(location.id, location.get('location')))
              .toList();
        });
      } else {
        return [];
      }
    }).catchError((e) {
      throw e.toString();
    });
  }

  Future submitQuickReport() async {
    final String bigFamily360OrId = "j1mHuKp3BKeAnnY4Wzb6";
    final bigFamily360Org = await FirebaseFirestore.instance
        .collection("organizations")
        .doc(bigFamily360OrId)
        .get();
    final user = await this.getUser();

    FirebaseFirestore.instance.collection('cases').doc().set({
      'language': 'en',
      'caseNumber': null,
      'userId': user["uId"],
      'orgId': bigFamily360Org.id,
      'orgName': bigFamily360Org.get("name"),
      'orgEmail': bigFamily360Org.get("orgEmail"),
      'caseType': "Quick Report",
      'caseDescription': "Case submitted by quick report feature",
      'focalPhone': bigFamily360Org.get("focalPhone"),
      'locationId': bigFamily360Org.get("locationId"),
      'locationName': user['location'],
      'timestamp': DateTime.now(),
      'status': 0,
      'referredBy': "0",
      'referredByName': bigFamily360Org.get("name"),
      'isVictim': true,
      'victimLocation': user["location"],
      'victimName': user["displayName"],
      'victimAge': _calcVictimAge(user["dob"]),
      'victimPhone': user["phoneNumber"],
      'victimGender': user["gender"],
      'isQuickReport': true
    }).then((onValue) {
      showToast(msg: S.current.caseRegisteredSuccesfully, type: "success");
    }).onError((error, stackTrace) => showToast(msg: error, type: "error"));
  }

  int _calcVictimAge(String dob) {
    DateTime now = new DateTime.now();
    int age = now.year - int.parse(dob.split("-")[2]);
    return age;
  }
}
