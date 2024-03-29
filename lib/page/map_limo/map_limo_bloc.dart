// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_animarker/lat_lng_interpolation.dart';
// import 'package:flutter_animarker/models/lat_lng_info.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// // import 'package:location/location.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
// import 'package:trungchuyen/models/network/service/network_factory.dart';
// import 'package:trungchuyen/service/soket_io_service.dart';
// import 'package:trungchuyen/utils/const.dart';
// import 'map_limo_event.dart';
// import 'map_limo_state.dart';
// String latLngLocation;
// class MapLimoBloc extends Bloc<MapLimoEvent,MapLimoState> {
//   //SocketIOService socketIOService;
//
//
//   BuildContext context;
//   NetWorkFactory _networkFactory;
//   String _accessToken;
//   String get accessToken => _accessToken;
//   String _refreshToken;
//   String get refreshToken => _refreshToken;
//   SharedPreferences _prefs;
//   SharedPreferences get prefs => _prefs;
//   // PermissionStatus permissionGranted;
//   bool serviceEnabled;
//   String currentLocationLimo;
//   // StreamSubscription<LocationData> locationSubscription;
//   LatLngInterpolationStream latLngStream = LatLngInterpolationStream();
//   List<DetailTripsResponseBody> listOfCustomerTrips = new List<DetailTripsResponseBody>();
//
//   // Location location = new Location();
//   String markerID;
//
//   MapLimoBloc(this.context) {
//     _networkFactory = NetWorkFactory(context);
//   }
//
//   // TODO: implement initialState
//   MapLimoState get initialState => MapLimoInitial();
//
//
//   @override
//   Stream<MapLimoState> mapEventToState(MapLimoEvent event) async* {
//     // TODO: implement mapEventToState
//     if (_prefs == null) {
//       _prefs = await SharedPreferences.getInstance();
//       _accessToken = _prefs.getString(Const.ACCESS_TOKEN) ?? "";
//       _refreshToken = _prefs.getString(Const.REFRESH_TOKEN) ?? "";
//     }
//
//     if(event is OnlineEvent){
//       yield MapLimoInitial();
//       startListenChangeLocation();
//       yield OnlineSuccess();
//     }
//     if(event is OfflineEvent){
//       yield MapLimoInitial();
//       stopListenChangeLocation();
//       yield OfflineSuccess();
//     }
//
//     if(event is CheckPermissionLimoEvent){
//       yield MapLimoInitial();
//       checkPermission();
//       yield CheckPermissionLimoSuccess();
//     }
//
//     if(event is GetListCustomerLimo){
//       yield MapLimoLoading();
//       listOfCustomerTrips = event.listOfDetailTrips;
//       print(listOfCustomerTrips.length);
//       yield GetListCustomerLimoSuccess(listOfCustomerTrips);
//     }
//     if(event is UpdateStatusDriverLimoEvent){
//       yield MapLimoLoading();
//       MapLimoState state = _handleUpdateStatusDriver(await _networkFactory.updateStatusDriver(_accessToken, event.statusDriver));
//       yield state;
//     }
//     if(event is PushLocationOfLimoEvent){
//       yield MapLimoInitial();
//       SocketIOService socketIOService = Get.find();
//       if(socketIOService.socket.connected)
//       {
//         socketIOService.socket.emit("TAIXE_CAPNHAT_TOADO",event.location);
//         print('TAIXE_LIMO_CAPNHAT_TOADO => ${event.location.toString()}');
//       }
//       yield PushLocationOfLimoSuccess();
//     }
//     if(event is GetEvent){
//       yield MapLimoInitial();
//       // subscriptions.add(_latLngStream.getAnimatedPosition("DriverMarker"));
//       markerID = event.markerId;
//       yield GetEventStateSuccess();
//     }
//   }
//
//   startListenChangeLocation() async {
//     int countPush = 0;
//     // if (await checkPermission()) {
//     //   locationSubscription = location.onLocationChanged.listen((LocationData currentLocation) {
//     //
//     //     currentLocationLimo = currentLocation.latitude.toString() + "," + currentLocation.longitude.toString() ;
//     //     countPush++;
//     //     latLngStream.addLatLng(LatLngInfo(currentLocation.latitude, currentLocation.longitude, "DriverMarker"));
//     //     //add(GetCurrentLocationEvent(currentLocationTC));
//     //     currentLocations(currentLocationLimo);
//     //     // print(countPush);
//     //     if(countPush == 1){
//     //       countPush=0;
//     //       var obj = {
//     //         'lat':currentLocation.latitude,
//     //         'lng':currentLocation.longitude
//     //       };
//     //       add(PushLocationOfLimoEvent(json.encode(obj)));
//     //     }
//     //   });
//     // }
//   }
//
//   stopListenChangeLocation(){
//     // locationSubscription.cancel();
//     // if (socketIOService!=null && socketIOService.socket.connected){
//     //   socketIOService.socket.emit('driver_offline');
//     // }
//   }
//
//   currentLocations(String location){
//     latLngLocation = location;
//   }
//
//   MapLimoState _handleUpdateStatusDriver(Object data) {
//     if (data is String) return MapLimoFailure(data);
//     try {
//       return UpdateStatusDriverLimoState();
//     } catch (e) {
//       print(e.toString());
//       return MapLimoFailure(e.toString());
//     }
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