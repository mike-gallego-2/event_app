import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final db = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getPoints() {
    return db.collection('markers').snapshots().asBroadcastStream();
  }

  Future<DocumentReference<Map<String, dynamic>>> createMarker(Map<String, dynamic> json) {
    return db.collection('markers').add(json);
  }
}
