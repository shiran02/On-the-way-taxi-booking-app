
import 'package:firebase_auth/firebase_auth.dart';

import '../models/direction_detail_info.dart';
import '../models/user_model.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUer ;
UserModel? userModelCurrentInfo;
List dList = []; //driversKey info List
DirectionDetailInfo? tripDirectionDetailInfo;
String? choosendriverId = "";
String cloudMesagingServerToken = "key=AAAAsCX5LDY:APA91bGV5Qaupvb9m6ZA7MM1-X32NheLwWORrzCL8NVn3WDcb7RZ1xTI_UX1x1ed0z6GdDVQ-L6cwWBOFAk4n7X4jS0wclqA32dTgzExLP0OgarmC8_ubfzlxITfsTB0BTqVIBBe8Lud";
String userDropAddress = "";