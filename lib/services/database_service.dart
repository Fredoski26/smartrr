import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUser(Map update) async {
    try {
      HashMap<String, Object> userData = HashMap.from(update);
      await userCollection.doc(uid).set(userData);
    } catch (e) {
      return null;
    }
  }

  Future getUser() async {
    try {
      DocumentSnapshot snapshot = await userCollection.doc(uid).get();
      return snapshot.data();
    } catch (e) {
      return null;
    }
  }

  Future getAllUsers() async {
    final response = await userCollection.get();

    print(response.docs.length);
  }
}
