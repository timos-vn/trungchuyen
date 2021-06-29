import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animarker/lat_lng_interpolation.dart';
import 'package:flutter_animarker/models/lat_lng_delta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
import 'package:trungchuyen/models/network/service/network_factory.dart';
import 'package:trungchuyen/service/soket_io_service.dart';
import 'package:trungchuyen/utils/const.dart';
import 'package:trungchuyen/utils/marker_icon.dart';
import 'map_limo_event.dart';
import 'map_limo_state.dart';

class MapLimoBloc extends Bloc<MapLimoEvent,MapLimoState> {
  //SocketIOService socketIOService;


  BuildContext context;
  NetWorkFactory _networkFactory;
  String _accessToken;
  String get accessToken => _accessToken;
  String _refreshToken;
  String get refreshToken => _refreshToken;
  SharedPreferences _prefs;
  SharedPreferences get prefs => _prefs;
  PermissionStatus permissionGranted;
  bool serviceEnabled;
  List<DetailTripsResponseBody> listOfCustomerTrips = new List<DetailTripsResponseBody>();

  Location location = new Location();
  String markerID;

  MapLimoBloc(this.context) : super(null){
    _networkFactory = NetWorkFactory(context);
  }

  // TODO: implement initialState
  MapLimoState get initialState => MapLimoInitial();


  @override
  Stream<MapLimoState> mapEventToState(MapLimoEvent event) async* {
    // TODO: implement mapEventToState
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      _accessToken = _prefs.getString(Const.ACCESS_TOKEN) ?? "";
      _refreshToken = _prefs.getString(Const.REFRESH_TOKEN) ?? "";
    }

    if(event is CheckPermissionLimoEvent){
      yield MapLimoInitial();
      checkPermission();
      yield CheckPermissionLimoSuccess();
    }

    if(event is GetListCustomerLimo){
      yield MapLimoLoading();
      listOfCustomerTrips = event.listOfDetailTrips;
      print(listOfCustomerTrips.length);
      yield GetListCustomerLimoSuccess(listOfCustomerTrips);
    }
    if(event is UpdateStatusDriverLimoEvent){
      yield MapLimoLoading();
      MapLimoState state = _handleUpdateStatusDriver(await _networkFactory.updateStatusDriver(_accessToken, event.statusDriver));
      yield state;
    }
    if(event is GetEvent){
      yield MapLimoInitial();
      // subscriptions.add(_latLngStream.getAnimatedPosition("DriverMarker"));
      markerID = event.markerId;
      yield GetEventStateSuccess();
    }
  }



  MapLimoState _handleUpdateStatusDriver(Object data) {
    if (data is String) return MapLimoFailure(data);
    try {
      return UpdateStatusDriverLimoState();
    } catch (e) {
      print(e.toString());
      return MapLimoFailure(e.toString());
    }
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