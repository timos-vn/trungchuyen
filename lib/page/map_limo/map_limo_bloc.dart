import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
import 'package:trungchuyen/models/network/service/network_factory.dart';
import 'package:trungchuyen/utils/const.dart';
import 'map_limo_event.dart';
import 'map_limo_state.dart';

class MapLimoBloc extends Bloc<MapLimoEvent,MapLimoState> {

  BuildContext context;
  NetWorkFactory _networkFactory;
  String _accessToken;
  String get accessToken => _accessToken;
  String _refreshToken;
  String get refreshToken => _refreshToken;
  SharedPreferences _prefs;
  SharedPreferences get prefs => _prefs;

  List<DetailTripsReponseBody> listOfCustomerTrips = new List<DetailTripsReponseBody>();


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
}