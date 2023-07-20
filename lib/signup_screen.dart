import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emailpassword/data_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'models/user_models.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;
  final _formkey = GlobalKey();

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final focusFirstName = FocusNode();
  final focusLastName = FocusNode();
  final focusEmail = FocusNode();
  final focusPassword = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        title: const Text("SignUp", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: ListView(children: <Widget>[
        Form(
          key: _formkey,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: firstnameController,
                focusNode: focusFirstName,
                decoration:
                    const InputDecoration(labelText: 'Enter your firstname'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: lastnameController,
                focusNode: focusLastName,
                decoration:
                    const InputDecoration(labelText: 'Enter your lastname'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: emailController,
                focusNode: focusEmail,
                decoration:
                    const InputDecoration(labelText: 'Enter your email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                obscureText: true,
                controller: passwordController,
                focusNode: focusPassword,
                decoration:
                    const InputDecoration(labelText: 'Enter your password'),
              ),
            ),
          ]),
        ),
        Center(
          child: ElevatedButton(
              onPressed: () {
                submit();
              },
              child: const Text(
                "SignUp",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
        ),
      ]),
    );
  }

  void submit() {
    if (firstnameController.text.trim().isNotEmpty) {
      if (lastnameController.text.trim().isNotEmpty) {
        if (emailController.text.trim().isNotEmpty) {
          if (passwordController.text.trim().isNotEmpty) {
            UserModel userModel = UserModel(
              firstname: firstnameController.text,
              lastname: lastnameController.text,
              email: emailController.text,
              password: passwordController.text,
            );
            createUserWithEmailAndPassword(userModel);
          } else {
            final snackBar = SnackBar(
              content: const Text(
                'Hey! This is a SnackBar message.',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 1),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  // Some code to undo the change.
                },
              ),
            );
          }
        } else {
          void showSnackBar(BuildContext context) {
            const snackBar = SnackBar(
              content: Text(
                "enter number",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
      } else {
        void showSnackBar(BuildContext context) {
          const snackBar = SnackBar(
            content: Text(
              "enter last name",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    } else {
      void showSnackBar(BuildContext context) {
        const snackBar = SnackBar(
          content: Text(
            "enter first name",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Future<void> createUserWithEmailAndPassword(UserModel userModel) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: userModel.email!,
        password: userModel.password!,
      )
          .then((value) {
        userModel.id = value.user!.uid;
        addUser(userModel);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        if (kDebugMode) {
          print('The password provided is too weak.');
        }
      } else if (e.code == 'email-already-in-use') {
        if (kDebugMode) {
          print('The account already exists for that email.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<dynamic> addUser(UserModel userModel) async {
    users.add(userModel.toJson()).then((value) {
      isLoading = false;
      Get.to(() => const DataDetails());
    }).catchError((error) => print(""
        "Failed to add user: $error"));
  }
}
