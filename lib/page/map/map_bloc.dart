// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_animarker/lat_lng_interpolation.dart';
// import 'package:flutter_animarker/models/lat_lng_info.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_controller/google_maps_controller.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:trungchuyen/models/database/dbhelper.dart';
// import 'package:trungchuyen/models/entity/customer.dart';
// import 'package:trungchuyen/models/network/request/tranfer_customer_request.dart';
// import 'package:trungchuyen/models/network/request/update_status_customer_request.dart';
// import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
// import 'package:trungchuyen/models/network/response/polyline_result_response.dart';
// import 'package:trungchuyen/models/network/service/network_factory.dart';
// import 'package:trungchuyen/page/main/main_bloc.dart';
// import 'package:trungchuyen/page/main/main_event.dart';
// import 'package:trungchuyen/service/soket_io_service.dart';
// import 'package:trungchuyen/utils/const.dart';
// import 'package:trungchuyen/utils/utils.dart';
// import 'map_event.dart';
// // import 'package:location/location.dart';
// import 'dart:async';
// import 'map_state.dart';
//
// String latLngLocation;
// class MapBloc extends Bloc<MapEvent,MapState> {
//
//   MainBloc _mainBloc;
//   MainBloc get mainBloc => _mainBloc;
//   BuildContext context;
//   NetWorkFactory _networkFactory;
//   String _accessToken;
//   String get accessToken => _accessToken;
//   String _refreshToken;
//   String get refreshToken => _refreshToken;
//   SharedPreferences _prefs;
//   SharedPreferences get prefs => _prefs;
//   SocketIOService socketIOService;
//  // List<DetailTripsResponseBody> listDetailTripsCustomer = new List<DetailTripsResponseBody>();
//
//   ///
//   //List<DetailTripsResponseBody> listCustomers = new List<DetailTripsResponseBody>();
//   // Location location = new Location();
//   bool serviceEnabled;
//   String currentLocationTC;
//   // PermissionStatus permissionGranted;
//   // LocationData locationData;
//   // StreamSubscription<LocationData> locationSubscription;
//   LatLngInterpolationStream latLngStream = LatLngInterpolationStream();
//   PolylineResultResponseBody polylineResultResponseBody;
//   String _nameLXTC;
//   String _sdtLXTC;
//   final db = DatabaseHelper();
//   String test1 = 'O';
//   String idUser;
//   List<Customer> listTaiXeLimos = new List<Customer>();
//
//   MapBloc(this.context)  {
//     _networkFactory = NetWorkFactory(context);
//     socketIOService = Get.find<SocketIOService>();
//   }
//
//   // TODO: implement initialState
//   MapState get initialState => MapInitial();
//
//   @override
//   Stream<MapState> mapEventToState(MapEvent event) async* {
//     // TODO: implement mapEventToState
//     if (_prefs == null) {
//       _prefs = await SharedPreferences.getInstance();
//       _accessToken = _prefs.getString(Const.ACCESS_TOKEN) ?? "";
//       _refreshToken = _prefs.getString(Const.REFRESH_TOKEN) ?? "";
//       _nameLXTC = _prefs.getString(Const.FULL_NAME) ?? "";
//       _sdtLXTC = _prefs.getString(Const.PHONE_NUMBER) ?? "";
//       idUser = _prefs.getString(Const.USER_ID) ??'';
//     }
//
//     if(event is UpdateTaiXeLimos){
//       yield MapInitial();
//       Customer customer = new Customer(
//         idTrungChuyen: event.customer.idTrungChuyen,
//         idTaiXeLimousine : event.customer.idTaiXeLimousine,
//         hoTenTaiXeLimousine : event.customer.hoTenTaiXeLimousine,
//         dienThoaiTaiXeLimousine : event.customer.dienThoaiTaiXeLimousine,
//         tenXeLimousine : event.customer.tenXeLimousine,
//         bienSoXeLimousine : event.customer.bienSoXeLimousine,
//         tenKhachHang : event.customer.tenKhachHang,
//         soDienThoaiKhach :event.customer.soDienThoaiKhach,
//         diaChiKhachDi :event.customer.diaChiKhachDi,
//         toaDoDiaChiKhachDi:event.customer.toaDoDiaChiKhachDi,
//         diaChiKhachDen:event.customer.diaChiKhachDen,
//         toaDoDiaChiKhachDen:event.customer.toaDoDiaChiKhachDen,
//         diaChiLimoDi:event.customer.diaChiLimoDi,
//         toaDoLimoDi:event.customer.toaDoLimoDi,
//         diaChiLimoDen:event.customer.diaChiLimoDen,
//         toaDoLimoDen:event.customer.toaDoLimoDen,
//         loaiKhach:event.customer.loaiKhach,
//         trangThaiTC: event.customer.trangThaiTC,
//         soKhach:event.customer.soKhach,
//         chuyen: _mainBloc.trips,
//         totalCustomer: event.customer.totalCustomer,
//         idKhungGio: event.customer.idKhungGio,
//         idVanPhong: event.customer.idVanPhong,
//         ngayTC: event.customer.ngayTC,
//       );
//       await db.addDriverLimo(customer);
//       listTaiXeLimos = await getListTXLimoFromDb();
//       yield GetListTaiXeLimosSuccess();
//     }
//
//     if(event is GetListTaiXeLimos){
//       yield MapLoading();
//       listTaiXeLimos = await getListTXLimoFromDb();
//       if (Utils.isEmpty(listTaiXeLimos)) {
//         yield GetListTaiXeLimosSuccess();
//         return;
//       }
//       yield GetListTaiXeLimosSuccess();
//     }
//
//     if(event is UpdateStatusDriverEvent){
//       yield MapLoading();
//       if(event.statusDriver == 0){
//         if(socketIOService.socket.connected)
//         {
//           socketIOService.socket.disconnect();
//           print('Disconnected');
//         }
//       }else if(event.statusDriver == 1){
//         if(socketIOService.socket.disconnected)
//         {
//           socketIOService.socket.connect();
//           print('connected');
//         }
//       }
//       yield UpdateStatusDriverState();
//     }
//     if(event is CheckPermissionEvent){
//       yield MapInitial();
//       checkPermission();
//       yield CheckPermissionSuccess();
//     }
//     if(event is OnlineEvent){
//       yield MapInitial();
//       startListenChangeLocation();
//       yield OnlineSuccess();
//     }
//     if(event is OfflineEvent){
//       yield MapInitial();
//       stopListenChangeLocation();
//       yield OfflineSuccess();
//     }
//     if(event is PushLocationToLimoEvent){
//       yield MapInitial();
//       SocketIOService socketIOService = Get.find();
//       if(socketIOService.socket.connected)
//         {
//           socketIOService.socket.emit("TAIXE_CAPNHAT_TOADO",event.location);
//         }
//       yield PushLocationToLimoSuccess();
//     }
//     if(event is GetListLocationPolylineEvent){
//       yield MapLoading();
//       String _location = event.customerLocation.replaceAll('{', '').replaceAll('}', '').replaceAll("\"","").replaceAll('lat', '').replaceAll('lng', '').replaceAll(':', '');
//       MapState state = _handleGetListLocationPolyline(await _networkFactory.getListLocationPolyline(_accessToken,latLngLocation,_location));
//       yield state;
//     }
//     if(event is CustomerTransferToLimo){
//         yield MapLoading();
//         List<String> listIdTXLimo = new List<String>();
//         List<String> listKhach = new List<String>();
//         List<String> listIdTC = new List<String>();
//         String numberCustomer;
//         String idTC;
//         List<Customer> listTaiXeTC = event.listTaiXeTC;
//         listTaiXeTC.forEach((element) {
//           listIdTXLimo.add(element.idTaiXeLimousine);/// a | a |
//           listKhach.add(element.soKhach.toString());
//           listIdTC.add(element.idTrungChuyen);
//         });
//         numberCustomer = listKhach.join('|');
//         idTC  = listIdTC.join(',');
//
//         var objData = {
//           'EVENT':'TAIXE_TRUNGCHUYEN_GIAOKHACH_LIMO',
//           'numberCustomer' : numberCustomer,
//         };
//         TranferCustomerRequestBody request = TranferCustomerRequestBody(
//           title: event.title,
//           body: 'Bạn nhận được $numberCustomer khách từ LXTC $_nameLXTC.',
//           data:objData,
//           idTaiKhoans: listIdTXLimo
//         );
//         MapState state =  _handleTransferCustomerLimo(await _networkFactory.sendNotification(request,_accessToken),idTC);
//         yield state;
//     }
//
//     else if(event is UpdateStatusCustomerMapEvent){
//       yield MapLoading();
//       UpdateStatusCustomerRequestBody request = UpdateStatusCustomerRequestBody(
//           id:event.idTrungChuyen,
//           status: event.status,
//           ghiChu: event.note
//       );
//       MapState state = _handleUpdateStatusCustomer(await _networkFactory.updateGroupStatusCustomer(request,_accessToken),event.status);
//       yield state;
//     }else if(event is GetListDetailTripsCustomer){
//       yield MapLoading();
//       MapState state = _handleGetListOfDetailTrips(await _networkFactory.getDetailTrips(event.date.toString(),_accessToken,event.date,event.idRoom.toString(),event.idTime.toString(),event.typeCustomer.toString()));
//       yield state;
//     }
//   }
//
//   MapState _handleGetListOfDetailTrips(Object data) {
//     if (data is String) return MapFailure(data);
//     try {
//       _mainBloc.listCustomer.clear();
//       db.deleteAll();
//       DetailTripsResponse response = DetailTripsResponse.fromJson(data);
//       response.data.forEach((element) {
//         var contain =  _mainBloc.listCustomer.where((phone) => phone.soDienThoaiKhach == element.soDienThoaiKhach);
//
//         if (contain.isEmpty){
//           element.chuyen = _mainBloc.trips;
//           element.totalCustomer = response.data.length;
//           element.idKhungGio = _mainBloc.idKhungGio;
//           element.idVanPhong = _mainBloc.idVanPhong;
//           element.ngayTC = _mainBloc.ngayTC;
//           _mainBloc.listCustomer.add(element);
//           _mainBloc.add(AddOldCustomerItemList(element));
//         }else{
//           final customerNews = _mainBloc.listCustomer.firstWhere((item) => item.soDienThoaiKhach == element.soDienThoaiKhach);
//           if (customerNews != null){
//             customerNews.soKhach = customerNews.soKhach + 1;
//             String listIdTC = customerNews.idTrungChuyen + ',' + element.idTrungChuyen;
//             customerNews.idTrungChuyen = listIdTC;
//           }
//           _mainBloc.listCustomer.removeWhere((rm) => rm.soDienThoaiKhach == customerNews.soDienThoaiKhach);
//           _mainBloc.listCustomer.add(customerNews);
//           _mainBloc.add(DeleteCustomerFormDB(element.idTrungChuyen));
//           _mainBloc.add(AddOldCustomerItemList(customerNews));
//           print(_mainBloc.listCustomer.length);
//         }
//       });
//       // _mainBloc.listCustomer.forEach((element) {
//       //   if(element.trangThaiTC == 4 || element.trangThaiTC == 8){
//       //     _mainBloc.soKhachDaDonDuoc =  _mainBloc.soKhachDaDonDuoc + 1;
//       //   }
//       // });
//       _mainBloc.currentNumberCustomerOfList = _mainBloc.listCustomer.length;
//       return GetListOfDetailTripsSuccess();
//     } catch (e) {
//       print(e.toString());
//       return MapFailure(e.toString());
//     }
//   }
//
//   MapState _handleUpdateStatusCustomer(Object data, int status) {
//     if (data is String) return MapFailure(data);
//     try {
//       if(socketIOService.socket.connected)
//       {
//         socketIOService.socket.emit("TAIXE_TRUNGCHUYEN_CAPNHAT_TRANGTHAI_KHACH");
//       }
//       return UpdateStatusCustomerMapSuccess(status);
//     } catch (e) {
//       print(e.toString());
//       return MapFailure(e.toString());
//     }
//   }
//
//   MapState _handleTransferCustomerLimo(Object data,String listIDTC) {
//     if (data is String) return MapFailure(data);
//     try {
//       return TransferCustomerToLimoSuccess(listIDTC);
//     } catch (e) {
//       print(e.toString());
//       return MapFailure(e.toString());
//     }
//   }
//
//   MapState _handleGetListLocationPolyline(Object data) {
//     if (data is String) return MapFailure(data);
//     try {
//       PolylineResultResponse response = PolylineResultResponse.fromJson(data);
//       polylineResultResponseBody = response.data;
//       List<LatLng> lsPoints =[];
//       polylineResultResponseBody.polyline.points.forEach((element) {
//         lsPoints.add(LatLng(element.lat, element.lng));
//       });
//       /// nó còn k nhảy cả vào print
//       print('KO!'+lsPoints.length.toString());
//       return GetListLocationPolylineSuccess(lsPoints);
//     } catch (e) {
//       print(e.toString());
//       return MapFailure(e.toString());
//     }
//   }
//
//   startListenChangeLocation() async {
//     int countPush = 0;
//     // if (await checkPermission()) {
//     //   locationSubscription = location.onLocationChanged.listen((LocationData currentLocation) {
//     //     currentLocationTC = currentLocation.latitude.toString() + "," + currentLocation.longitude.toString() ;//{'lat': , 'lng': currentLocation.longitude};
//     //     countPush++;
//     //     latLngStream.addLatLng(LatLngInfo(currentLocation.latitude, currentLocation.longitude, "DriverMarker"));
//     //     currentLocations(currentLocationTC);
//     //     if(countPush == 45){
//     //       countPush=0;
//     //       var obj = {
//     //         'lat':currentLocation.latitude,
//     //         'lng':currentLocation.longitude
//     //       };
//     //      add(PushLocationToLimoEvent(json.encode(obj)));
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
//
//   Future<List<Customer>> getListTXLimoFromDb() {
//     return db.fetchAllDriverLimo();
//   }
//
//   void getMainBloc(BuildContext context) {
//     _mainBloc = BlocProvider.of<MainBloc>(context);
//   }
// }