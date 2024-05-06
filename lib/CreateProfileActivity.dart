import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:image_picker/image_picker.dart';
import 'package:kosh/CreateProfileActivity.dart';
import 'package:flutter/material.dart';
import 'package:kosh/MainActivity.dart';

class CreateProfileActivity extends StatefulWidget {
  final String email;
  const CreateProfileActivity({super.key, required this.email});

  @override
  State<CreateProfileActivity> createState() => _CreateProfileActivityState();
}

class _CreateProfileActivityState extends State<CreateProfileActivity> {
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();

  File? fileImage;

  String? imageUrl;

  ImagePicker picker = ImagePicker();

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      "Create Profile",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 50,
                    ),

                    InkWell(
                     onTap: (){
                       _showPicker(context: context);
                     },
                     child: fileImage == null
                         ? const CircleAvatar(
                         backgroundColor: Colors.blue,
                         radius: 80,
                         backgroundImage:  NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTvrgRcN-UA_HZ3Bv2qBNRxtoAFgfj03u4VT9kRDF-xA&s.png")
                     )
                         :  CircleAvatar(
                         backgroundColor: Colors.blue,
                         radius: 80,
                         backgroundImage:  FileImage(fileImage!))

                   ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                          hintText: 'Enter Your Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.perm_identity)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: number,
                      decoration: InputDecoration(
                          hintText: 'Enter Your Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.phone)),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            String name1 = name.text.toString();
                            String number1 = number.text.toString();

                            setState(() {
                              isLoading = true;
                            });
                            if (fileImage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please Select Image")));
                              return;
                            } else if (name1.isEmpty ||
                                number1.isEmpty
                               ) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("Please Fill All Details")));
                              return;
                            }
                            try {
                              String ct = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();
                              Reference reff = await FirebaseStorage.instance
                                  .ref()
                                  .child("Users")
                                  .child('$ct.png');
                              await reff.putFile(fileImage!);
                              imageUrl = await reff.getDownloadURL();

                              setState(() {});

                              await FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(FirebaseAuth.instance.currentUser?.uid)
                                  .update({
                                "name": name1,
                                "number": number1,
                                "image": imageUrl.toString()
                              }).then((value) => Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MainActivity()))
                                          .then((value) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content:
                                                    Text("Profile Created")));
                                      }));
                            } catch (e) {
                              print('error is $e');
                            }

                            setState(() {
                              isLoading = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            elevation: 10,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 30),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                          child:isLoading == true
                              ? const SpinKitCircle(color: Colors.white, size: 25)
                              : const Text(
                            "Profile Created",
                            style: TextStyle(color: Colors.white),
                          ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    const Expanded(
                      child: SizedBox(
                        height: 30,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainActivity()));
                      },
                      child: Container(
                        height: 50,
                        width: 100,
                        //color: Colors.blue,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.blue,
                        ),

                        //width: double.infinity,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Skip",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(
    ImageSource img,
  ) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        fileImage = File(pickedFile!.path);
      },
    );
  }
}
