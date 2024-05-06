import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

class Screen4 extends StatefulWidget {
  const Screen4({super.key});

  @override
  State<Screen4> createState() => _Screen4State();
}

class _Screen4State extends State<Screen4> {
  String? imageUrl;
  File? gallery_image;

  ImagePicker picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UploadPostForm()));
                },
                child: const Text("Upload Post")),
            const SizedBox(
              height: 50,
            ),
            OutlinedButton(
                onPressed: () async {
                  XFile? file =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (file != null) {
                    setState(() {
                      gallery_image = File(file.path);
                    });
                  }

                  try {
                    String ct =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    Reference reff = await FirebaseStorage.instance
                        .ref()
                        .child("postImage")
                        .child('$ct.png');
                    await reff.putFile(gallery_image!);
                    imageUrl = await reff.getDownloadURL();
                    setState(() {});

                    await FirebaseFirestore.instance.collection("AAA").add({
                      'aa': 'aa',
                      'bb': 'bb',
                      'im': imageUrl.toString()
                    }).then((value) => ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text("Search"))));
                  } catch (e) {
                    print('error is $e');
                  }
                },
                child: const Text("Upload Silk Rate"))
          ],
        ),
      ),
    );
  }
}

class UploadPostForm extends StatefulWidget {
  const UploadPostForm({super.key});

  @override
  State<UploadPostForm> createState() => _UploadPostFormState();
}

class _UploadPostFormState extends State<UploadPostForm> {
  String? imageUrl;
  File? FileImage;

  ImagePicker picker = ImagePicker();

  bool isLoading = false;

  late TextEditingController title;
  late TextEditingController dis;
  late TextEditingController more;

  @override
  void initState() {
    title = TextEditingController();
    dis = TextEditingController();
    more = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    title.dispose();
    dis.dispose();
    more.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: () async {
                  _showPicker(context: context);
                },
                child: Container(
                  height: 200,
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        FileImage == null
                            ? Image.asset(
                                'assets/images/upload_image.png',
                                height: 60,
                                width: 60,
                                alignment: Alignment.center,
                              )
                            : Image.file(
                          FileImage!,
                                height: 150,
                                width: double.infinity,
                                alignment: Alignment.center,
                              ),
                        if (FileImage == null)
                          const SizedBox(
                            height: 10,
                          ),
                        if (FileImage == null) const Text("UPLOAD IMAGE"),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              TextFormField(
                controller: title,
                maxLines: null,
                maxLength: 50,
                decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red))),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: dis,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                    labelText: 'Destcription',
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: more,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                    labelText: 'More',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red))),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    String title1 = title.text;
                    String dis1 = dis.text;
                    String more1 = more.text;

                    if (FileImage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please Select Image")));
                      return;
                    } else if (title1.isEmpty ||
                        dis1.isEmpty ||
                        more1.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please Fill All Details")));
                      return;
                    }
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      String ct =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      Reference reff = await FirebaseStorage.instance
                          .ref()
                          .child("postImage")
                          .child('$ct.png');
                      await reff.putFile(FileImage!);
                      imageUrl = await reff.getDownloadURL();

                      setState(() {});

                      final newRef = FirebaseFirestore.instance
                          .collection('PostData')
                          .doc();
                      final newId = newRef.id;

                      await FirebaseFirestore.instance
                          .collection("PostData")
                          .doc(newId)
                          .set({
                            "title": "$title1",
                            "des": "$dis1",
                            "more": "$more1",
                            "id": "$newId",
                            "post": imageUrl.toString()
                          })
                          .then((value) => ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Text("Post Uploaded"))))
                          .then((value) {
                            title.clear();
                            dis.clear();
                            more.clear();
                            FileImage = null;
                            Navigator.pop(context);
                          });
                    } catch (e) {
                      print('error is $e');
                    }

                    setState(() {
                      isLoading = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                      textStyle: const TextStyle(
                        fontSize: 20,
                      )),
                  child: isLoading == true
                      ? const SpinKitCircle(color: Colors.white, size: 25)
                      : const Text(
                          "SUBMIT POST",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
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
        FileImage = File(pickedFile!.path);
      },
    );
  }
}
