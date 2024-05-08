import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kosh/LatestRateActivity.dart';
import 'package:kosh/Screen1.dart';
import 'package:kosh/Screen2.dart';
import 'package:kosh/Screen3.dart';
import 'package:kosh/Screen4.dart';
import 'package:kosh/SignUpActivity.dart';
import 'package:kosh/UploadActivity.dart';

class MainActivity extends StatefulWidget {
  const MainActivity({super.key});

  @override
  State<MainActivity> createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  int myindex = 0;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  CollectionReference reference =
      FirebaseFirestore.instance.collection("Users");

  String name = "User Name";
  String email = "User Email";
  void getdata() async {
    var vari = await FirebaseFirestore.instance
        .collection("Users")
        .doc(user?.uid)
        .get();
    setState(() {
      name = vari.data()?['name'];
      email = vari.data()?['email'];
    });
  }

  @override
  void initState() {
    getdata();
  }

  List<Widget> widgetlist = const [
    Screen1(),
    Screen2(),
    Screen3(),
    Screen4(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "कोश",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Row(
            children: [
              InkWell(
                child: const Icon(
                  Icons.price_change,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LatestRateActivity()),
                  );
                },
              ),
              const SizedBox(
                width: 20,
              )
            ],
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      return Container(
                        margin:const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.blue,
                              backgroundImage: NetworkImage(
                                "${snapshot.data!["image"]}",

                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "${snapshot.data!["name"]}",
                              style:const TextStyle(
                                  color: Colors.black, fontSize: 20),
                            ),
                            Text( "${snapshot.data!["email"]}",
                                style:const TextStyle(
                                color: Colors.black, fontSize: 15),),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(
                              color: Colors.black,
                            )
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.hasError.toString()),
                      );
                    } else {
                      return const Center(
                        child: Text("No Data Avaiablle"),
                      );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(' My Profile '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.drive_folder_upload),
              title: const Text(' Upload Post '),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PostUpload()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload_sharp),
              title: const Text('Upload Query '),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const QueryUpload()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.rate_review),
              title: const Text(' Upload Rate '),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RateUpload()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text(' Edit Profile '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                showAlertDialog(context);
              },
            ),
          ],
        ),
      ), //Drawer
      body: Container(
        child: widgetlist[myindex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            myindex = index;
          });
        },
        currentIndex: myindex,
        //backgroundColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Post'),
          BottomNavigationBarItem(icon: Icon(Icons.help), label: 'Need'),
          BottomNavigationBarItem(icon: Icon(Icons.notification_add),label: 'Notification'),
          BottomNavigationBarItem(icon: Icon(Icons.rate_review), label: 'Rate')
        ],
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Logout"),
    onPressed: () async {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut().then(
          (value) => _auth.signOut().then((value) => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignUpActivity()),
              )));
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Logout"),
    content: const Text("Are you sure you want to logout?."),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
