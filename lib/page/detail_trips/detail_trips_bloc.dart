import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/models/entity/customer.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
import 'package:trungchuyen/page/detail_trips/detail_trips_event.dart';
import 'package:trungchuyen/page/detail_trips/detail_trips_state.dart';
import 'package:trungchuyen/page/main/main_bloc.dart';
import 'package:trungchuyen/page/waiting/waiting_event.dart';
import 'package:trungchuyen/page/waiting/waiting_sate.dart';
import 'package:trungchuyen/utils/const.dart';
import 'package:trungchuyen/models/network/response/list_of_group_awaiting_customer_response.dart';
import 'package:trungchuyen/models/network/service/network_factory.dart';


class DetailTripsBloc extends Bloc<DetailTripsEvent,DetailTripsState> {
  MainBloc _mainBloc;
  MainBloc get mainBloc => _mainBloc;
  BuildContext context;
  NetWorkFactory _networkFactory;
  String _accessToken;
  String get accessToken => _accessToken;
  String _refreshToken;
  String get refreshToken => _refreshToken;
  SharedPreferences _prefs;
  SharedPreferences get prefs => _prefs;
  List<DetailTripsResponseBody> listOfDetailTrips = new List<DetailTripsResponseBody>();

  DetailTripsBloc(this.context){
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
      DetailTripsState state = _handleGetListOfDetailTrips(await _networkFactory.getDetailTrips(_accessToken,event.date,event.idRoom.toString(),event.idTime.toString(),event.typeCustomer.toString()));
      yield state;
    }
  }
  DetailTripsState _handleGetListOfDetailTrips(Object data) {
    if (data is String) return DetailTripsFailure(data);
    try {
      listOfDetailTrips.clear();
      DetailTripsResponse response = DetailTripsResponse.fromJson(data);
          response.data.forEach((element) {
        var contain =  listOfDetailTrips.where((phone) => phone.soDienThoaiKhach == element.soDienThoaiKhach);
        if (contain.isEmpty){
          listOfDetailTrips.add(element);
        }else{
          final customerNews = listOfDetailTrips.firstWhere((item) => item.soDienThoaiKhach == element.soDienThoaiKhach);
          if (customerNews != null){
            customerNews.soKhach = customerNews.soKhach + 1;
            String listIdTC = customerNews.idTrungChuyen + ',' + element.idTrungChuyen;
            customerNews.idTrungChuyen = listIdTC;
          }
          listOfDetailTrips.remove(customerNews);
          listOfDetailTrips.add(customerNews);
          print(_mainBloc.listCustomer.length);
        }
      });
      return GetListOfDetailTripsSuccess();
    } catch (e) {
      print(e.toString());
      return DetailTripsFailure(e.toString());
    }
  }
  void getMainBloc(BuildContext context) {
    _mainBloc = BlocProvider.of<MainBloc>(context);
  }
}