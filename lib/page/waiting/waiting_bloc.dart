import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/models/database/dbhelper.dart';
import 'package:trungchuyen/models/entity/customer.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
import 'package:trungchuyen/models/network/response/list_of_group_awaiting_customer_response.dart';
import 'package:trungchuyen/models/network/service/network_factory.dart';
import 'package:trungchuyen/page/main/main_bloc.dart';
import 'package:trungchuyen/page/main/main_event.dart';
import 'package:trungchuyen/page/waiting/waiting_event.dart';
import 'package:trungchuyen/page/waiting/waiting_sate.dart';
import 'package:trungchuyen/utils/const.dart';


class WaitingBloc extends Bloc<WaitingEvent,WaitingState> {

  // ignore: close_sinks
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
  List<ListOfGroupAwaitingCustomerBody> listOfGroupAwaitingCustomer;
  List<DetailTripsResponseBody> listOfDetailTrips1 = new List<DetailTripsResponseBody>();
  int testRole;
  DateFormat format = DateFormat("dd/MM/yyyy");
  DatabaseHelper db = DatabaseHelper();
  WaitingBloc(this.context)  {
    _networkFactory = NetWorkFactory(context);
    // try{
    //   _mainBloc = BlocProvider.of<MainBloc>(context);
    // }catch(e){
    //   print(e);
    // }
  }

  // TODO: implement initialState
  WaitingState get initialState => WaitingInitial();

  @override
  Stream<WaitingState> mapEventToState(WaitingEvent event) async* {
    // TODO: implement mapEventToState
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      _accessToken = _prefs.getString(Const.ACCESS_TOKEN) ?? "";
      _refreshToken = _prefs.getString(Const.REFRESH_TOKEN) ?? "";
      testRole = int.parse(_prefs.getString(Const.CHUC_VU) ?? 0);

    }
    if(event is GetListGroupAwaitingCustomer){
      yield WaitingLoading();
      print(event.date);
      WaitingState state = _handleAwaitingCustomer(await _networkFactory.groupCustomerAWaiting(_accessToken,event.date));
      yield state;
    }

    if(event is GetListDetailTripsOfPageWaiting){
      yield WaitingLoading();
      WaitingState state = _handleGetListOfDetailTrips(await _networkFactory.getDetailTrips(event.date.toString(),_accessToken,event.date,event.idRoom.toString(),event.idTime.toString(),event.typeCustomer.toString()));
      yield state;
    }
  }

  WaitingState _handleGetListOfDetailTrips(Object data) {
    if (data is String) return WaitingFailure(data);
    try {
      _mainBloc.listCustomer.clear();

      DetailTripsResponse response = DetailTripsResponse.fromJson(data);
      _mainBloc.listCustomer = response.data;
      // response.data.forEach((element) {
      //   var contain =  _mainBloc.listCustomer.where((phone) => phone.soDienThoaiKhach == element.soDienThoaiKhach);
      //   if (contain.isEmpty){
      //     element.chuyen = _mainBloc.trips;
      //     element.totalCustomer = response.data.length;
      //     element.idKhungGio = _mainBloc.idKhungGio;
      //     element.idVanPhong = _mainBloc.idVanPhong;
      //     element.ngayTC = _mainBloc.ngayTC;
      //     element.totalCustomer = response.data.length;
      //     _mainBloc.listCustomer.add(element);
      //     _mainBloc.add(AddOldCustomerItemList(element));
      //   }else{
      //     final customerNews = _mainBloc.listCustomer.firstWhere((item) => item.soDienThoaiKhach == element.soDienThoaiKhach);
      //     if (customerNews != null){
      //       customerNews.soKhach = customerNews.soKhach + 1;
      //       String listIdTC = customerNews.idTrungChuyen + ',' + element.idTrungChuyen;
      //       print('check1');
      //       print(listIdTC);
      //       customerNews.idTrungChuyen = listIdTC;
      //     }
      //     _mainBloc.listCustomer.removeWhere((rm) => rm.soDienThoaiKhach == customerNews.soDienThoaiKhach );
      //     _mainBloc.listCustomer.add(customerNews);
      //     _mainBloc.add(DeleteCustomerFormDB(element.idTrungChuyen));
      //     _mainBloc.add(AddOldCustomerItemList(customerNews));
      //     print('check');
      //     print(_mainBloc.listCustomer.length);
      //   }
      // });
      _mainBloc.soKhachDaDonDuoc = 0;
      _mainBloc.tongKhach = 0;
      _mainBloc.soKhachHuy = 0;
      _mainBloc.listCustomer.forEach((element) {
        if(element.trangThaiTC == 12){
          _mainBloc.soKhachHuy = _mainBloc.soKhachHuy  + 1;
        }
        if(element.trangThaiTC == 4 || element.trangThaiTC == 8 || element.trangThaiTC == 12){
          _mainBloc.soKhachDaDonDuoc =  _mainBloc.soKhachDaDonDuoc + 1;
          _mainBloc.tongKhach =  _mainBloc.tongKhach + 1;
        }
      });
      print('123lkl: ${ _mainBloc.soKhachDaDonDuoc}');
      // _mainBloc.listCustomer = (_mainBloc.listCustomer.sort((a,b)=>));
      // _mainBloc.listCustomer.sort((a,b)=> a.trangThaiTC.compareTo(b.trangThaiTC));
      _mainBloc.listCustomer.sort((a,b){
        //a.trangThaiTC.compareTo(b.trangThaiTC)
        if(a.trangThaiTC == 5) return -1;
        if(b.trangThaiTC == 5) return 1;
        if(a.trangThaiTC == 2) return -1;
        if(b.trangThaiTC == 2) return 1;
        if(a.trangThaiTC > b.trangThaiTC) return 1;
        return 0;
      });
      _mainBloc.currentNumberCustomerOfList = _mainBloc.listCustomer.length;
      return GetListOfDetailTripsOfWaitingPageSuccess();
    } catch (e) {
      print(e.toString());
      return WaitingFailure(e.toString());
    }
  }

  WaitingState _handleAwaitingCustomer(Object data) {
    if (data is String) return WaitingFailure(data);
    try {
      bool vanTrongChuyen = false;
      String ngayChay;
      _mainBloc.listOfGroupAwaitingCustomer.clear();
      ListOfGroupAwaitingCustomer response = ListOfGroupAwaitingCustomer.fromJson(data);
      listOfGroupAwaitingCustomer = response.data;
      _mainBloc.listOfGroupAwaitingCustomer = response.data;
      print(_mainBloc.listOfGroupAwaitingCustomer.length);
      _mainBloc.listOfGroupAwaitingCustomer.forEach((item) {
        if(item.idKhungGio == _mainBloc.idKhungGio && item.loaiKhach == _mainBloc.loaiKhach && _mainBloc.blocked == true&& item.idVanPhong == _mainBloc.idVanPhong){
          vanTrongChuyen = true;
          _mainBloc.trips = item.thoiGianDi + ' - ' + item.ngayChay;
          ngayChay = item.ngayChay;
        }
      });
      if(vanTrongChuyen == true){
        add(GetListDetailTripsOfPageWaiting(format.parse(ngayChay),_mainBloc.idVanPhong,_mainBloc.idKhungGio,_mainBloc.loaiKhach));
      }
      return GetListOfWaitingCustomerSuccess();
    } catch (e) {
      print(e.toString());
      return WaitingFailure(e.toString());
    }
  }

  void getMainBloc(BuildContext context) {
    _mainBloc = BlocProvider.of<MainBloc>(context);
  }
}