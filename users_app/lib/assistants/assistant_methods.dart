import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistants/request_assistant.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/infoHandler/app_info.dart';
import 'package:users_app/models/directions.dart';
import 'package:users_app/models/user_model.dart';
import '../models/direction_detail_info.dart';
import 'package:http/http.dart' as http;

class AssistantMethods{

  String mapKey = "AIzaSyCWVJSsMkbwzC8r7XhW62cycZMowkh-OKY";

  //this is for riversecoding for user current location latlangs to human readable ........................


  static Future<String> searchAddressForGeograpiCodinates(Position position , context)async{
    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyCWVJSsMkbwzC8r7XhW62cycZMowkh-OKY";
    String humanReadableAddress = "";

    //called receiveRequest method for get response body.......

    var requestresponse =  await RequestAssistant.receiveRequest(apiUrl);

    //............................................

    if(requestresponse !=  "Error occured ,Faild. No Response"){
      humanReadableAddress =requestresponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatiude = position.latitude.toString();
      userPickUpAddress.locationLongitude = position.longitude.toString();
      userPickUpAddress.locationname = humanReadableAddress;

      //update user pick up location using provider
      Provider.of<AppInfo>(context , listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }
    
    return humanReadableAddress;
  }



  //this is get user current user location ....................................................

  static void readCurrentUserOnLineUserInfo() async{

    currentFirebaseUer = fAuth.currentUser;

    DatabaseReference userRef = FirebaseDatabase.instance
    .ref()
    .child("users")
    .child(currentFirebaseUer!.uid);

    userRef.once().then((snap){

      if(snap.snapshot.value != null){
       userModelCurrentInfo =   UserModel.fromSnapshot(snap.snapshot);
       print("name" + userModelCurrentInfo!.name.toString());
       print("email" + userModelCurrentInfo!.email.toString());
      }
      
    });
  }

  //  pick up location to drop up location distance detail .....................................



  static Future<DirectionDetailInfo?> obtainOriginToDestinationDirectionDetail(LatLng originPosition , LatLng destinationPosition)async{

    String urlOriginToDestinationDirectionDetail = "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=AIzaSyCWVJSsMkbwzC8r7XhW62cycZMowkh-OKY";

    //get response from API 
    var responseDirectionApi =  await RequestAssistant.receiveRequest(urlOriginToDestinationDirectionDetail);
  
  
     if (responseDirectionApi == "Error occured ,Faild. No Response") {
        return null;
      }


      //this is accoding to the documentation  and using direction Model class

      DirectionDetailInfo directionDetailInfo = DirectionDetailInfo();
      directionDetailInfo.e_points = responseDirectionApi["routes"][0]["overview_polyline"]["points"];
      directionDetailInfo.distance_text = responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
      directionDetailInfo.distance_value = responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];
      directionDetailInfo.duration_text = responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
      directionDetailInfo.duration_value = responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];


      return directionDetailInfo;


  }

  // ......................................................................

  static double claculateFairAmountFromOriginoDestination(DirectionDetailInfo directionDetailInfo){

    double timeTraveledFareAmountPerMinutes = (directionDetailInfo.duration_value! / 60) * 0.1;
    double distanceTraveledFareAmountPerLilometer = (directionDetailInfo.duration_value! / 1000) * 0.1;
    double totalFaireAmount = timeTraveledFareAmountPerMinutes + distanceTraveledFareAmountPerLilometer;

    // 1 used = 120;
    double localCurrencyAmountTotalFare = totalFaireAmount * 120;
    return double.parse(localCurrencyAmountTotalFare.toStringAsFixed(2));
  }


  static sendNotificationToDriver(String deviceRegistationToken,String userRideRequestId , context)async{

    String destinationAddress = userDropAddress;

    Map<String,String> headerNotification = 
    {
      'Content-Type':'application/json',
      'Authorization':cloudMesagingServerToken,
    };

    Map<String , String> bodyNotification = 
    {
        "body":"Destination Address : \n $destinationAddress",
        "title":"new Trip Request"
    };

    Map dataMap = 
    {
      
          "click_action":"FLUTTER_NOTIFICATION_CLICK",
          "id":"1",
          "status":"done",
          "rideRequestId": userRideRequestId
      
    };

    Map officialNotificationFomat = 
    {
      "to":deviceRegistationToken,
      "notification": bodyNotification,
      "data":dataMap,
      "priority":'high'
    };

    var responseNotification = http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(officialNotificationFomat),
    );


  }



}