import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
import 'package:trungchuyen/page/detail_trips/detail_trips_event.dart';
import 'package:trungchuyen/page/detail_trips/detail_trips_state.dart';
import 'package:trungchuyen/page/waiting/waiting_event.dart';
import 'package:trungchuyen/page/waiting/waiting_sate.dart';
import 'package:trungchuyen/utils/const.dart';
import 'package:trungchuyen/models/network/response/list_of_group_awaiting_customer_response.dart';
import 'package:trungchuyen/models/network/service/network_factory.dart';


class DetailTripsBloc extends Bloc<DetailTripsEvent,DetailTripsState> {

  BuildContext context;
  NetWorkFactory _networkFactory;
  String _accessToken;
  String get accessToken => _accessToken;
  String _refreshToken;
  String get refreshToken => _refreshToken;
  SharedPreferences _prefs;
  SharedPreferences get prefs => _prefs;
  List<DetailTripsReponseBody> listOfDetailTrips = new List<DetailTripsReponseBody>();

  DetailTripsBloc(this.context) : super(null){
    _networkFactory = NetWorkFactory(context);
  }

  // TODO: implement initialState
  DetailTripsState get initialState => DetailTripsInitial();

  @override
  Stream<DetailTripsState> mapEventToState(DetailTripsEvent event) async* {
    // TODO: implement mapEventToState
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      _accessToken = _prefs.getString(Const.ACCESS_TOKEN) ?? "";
      _refreshToken = _prefs.getString(Const.REFRESH_TOKEN) ?? "";
    }
    if(event is GetListDetailTrips){
      yield DetailTripsLoading();
      DetailTripsState state = _handleGetListOfDetailTrips(await _networkFactory.getDetailTrips(_accessToken,event.date,event.idTrips,event.idTime));
      yield state;
    }
  }
  DetailTripsState _handleGetListOfDetailTrips(Object data) {
    if (data is String) return DetailTripsFailure(data);
    try {
      DetailTripsReponse response = DetailTripsReponse.fromJson(data);
      listOfDetailTrips = response.data;
      return GetListOfDetailTripsSuccess();
    } catch (e) {
      print(e.toString());
      return DetailTripsFailure(e.toString());
    }
  }
}