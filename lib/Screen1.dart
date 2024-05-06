import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("PostData").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                "${snapshot.data!.docs[index]["post"]}",
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.contain,
                              ),
                               Container(
                                 margin: const EdgeInsets.symmetric(horizontal: 10),
                                 child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "${snapshot.data!.docs[index]["title"]}",
                                      style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${snapshot.data!.docs[index]["des"]}",
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${snapshot.data!.docs[index]["more"]}",
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                                               ),
                               ),

                            ],
                          ),
                        );
                      });
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
            })
    );
  }
}
