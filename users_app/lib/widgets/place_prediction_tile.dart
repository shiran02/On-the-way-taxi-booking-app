import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistants/request_assistant.dart';
import 'package:users_app/global/map_key.dart';
import 'package:users_app/models/directions.dart';
import 'package:users_app/models/predicted_places.dart';
import 'package:users_app/widgets/progress_dialog.dart';

import '../appConstants/app_colors.dart';
import '../infoHandler/app_info.dart';

class PlacePredictionTileDesign extends StatelessWidget {
  final PredictedPlaces? predictedPlaces;

  PlacePredictionTileDesign({this.predictedPlaces});

  getPlaceDirectionDetail(String? placeId  , context)async{

        showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
          message: ",Please wait.",
        ),
    );

    String placeDirectionDetail = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
  
    var responseApi = await RequestAssistant.receiveRequest(placeDirectionDetail);

    Navigator.pop(context);

    if(responseApi == "Error occured ,Faild. No Response"){
          return;
    }


    if(responseApi["status"] == "OK")
    {
      //  Directions directions = Directions();

      // directions.locationname = responseApi["result"]["name"];
      // directions.locationId = placeId;
      // directions.locationLatiude = responseApi["result"]["geometry"]["location"]["lat"];
      // directions.locationLongitude = responseApi["result"]["geometry"]["location"]["lng"];
        
      //   print("\nlocation name : " + directions.locationname!);
      //   print("\nlocation lat : " + directions.locationLatiude!.toString());
      //   print("\nlocation lng : " + directions.locationLongitude!.toString());

        Directions directions = Directions();
        directions.locationname = responseApi["result"]["name"];
        directions.locationId = placeId;
        
        double latitude = double.tryParse(responseApi["result"]["geometry"]["location"]["lat"].toString()) ?? 0.0;
        double longitude = double.tryParse(responseApi["result"]["geometry"]["location"]["lng"].toString()) ?? 0.0;

        directions.locationLatiude = latitude.toString(); // Convert double to string
        directions.locationLongitude = longitude.toString(); // Convert double to string

        print("\nlocation name: " + directions.locationname!);
        print("\nlocation lat: " + directions.locationLatiude!);
        print("\nlocation lng: " + directions.locationLongitude!);


        Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(directions);

        Navigator.pop(context, "obtainedDropoff");


    }



  
  
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: AppColors.blackColor),
          onPressed: () {
            getPlaceDirectionDetail(predictedPlaces!.place_id , context);
          },
          child: Row(
            children: [
              const Icon(
                Icons.add_location,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 14,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    predictedPlaces!.main_text!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    predictedPlaces!.secondary_text!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                ],
              )),
            ],
          )),
    );
  }
}
