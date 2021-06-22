import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationService extends GetxService {
  Location location = new Location();
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;
  //SocketIOService socketIOService;

  StreamSubscription<LocationData> locationSubscription;
  @override
  void onInit() async {
    if (await checkPermission()) {}
    super.onInit();
  }

  @override
  void onClose() {
    locationSubscription.cancel();
    super.onClose();
  }

  startListenChangeLocation() async {
    print('abc');
    if (await checkPermission()) {
      locationSubscription = location.onLocationChanged.listen((LocationData currentLocation) {
        print('lat: ${currentLocation.latitude} - lng: ${currentLocation.longitude}');
        final location = {'lat': currentLocation.latitude, 'lng': currentLocation.longitude};

        //phải update location từ đây gooooo haha
        //cho này ăn rồi
        // try {
        //   if (socketIOService == null) socketIOService = Get.find();
        //   if (socketIOService.socket.connected) {
        //     socketIOService.socket.emit('update_location', {'location': location, 'driver': socketIOService.user, 'timeUpdate': DateTime.now().toString()});
        //   }
        // } catch (error) {
        //   print(error);
        // }
      });
    }
  }
  stopListenChangeLocation(){
    locationSubscription.cancel();
    // if (socketIOService!=null && socketIOService.socket.connected){
    //   socketIOService.socket.emit('driver_offline');
    // }
  }
  showDialog() {
    Get.dialog(
      CupertinoAlertDialog(
        title: Text('Please turn on Location to continue using this app'),
      ),
      barrierDismissible: false,
    );
  }

  Future<bool> checkPermission() async {
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted == PermissionStatus.granted) {
        serviceEnabled = await location.serviceEnabled();
        if (!serviceEnabled) {
          serviceEnabled = await location.requestService();
          if (serviceEnabled) {
            return true;
          }
        } else {
          return true;
        }
      }
    } else {
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (serviceEnabled) {
          return true;
        }
      } else {
        return true;
      }
    }
    return false;
  }
}
