import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> isOnline() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  final result = connectivityResult.contains(ConnectivityResult.mobile) ||
      connectivityResult.contains(ConnectivityResult.wifi);

  return result;
}
