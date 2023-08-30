import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/splashScreen/splash_screen.dart';

class MyDrawer extends StatefulWidget {
 // const MyDrawer({super.key});

  String? name;
  String? email;

  MyDrawer({String? this.name, String? this.email});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          //drawer header
          Container(
            height: 165,
            color: Colors.black,
            child:  DrawerHeader(
              child: Row(
                children: [
                const Icon(
                  Icons.person,
                  size: 70,
                  color: Colors.white,
                ),

                SizedBox(width: 16,),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text(
                      //"shiran",
                      widget.name.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                     const SizedBox(height:4,),

                    Text(
                      widget.email.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                
                  ],
                )
              ]),
            ),
          ),
          

          SizedBox(height: 12,),
          //drawer body

          GestureDetector(
            onTap: (){

            },
            child: ListTile(
              leading: Icon(
                Icons.history,
                color: Colors.black,
              ),
              title: Text(
                "Histort",
                style: TextStyle(
                  color: Colors.black
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){

            },
            child: ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.black,
              ),
              title: Text(
                "Visit Profile",
                style: TextStyle(
                  color: Colors.black
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){

            },
            child: ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.black,
              ),
              title: Text(
                "about",
                style: TextStyle(
                  color: Colors.black
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){
              fAuth.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (c)=>MySplashScreen()));
            },
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.black,
              ),
              title: Text(
                "Sign out",
                style: TextStyle(
                  color: Colors.black
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
