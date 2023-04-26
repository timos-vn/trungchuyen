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
  NetWorkFactory? _networkFactory;
  String? _accessToken;
  String? get accessToken => _accessToken;
  String? _refreshToken;
  String? get refreshToken => _refreshToken;
  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;
  List<DsKhachs> listOfDetailTripsLimo = [];
  int totalCustomerCancel = 0;
  int totalCustomer = 0;



  DetailTripsLimoBloc(this.context) : super(DetailTripsLimoInitial()){
    _networkFactory = NetWorkFactory(context);
    on<GetPrefs>(_getPrefs,);
    on<GetListDetailTripsLimo>(_getListDetailTripsLimo);
    on<ConfirmCustomerLimoEvent>(_confirmCustomerLimoEvent);
  }

  void _getPrefs(GetPrefs event, Emitter<DetailTripsLimoState> emitter)async{
    emitter(DetailTripsLimoLoading());
    _prefs = await SharedPreferences.getInstance();
    _accessToken = _prefs!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _prefs!.getString(Const.REFRESH_TOKEN) ?? "";
    emitter(GetPrefsSuccess());
  }

  void _getListDetailTripsLimo(GetListDetailTripsLimo event, Emitter<DetailTripsLimoState> emitter)async{
    emitter(DetailTripsLimoLoading());
    DetailTripsLimoState state = _handleGetListOfDetailTrips(await _networkFactory!.getDetailTripsLimo(_accessToken!,event.date,event.idTrips
        .toString(),event.idTime.toString()));
    emitter(state);
  }

  void _confirmCustomerLimoEvent(ConfirmCustomerLimoEvent event, Emitter<DetailTripsLimoState> emitter)async{
    emitter(DetailTripsLimoLoading());
    DetailTripsLimoState state = _handleConfirmCustomerLimo(await _networkFactory!.confirmCustomerLimo(_accessToken!,event.idDatVe,event.trangThai,event.note),event.trangThai);
    emitter(state);
  }

  DetailTripsLimoState _handleGetListOfDetailTrips(Object data) {
    if (data is String) return DetailTripsLimoFailure(data);
    try {
      DetailTripsLimo response = DetailTripsLimo.fromJson(data as Map<String,dynamic>);
      listOfDetailTripsLimo = response.data!.dsKhachs!;
      totalCustomerCancel = response.data!.khachHuy!;
      totalCustomer = response.data!.tongKhach!;
      return GetListOfDetailTripsLimoSuccess();
    } catch (e) {
      return DetailTripsLimoFailure(e.toString());
    }
  }

  DetailTripsLimoState _handleConfirmCustomerLimo(Object data, int status) {
    if (data is String) return DetailTripsLimoFailure(data);
    try {
      return ConfirmCustomerLimoSuccess(status);
    } catch (e) {
      print(e.toString());
      return DetailTripsLimoFailure(e.toString());
    }
  }
}