import 'dart:async';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistants/assistant_methods.dart';
import 'package:users_app/assistants/geofire_assistant.dart';
import 'package:users_app/authentication/login_screen.dart';
import 'package:users_app/infoHandler/app_info.dart';
import 'package:users_app/mainScreen/search_places_screen.dart';
import 'package:users_app/widgets/my_drawer.dart';

import '../appConstants/app_colors.dart';
import '../global/global.dart';
import '../models/active_nearby_acailable_drivers.dart';
import '../splashScreen/splash_screen.dart';
import '../widgets/progress_dialog.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  bool openNavigationDrawer = true;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  GoogleMapController? newGoogleMapController;

  Position? userCurentPosition;
  var geoLocater = Geolocator();

  List<LatLng> pLineCoOrdinatesList = [];
  Set<Polyline> polyLineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  String userName = "Your Name";
  String userEmail = "Your Email";

  bool activeNearByDriverKeyLoads = false;
  BitmapDescriptor? activeNearbyIcon;


  blackThemeGoogleMap() {
    newGoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
  }

  LocationPermission? _locationPermission;

  double bottomPaddingOfMap = 0;
  double topPaddingOfMap = 0;

  checkIfLocationPermissionload() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(8.576425, 81.2344952),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();

  double searchLocationContaimerHeight = 240;

  // get user current location
  localUserPosition() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurentPosition = currentPosition;

    LatLng latingPosition =
        LatLng(userCurentPosition!.latitude, userCurentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latingPosition, zoom: 10);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeograpiCodinates(
            userCurentPosition!, context);
    print("this is your address" + humanReadableAddress);

    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;

    initializeGeoFireListener();
  }

  @override
  void initState() {
    super.initState();
    checkIfLocationPermissionload();
  }

  @override
  Widget build(BuildContext context) {

    createActiveNearByDriverIconMarker();

    return Scaffold(
      key: sKey,
      drawer: Container(
        //width: 350,
        child: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.black),
          child: MyDrawer(
            name: userName,
            email: userEmail,
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(
                bottom: bottomPaddingOfMap, top: topPaddingOfMap),
            //mapType: MapType.hybrid,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            polylines: polyLineSet,
            markers: markersSet,
            circles: circlesSet,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              newGoogleMapController = controller;

              // for black theme google map
              //  newGoogleMapController!.setMapStyle(_mapStyle);
              blackThemeGoogleMap();

              setState(() {
                bottomPaddingOfMap = 275;
                topPaddingOfMap = 25;
              });

              localUserPosition();
            },
          ),

          //custom hamburger button for drawer
          Positioned(
            top: 46,
            left: 22,
            child: GestureDetector(
              onTap: () {

                if(openNavigationDrawer){
                  sKey.currentState!.openDrawer();
                }else{
                  //resraet - refresh-minimize app programatically
                  SystemNavigator.pop();
                }
              },
              child: CircleAvatar(
                backgroundColor: Color.fromARGB(191, 115, 104, 84),
                child: Icon(
                  openNavigationDrawer  ? Icons.menu : Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          //Ui for serching location

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSize(
              curve: Curves.easeIn,
              duration: Duration(microseconds: 120),
              child: Container(
                height: searchLocationContaimerHeight,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(191, 115, 104, 84),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    children: [
                      //from ---------------------------------------------------
                      Row(
                        children: [
                          Icon(
                            Icons.add_location_alt_outlined,
                            color: AppColors.fontColor,
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "From",
                                style: TextStyle(
                                    color: AppColors.whiteColor, fontSize: 12),
                              ),
                              Text(
                                Provider.of<AppInfo>(context)
                                            .userPickUpLocation !=
                                        null
                                    ? (Provider.of<AppInfo>(context)
                                            .userPickUpLocation!
                                            .locationname!)
                                        .substring(0, 28)
                                    : "Not Getting Address",
                                style: TextStyle(
                                    color: AppColors.whiteColor, fontSize: 14),
                              ),
                            ],
                          )
                        ],
                      ),

                      SizedBox(height: 10),

                      Divider(
                        height: 2,
                        color: AppColors.drawerblue,
                      ),

                      SizedBox(height: 10),
                      //to ..............................
                      GestureDetector(
                        onTap: () async {
                          var responseFromSearchCsreen = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => SearchPlacesScreen()));
                          print("taping");

                          if (responseFromSearchCsreen == "obtainedDropoff") {

                            setState(() {
                              openNavigationDrawer = false;
                            });

                            //draw route / draw polyline
                            await drawPolyLineFromOriginToDestination();
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_location_alt_outlined,
                              color: AppColors.fontColor,
                            ),
                            SizedBox(
                              width: 12.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "To",
                                  style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: 12),
                                ),
                                Text(
                                  Provider.of<AppInfo>(context)
                                              .userDropOffLocation !=
                                          null
                                      ? Provider.of<AppInfo>(context)
                                          .userDropOffLocation!
                                          .locationname!
                                      : "Where to go",
                                  style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: 14),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 10),

                      const Divider(
                        height: 2,
                        color: AppColors.drawerblue,
                      ),
                      const SizedBox(height: 10),

                      ElevatedButton(
                          onPressed: () {
                            //  Navigator.push(context, MaterialPageRoute(builder: (c)=>const CarInfoScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                              primary: AppColors.drawerblue),
                          child: const Text(
                            "Request a ride",
                            style: TextStyle(
                                color: AppColors.fontColor, fontSize: 18),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> drawPolyLineFromOriginToDestination() async {
    var originPosition =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    // var sourceLatlang = LatLng(sourcePosition!.locationLatiude!, sourcePosition!.locationLongitude!);
    // var destinationLatlang = LatLng(destinationPosition!.locationLatiude!, destinationPosition!.locationLongitude!);

    var originLatlang = LatLng(double.parse(originPosition!.locationLatiude!),
        double.parse(originPosition!.locationLongitude!));

    var destinationLatlang = LatLng(
        double.parse(destinationPosition!.locationLatiude!),
        double.parse(destinationPosition!.locationLongitude!));

    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: ",Please wait.",
      ),
    );

    var directionDetailsInfo =
        await AssistantMethods.obtainOriginToDestinationDirectionDetail(
            originLatlang, destinationLatlang);

    Navigator.pop(context);

    print("These are points = ");
    print(directionDetailsInfo!.e_points);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList =
        pPoints.decodePolyline(directionDetailsInfo!.e_points!);

    pLineCoOrdinatesList.clear();

    if (decodedPolyLinePointsResultList.isNotEmpty) {
      decodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoOrdinatesList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.white,
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoOrdinatesList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polyLineSet.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if (originLatlang.latitude > destinationLatlang.latitude &&
        originLatlang.longitude > destinationLatlang.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatlang, northeast: originLatlang);
    } else if (originLatlang.longitude > destinationLatlang.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatlang.latitude, destinationLatlang.longitude),
        northeast: LatLng(destinationLatlang.latitude, originLatlang.longitude),
      );
    } else if (originLatlang.latitude > originLatlang.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatlang.latitude, originLatlang.longitude),
        northeast: LatLng(originLatlang.latitude, destinationLatlang.longitude),
      );
    } else {
      boundsLatLng =
          LatLngBounds(southwest: originLatlang, northeast: destinationLatlang);
    }

    newGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      infoWindow:
          InfoWindow(title: originPosition.locationname, snippet: "Origin"),
      position: originLatlang,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(
          title: destinationPosition.locationname, snippet: "Destination"),
      position: destinationLatlang,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );

    setState(() {
      markersSet.add(originMarker);
      markersSet.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: const CircleId("originID"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatlang,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatlang,
    );

    setState(() {
      circlesSet.add(originCircle);
      circlesSet.add(destinationCircle);
    });
  }


  initializeGeoFireListener()
  {

    Geofire.initialize("activeDrivers");

    Geofire.queryAtLocation(userCurentPosition!.latitude, userCurentPosition!.longitude, 5)!.listen((map) {
        print(map);
        if (map != null) {
          var callBack = map['callBack'];

          //latitude will be retrieved from map['latitude']
          //longitude will be retrieved from map['longitude']

          switch (callBack) {
             //when any driver come active 
            case Geofire.onKeyEntered:    
              ActiveNearbyAvailableDrivers activeNearbyAvailableDriver = ActiveNearbyAvailableDrivers();
              activeNearbyAvailableDriver.locationLatiude = map['latitude'];
              activeNearbyAvailableDriver.locationLongitude = map['longitude'];
              activeNearbyAvailableDriver.driverId = map['key'];
              GeoFireAssistant.activeNearbyAvailableDriversList.add(activeNearbyAvailableDriver);
              if(activeNearByDriverKeyLoads == true){
                displaActiveDriversOnUsersMap();
              }
              break;

            //when any driver become offline 
            case Geofire.onKeyExited:   
              GeoFireAssistant.deleteOffmileDriverFronList(map['key']);
              break;

            //when driver move - siply update dirver location
            case Geofire.onKeyMoved:
              ActiveNearbyAvailableDrivers activeNearbyAvailableDriver = ActiveNearbyAvailableDrivers();
              activeNearbyAvailableDriver.locationLatiude = map['latitude'];
              activeNearbyAvailableDriver.locationLongitude = map['longitude'];
              activeNearbyAvailableDriver.driverId = map['key'];
              GeoFireAssistant.updateActiveNeatByAvailbleDriverLocation(activeNearbyAvailableDriver);
              break;
            
            //display the online / active drivers on use's map
            case Geofire.onGeoQueryReady:
              activeNearByDriverKeyLoads = true;
              displaActiveDriversOnUsersMap();
              break;
          }
        }

        setState(() {});



  });
}

    displaActiveDriversOnUsersMap()
    {
      setState(() {
        markersSet.clear();
        circlesSet.clear();

        Set<Marker> driversmarkersSet = Set<Marker>();

        for(ActiveNearbyAvailableDrivers eachDriver in GeoFireAssistant.activeNearbyAvailableDriversList){
          LatLng eachDriveractiveposition = LatLng(eachDriver.locationLatiude! ,eachDriver.locationLongitude!);
        
          Marker marker = Marker(
            markerId: MarkerId(eachDriver.driverId!),
            position: eachDriveractiveposition,
            icon: activeNearbyIcon!,
            rotation: 360,
          );

          driversmarkersSet.add(marker);

          setState(() {
            markersSet = driversmarkersSet;
          });
        
        }

        


      });
    }

    createActiveNearByDriverIconMarker(){
      if(activeNearbyIcon == null){
        ImageConfiguration imageConfiguration = createLocalImageConfiguration(context , size:const Size(2, 2));
        BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car.png").then((value){
          activeNearbyIcon = value;
        });
      }
    }

}
