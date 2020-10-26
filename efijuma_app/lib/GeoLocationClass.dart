import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

//Position _currentPosition; //coordinates as LatLng
final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
/* //some Properties
double _currentPosition.latitude;
double _currentPosition.longitude; //localeIdentifier: string*/

Future<void> getPermissions() async {
  final PermissionHandler _permissionHandler = PermissionHandler();
  await _permissionHandler
      .requestPermissions([PermissionGroup.locationWhenInUse]);
}

Future<String> getCurrentLocation() async {
  Position a = await geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best);
  return "${a.latitude}, ${a.longitude}";
}

//Convert Latitude Longitude coordinates to An address in string
//ignore:missing_return
Future<String> getAddressFromLatLng(String input) async {
  String ans = "N/A";
  List<String> ls = input.split(",");
  if (ls.length != 2) return ans;

  try {
    //final doubleRegex = RegExp(r'\s+(\d+\.\d+)\s+', multiLine: true);
    //doubleRegex.allMatches(ls[0]).map((m) => m.group(0)).join(""));
    double lat = double.tryParse(ls[0]);

    double long = double.tryParse(ls[1]);
    List<Placemark> p =
        await geolocator.placemarkFromCoordinates(lat, long).catchError((err) {
      print(err);
    });
    Placemark place = p[0];

    ans =
        "${place.subLocality.toString() != "" ? (place.subLocality + ",") : ""} ${place.locality}";
    return ans;
    //redesigned to make more friendly
  } catch (e) {
    print("------ERROR:-----\ngetAddressFromLatLng() error: $e");
  }
}
