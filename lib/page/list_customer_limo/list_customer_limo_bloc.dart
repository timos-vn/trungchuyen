import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/models/network/response/detail_trips_limo_reponse.dart';
import 'package:trungchuyen/models/network/response/list_of_group_limo_customer_response.dart';
import 'package:trungchuyen/models/network/service/network_factory.dart';

import 'package:trungchuyen/utils/const.dart';

import 'list_customer_limo_event.dart';
import 'list_customer_limo_state.dart';


class ListCustomerLimoBloc extends Bloc<ListCustomerLimoEvent,ListCustomerLimoState> {


  BuildContext context;
  NetWorkFactory? _networkFactory;
  String? _accessToken;
  String? get accessToken => _accessToken;
  String? _refreshToken;
  String? get refreshToken => _refreshToken;
  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;
  List<ListOfGroupLimoCustomerResponseBody> listCustomerLimo = [];
  List<DsKhachs> listOfDetailTripsLimo = [];
  String? _nameLXLimo;
  String? _sdtLXLimo;



  ListCustomerLimoBloc(this.context) : super(ListCustomerLimoInitial()){
    _networkFactory = NetWorkFactory(context);
    on<GetPrefs>(_getPrefs,);
    on<GetListCustomerLimo>(_getListCustomerLimo);
    on<GetListDetailTripLimo>(_getListDetailTripLimo);
  }


  void _getPrefs(GetPrefs event, Emitter<ListCustomerLimoState> emitter)async{
    emitter(ListCustomerLimoLoading());
    _prefs = await SharedPreferences.getInstance();
    _accessToken = _prefs!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _prefs!.getString(Const.REFRESH_TOKEN) ?? "";
    _nameLXLimo = _prefs!.getString(Const.FULL_NAME) ?? "";
    _sdtLXLimo = _prefs!.getString(Const.PHONE_NUMBER) ?? "";
    emitter(GetPrefsSuccess());
  }

  void _getListCustomerLimo(GetListCustomerLimo event, Emitter<ListCustomerLimoState> emitter)async{
    emitter(ListCustomerLimoLoading());
    ListCustomerLimoState state = _handleAwaitingCustomer(await _networkFactory!.getListCustomerLimo(_accessToken!,event.date));
    emitter(state);
  }

  void _getListDetailTripLimo(GetListDetailTripLimo event, Emitter<ListCustomerLimoState> emitter)async{
    emitter(ListCustomerLimoLoading());
    ListCustomerLimoState state = _handleGetListOfDetailTrips(await _networkFactory!.getDetailTripsLimo(_accessToken!,event.date.toString(),event.idRoom.toString(),event.idTime.toString()));
    emitter(state);
  }


  ListCustomerLimoState _handleTransferCustomerLimo(Object data) {
    if (data is String) return ListCustomerLimoFailure(data);
    try {
      return TransferLimoSuccess();
    } catch (e) {
      print(e.toString());
      return ListCustomerLimoFailure(e.toString());
    }
  }

  ListCustomerLimoState _handleGetListOfDetailTrips(Object data) {
    if (data is String) return ListCustomerLimoFailure(data);
    try {
      DetailTripsLimo response = DetailTripsLimo.fromJson(data as Map<String,dynamic>);
      listOfDetailTripsLimo = response.data!.dsKhachs!;
      return GetListOfDetailTripLimoSuccess();
    } catch (e) {
      print(e.toString());
      return ListCustomerLimoFailure(e.toString());
    }
  }

  ListCustomerLimoState _handleAwaitingCustomer(Object data) {
    if (data is String) return ListCustomerLimoFailure(data);
    try {
      ListOfGroupLimoCustomerResponse response = ListOfGroupLimoCustomerResponse.fromJson(data as Map<String,dynamic>);
      listCustomerLimo = response.data!;
      return GetListCustomerLimoSuccess();
    } catch (e) {
      print(e.toString());
      return ListCustomerLimoFailure(e.toString());
    }
  }
}