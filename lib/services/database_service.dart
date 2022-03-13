import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String email;

  DatabaseService({this.email});

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

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

  Future getAllUsers() async {
    final response = await userCollection.get();

    print(response.docs.length);
  }
}
