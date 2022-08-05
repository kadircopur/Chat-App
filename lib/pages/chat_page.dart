// ignore: file_names
import 'package:chat_app/message.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/fire_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _formKey = GlobalKey<FormState>();
  String message = "";
  final AuthService _auth = AuthService();
  final DataBaseService _fireStore = DataBaseService();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String name = _auth.getCurrentUserName();
      String uid = "";
      if (_auth.getCurrentUser() != null) {
        uid = _auth.getCurrentUser()!.uid;
      }
      setState(() {
        Message messageO = Message(name, '', uid, message);
        _fireStore.addMessage(messageO);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text('D204'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: _fireStore.fetchMessage(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Message> messageList = <Message>[];
                  messageList = snapshot.data!.docs.map((DocumentSnapshot doc) {
                    return Message.fromMap(doc.data() as Map, doc.id);
                  }).toList();
                  return Expanded(
                    child: ListView.builder(
                        itemCount: messageList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onLongPress: () {
                              if (messageList[index].uid ==
                                  _auth.getCurrentUser()?.uid) {
                                _fireStore.deleteMessage(messageList[index].id);
                              }
                            },
                            child: Container(
                                margin: const EdgeInsets.all(10),
                                child: Align(
                                  alignment: (messageList[index].uid ==
                                          _auth.getCurrentUser()?.uid
                                      ? Alignment.topRight
                                      : Alignment.topLeft),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 14,
                                        right: 14,
                                        top: 10,
                                        bottom: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: (messageList[index].uid ==
                                              _auth.getCurrentUser()?.uid
                                          ? Colors.deepOrange
                                          : Colors.grey[600]),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          (messageList[index].uid ==
                                                  _auth.getCurrentUser()?.uid
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start),
                                      children: <Widget>[
                                        Text(
                                          messageList[index]
                                              .senderName
                                              .toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Text(
                                          messageList[index].message,
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          );
                        }),
                  );
                } else {
                  return const Text("Snapshot does not have data");
                }
              }),
          Container(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter a message here',
                        ),
                        onSaved: (data) =>
                            data != null ? message = (data) : message = message,
                      ),
                    ),
                  ),
                  Container(
                      color: Colors.amber,
                      margin: const EdgeInsets.all(10),
                      child: IconButton(
                        onPressed: () => _submit(),
                        icon: const Icon(Icons.arrow_forward),
                        color: Colors.deepOrange,
                      ))
                ],
              ))
        ],
      ),
    );
  }
}
