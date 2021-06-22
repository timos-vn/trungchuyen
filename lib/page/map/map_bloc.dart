import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
import 'package:trungchuyen/models/network/service/network_factory.dart';
import 'package:trungchuyen/utils/const.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent,MapState> {

  BuildContext context;
  NetWorkFactory _networkFactory;
  String _accessToken;
  String get accessToken => _accessToken;
  String _refreshToken;
  String get refreshToken => _refreshToken;
  SharedPreferences _prefs;
  SharedPreferences get prefs => _prefs;

  List<DetailTripsReponseBody> listOfCustomerTrips = new List<DetailTripsReponseBody>();


  MapBloc(this.context) : super(null){
    _networkFactory = NetWorkFactory(context);
  }

  // TODO: implement initialState
  MapState get initialState => MapInitial();


  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    // TODO: implement mapEventToState
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      _accessToken = _prefs.getString(Const.ACCESS_TOKEN) ?? "";
      _refreshToken = _prefs.getString(Const.REFRESH_TOKEN) ?? "";
    }

    if(event is GetListCustomer){
      yield MapLoading();
      listOfCustomerTrips = event.listOfDetailTrips;
      print(listOfCustomerTrips.length);
      yield GetListCustomerSuccess(listOfCustomerTrips);
    }
    if(event is UpdateStatusDriverEvent){
      yield MapLoading();
      MapState state = _handleUpdateStatusDriver(await _networkFactory.updateStatusDriver(_accessToken, event.statusDriver));
      yield state;
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
}