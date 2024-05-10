import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';




//Post Upload


class PostUpload extends StatefulWidget {
  const PostUpload({super.key});

  @override
  State<PostUpload> createState() => _UploadPostFormState();
}

class _UploadPostFormState extends State<PostUpload> {
  String? imageUrl;
  File? FileImage;

  ImagePicker picker = ImagePicker();

  bool isLoading = false;

  late TextEditingController title;
  late TextEditingController dis;

  @override
  void initState() {
    title = TextEditingController();
    dis = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    title.dispose();
    dis.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text(
        "Upload Post",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  _showPicker(context: context);
                },
                child: Container(
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
                decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red))),
              ),
              const SizedBox(
                height: 30,
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
                height: 50,
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    String title1 = title.text;
                    String dis1 = dis.text;

                    if (FileImage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please Select Image")));
                      return;
                    } else if (title1.isEmpty ||
                        dis1.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please Fill All Details")));
                      return;
                    }
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      String userid=FirebaseAuth.instance.currentUser!.uid;
                      String timestamp=DateTime.now().millisecondsSinceEpoch.toString();
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
                        "id": "$newId",
                        "userid":userid,
                        "time":timestamp,
                        "post": imageUrl.toString()
                      })
                          .then((value) => ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                          content: Text("Post Uploaded"))))
                          .then((value) {
                        title.clear();
                        dis.clear();
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


//Query Upload
class QueryUpload extends StatefulWidget {
  const QueryUpload({super.key});

  @override
  State<QueryUpload> createState() => _UploadActivityState();
}

class _UploadActivityState extends State<QueryUpload> {
  String type="";
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text("तुम्हाला काय पाहिजे आहे ?",style: TextStyle(
                fontWeight: FontWeight.bold,fontSize: 20
              ),),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SubQueryUpload(type:"need")));
          
                },
                child: Container(
                  width: double.infinity,
                  margin:const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child:const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Icon(Icons.person_search,size: 30,),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
          
                          Text("कामासाठी व्यक्ती पाहिजे",style: TextStyle(
                              fontWeight: FontWeight.bold,fontSize: 15
                          ),),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Need person for work on per day basis"),
          
                        ],
          
                      ),
                    ],
          
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SubQueryUpload(type:"rentout")));

                },
                child: Container(
                  width: double.infinity,
                  margin:const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child:const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Icon(Icons.person_search,size: 30,),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
          
                          Text("किरायाने देणे आहे",style: TextStyle(
                              fontWeight: FontWeight.bold,fontSize: 15
                          ),),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Need person for work on per day basis"),
          
                        ],
          
                      ),
                    ],
          
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SubQueryUpload(type:"rentin")));

                },
                child: Container(
                  width: double.infinity,
                  margin:const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child:const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Icon(Icons.person_search,size: 30,),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
          
                          Text("किरायाने पाहिजे आहे",style: TextStyle(
                              fontWeight: FontWeight.bold,fontSize: 15
                          ),),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Need person for work on per day basis"),
          
                        ],
          
                      ),
                    ],
          
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SubQueryUpload(type:"sellout")));

                },
                child: Container(
                  width: double.infinity,
                  margin:const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child:const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Icon(Icons.person_search,size: 30,),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
          
                          Text("विक्री आहे",style: TextStyle(
                              fontWeight: FontWeight.bold,fontSize: 15
                          ),),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Need person for work on per day basis"),
          
                        ],
          
                      ),
                    ],
          
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SubQueryUpload(type:"sellin")));

                },
                child: Container(
                  width: double.infinity,
                  margin:const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child:const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Icon(Icons.person_search,size: 30,),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
          
                          Text("विकत पाहिजे",style: TextStyle(
                              fontWeight: FontWeight.bold,fontSize: 15
                          ),),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Need person for work on per day basis"),
          
                        ],
          
                      ),
                    ],
          
                  ),
                ),
              ),

            ],
          ),
        ),
      
      ),
    );
  }
}




//Rate Upload

class RateUpload extends StatefulWidget {
  const RateUpload({super.key});

  @override
  State<RateUpload> createState() => _RateUploadState();
}

class _RateUploadState extends State<RateUpload> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


//subquery Upload


class SubQueryUpload extends StatefulWidget {

  final String type;
  const SubQueryUpload({super.key, required this.type});

  @override
  State<SubQueryUpload> createState() => _SubQueryUploadState();
}

class _SubQueryUploadState extends State<SubQueryUpload> {

  //final String tp='${widget.type}';

  String? imageUrl1;
  File? fileImage1;

  ImagePicker picker1 = ImagePicker();

  bool isLoading1 = false;

  late String title,subtitle,des,money,address,rule,name,contact,whatsapp,image;

  late TextEditingController subtitle1;
  late TextEditingController des1;
  late TextEditingController money1;
  late TextEditingController address1;
  late  TextEditingController rule1;
  late TextEditingController name1;
  late TextEditingController contact1;
  late TextEditingController whatsapp1;





  @override
  void initState() {
    super.initState();
    subtitle1=TextEditingController();
    des1=TextEditingController();
    money1=TextEditingController();
    address1=TextEditingController();
    rule1=TextEditingController();
    name1=TextEditingController();
    contact1=TextEditingController();
    whatsapp1=TextEditingController();

    if (widget.type=="need") {
      title="कामासाठी व्यक्ती पाहिजे";
      subtitle= "तुम्हाला कोणत्या कामासाठी व्यक्ती पाहिजे ?";
      des="कामाचे वर्णन करा";
      money="रोज किती असेल ?";
      address="कामाच्या जागेचा पत्ता टाका";
      rule="काही नियम व अटी आहेत का ?";
      name="तुमचे नाव टाका";
      contact="तुमचा संपर्क टाका";
      whatsapp="तुमचा व्हॉट्सअँप नंबर टाका";
      image="तुम्हाला एखादा फोटो अपलोड करायचा आहे का ?";
    }else if(widget.type=="rentout"){
      title="किरायाने देणे आहे";
      subtitle= "तुम्हाला काय किरायाने द्यायचे आहे ?";
      des="काय किरायाणे द्यायचे आहे, त्याचे वर्णन करा";
      money="काय किरायाणे द्यायचे आहे, त्याचा किराया टाका";
      address="पत्ता टाका";
      rule="काही नियम व अटी आहेत का ?";
      name="तुमचे नाव टाका";
      contact="तुमचा संपर्क टाका";
      whatsapp="तुमचा व्हॉट्सअँप नंबर टाका";
      image="तुम्हाला एखादा फोटो अपलोड करायचा आहे का ?";
    }else if(widget.type=="rentin"){
      title="किरायाने पाहिजे आहे";
      subtitle= "तुम्हाला काय किरायाने पाहिजे आहे ?";
      des="काय किरायाणे पाहिजे आहे, त्याचे वर्णन करा";
      money="काय किरायाणे पाहिजे आहे, त्याचा किराया टाका";
      address="पत्ता टाका";
      rule="काही नियम व अटी आहेत का ?";
      name="तुमचे नाव टाका";
      contact="तुमचा संपर्क टाका";
      whatsapp="तुमचा व्हॉट्सअँप नंबर टाका";
      image="तुम्हाला एखादा फोटो अपलोड करायचा आहे का ?";
    }else if(widget.type=="sellout"){
      title="विकायचे आहे";
      subtitle= "तुम्हाला काय विकायचे आहे ?";
      des="काय विकायचे आहे, त्याचे वर्णन करा";
      money="काय विकायचे आहे, त्याची किंमत टाका";
      address="पत्ता टाका";
      rule="काही नियम व अटी आहेत का ?";
      name="तुमचे नाव टाका";
      contact="तुमचा संपर्क टाका";
      whatsapp="तुमचा व्हॉट्सअँप नंबर टाका";
      image="तुम्हाला एखादा फोटो अपलोड करायचा आहे का ?";
    } else{
      title="विकत पाहिजे आहे";
      subtitle= "तुम्हाला काय विकत पाहिजे आहे ?";
      des="काय विकत पाहिजे आहे, त्याचे वर्णन करा";
      money="काय विकत पाहिजे आहे, त्याची किंमत टाका";
      address="पत्ता टाका";
      rule="काही नियम व अटी आहेत का ?";
      name="तुमचे नाव टाका";
      contact="तुमचा संपर्क टाका";
      whatsapp="तुमचा व्हॉट्सअँप नंबर टाका";
      image="तुम्हाला एखादा फोटो अपलोड करायचा आहे का ?";
    };


  /*  if (widget.type=="need") {
      return const Text("तुम्हाला कोणत्या कामासाठी व्यक्ती पाहिजे ?");
    }else if(widget.type=="rentout"){
      return const Text("तुम्हाला काय किरायाने द्यायचे आहे ?");
    }else if(widget.type=="rentin"){
      return const Text("तुम्हाला काय किरायाने पाहिजे आहे ?");
    }else if(widget.type=="sellout"){
      return const Text("तुम्हाला काय विकायचे आहे ?");
    } else{
      return  const Text("तुम्हाला काय विकत घ्यायचे आहे ?");
    };*/
  }


  @override
  Widget build(BuildContext context) {
    return  SafeArea(

      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin:const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               const SizedBox(
                  height: 20,
                ),
                Text(title,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                const SizedBox(
                  height: 40,
                ),
                Text(subtitle),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: subtitle1,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: subtitle,
                    border: OutlineInputBorder(
                      borderSide:const BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(10),
          
                    ),
          
                  ),
          
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(des),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: des1,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: des,
                    border: OutlineInputBorder(
                      borderSide:const BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(10),
          
                    ),
          
                  ),
          
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(money),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: money1,
                  decoration: InputDecoration(
                    hintText: money,
                    border: OutlineInputBorder(
                      borderSide:const BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(10),
          
                    ),
          
                  ),
          
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(address),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: address1,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: address,
                    border: OutlineInputBorder(
                      borderSide:const BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(10),
          
                    ),
          
                  ),
          
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(rule),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: rule1,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: rule,
                    border: OutlineInputBorder(
                      borderSide:const BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(10),
          
                    ),
          
                  ),
          
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(name),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: name1,
                  decoration: InputDecoration(
                    hintText: name,
                    border: OutlineInputBorder(
                      borderSide:const BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(10),
          
                    ),
          
                  ),
          
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(contact),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: contact1,
                  decoration: InputDecoration(
                    hintText: contact,
                    border: OutlineInputBorder(
                      borderSide:const BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(10),

                    ),

                  ),

                ),
                const SizedBox(
                  height: 40,
                ),
                Text(whatsapp),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: whatsapp1,
                  decoration: InputDecoration(
                    hintText: whatsapp,
                    border: OutlineInputBorder(
                      borderSide:const BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(10),

                    ),

                  ),

                ),
                const SizedBox(
                  height: 50,
                ),
               const Text("तुम्हाला एखादा फोटो अपलोड करायचा आहे का ?"),
                const SizedBox(
                  height: 10,
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

                          fileImage1 == null
                              ? Image.asset(
                            'assets/images/upload_image.png',
                            height: 60,
                            width: 60,
                            alignment: Alignment.center,
                          )
                              : Image.file(
                            fileImage1!,
                            height: 150,
                            width: double.infinity,
                            alignment: Alignment.center,
                          ),
                          if (fileImage1 == null)
                            const SizedBox(
                              height: 10,
                            ),
                          if (fileImage1 == null) const Text("फोटो अपलोड करा"),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {

                      String subtitle11=subtitle1.text;
                      String des11=des1.text;
                      String money11=money1.text;
                      String address11=address1.text;
                      String rule11=rule1.text;
                      String name11=name1.text;
                      String contact11=contact1.text;
                      String whatsapp11=whatsapp1.text;

                      //timestamp
                      String currentime=DateTime.now().millisecondsSinceEpoch.toString();

                    /*  if (fileImage1 == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please Select Image")));
                        return;
                      } else if (subtitle11.isEmpty || des11.isEmpty || money11.isEmpty||address11.isEmpty||rule11.isEmpty||name11.isEmpty||contact11.isEmpty||whatsapp11.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Please Fill All Details")));
                        return;
                      }*/



                      setState(() {
                        isLoading1 = true;
                      });

                      try {
                        String ct =
                        DateTime.now().millisecondsSinceEpoch.toString();
                        Reference reff = await FirebaseStorage.instance
                            .ref()
                            .child("QueryImage")
                            .child('$ct.png');
                        await reff.putFile(fileImage1!);
                        imageUrl1 = await reff.getDownloadURL();

                        setState(() {});

                        final newRef = FirebaseFirestore.instance
                            .collection('QueryData')
                            .doc();
                        final newId = newRef.id;

                        await FirebaseFirestore.instance
                            .collection("QueryData")
                            .doc(newId)
                            .set({
                          "title":title,
                          "subtitle":subtitle11,
                          "des":des11,
                          "money":money11,
                          "address":address11,
                          "rule":rule11,
                          "name":name11,
                          "contact":contact11,
                          "whatsapp":whatsapp11,
                          "time":currentime,
                          "id": "$newId",
                          "post": imageUrl1.toString()
                        })
                            .then((value) => ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                            content: Text("Query Uploaded"))))
                            .then((value) {

                          fileImage1 = null;
                          Navigator.pop(context);
                        });
                      } catch (e) {
                        print('error is $e');
                      }

                      setState(() {
                        isLoading1 = false;
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
                    child: isLoading1 == true
                        ? const SpinKitCircle(color: Colors.white, size: 25)
                        : const Text(
                      "अपलोड करा",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
    final pickedFile = await picker1.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
          () {
            fileImage1 = File(pickedFile!.path);
      },
    );
  }
}