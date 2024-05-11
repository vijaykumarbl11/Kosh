

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Scaffold(
            body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("QueryData").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                if(snapshot.connectionState==ConnectionState.active){
                  if(snapshot.hasData){
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context,index){


                          String title="${snapshot.data!.docs[index]["title"]}";
                          String subtitle="${snapshot.data!.docs[index]["subtitle"]}";
                          String des="${snapshot.data!.docs[index]["des"]}";
                          String money="${snapshot.data!.docs[index]["money"]}";
                          String address="${snapshot.data!.docs[index]["address"]}";
                          String rule="${snapshot.data!.docs[index]["rule"]}";
                          String name="${snapshot.data!.docs[index]["name"]}";
                          String contact="${snapshot.data!.docs[index]["contact"]}";
                          String whatsapp="${snapshot.data!.docs[index]["whatsapp"]}";
                          String post="${snapshot.data!.docs[index]["post"]}";

                          String money1;

                          if(title=="कामासाठी व्यक्ती पाहिजे"){
                            money1="रोज : ";
                          }else if(title=="किरायाने देणे आहे"||title=="किरायाने पाहिजे आहे"){
                            money1="किराया : ";
                          }else{
                            money1="किंमत : ";
                          }


                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(5)),
                            child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Container(
                                  padding: const EdgeInsets.all(10),
                                  color: Colors.blue,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          title,
                                          style:const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),

                                      Row(
                                        children: [
                                          Image.asset("assets/images/whatsappb.png",height: 30,width: 30),
                                         const  SizedBox(
                                            width: 30,
                                          ),Image.asset("assets/images/circle.png",height: 30,width: 30),
                                         const SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      )
                                    ]
                                  ),
                                ),
                                const  SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),

                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        subtitle,
                                        style:const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                      if (des.isNotEmpty)  const  SizedBox(
                                        height: 10,
                                      ),
                                      if (des.isNotEmpty) Text(des, style:const  TextStyle(fontSize: 17,)),
                                      if (money.isNotEmpty)  const  SizedBox(
                                        height: 20,
                                      ),
                                      if (money.isNotEmpty) Wrap(
                                        direction: Axis.horizontal,
                                        children: [
                                          Text(
                                            money1,
                                            style:const TextStyle(
                                                fontSize: 15,fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            money,
                                            //overflow:TextOverflow.ellipsis,
                                            maxLines: null,
                                            style:const  TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (address.isNotEmpty) const  SizedBox(
                                        height: 20,
                                      ),
                                      if (address.isNotEmpty) Wrap(
                                        direction: Axis.horizontal,
                                        children: [
                                          const Text(
                                            "पत्ता : ",
                                            style: TextStyle(
                                                fontSize: 15,fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            address,
                                            style:const  TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                        ],
                                      ),

                                      if (rule.isNotEmpty) const  SizedBox(
                                        height: 20,
                                      ),
                                      if (rule.isNotEmpty) Wrap(
                                        direction: Axis.horizontal,
                                        children: [
                                          const Text(
                                            "नियम व अटी : ",
                                            style: TextStyle(
                                                fontSize: 15,fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          const  SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            rule,
                                            style:const  TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (name.isNotEmpty) const  SizedBox(
                                        height: 20,
                                      ),
                                      if (name.isNotEmpty) Wrap(
                                        direction: Axis.horizontal,
                                        children: [
                                          const Text(
                                            "मालकाचे नाव : ",
                                            style: TextStyle(
                                                fontSize: 15,fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          const  SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            name,
                                            style:const  TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (contact.isNotEmpty) const  SizedBox(
                                        height: 10,
                                      ),
                                      if (contact.isNotEmpty) Row(
                                        children: [
                                          const  Text(
                                            "संपर्क : ",
                                            style: TextStyle(
                                                fontSize: 15,fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          const  SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            contact,
                                            style: const TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (whatsapp.isNotEmpty) const SizedBox(
                                        height: 10,
                                      ),
                                      if (whatsapp.isNotEmpty) Row(
                                        children: [
                                          const Text(
                                            "व्हॉट्सअँप नंबर : ",
                                            style: TextStyle(
                                                fontSize: 15,fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          const  SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            whatsapp,
                                            style:const  TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),

                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );

                    });

                  }else if(snapshot.hasError){
                    return Center(child: Text(snapshot.hasError.toString()));
                  }else{
                    return const Center(child: Text("Data Not Available"),);
                  }

                }else{
                  return const Center(child: CircularProgressIndicator());
                }

              },

            )));
  }
}
