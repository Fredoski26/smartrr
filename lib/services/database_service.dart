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
    final bigFamily360Org = await FirebaseFirestore.instance
        .collection("organizations")
        .doc("j1mHuKp3BKeAnnY4Wzb6")
        .get();
    final user = await this.getUser();

    FirebaseFirestore.instance.collection('cases').doc().set({
      'language': 'en',
      'caseNumber': null,
      'userId': user.userId,
      'orgId': bigFamily360Org.id,
      'orgName': bigFamily360Org.get("name"),
      'orgEmail': bigFamily360Org.get("orgEmail"),
      'caseType': null,
      'caseDescription': null,
      'focalPhone': bigFamily360Org.get("focalPhone"),
      'locationId': bigFamily360Org.get("locationid"),
      'locationName': user['location'],
      'timestamp': DateTime.now(),
      'status': 0,
      'referredBy': "0",
      'referredByName': bigFamily360Org.get("name"),
      'isVictim': true,
      'victimName': null,
      'victimAge': null,
      'victimPhone': null,
      'victimGender': null
    }).then((onValue) {
      showToast(msg: S.current.caseRegisteredSuccesfully, type: "success");
    });
  }
}
