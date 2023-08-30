import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistants/assistant_methods.dart';
import 'package:users_app/authentication/login_screen.dart';
import 'package:users_app/infoHandler/app_info.dart';
import 'package:users_app/widgets/my_drawer.dart';

import '../appConstants/app_colors.dart';
import '../global/global.dart';
import '../splashScreen/splash_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  GoogleMapController? newGoogleMapController;

  Position? userCurentPosition;
  var geoLocater = Geolocator();

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



  checkIfLocationPermissionload() async{

    _locationPermission = await Geolocator.requestPermission();
    if(_locationPermission == LocationPermission.denied){
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
  localUserPosition() async
  {
    Position currentPosition =  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurentPosition = currentPosition;
  
  
    LatLng latingPosition = LatLng(userCurentPosition!.latitude,userCurentPosition!.longitude ); 
  
    CameraPosition cameraPosition = CameraPosition(target: latingPosition,zoom: 40);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =  await AssistantMethods.searchAddressForGeograpiCodinates(userCurentPosition! , context);
    print("this is your address" + humanReadableAddress);
  
   }

  @override
  void initState() {
    super.initState();
    checkIfLocationPermissionload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sKey,
      drawer: Container(
        //width: 350,
        child: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.black),
          child: MyDrawer(
            name: userModelCurrentInfo?.name,
            email: userModelCurrentInfo?.email,
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap , top: topPaddingOfMap),
            //mapType: MapType.hybrid,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
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
                sKey.currentState!.openDrawer();
              },
              child: const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.menu,
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
                    color: Colors.black87,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child:  Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    children: [
                      //from ---------------------------------------------------
                      Row(
                        children:  [
                          Icon(
                            Icons.add_location_alt_outlined,
                            color: Colors.white,
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
                                    color: Colors.white, fontSize: 12),
                              ),
                              Text( 
                                Provider.of<AppInfo>(context).userPickUpLocation != null
                                ? (Provider.of<AppInfo>(context).userPickUpLocation!.locationname!).substring(0,28)
                                : "Not Getting Address",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          )
                        ],
                      ),

                      SizedBox(height: 10),

                      Divider(
                        height: 2,
                        color: Colors.white,
                      ),

                      SizedBox(height: 10),
                      //to ..............................
                      Row(
                        children: [
                          Icon(
                            Icons.add_location_alt_outlined,
                            color: Colors.white,
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
                                    color: Colors.white, fontSize: 12),
                              ),
                              Text(
                                "Your dropped location",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          )
                        ],
                      ),

                      SizedBox(height: 10),

                      const Divider(
                        height: 2,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10),

                      ElevatedButton(
                          onPressed: () {
                            //  Navigator.push(context, MaterialPageRoute(builder: (c)=>const CarInfoScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                              primary: AppColors.greenColor),
                          child: const Text(
                            "Request a ride",
                            style: TextStyle(
                                color: AppColors.whiteColor, 
                                fontSize: 18),
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
}
