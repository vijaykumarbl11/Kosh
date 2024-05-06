import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kosh/CreateProfileActivity.dart';
import 'package:kosh/SpashActivity.dart';
import 'package:kosh/shared/constants.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid?
  await Firebase.initializeApp(
      options: const FirebaseOptions(

        apiKey: "AIzaSyD7pZjyDicD0qdaIck4rmknXBBV4nuF8SE",
        projectId: "kosh-d3923",
        messagingSenderId: "199372105070",
        appId: "1:199372105070:android:be1d348c13e2acb7ee4d7f",
        storageBucket: "kosh-d3923.appspot.com"

      )
  ):await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {


  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashActivity(),
     
    );
  }
}


