
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:users_app/assistants/request_assistant.dart';
import 'package:users_app/models/predicted_places.dart';
import 'package:users_app/widgets/place_prediction_tile.dart';

class SearchPlacesScreen extends StatefulWidget {
  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {

  String mapKey = "AIzaSyCWVJSsMkbwzC8r7XhW62cycZMowkh-OKY";


  List<PredictedPlaces> placePredictedList = [];


  void findPlacesAutoCompleteSearch(String inputText) async{

    if(inputText.length > 1){

      //String encodedInputText = Uri.encodeQueryComponent(inputText);
      String urlAutoCompleteSearch = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:LK";

      var responseAutoCompleteSearch = await RequestAssistant.receiveRequest(urlAutoCompleteSearch);
    
      if(responseAutoCompleteSearch == "Error occured ,Faild. No Response"){
          return;
      }

      if(responseAutoCompleteSearch["status"] == "OK")
      {
       var placePrediction =  responseAutoCompleteSearch["predictions"];

       var placePredictionList = (placePrediction as List).map((jsonData) => PredictedPlaces.fromJson(jsonData)).toList();
     
        setState(() {
          placePredictedList =  placePredictionList;
        });
        
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [

          Container(
            height: 210,
            decoration: BoxDecoration(color: Colors.black54, boxShadow: [
              BoxShadow(
                  color: Colors.white, blurRadius: 5, offset: Offset(0.7, 0.5)),
            ]),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.grey,
                        ),
                      ),
                      Center(
                        child: Text(
                          "Search & set dropped Location",
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
            
                  Row(
                    children: [
            
                      const Icon(
                        Icons.adjust_sharp,
                        color: Colors.grey,
                      ),
            
                      SizedBox(width: 10,),
            
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (valueType){
                              findPlacesAutoCompleteSearch(valueType);
                            },
                            decoration: InputDecoration(
                              hintText: "Search here",
                              fillColor: Colors.grey,
                              filled: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                left: 11.0,
                                top: 8.0,
                                bottom: 8.0
                              )
                            ),
                          ),
                        ),
                      )
            
                    ],
                  ),
                ],
              ),
            ),
          ),


  //display place prediction result

  (placePredictedList.length > 0) 
    ? Expanded(child: ListView.separated(
      physics: ClampingScrollPhysics(),

      separatorBuilder: (BuildContext context , int index){
        return Divider(
          height: 1,
          color: Colors.grey,
          thickness: 1,
        );
      },
      itemBuilder: (context , index){
        return PlacePredictionTileDesign(
          predictedPlaces:  placePredictedList[index],
        );
      },
      itemCount: placePredictedList.length)
      )
        : Container()
,
        ],
      ),
    );
  }
}
