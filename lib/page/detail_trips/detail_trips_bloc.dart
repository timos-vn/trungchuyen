import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:trungchuyen/models/network/request/tranfer_customer_request.dart';
import 'package:trungchuyen/models/network/request/update_status_customer_request.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
import 'package:trungchuyen/page/detail_trips/detail_trips_event.dart';
import 'package:trungchuyen/page/detail_trips/detail_trips_state.dart';
import 'package:trungchuyen/page/main/main_bloc.dart';
import 'package:trungchuyen/service/soket_io_service.dart';
import 'package:trungchuyen/utils/const.dart';
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
  String _nameLXTC;
  SocketIOService socketIOService;
  List<DetailTripsResponseBody> listOfDetailTrips = new List<DetailTripsResponseBody>();

  DetailTripsBloc(this.context){
    _networkFactory = NetWorkFactory(context);
    socketIOService = Get.find<SocketIOService>();
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
      _nameLXTC = _prefs.getString(Const.FULL_NAME) ?? "";
    }
    if(event is GetListDetailTrips){
      yield DetailTripsLoading();
      DetailTripsState state = _handleGetListOfDetailTrips(await _networkFactory.getDetailTrips(event.date.toString(),_accessToken,event.date,event.idRoom.toString(),event.idTime.toString(),event.typeCustomer.toString()));
      yield state;
    }
    else if(event is GetListDetailTripsHistory){
      yield DetailTripsLoading();
      DetailTripsState state = _handleGetListOfDetailTrips(await _networkFactory.getDetailTripsHistory(_accessToken,event.idRoom.toString(),event.idTime.toString(),event.typeCustomer.toString(),event.dateTime.toString()));
      yield state;
    }
    else if(event is UpdateStatusCustomerDetailEvent){
      yield DetailTripsLoading();
      UpdateStatusCustomerRequestBody request = UpdateStatusCustomerRequestBody(
          id:event.idTrungChuyen,
          status: event.status,
          ghiChu: event.note
      );
      DetailTripsState state = _handleUpdateStatusCustomer(await _networkFactory.updateGroupStatusCustomer(request,_accessToken),event.status);
      yield state;
    }
    else if(event is TCTransferCustomerToLimoEvent){
      yield DetailTripsLoading();
      List<String> listIdTXLimo = new List<String>();
      List<String> listKhach = new List<String>();
      List<String> listIdTC = new List<String>();
      String numberCustomer;
      String idTC;
      String taiXeLimo;
      List<DetailTripsResponseBody> listitem = event.listCustomer;
      if(_mainBloc.listDriverLimo !=null){
        _mainBloc.listDriverLimo.clear();
      }
      listitem.forEach((element) {
        if(element.trangThaiTC != 12){
          listIdTC.add(element.idTrungChuyen);
          if(listIdTXLimo.contains(element.idTaiXeLimousine) == false ){
            _mainBloc.listDriverLimo.add(element);
            listIdTXLimo.add(element.idTaiXeLimousine);
          }
          else {
            DetailTripsResponseBody itemDetail = DetailTripsResponseBody(
              soKhach: element.soKhach + 1,
              hoTenTaiXeLimousine: element.hoTenTaiXeLimousine,
              dienThoaiTaiXeLimousine: element.dienThoaiTaiXeLimousine,
              bienSoXeLimousine: element.bienSoXeLimousine,
            );
            _mainBloc.listDriverLimo.removeWhere((item) => item.idTaiXeLimousine == element.idTaiXeLimousine);
            _mainBloc.listDriverLimo.add(itemDetail);
          }
        }
      });

      if(_mainBloc.listDriverLimo != null){
        _mainBloc.listDriverLimo.forEach((element) {
          listKhach.add(element.soKhach.toString());
        });
      }

      numberCustomer = listKhach.join(',');
      idTC  = listIdTC.join(',');
      taiXeLimo = listIdTXLimo.join(',');
      var objData = {
        'EVENT':'TAIXE_TRUNGCHUYEN_GIAOKHACH_LIMO',
        'numberCustomer' : numberCustomer,
        'nameLXTC':_nameLXTC,
        'listIdTXLimo':taiXeLimo
      };
      TranferCustomerRequestBody request = TranferCustomerRequestBody(
          title: event.title,
          body: '',
          data: objData,
          idTaiKhoans: listIdTXLimo,
      );

      DetailTripsState state =  _handleTransferCustomerLimo(await _networkFactory.sendNotification(request,_accessToken),idTC);
      yield state;
    }
  }

  DetailTripsState _handleTransferCustomerLimo(Object data,String listIDTC) {
    if (data is String) return DetailTripsFailure(data);
    try {
      return TCTransferCustomerToLimoSuccess(listIDTC);
    } catch (e) {
      print(e.toString());
      return DetailTripsFailure(e.toString());
    }
  }

  DetailTripsState _handleUpdateStatusCustomer(Object data, int status) {
    if (data is String) return DetailTripsFailure(data);
    try {
      if(socketIOService.socket.connected)
      {
        socketIOService.socket.emit("TAIXE_TRUNGCHUYEN_CAPNHAT_TRANGTHAI_KHACH");
      }
      return UpdateStatusCustomerSuccess(status);
    } catch (e) {
      print(e.toString());
      return DetailTripsFailure(e.toString());
    }
  }

  DetailTripsState _handleGetListOfDetailTrips(Object data) {
    if (data is String) return DetailTripsFailure(data);
    try {
      // listOfDetailTrips.clear();
      DetailTripsResponse response = DetailTripsResponse.fromJson(data);
      listOfDetailTrips = response.data;
          //response.data.forEach((element) {
        //var contain =  listOfDetailTrips.where((phone) => phone.soDienThoaiKhach == element.soDienThoaiKhach);
        // if (contain.isEmpty){
        //   listOfDetailTrips.add(element);
        // }
        // else{
        //   final customerNews = listOfDetailTrips.firstWhere((item) => item.soDienThoaiKhach == element.soDienThoaiKhach);
        //   if (customerNews != null){
        //     customerNews.soKhach = customerNews.soKhach + 1;
        //     String listIdTC = customerNews.idTrungChuyen + ',' + element.idTrungChuyen;
        //     customerNews.idTrungChuyen = listIdTC;
        //   }
        //   listOfDetailTrips.remove(customerNews);
        //   listOfDetailTrips.add(customerNews);
        // }
      //});
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