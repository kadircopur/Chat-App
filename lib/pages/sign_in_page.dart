// ignore: file_names
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/fire_store.dart';
import 'package:chat_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final DataBaseService dataBaseService = DataBaseService();
  final AuthService _auth = AuthService();
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Container(
        margin: const EdgeInsets.all(35.0),
        child: Column(children: <Widget>[
          TextField(
            controller: myController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'User Name',
              hintText: 'Enter Your Name',
            ),
          ),
          Container(
            margin: const EdgeInsets.all(15.0),
            child: ElevatedButton(
                onPressed: () async {
                  User? user = await _auth.signInAnonym();
                  if (user == null) {
                    print("Can not signed in");
                  } else {
                    await user.updateDisplayName(myController.text);
                    print("Signed in");
                    // To ChatPage
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChatPage()),
                    );
                  }
                },
                child: const Text("Enter")),
          )
        ]),
      ),
    );
  }
}
