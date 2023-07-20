import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  const DialogBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      backgroundColor: Colors.white,
      body:  Dialog(
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xffcbbbd3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Text("Success",
              style: TextStyle(color: Color(0xff136262),
                  fontSize: 30, fontWeight: FontWeight.bold),),
          ),
        ),
      ),
    );
  }
}
