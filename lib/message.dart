import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  late String senderName;
  late String id;
  late String uid;
  late String message;
  final date = DateTime.now();

  Message(this.senderName, this.id, this.uid, this.message);

  Message.fromMap(Map snapshot, String? id)
      : id = id ?? '',
        senderName = snapshot['senderName'] ?? '',
        message = snapshot['message'] ?? '',
        uid = snapshot['uid'] ?? '';

  toJson() {
    return {
      "senderName": senderName,
      "message": message,
      "uid": uid,
      "date": date,
    };
  }
}
