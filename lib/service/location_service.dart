// import 'dart:async';
// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_animarker/models/lat_lng_info.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// // import 'package:location/location.dart';
// import 'package:trungchuyen/page/main/main_bloc.dart';
// import 'package:trungchuyen/service/soket_io_service.dart';
// import 'package:trungchuyen/utils/log.dart';
//
// class LocationService extends GetxService {
//   // Location location = new Location();
//   bool serviceEnabled;
//   // PermissionStatus permissionGranted;
//   // LocationData locationData;
//   BuildContext context;
//   MainBloc _mainBloc;
//
//   SocketIOService socketIOService;
//
//   // StreamSubscription<LocationData> locationSubscription;
//   @override
//   void onInit() async {
//     try {
//       _mainBloc = BlocProvider.of<MainBloc>(context);
//     } catch (e) {
//       logger.e(e);
//     }
//     if (await checkPermission()) {}
//     super.onInit();
//   }
//
//   @override
//   void onClose() {
//     // locationSubscription.cancel();
//     super.onClose();
//   }
//
//   startListenChangeLocation() async {
//     print('abc');
//     // if (await checkPermission()) {
//     //   locationSubscription = location.onLocationChanged.listen((LocationData currentLocation) {
//     //     print('lat: ${currentLocation.latitude} - lng: ${currentLocation.longitude}');
//     //     final location = {'lat': currentLocation.latitude, 'lng': currentLocation.longitude};
//     //
//     //     if(_mainBloc == null){
//     //       _mainBloc = BlocProvider.of<MainBloc>(Get.context);
//     //     }
//     //     else  {
//     //      // _mainBloc.latLngStream.addLatLng(LatLngInfo(currentLocation.latitude, currentLocation.longitude, "DriverMarker"));
//     //     }
//     //
//     //     //phải update location từ đây gooooo haha
//     //     // takecare@1Qaz2Wsx3Edc
//     //     // takecare@1Qaz2Wsx3Edc
//     //     // try {
//     //     //   if (socketIOService == null) socketIOService = Get.find();
//     //     //   if (socketIOService.socket.connected) {
//     //     //     socketIOService.socket.emit('update_location', {'location': location, 'driver': socketIOService.user, 'timeUpdate': DateTime.now().toString()});
//     //     //   }
//     //     // } catch (error) {
//     //     //   print(error);
//     //     // }
//     //   });
//     // }
//   }
//   stopListenChangeLocation(){
//     // locationSubscription.cancel();
//     // if (socketIOService!=null && socketIOService.socket.connected){
//     //   socketIOService.socket.emit('driver_offline');
//     // }
//   }
//   showDialog() {
//     Get.dialog(
//       CupertinoAlertDialog(
//         title: Text('Please turn on Location to continue using this app'),
//       ),
//       barrierDismissible: false,
//     );
//   }
//
//   Future<bool> checkPermission() async {
//     // permissionGranted = await location.hasPermission();
//     // if (permissionGranted == PermissionStatus.denied) {
//     //   permissionGranted = await location.requestPermission();
//     //   if (permissionGranted == PermissionStatus.granted) {
//     //     serviceEnabled = await location.serviceEnabled();
//     //     if (!serviceEnabled) {
//     //       serviceEnabled = await location.requestService();
//     //       if (serviceEnabled) {
//     //         return true;
//     //       }
//     //     } else {
//     //       return true;
//     //     }
//     //   }
//     // } else {
//     //   serviceEnabled = await location.serviceEnabled();
//     //   if (!serviceEnabled) {
//     //     serviceEnabled = await location.requestService();
//     //     if (serviceEnabled) {
//     //       return true;
//     //     }
//     //   } else {
//     //     return true;
//     //   }
//     // }
//     return false;
//   }
// }
