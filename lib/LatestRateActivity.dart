import 'package:flutter/material.dart';





class LatestRateActivity extends StatefulWidget {
  const LatestRateActivity({super.key});

  @override
  State<LatestRateActivity> createState() => _LatestRateActivityState();
}

class _LatestRateActivityState extends State<LatestRateActivity> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: double.infinity,
              margin:const EdgeInsets.all(10),
              padding: const EdgeInsets.all(20),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text("आजचा प्रती क्विंटल कोसल्याचा भाव",style: TextStyle(
                      fontWeight: FontWeight.bold,fontSize: 15
                  ),),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const  Text("70,000₹",style: TextStyle(
                          fontWeight: FontWeight.bold,fontSize: 50
                      ),),
                      const SizedBox(
                        width: 20,
                      ),
                      Image.asset("assets/images/increase.png",height: 50,width: 50),
                    ],

                  ),
                 const SizedBox(
                    height: 10,
                  ),
                  const Text("काल पेक्षा आज भावात वाड झालेली आहे"),
                  const SizedBox(
                    height: 10,
                  ),
                 const Text("Need person for work on per day basis"),

                ],

              ),
            ),
           const Divider(
              height: 5,color: Colors.black12
            ),
            Container(
              width: double.infinity,
              margin:const EdgeInsets.all(10),
              padding: const EdgeInsets.all(20),
              child:const  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text("कालचा भाव",style: TextStyle(
                      fontWeight: FontWeight.bold,fontSize: 15
                  ),),
                  SizedBox(
                    height: 10,
                  ),
                  Text("70,000₹",style: TextStyle(
                      fontWeight: FontWeight.bold,fontSize: 30
                  ),),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Need person for work on per day basis"),

                ],

              ),
            ),
           const Divider(
              height: 5,color: Colors.black12
            ),
            Container(
              width: double.infinity,
              margin:const EdgeInsets.all(10),
              padding: const EdgeInsets.all(20),
              child:const  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text("परवा दिवशीचा भाव",style: TextStyle(
                      fontWeight: FontWeight.bold,fontSize: 15
                  ),),
                  SizedBox(
                    height: 10,
                  ),
                  Text("70,000₹",style: TextStyle(
                      fontWeight: FontWeight.bold,fontSize: 30
                  ),),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Need person for work on per day basis"),

                ],

              ),
            ),
            const Divider(
                height: 5,color: Colors.black12
            ),
      
            
          ],
      
        ),
      ),
    );
  }
}
