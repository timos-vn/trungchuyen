import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/models/network/response/detail_trips_limo_reponse.dart';
import 'package:trungchuyen/utils/const.dart';
import 'package:trungchuyen/models/network/service/network_factory.dart';

import 'detail_trips_limo_event.dart';
import 'detail_trips_limo_state.dart';

class DetailTripsLimoBloc extends Bloc<DetailTripsLimoEvent,DetailTripsLimoState> {

  BuildContext context;
  NetWorkFactory _networkFactory;
  String _accessToken;
  String get accessToken => _accessToken;
  String _refreshToken;
  String get refreshToken => _refreshToken;
  SharedPreferences _prefs;
  SharedPreferences get prefs => _prefs;
  List<DetailTripsLimoReponseBody> listOfDetailTripsLimo = new List<DetailTripsLimoReponseBody>();

  DetailTripsLimoBloc(this.context) : super(null){
    _networkFactory = NetWorkFactory(context);
  }

  // TODO: implement initialState
  DetailTripsLimoState get initialState => DetailTripsLimoInitial();

  @override
  Stream<DetailTripsLimoState> mapEventToState(DetailTripsLimoEvent event) async* {
    // TODO: implement mapEventToState
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      _accessToken = _prefs.getString(Const.ACCESS_TOKEN) ?? "";
      _refreshToken = _prefs.getString(Const.REFRESH_TOKEN) ?? "";
    }
    if(event is GetListDetailTripsLimo){
      yield DetailTripsLimoLoading();
      DetailTripsLimoState state = _handleGetListOfDetailTrips(await _networkFactory.getDetailTripsLimo(_accessToken,event.date,event.idTrips,event.idTime));
      yield state;
    }
  }
  DetailTripsLimoState _handleGetListOfDetailTrips(Object data) {
    if (data is String) return DetailTripsLimoFailure(data);
    try {
      DetailTripsLimo response = DetailTripsLimo.fromJson(data);
      listOfDetailTripsLimo = response.data;
      return GetListOfDetailTripsLimoSuccess();
    } catch (e) {
      print(e.toString());
      return DetailTripsLimoFailure(e.toString());
    }
  }
}