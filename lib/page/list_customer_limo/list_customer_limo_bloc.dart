import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/models/network/request/tranfer_customer_request.dart';
import 'package:trungchuyen/models/network/response/detail_trips_limo_reponse.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
import 'package:trungchuyen/models/network/response/list_of_group_awaiting_customer_response.dart';
import 'package:trungchuyen/models/network/response/list_of_group_limo_customer_response.dart';
import 'package:trungchuyen/models/network/service/network_factory.dart';
import 'package:trungchuyen/page/main/main_bloc.dart';
import 'package:trungchuyen/page/waiting/waiting_event.dart';
import 'package:trungchuyen/page/waiting/waiting_sate.dart';
import 'package:trungchuyen/utils/const.dart';

import 'list_customer_limo_event.dart';
import 'list_customer_limo_state.dart';


class ListCustomerLimoBloc extends Bloc<ListCustomerLimoEvent,ListCustomerLimoState> {

 // MainBloc _mainBloc;
  BuildContext context;
  NetWorkFactory _networkFactory;
  String _accessToken;
  String get accessToken => _accessToken;
  String _refreshToken;
  String get refreshToken => _refreshToken;
  SharedPreferences _prefs;
  SharedPreferences get prefs => _prefs;
  List<ListOfGroupLimoCustomerResponseBody> listCustomerLimo;
  List<DsKhachs> listOfDetailTripsLimo = new List<DsKhachs>();
  String _nameLXLimo;
  String _sdtLXLimo;

  ListCustomerLimoBloc(this.context){
    _networkFactory = NetWorkFactory(context);
    // _mainBloc = BlocProvider.of<MainBloc>(context);
  }

  // TODO: implement initialState
  ListCustomerLimoState get initialState => ListCustomerLimoInitial();

  @override
  Stream<ListCustomerLimoState> mapEventToState(ListCustomerLimoEvent event) async* {
    // TODO: implement mapEventToState
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      _accessToken = _prefs.getString(Const.ACCESS_TOKEN) ?? "";
      _refreshToken = _prefs.getString(Const.REFRESH_TOKEN) ?? "";
      _nameLXLimo = _prefs.getString(Const.FULL_NAME) ?? "";
      _sdtLXLimo = _prefs.getString(Const.PHONE_NUMBER) ?? "";

    }
    if(event is GetListCustomerLimo){
      yield ListCustomerLimoLoading();
      ListCustomerLimoState state = _handleAwaitingCustomer(await _networkFactory.getListCustomerLimo(_accessToken,event.date));
      yield state;
    }

    if(event is GetListDetailTripLimo){
      yield ListCustomerLimoLoading();
      ListCustomerLimoState state = _handleGetListOfDetailTrips(await _networkFactory.getDetailTripsLimo(_accessToken,event.date.toString(),event.idRoom.toString(),event.idTime.toString()));
      yield state;
    }

    if(event is CustomerTransferToTC){
    }
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
      DetailTripsLimo response = DetailTripsLimo.fromJson(data);
      listOfDetailTripsLimo = response.data.dsKhachs;
      return GetListOfDetailTripLimoSuccess();
    } catch (e) {
      print(e.toString());
      return ListCustomerLimoFailure(e.toString());
    }
  }

  ListCustomerLimoState _handleAwaitingCustomer(Object data) {
    if (data is String) return ListCustomerLimoFailure(data);
    try {
      ListOfGroupLimoCustomerResponse response = ListOfGroupLimoCustomerResponse.fromJson(data);
      listCustomerLimo = response.data;
      return GetListCustomerLimoSuccess();
    } catch (e) {
      print(e.toString());
      return ListCustomerLimoFailure(e.toString());
    }
  }
}