import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CommentActivity extends StatefulWidget {
  String id;
  CommentActivity({super.key, required this.id});

  @override
  State<CommentActivity> createState() => _CommentActivityState();
}

class _CommentActivityState extends State<CommentActivity> {
  late TextEditingController comment = TextEditingController();

/*
  @override
  void initState() {
    comment = TextEditingController();
    super.initState();
  }
*/






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comment"),
      ),
      body: Container(
        margin: const EdgeInsets.all(5),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Like&Comment")
                      .doc(widget.id)
                      .collection("Comment")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              String cmm = "${snapshot.data!.docs[index]["comment"]}";
                              String userid = "${snapshot.data!.docs[index]["userid"]}";
                              String time = "${snapshot.data!.docs[index]["time"]}";
                              var dd=int.parse(time);
                              var date = DateTime.fromMillisecondsSinceEpoch(dd * 1000);
                              var ddd=date.toString();
                             // final dateFormatter = DateFormat('yyyy-MM-dd');
                             // final formattedDate = dateFormatter.format(date);

                              return Container(
                                margin: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Column(

                                      children: [

                                        Align(
                                          alignment: Alignment.topRight,
                                          child:  Text(
                                            ddd,
                                            style:const TextStyle(
                                              fontSize: 10,
                                              backgroundColor: Colors.red
                                            ),
                                          ),
                                        ),

                                       const  SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                    StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection("Users")
                                            .doc(userid)
                                            .snapshots(),
                                        builder: (context, snapshot1) {
                                          return Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: Colors.blue,
                                                  backgroundImage: NetworkImage(
                                                      "${snapshot1.data!["image"]}"),
                                                ),
                                               const SizedBox(
                                                  width: 20,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "${snapshot1.data!["name"]}",
                                                    maxLines:1,
                                                    style:const TextStyle(
                                                        fontSize: 15,
                                                        backgroundColor: Colors.green
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),

                                                const  Align(
                                                  alignment: Alignment.topRight,
                                                  child: Text(
                                                    "12-01-24  12:34 AM",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        backgroundColor: Colors.red
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),

                                          );
                                        }),

                                  const SizedBox(
                                      height: 10,
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child:Text(
                                        cmm,
                                        maxLines: null,
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(
                                          fontSize: 15,

                                        ),
                                      ),
                                    ),
                                   const  Divider(
                                      height: 10,
                                      color: Colors.black12,
                                    )

                                  ],
                                ),
                              );
                            });
                      }
                      else {
                        return const Center(
                          child: Text("Not Comments Yet"),
                        );
                      }
                    } else {
                      return const Center(
                        child: SpinKitCircle(color: Colors.white, size: 25),
                      );
                    }
                  }),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: comment,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Enter Comment',
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      String cmm = comment.text.toString();
                      var userid = FirebaseAuth.instance.currentUser?.uid;
                      var time =
                          DateTime.now().millisecondsSinceEpoch.toString();

                      var ref = FirebaseFirestore.instance
                          .collection("Like&Comment")
                          .doc(widget.id)
                          .collection("Comment").doc();
                      var newId = ref.id;

                      if (cmm.isNotEmpty) {
                        await FirebaseFirestore.instance
                            .collection("Like&Comment")
                            .doc(widget.id)
                            .collection("Comment")
                            .doc(newId)
                            .set({
                          "userid": userid,
                          "id": widget.id,
                          "comid": newId,
                          "comment": cmm,
                          "time": time,
                        }).then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Comment Uploaded Successfully"),

                              )
                          );
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please enter comment")
                            )
                        );
                      }
                    },
                  icon: const Icon(
                    Icons.send,
                  ),),

              ],
            )
          ],
        ),
      ),
    );
  }
}
