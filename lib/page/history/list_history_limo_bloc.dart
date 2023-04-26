import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/models/network/response/detail_trips_limo_reponse.dart';
import 'package:trungchuyen/models/network/response/list_of_group_limo_customer_response.dart';
import 'package:trungchuyen/models/network/service/network_factory.dart';
import 'package:trungchuyen/utils/const.dart';
import 'package:trungchuyen/utils/utils.dart';

import 'list_history_limo_event.dart';
import 'list_history_limo_state.dart';


class ListHistoryLimoBloc extends Bloc<HistoryLimoEvent,ListHistoryLimoState> {

 // MainBloc _mainBloc;
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
  String? _sdtLXLimo;int tongSoKhach=0;

  ListHistoryLimoBloc(this.context) : super(ListHistoryLimoInitial()){
    _networkFactory = NetWorkFactory(context);
    on<GetPrefs>(_getPrefs,);
    on<GetListHistoryLimo>(_getListHistoryLimo);
  }

  void _getPrefs(GetPrefs event, Emitter<ListHistoryLimoState> emitter)async{
    emitter(ListHistoryLimoLoading());
    _prefs = await SharedPreferences.getInstance();
    _accessToken = _prefs!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _prefs!.getString(Const.REFRESH_TOKEN) ?? "";
    _nameLXLimo = _prefs!.getString(Const.FULL_NAME) ?? "";
    _sdtLXLimo = _prefs!.getString(Const.PHONE_NUMBER) ?? "";
    emitter(GetPrefsSuccess());
  }

  void _getListHistoryLimo(GetListHistoryLimo event, Emitter<ListHistoryLimoState> emitter)async{
    emitter(ListHistoryLimoLoading());
    ListHistoryLimoState state = _handleAwaitingCustomer(await _networkFactory!.getListHistoryLimo(_accessToken!,event.dateTime));
    emitter(state);
  }

  ListHistoryLimoState _handleAwaitingCustomer(Object data) {
    if (data is String) return ListHistoryLimoFailure(data);
    try {
      tongSoKhach=0;
      if(!Utils.isEmpty(listCustomerLimo)){
        listCustomerLimo.clear();
      }
      ListOfGroupLimoCustomerResponse response = ListOfGroupLimoCustomerResponse.fromJson(data as Map<String,dynamic>);
      listCustomerLimo = response.data!;
      listCustomerLimo.forEach((element) {
        tongSoKhach = tongSoKhach + element.khachCanXuLy!;
      });
      return GetListHistoryLimoSuccess();
    } catch (e) {
      print(e.toString());
      return ListHistoryLimoFailure(e.toString());
    }
  }
}