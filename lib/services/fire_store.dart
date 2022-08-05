// ignore: file_names
// ignore: import_of_legacy_library_into_null_safe
import 'package:chat_app/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  CollectionReference fireBase =
      FirebaseFirestore.instance.collection('message');

  Future deleteMessage(String docId) async {
    try {
      await fireBase.doc(docId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future addMessage(Message message) async {
    try {
      await fireBase.add(message.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot> fetchMessage() {
    return fireBase.orderBy('date').snapshots();
  }
}
