
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kosh/CommentActivity.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  bool isLike=false;



  Future<bool> userExists(myid,postid) async {
    return await FirebaseFirestore.instance.collection('Like&Comment')
    .doc(postid).collection("Like")
        .where('userid', isEqualTo: myid)
        .get()
        .then((value) => value.size > 0 ? true : false);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("PostData").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return ListView.builder (

                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {

                        String image = "${snapshot.data!.docs[index]["post"]}";
                        String userid = "${snapshot.data!.docs[index]["userid"]}";
                        String id = "${snapshot.data!.docs[index]["id"]}";



                        String myid=FirebaseAuth.instance.currentUser!.uid;


                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Image.network(
                                  image,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
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
                                            backgroundColor: Colors.blue,
                                            radius: 15,
                                            backgroundImage: NetworkImage(
                                                "${snapshot1.data!["image"]}"),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                           Text(
                                            "${snapshot1.data!["name"]}",
                                            style:const TextStyle(fontSize: 15),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                         const Text(
                                            "( ",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                           Text(
                                            "${snapshot1.data!["village"]}",
                                            style:const TextStyle(fontSize: 15),
                                          ),
                                          const Text(
                                            " )",
                                            style: TextStyle(fontSize: 15),
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${snapshot.data!.docs[index]["title"]}",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${snapshot.data!.docs[index]["des"]}",
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin:const EdgeInsets.symmetric(horizontal: 10),
                                child:const Row(
                                  children: [
                                  Text("54",style: TextStyle(fontSize: 15)),
                                  Text(" likes",style: TextStyle(fontSize: 15)),
                                  Text(" . ",style: TextStyle(fontSize: 15)),
                                  Text("23",style: TextStyle(fontSize: 15)),
                                  Text(" comments",style: TextStyle(fontSize: 15)),
                                  ],
                                ),
                              ),
                              const Divider(
                                color: Colors.black12,
                                thickness: 0.5,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                               Row(

                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  /* Expanded(flex: 1,
                                       child:  FutureBuilder<bool>(
                                           future: userExists(myid,id),
                                           builder: (context,snapshot2){

                                             if( snapshot2.data == true){

                                                return
                                                 InkWell(
                                                     onTap: (){

                                                       FirebaseFirestore.instance.collection("Like&Comment").doc(id).collection("Like").doc(userid)
                                                           .delete();

                                                     },
                                                     child: Image.asset("assets/images/likeb.png",width: 22,height: 22,)
                                                 );
                                             }
                                             else if(snapshot2.data==false){
                                              return InkWell(
                                                   onTap: (){

                                                     FirebaseFirestore.instance.collection("Like&Comment").doc(id).collection("Like").doc(userid)
                                                         .set({
                                                       "id":id,
                                                       "userid":userid
                                                     });

                                                   },
                                                   child: Image.asset("assets/images/like.png",width: 22,height: 22,)
                                               );
                                             }
                                             else{
                                               return const Text("Error");
                                             }
                                              *//*
                                             if(snapshot.connectionState==ConnectionState.waiting){
                                               return Center(child: SpinKitCircle());

                                             }else{ if(snapshot.data == true){
                                                 return InkWell(
                                                     onTap: (){

                                                       FirebaseFirestore.instance.collection("Like&Comment").doc(id).collection("Like").doc(userid)
                                                           .delete();

                                                     },
                                                     child: Image.asset("assets/images/likeb.png",width: 22,height: 22,)
                                                 );
                                               }
                                               else{
                                                 return InkWell(
                                                     onTap: (){

                                                       FirebaseFirestore.instance.collection("Like&Comment").doc(id).collection("Like").doc(userid)
                                                           .set({
                                                         "id":id,
                                                         "userid":userid
                                                       });

                                                     },
                                                     child: Image.asset("assets/images/like.png",width: 22,height: 22,)
                                                 );
                                               }*//*



                                                                              })),*/
                                   Expanded(flex: 1,child:  Image.asset("assets/images/like.png",width: 22,height: 22,)),
                                   Expanded(flex: 1,child:
                                   InkWell(
                                     onTap: (){
                                       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CommentActivity(id:id)));
                                     },
                                       child: Image.asset("assets/images/comment.png",width: 22,height: 22,))),
                                   Expanded(flex: 1,child:  Image.asset("assets/images/send.png",width: 22,height: 22,)),
                                    Expanded(flex: 1,child: Image.asset("assets/images/share.png",width: 22,height: 22,)),
                                  const Expanded(flex: 1,child:  Text("22-03-24 12:34 AM",style: TextStyle(fontSize: 10)),)

                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Divider(
                                color: Colors.black12,
                                height: 20,
                                thickness: 5,
                              )
                            ],
                          ),
                        );
                      });
                }
                else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.hasError.toString()),
                  );
                }
                else {
                  return const Center(
                    child: Text("No Data Avaiablle"),
                  );
                }
              } else {
                return const Center(child: SpinKitCircle(color: Colors.white, size: 25));
              }
            }));
  }
}
