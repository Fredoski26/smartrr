import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartrr/models/location.dart';

class DatabaseService {
  final String email;

  DatabaseService({this.email = ""});

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  CollectionReference stateCollection =
      FirebaseFirestore.instance.collection("state");

  Future updateUser(Map update) async {
    try {
      HashMap<String, Object> userData = HashMap.from(update);
      final id = await userCollection
          .where("email", isEqualTo: email)
          .get()
          .then((value) => value.docs[0].id);

      await userCollection.doc(id).set(userData, SetOptions(merge: true));
    } catch (e) {
      return null;
    }
  }

  Future getUser() async {
    try {
      final data = await userCollection
          .where("email", isEqualTo: email)
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
}
