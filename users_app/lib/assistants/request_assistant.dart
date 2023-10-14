import 'dart:convert';

import 'package:http/http.dart' as http;

//this is for riversecoding for user current location latlangs to human readable ............

class RequestAssistant{
  static Future<dynamic> receiveRequest(String url) async
  {
  http.Response httpResponse = await http.get(Uri.parse(url));

  try{
     if(httpResponse.statusCode == 200) //successful response
    {
     String responseData = httpResponse.body; //json

      var decodeResponseData = jsonDecode(responseData);

      return decodeResponseData; 
    }
    else// not successful response
    {
      return "Error occured ,Faild. No Response";
    }
  }catch(exp){
      return "Error occured ,Faild. No Response";
  }

  }
}