import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistants/request_assistant.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/infoHandler/app_info.dart';
import 'package:users_app/models/directions.dart';
import 'package:users_app/models/user_model.dart';

class AssistantMethods{


  static Future<String> searchAddressForGeograpiCodinates(Position position , context)async{
    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyCWVJSsMkbwzC8r7XhW62cycZMowkh-OKY";
    String humanReadableAddress = "";

    var requestresponse =  await RequestAssistant.receiveRequest(apiUrl);

    if(requestresponse !=  "Error occured ,Faild. No Response"){
      humanReadableAddress =requestresponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatiude = position.latitude.toString();
      userPickUpAddress.locationLongitude = position.longitude.toString();
      userPickUpAddress.locationname = humanReadableAddress;

      Provider.of<AppInfo>(context , listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }
    
    return humanReadableAddress;
  }





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


}