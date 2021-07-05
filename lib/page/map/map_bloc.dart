import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_animarker/lat_lng_interpolation.dart';
import 'package:flutter_animarker/models/lat_lng_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/models/database/dbhelper.dart';
import 'package:trungchuyen/models/entity/customer.dart';
import 'package:trungchuyen/models/network/request/push_location_request.dart';
import 'package:trungchuyen/models/network/request/tranfer_customer_request.dart';
import 'package:trungchuyen/models/network/request/update_status_customer_request.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
import 'package:trungchuyen/models/network/response/polyline_result_response.dart';
import 'package:trungchuyen/models/network/service/network_factory.dart';
import 'package:trungchuyen/service/soket_io_service.dart';
import 'package:trungchuyen/utils/const.dart';
import 'package:trungchuyen/utils/utils.dart';
import 'map_event.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'map_state.dart';

String latLngLocation;
class MapBloc extends Bloc<MapEvent,MapState> {

  BuildContext context;
  NetWorkFactory _networkFactory;
  String _accessToken;
  String get accessToken => _accessToken;
  String _refreshToken;
  String get refreshToken => _refreshToken;
  SharedPreferences _prefs;
  SharedPreferences get prefs => _prefs;
  SocketIOService socketIOService;
  List<DetailTripsResponseBody> listOfCustomerTrips = new List<DetailTripsResponseBody>();

  ///

  Location location = new Location();
  bool serviceEnabled;
  String currentLocationTC;
  PermissionStatus permissionGranted;
  LocationData locationData;
  StreamSubscription<LocationData> locationSubscription;
  LatLngInterpolationStream latLngStream = LatLngInterpolationStream();
  PolylineResultResponseBody polylineResultResponseBody;
  String _nameLXTC;
  String _sdtLXTC;
  final db = DatabaseHelper();
  String test1 = 'O';
  String idUser;

  MapBloc(this.context)  {
    _networkFactory = NetWorkFactory(context);
    socketIOService = Get.find<SocketIOService>();
  }

  // TODO: implement initialState
  MapState get initialState => MapInitial();

  // Future<List<Customer>> getListFromDb() {
  //   return db.fetchAll();
  // }
  //
  // void deleteItems(int index) {
  //   listCustomer.removeAt(index);
  // }
  //
  // Customer getCustomer(int i) {
  //   return listCustomer.elementAt(i);
  // }

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    // TODO: implement mapEventToState
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      _accessToken = _prefs.getString(Const.ACCESS_TOKEN) ?? "";
      _refreshToken = _prefs.getString(Const.REFRESH_TOKEN) ?? "";
      _nameLXTC = _prefs.getString(Const.FULL_NAME) ?? "";
      _sdtLXTC = _prefs.getString(Const.PHONE_NUMBER) ?? "";
      idUser = _prefs.getString(Const.USER_ID) ??'';
    }

    // if(event is GetCustomerList){
    //   yield MapLoading();
    //   listCustomer = await getListFromDb();
    //   if (Utils.isEmpty(listCustomer)) {
    //     yield GetListCustomerSuccess();
    //     return;
    //   }
    //   yield GetListCustomerSuccess();
    // }

    // if (event is Delete) {
    //   yield MapLoading();
    //   deleteItems(event.index);
    //   await db.remove(event.idTC);
    //   listCustomer = await getListFromDb();
    //   yield GetCustomerListSuccess();
    //   add(GetCustomerList());
    // }

    // if(event is UpdateCustomerList){
    //   yield MapLoading();
    //   await db.update(event.customer);
    //   listCustomer = await getListFromDb();
    //   yield GetCustomerListSuccess();
    //   add(GetCustomerList());
    // }


    if(event is UpdateStatusDriverEvent){
      yield MapLoading();
      MapState state = _handleUpdateStatusDriver(await _networkFactory.updateStatusDriver(_accessToken, event.statusDriver));
      yield state;
    }
    if(event is CheckPermissionEvent){
      yield MapInitial();
      checkPermission();
      yield CheckPermissionSuccess();
    }
    if(event is OnlineEvent){
      yield MapInitial();
      startListenChangeLocation();
      yield OnlineSuccess();
    }
    if(event is OfflineEvent){
      yield MapInitial();
      stopListenChangeLocation();
      yield OfflineSuccess();
    }
    if(event is PushLocationToLimoEvent){
      yield MapInitial();
      SocketIOService socketIOService = Get.find();
      if(socketIOService.socket.connected)
        {
          socketIOService.socket.emit("TAIXE_CAPNHAT_TOADO",event.location);
          print('TAIXE_TC_CAPNHAT_TOADO => ${event.location.toString()}');
        }
      // PushLocationRequestBody request = PushLocationRequestBody(
      //   location: event.location
      // );
      // MapState state = _handlePushLocationToLimo(await _networkFactory.pushLocationToLimo(request,_accessToken));
      yield PushLocationToLimoSuccess();
    }
    if(event is GetListLocationPolylineEvent){
      ///{\"lat\":20.9902775,\"lng\":105.8014063}
      yield MapLoading();
      String _location = event.customerLocation.replaceAll('{', '').replaceAll('}', '').replaceAll("\"","").replaceAll('lat', '').replaceAll('lng', '').replaceAll(':', '');
      MapState state = _handleGetListLocationPolyline(await _networkFactory.getListLocationPolyline(_accessToken,latLngLocation,_location));
      yield state;
    }
    if(event is CustomerTransferToLimo){
        yield MapLoading();
        List<String> listIdTXLimo = new List<String>();
        List<String> listKhach = new List<String>();
        List<String> listIdTC = new List<String>();
        String numberCustomer;
        // String listIdTAIXELIMO;
        String idTC;
        List<Customer> listTaiXeTC = event.listTaiXeTC;
        listTaiXeTC.forEach((element) {
          listIdTXLimo.add(element.idTaiXeLimousine);/// a | a |
          listKhach.add(element.soKhach.toString());
          listIdTC.add(element.idTrungChuyen);
        });
        numberCustomer = listKhach.join('|');
        // listIdTAIXELIMO = listIdTXLimo.join(',');
        idTC  = listIdTC.join(',');

        var objData = {
          'EVENT':'TAIXE_TRUNGCHUYEN_GIAOKHACH_LIMO',
          'numberCustomer' : numberCustomer,
          // 'listIdTAIXELIMO':listIdTAIXELIMO,
          // 'nameTC': _nameLXTC,
          // 'phoneTC': _sdtLXTC,
          // 'listIdTC':idTC,
          // 'idDriverTC':idUser
        };
        TranferCustomerRequestBody request = TranferCustomerRequestBody(
          title: event.title,
          body: 'Bạn nhận được $numberCustomer khách từ LXTC $_nameLXTC.',
          data:objData,
          idTaiKhoans: listIdTXLimo
        );
        MapState state =  _handleTransferCustomerLimo(await _networkFactory.sendNotification(request,_accessToken),idTC);
        yield state;
    }
    else if(event is UpdateStatusCustomerMapEvent){
      yield MapLoading();

      UpdateStatusCustomerRequestBody request = UpdateStatusCustomerRequestBody(
          id:event.idTrungChuyen.split(','),
          status: event.status,
          ghiChu:""
      );
      MapState state = _handleUpdateStatusCustomer(await _networkFactory.updateGroupStatusCustomer(request,_accessToken));
      yield state;
    }
  }

  MapState _handleUpdateStatusCustomer(Object data) {
    if (data is String) return MapFailure(data);
    try {
      if(socketIOService.socket.connected)
      {
        socketIOService.socket.emit("TAIXE_TRUNGCHUYEN_CAPNHAT_TRANGTHAI_KHACH");
      }
      return UpdateStatusCustomerMapSuccess();
    } catch (e) {
      print(e.toString());
      return MapFailure(e.toString());
    }
  }

  MapState _handleTransferCustomerLimo(Object data,String listIDTC) {
    if (data is String) return MapFailure(data);
    try {
      return TransferCustomerToLimoSuccess(listIDTC);
    } catch (e) {
      print(e.toString());
      return MapFailure(e.toString());
    }
  }

  MapState _handleGetListLocationPolyline(Object data) {
    if (data is String) return MapFailure(data);
    try {
      PolylineResultResponse response = PolylineResultResponse.fromJson(data);
      polylineResultResponseBody = response.data;
      List<LatLng> lsPoints =[];
      polylineResultResponseBody.polyline.points.forEach((element) {
        lsPoints.add(LatLng(element.lat, element.lng));
      });
      /// nó còn k nhảy cả vào print
      print('KO!'+lsPoints.length.toString());
      return GetListLocationPolylineSuccess(lsPoints);
    } catch (e) {
      print(e.toString());
      return MapFailure(e.toString());
    }
  }

  MapState _handlePushLocationToLimo(Object data) {
    if (data is String) return MapFailure(data);
    try {
      return PushLocationToLimoSuccess();
    } catch (e) {
      print(e.toString());
      return MapFailure(e.toString());
    }
  }

  MapState _handleUpdateStatusDriver(Object data) {
    if (data is String) return MapFailure(data);
    try {
      return UpdateStatusDriverState();
    } catch (e) {
      print(e.toString());
      return MapFailure(e.toString());
    }
  }

  startListenChangeLocation() async {
    int countPush = 0;
    if (await checkPermission()) {
      locationSubscription = location.onLocationChanged.listen((LocationData currentLocation) {
        // print(currentLocation.toString());
        currentLocationTC = currentLocation.latitude.toString() + "," + currentLocation.longitude.toString() ;//{'lat': , 'lng': currentLocation.longitude};
        countPush++;
        latLngStream.addLatLng(LatLngInfo(currentLocation.latitude, currentLocation.longitude, "DriverMarker"));
        //add(GetCurrentLocationEvent(currentLocationTC));
        currentLocations(currentLocationTC);
        // print('---Tream--- ${currentLocationTC.toString()}');
        ///{\"lat\":20.9763858,\"lng\":105.8175841}
        // print(countPush);
        if(countPush == 1){
          countPush=0;
          var obj = {
            'lat':currentLocation.latitude,
            'lng':currentLocation.longitude
          };
         add(PushLocationToLimoEvent(json.encode(obj)));
        }
      });
    }
  }

  stopListenChangeLocation(){
    locationSubscription.cancel();
    // if (socketIOService!=null && socketIOService.socket.connected){
    //   socketIOService.socket.emit('driver_offline');
    // }
  }

  currentLocations(String location){
    print(location + "---Tream---");
    latLngLocation = location;
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