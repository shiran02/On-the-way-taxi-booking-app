
import 'package:firebase_auth/firebase_auth.dart';

import '../models/direction_detail_info.dart';
import '../models/user_model.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUer ;
UserModel? userModelCurrentInfo;
List dList = []; //driversKey info List
DirectionDetailInfo? tripDirectionDetailInfo;
String? choosendriverId = "";