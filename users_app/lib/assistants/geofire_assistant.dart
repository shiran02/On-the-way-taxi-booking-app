import 'package:users_app/models/active_nearby_acailable_drivers.dart';

class GeoFireAssistant
{

  static List<ActiveNearbyAvailableDrivers> activeNearbyAvailableDriversList =  [];

  static void deleteOffmileDriverFronList(String driverId){

    int indexNumber = activeNearbyAvailableDriversList.indexWhere((element) => element.driverId == driverId);
 
    activeNearbyAvailableDriversList.remove(indexNumber);
  }

  static void updateActiveNeatByAvailbleDriverLocation(ActiveNearbyAvailableDrivers driverWhoMove){
    int indexNumber = activeNearbyAvailableDriversList.indexWhere((element) => element.driverId == driverWhoMove);

    activeNearbyAvailableDriversList[indexNumber].locationLatiude = driverWhoMove.locationLatiude;
    activeNearbyAvailableDriversList[indexNumber].locationLongitude = driverWhoMove.locationLongitude;
  
  }
}