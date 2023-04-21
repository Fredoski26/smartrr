import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartrr/generated/l10n.dart';
import 'package:smartrr/models/location.dart';
import 'package:smartrr/models/smart_service.dart';
import 'package:smartrr/services/my_translator.dart';
import 'package:smartrr/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DatabaseService {
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  CollectionReference orgCollection =
      FirebaseFirestore.instance.collection('organizations');

  CollectionReference stateCollection =
      FirebaseFirestore.instance.collection("state");

  CollectionReference faqCollection =
      FirebaseFirestore.instance.collection("faq");

  CollectionReference serviceCollection =
      FirebaseFirestore.instance.collection("services");

  Box configBox = Hive.box("config");

  String? get getDeviceToken => configBox.get("deviceToken");

  Future<List<QueryDocumentSnapshot<Object>>> getFaqs() async {
    final docs = await faqCollection.get();

    return docs.docs as List<QueryDocumentSnapshot<Object>>;
  }

  Future updateUser(Map update) async {
    try {
      String userId = await getUserIdPref();
      HashMap<String, Object> userData = HashMap.from(update);
      final id = await userCollection
          .where("uId", isEqualTo: userId)
          .get()
          .then((value) => value.docs[0].id);

      await userCollection.doc(id).set(userData, SetOptions(merge: true));
    } catch (e) {
      return null;
    }
  }

  Future updateOrg(Map update) async {
    try {
      String orgId = await getOrgIdPref();
      HashMap<String, Object> orgData = HashMap.from(update);
      final id = await orgCollection
          .where("uId", isEqualTo: orgId)
          .get()
          .then((value) => value.docs[0].id);

      await orgCollection.doc(id).set(orgData, SetOptions(merge: true));
    } catch (e) {
      return null;
    }
  }

  Future getUser() async {
    try {
      String userId = await getUserIdPref();
      final data = await userCollection
          .where("uId", isEqualTo: userId)
          .get()
          .then((snapshot) => snapshot.docs[0].data());

      return data;
    } catch (e) {
      return null;
    }
  }

  Future getOrg() async {
    try {
      String orgId = await getOrgIdPref();
      final data = await orgCollection
          .where("uId", isEqualTo: orgId)
          .get()
          .then((snapshot) => snapshot.docs[0].data());

      return data;
    } catch (e) {
      return null;
    }
  }

  Future setDeviceToken({required User user, isUser = true}) async {
    final deviceToken = await FirebaseMessaging.instance.getToken();

    configBox.put("deviceToken", deviceToken);
    if (isUser) {
      await updateUser({"deviceToken": deviceToken});
    } else {
      await updateOrg({"deviceToken": deviceToken});
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
    User currentUser = FirebaseAuth.instance.currentUser!;
    final String bigFamily360OrId = "j1mHuKp3BKeAnnY4Wzb6";
    final String service = "Quick Report";
    String caseNumber = '';
    List<String> ll = currentUser.displayName!.split(' ');
    for (int i = 0; i < ll.length; i++) {
      caseNumber += ll[i].substring(0, 1);
    }
    caseNumber =
        "$caseNumber${DateTime.now().millisecondsSinceEpoch}${service.substring(0, 1)}";

    final bigFamily360Org = await FirebaseFirestore.instance
        .collection("organizations")
        .doc(bigFamily360OrId)
        .get();
    final user = await this.getUser();

    FirebaseFirestore.instance.collection('cases').doc().set({
      'language': 'en',
      'caseNumber': caseNumber,
      'userId': user["uId"],
      'orgId': bigFamily360Org.id,
      'orgName': bigFamily360Org.get("name"),
      'orgEmail': bigFamily360Org.get("orgEmail"),
      'caseType': service,
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
    }).onError(
        (error, stackTrace) => showToast(msg: error.toString(), type: "error"));
  }

  int _calcVictimAge(String dob) {
    DateTime now = new DateTime.now();
    int age = now.year - int.parse(dob.split("-")[2]);
    return age;
  }

  Future<List<SmartService>> getServices(String lang) async {
    return serviceCollection.get().then((docs) async {
      List<SmartService> services = [];
      docs.docs.forEach((service) async {
        services.add(SmartService(id: service.id, name: service.get("title")));
      });

      if (lang == "ha") {
        for (int i = 0; i < services.length; i++) {
          final String translated =
              await MyTranslator.translate(text: services[i].name);

          services[i] = SmartService(id: services[i].id, name: translated);
        }
      }
      return services;
    });
  }

  Future<List<SmartService>> getSubServices(String docId, String lang) async {
    return serviceCollection
        .doc(docId)
        .collection("sub-services")
        .get()
        .then((subServices) async {
      List<SmartService> services = [];

      subServices.docs.forEach((subService) async {
        services.add(
          SmartService(
            id: subService.id,
            name: "${subService.get('title')}_${subService.get('title')}",
          ),
        );
      });

      if (lang == "ha") {
        for (int i = 0; i < services.length; i++) {
          final String translated =
              await MyTranslator.translate(text: services[i].name);

          services[i] = SmartService(
              id: services[i].id, name: "${translated}_${services[i].name}");
        }
      }

      return services;
    });
  }
}
