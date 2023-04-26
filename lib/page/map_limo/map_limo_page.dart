// import 'dart:async';
//
// import 'package:animator/animator.dart';
// import 'package:async/async.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animarker/lat_lng_interpolation.dart';
// import 'package:flutter_animarker/models/lat_lng_delta.dart';
// import 'package:flutter_animarker/models/lat_lng_info.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_controller/google_maps_controller.dart';
// // import 'package:location/location.dart';
//
// import 'package:trungchuyen/page/main/main_bloc.dart';
// import 'package:trungchuyen/page/map_limo/map_limo_bloc.dart';
// import 'package:trungchuyen/service/soket_io_service.dart';
// import 'package:trungchuyen/utils/marker_icon.dart';
// import 'package:trungchuyen/utils/utils.dart';
//
//
// import 'map_limo_event.dart';
// import 'map_limo_state.dart';
//
//
//
// class MapLimoPage extends StatefulWidget {
//
//   MapLimoPage({Key key}) : super(key: key);
//
//   @override
//   MapLimoPageState createState() => MapLimoPageState();
// }
// /// đây là map limo
// class MapLimoPageState extends State<MapLimoPage> {
//   final scrollController = ScrollController();
//   bool isOnline = false;
//   bool isInProcessPickup = false;
//   MainBloc _mainBloc;
//   MapLimoBloc _mapLimoBloc;
//
//   Set<Marker> markers = new Set();
//
//   LatLngInterpolationStream latLngStream = LatLngInterpolationStream();
//   List<String> lsMarkerId = [];
//   // cái này này để samg bloc
//   // lấy cái
//   StreamGroup<LatLngDelta> subscriptions = StreamGroup<LatLngDelta>();
//   var scaffoldKey = new GlobalKey<ScaffoldState>();
//   SocketIOService socketIOService;
//   GlobalKey keyMap;
//   bool clearMarker = false;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _mapLimoBloc = MapLimoBloc(context);
//     _mainBloc = BlocProvider.of<MainBloc>(context);
//     _mapLimoBloc.add(CheckPermissionLimoEvent());
//
//   }
//
//   Timer _timer;
//   int _start = 5;
//
//   void startTimer() {
//     clearMarker = true;
//     const oneSec = const Duration(seconds: 5);
//     _timer = new Timer.periodic(
//       oneSec,
//           (Timer timer) {
//         if (_start == 0) {
//           setState(() {
//             mapController.clearMarkers();
//             clearMarker = false;
//             timer.cancel();
//           });
//         } else {
//           setState(() {
//             _start--;
//             print('ACD ${_start}');
//           });
//         }
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
//
//   moveCameraPosition(LatLng position){
//     // CameraPosition cameraPosition = new CameraPosition(
//     //     target: LatLng(position.latitude,position.longitude),
//     //     zoom: 14.4746,
//     // );
//     mapController.moveCamera(CameraUpdate.newLatLng(position));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<MapLimoBloc,MapLimoState>(
//       bloc: _mapLimoBloc,
//       listener:  (context, state){
//         if(state is GetListCustomerLimoSuccess){
//
//         }else if(state is GetEventStateSuccess){
//           print('RELOAD AGAIN1');
//         }else if(state is CheckPermissionLimoSuccess){
//           // subscriptions.add(_mapLimoBloc.latLngStream.getAnimatedPosition("DriverMarker"));
//           // subscriptions.stream.listen((LatLngDelta delta) {
//           //   moveCameraPosition(LatLng(delta.from.latitude, delta.from.longitude));
//           // });
//         }else if(state is OnlineSuccess){
//           socketIOService = Get.find<SocketIOService>();
//           socketIOService.socket.on("TAIXE_CAPNHAT_TOADO", (data){
//             _start = 5;
//             if(clearMarker == false){
//               startTimer();
//             }
//             String item = data['LOCATION'];
//             String _location = item.replaceAll('{', '').replaceAll('}', '').replaceAll("\"","").replaceAll('lat', '').replaceAll('lng', '').replaceAll(':', '');
//             String makerId = data['PHONE'];
//             latLngStream.addLatLng(new LatLngInfo(double.parse( _location.split(',')[0]), double.parse( _location.split(',')[1]),makerId));
//             setState(() {
//               if(lsMarkerId.where((id) => id==makerId).length==0){
//                 lsMarkerId.add(makerId);
//                 subscriptions.add(latLngStream.getAnimatedPosition(makerId));
//                 subscriptions.stream.listen((LatLngDelta delta) {
//                   drawMyLocation(LatLng(delta.from.latitude, delta.from.longitude), delta.rotation,delta.markerId,data['FULLNAME'],data['PHONE']);
//                 });
//               }
//             });
//             // timer.isActive;
//             print('TAIXE_CAPNHAT_TOADO => ${data.toString()}');
//           });
//         }
//       },
//       child: BlocBuilder<MapLimoBloc,MapLimoState>(
//         bloc: _mapLimoBloc,
//         builder: (BuildContext context, MapLimoState state) {
//           return Scaffold(
//             appBar: AppBar(
//               backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//               automaticallyImplyLeading: false,
//               title: !isOnline ?  InkWell(
//                 //onTap: ()=>_mainBloc.firebaseMessaging.deleteInstanceID(),
//                 child: Text(
//                   'OffLine',
//                   style: Theme.of(context).textTheme.title.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: Theme.of(context).textTheme.title.color,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               )
//                   :
//               Text(
//                 'Online',
//                 style: Theme.of(context).textTheme.title.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).textTheme.title.color,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               centerTitle: true,
//               actions: [
//                 Container(
//                   padding: EdgeInsets.only(right: 10),
//                   alignment: Alignment.centerRight,
//                   child: Switch(
//                     activeColor: Colors.orange,
//                     hoverColor: Colors.orange,
//                     value: isOnline,
//                     onChanged: (bool value) {
//                       changeOnline();
//                       setState(() {
//                         if(value == true){
//                           // _mainBloc.add(UpdateStatusDriverEvent(1));
//                           if(_mainBloc.socketIOService.socket.disconnected)
//                           {
//                             _mainBloc.socketIOService.socket.connect();
//                             print('connected');
//                           }
//                         }else{
//                           if(_mainBloc.socketIOService.socket.connected)
//                           {
//                             _mainBloc.socketIOService.socket.disconnect();
//                             print('Disconnected');
//                           }
//                           // _mainBloc.add(UpdateStatusDriverEvent(0));
//                         }
//                         isOnline = value;
//                         isInProcessPickup = true;
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             body: buildPage(context, state)
//           );
//         },
//       ),
//     );
//   }
//
//   Widget buildPage(BuildContext context,MapLimoState state){
//     return Stack(
//       children: [
//         Container(
//           color: Theme.of(context).scaffoldBackgroundColor,
//           child: Scaffold(
//               key: scaffoldKey,
//               body: googleMap()
//           ),
//         ),
//         isOnline ==false? offLineMode() : Container(),
//         Visibility(
//           visible: state is MapLimoLoading,
//           child: Center(
//             child: CircularProgressIndicator(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   GoogleMapsController mapController = GoogleMapsController(
//
//     initialCameraPosition: CameraPosition(
//       target: LatLng(21.0003347, 105.8233759),
//       zoom: 14.4746,
//     ),
//     compassEnabled: true,
//     myLocationEnabled: true,
//     myLocationButtonEnabled: false,
//     zoomControlsEnabled: false,
//     //rotateGesturesEnabled: true,
//   );
//
//   void newMarker(LatLng position,double alpha,String markerId ,String userName, String phoneNumber)async {
//     var iconCar = await getBitmapDescriptorFromAssetBytes('assets/images/carMarker.png', 50);
//     final Marker marker = Marker(
//         infoWindow: InfoWindow(
//             title: userName,
//             snippet: phoneNumber
//         ),
//         markerId: MarkerId(markerId),
//         position: position,
//         icon: iconCar,
//         anchor: Offset(0.5, 0.5),
//         rotation: alpha);
//     setState(() {
//       markers.add(marker);
//     });
//   }
//
//   Widget googleMap() {
//     return// GoogleMap(
//
//     //   onMapCreated: (GoogleMapController controller) {
//     //     //mapController = controller;
//     //   },
//     //   initialCameraPosition: CameraPosition(
//     //     target: const LatLng(21.0003347, 105.8233759),
//     //     zoom: 14.4746,
//     //   ),
//     //   myLocationButtonEnabled: true,
//     //   myLocationEnabled: true,
//     //   compassEnabled: true,
//     //   markers: Set<Marker>.of(markers),
//     // );
//
//       GoogleMaps(controller: mapController);
//   }
//
//   changeOnline() {
//     try {
//       isOnline = !isOnline;
//       if (isOnline) {
//         _mapLimoBloc.add(OnlineEvent());
//       } else {
//         _mapLimoBloc.add(OfflineEvent());
//       }
//     } catch (error) {
//       print(error);
//     }
//   }
//
//   drawMyLocation(LatLng position, double alpha, String markerId,String userName, String phoneNumber) async {
//
//     var iconCar = await getBitmapDescriptorFromAssetBytes('assets/images/carMarker.png', 50);
//
//     print('LengthABCCC123');
//     mapController.addMarker(Marker(
//         infoWindow: InfoWindow(
//           title: userName,
//           snippet: phoneNumber
//         ),
//         markerId: MarkerId(markerId),
//         position: position,
//         icon: iconCar,
//         anchor: Offset(0.5, 0.5),
//         rotation: alpha),
//     );
//   }
//
//   Widget offLineMode() {
//     return Animator(
//       duration: Duration(milliseconds: 400),
//       cycles: 1,
//       builder: (anim) => SizeTransition(
//         sizeFactor: anim,
//         axis: Axis.horizontal,
//         child: Container(
//           height: AppBar().preferredSize.height,
//           color: Colors.orange,
//           child: Padding(
//             padding: const EdgeInsets.only(right: 14, left: 14),
//             child: Row(
//               children: <Widget>[
//                 DottedBorder(
//                   color: Colors.white,
//                   borderType: BorderType.Circle,
//                   strokeWidth: 2,
//                   child: Padding(
//                     padding: const EdgeInsets.all(4),
//                     child: Icon(
//                       FontAwesomeIcons.cloudMoon,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 16,
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       'Bạn đang offline !',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Text(
//                       'Bật online để bắt đầu nhận việc.',
//                       style: TextStyle(
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
