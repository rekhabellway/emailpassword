import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'bottomnavigationbar.dart';

class DataDetails extends StatefulWidget {
  const DataDetails({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DataDetailsState createState() => _DataDetailsState();
}

class _DataDetailsState extends State<DataDetails> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                Get.to(() => const BottomBar());
              },
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['firstname'].toString(),
                        style: const TextStyle(),
                      ),
                      Text(
                        data['lastname'].toString(),
                        style: const TextStyle(),
                      ),
                      Text(
                        data['email'].toString(),
                        style: const TextStyle(),
                      ),
                      Text(
                        data['password'].toString(),
                        style: const TextStyle(),
                      ),
                    ],
                  ),
                );
              }).toList());
            } else {
              return const Text("No data");
            }
          },
        ));
  }
}
