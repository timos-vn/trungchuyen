import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/models/database/dbhelper.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
import 'package:trungchuyen/models/network/response/list_of_group_awaiting_customer_response.dart';
import 'package:trungchuyen/models/network/service/network_factory.dart';
import 'package:trungchuyen/page/main/main_bloc.dart';
import 'package:trungchuyen/utils/const.dart';
import 'package:trungchuyen/utils/utils.dart';

import 'list_history_tc_event.dart';
import 'list_history_tc_state.dart';


class ListHistoryTCBloc extends Bloc<HistoryTCEvent,ListHistoryTCState> {

  // ignore: close_sinks
  late MainBloc _mainBloc;
  MainBloc get mainBloc => _mainBloc;
  BuildContext context;
  NetWorkFactory? _networkFactory;
  String? _accessToken;
  String? get accessToken => _accessToken;
  String? _refreshToken;
  String? get refreshToken => _refreshToken;
  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;
  List<ListOfGroupAwaitingCustomerBody> listCustomerTC = [];
  int tongSoKhach=0;
  int tongKhachHuy = 0;
  int tongKhachThanhCong =0;
  List<DetailTripsResponseBody> listOfDetailTrips1 = [];

  DatabaseHelper db = DatabaseHelper();


  ListHistoryTCBloc(this.context) : super(ListHistoryTCInitial()){
    _networkFactory = NetWorkFactory(context);
    db = DatabaseHelper();
    db.init();
    on<GetPrefs>(_getPrefs,);
    on<GetListHistoryTC>(_getListHistoryTC);
  }

  void _getPrefs(GetPrefs event, Emitter<ListHistoryTCState> emitter)async{
    emitter(ListHistoryTCLoading());
    _prefs = await SharedPreferences.getInstance();
    _accessToken = _prefs!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _prefs!.getString(Const.REFRESH_TOKEN) ?? "";
    emitter(GetPrefsSuccess());
  }

  void _getListHistoryTC(GetListHistoryTC event, Emitter<ListHistoryTCState> emitter)async{
    emitter(ListHistoryTCLoading());
    ListHistoryTCState state = _handleGetListHistory(await _networkFactory!.getListHistoryTC(_accessToken!,event.dateTime));
    emitter(state);
  }

  ListHistoryTCState _handleGetListHistory(Object data) {
    if (data is String) return ListHistoryTCFailure(data);
    try {
      tongSoKhach=0;
      tongKhachHuy = 0;
      tongKhachThanhCong  = 0;
      if(!Utils.isEmpty(_mainBloc.listOfGroupAwaitingCustomer)){
        _mainBloc.listOfGroupAwaitingCustomer.clear();
      }
      if(!Utils.isEmpty(listCustomerTC)){
        listCustomerTC.clear();
      }
      ListOfGroupAwaitingCustomer response = ListOfGroupAwaitingCustomer.fromJson(data as Map<String,dynamic>);
      listCustomerTC = response.data!;
      listCustomerTC.forEach((element) {
        tongSoKhach = tongSoKhach + element.soKhach!;
        tongKhachHuy = tongKhachHuy + element.thatBai!;
        tongKhachThanhCong = tongKhachThanhCong + element.thanhCong!;
      });
      _mainBloc.listOfGroupAwaitingCustomer = response.data!;
      print(_mainBloc.listOfGroupAwaitingCustomer.length);
      return LoadMoreListHistoryTC();
    } catch (e) {
      print(e.toString());
      return ListHistoryTCFailure(e.toString());
    }
  }

  void getMainBloc(BuildContext context) {
    _mainBloc = BlocProvider.of<MainBloc>(context);
  }
}