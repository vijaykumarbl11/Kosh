import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Screen3 extends StatefulWidget {
  const Screen3({super.key});

  @override
  State<Screen3> createState() => _Screen1State();
}

class _Screen1State extends State<Screen3> {


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child : Text("Notification")
      ),


    );
  }
}
