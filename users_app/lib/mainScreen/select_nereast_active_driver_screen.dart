import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:users_app/appConstants/app_colors.dart';
import 'package:users_app/assistants/assistant_methods.dart';
import 'package:users_app/global/global.dart';

class SelectNearestActiveDriversScreen extends StatefulWidget {

  DatabaseReference? referenceRideRequest;

  SelectNearestActiveDriversScreen({this.referenceRideRequest});

  @override
  State<SelectNearestActiveDriversScreen> createState() =>
      _SelectNearestActiveDriversScreenState();
}

class _SelectNearestActiveDriversScreenState
    extends State<SelectNearestActiveDriversScreen> {

  String fareAmount = "";

  getFareAmountAccordingToVehicalType(int index){
    if(tripDirectionDetailInfo != null){
      if(dList[index]["car_detail"]["type"].toString() == "bike"){
        fareAmount = (AssistantMethods.claculateFairAmountFromOriginoDestination(tripDirectionDetailInfo!)/2).toString(); 
      }
      if(dList[index]["car_detail"]["type"].toString() == "uber-x"){  // this for three wheel
        fareAmount = (AssistantMethods.claculateFairAmountFromOriginoDestination(tripDirectionDetailInfo!)/2).toString(); 
      }
      if(dList[index]["car_detail"]["type"].toString() == "uber-go"){  //this for three car
        fareAmount = (AssistantMethods.claculateFairAmountFromOriginoDestination(tripDirectionDetailInfo!)).toString(); 
      }
    }

    return fareAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.orange.shade600,       
        title: const Text(
          "Nearest Online Drivers",
          style: TextStyle(fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () {
            //delete he ride requestfrom data base
            Fluttertoast.showToast(msg: "you have canclled the ride request");
            widget.referenceRideRequest!.remove();
            SystemNavigator.pop();
          },
        ),
      ),
      body: ListView.builder(
        itemCount: dList.length,
        itemBuilder: (context, index) {

          return GestureDetector(
            onTap: (){
             setState(() {
               choosendriverId =  dList[index]["id"].toString(); 
             });

            Navigator.pop(context,"driverChoosed");

            },
            child: Card(
              color: AppColors.yellowColor,
              elevation: 3,
              shadowColor: Colors.green,
              margin: EdgeInsets.all(8),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Image.asset(
                    "images/" + dList[index]["car_detail"]["type"].toString() + ".png",
                    width: 70,
                  ),
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      dList[index]["name"],
                      style: const TextStyle(fontSize: 14, color: AppColors.darkGreen ,fontWeight: FontWeight.bold),
                    ),
                    Text(
                      dList[index]["car_detail"]["car_model"],
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
          
                    SmoothStarRating(
                      rating: 3.5,
                      color: Colors.red,
                      borderColor: Colors.black,
                      allowHalfRating: true,
                      starCount: 5,
                      size: 15,
                    ),
                    
                  ],
                ),
          
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Rs. " + getFareAmountAccordingToVehicalType(index),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 1,),
                    Text(
                      tripDirectionDetailInfo !=  null ? tripDirectionDetailInfo!.duration_text! : "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        fontSize: 12
                      ),
                    ),
                    const SizedBox(height: 2,),
                    Text(
                      tripDirectionDetailInfo !=  null ? tripDirectionDetailInfo!.distance_text! : "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        fontSize: 10
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
