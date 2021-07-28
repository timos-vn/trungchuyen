import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/models/network/request/tranfer_customer_request.dart';
import 'package:trungchuyen/models/network/request/update_status_customer_request.dart';
import 'package:trungchuyen/models/network/response/list_customer_confirm_response.dart';
import 'package:trungchuyen/models/network/service/network_factory.dart';
import 'package:trungchuyen/page/main/main_bloc.dart';
import 'package:trungchuyen/service/soket_io_service.dart';
import 'package:trungchuyen/utils/const.dart';

import 'limo_confirm_event.dart';
import 'limo_confirm_state.dart';

class LimoConfirmBloc extends Bloc<LimoConfirmEvent,LimoConfirmState> {

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
  SocketIOService socketIOService;
  List<CustomerLimoConfirmBody> listCustomerConfirmLimos = new List<CustomerLimoConfirmBody>();
  String role;
  LimoConfirmBloc(this.context){
    _networkFactory = NetWorkFactory(context);
    socketIOService = Get.find<SocketIOService>();
  }

  @override
  Stream<LimoConfirmState> mapEventToState(LimoConfirmEvent event)async* {
    // TODO: implement mapEventToState
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      _accessToken = _prefs.getString(Const.ACCESS_TOKEN) ?? "";
      _refreshToken = _prefs.getString(Const.REFRESH_TOKEN) ?? "";
      role = _prefs.getString(Const.CHUC_VU) ?? "";
    }

    if(event is GetListCustomerConfirmEvent){
      yield LimoConfirmLoading();
      LimoConfirmState state = _handleGetListConfirmLimo(await _networkFactory.getListCustomerConfirmLimo(_accessToken));
      yield state;
    }
    if(event is UpdateStatusCustomerConfirmMapEvent){
      yield LimoConfirmLoading();

      UpdateStatusCustomerRequestBody request = UpdateStatusCustomerRequestBody(
          id:event.idTrungChuyen.split(','),
          status: event.status,
          ghiChu:""
      );
      LimoConfirmState state = _handleUpdateStatusCustomer(await _networkFactory.updateGroupStatusCustomer(request,_accessToken),event.idLaiXeTC);
      yield state;
    }
    else if(event is LimoConfirm){
      yield LimoConfirmLoading();
      var objData = {
        'EVENT':'TAIXE_LIMO_XACNHAN',
      };
      List<String> idLXTC = new List<String>();
      idLXTC.add(event.listTaiXeTC);
      TranferCustomerRequestBody request = TranferCustomerRequestBody(
          title: event.title,
          body: event.body,
          data:objData,
          idTaiKhoans: idLXTC
      );
      LimoConfirmState state =  _handleTransferCustomerLimo(await _networkFactory.sendNotification(request,_accessToken));
      yield state;
    }
  }

  @override
  // TODO: implement initialState
  LimoConfirmState get initialState => LimoConfirmInitial();

  LimoConfirmState _handleTransferCustomerLimo(Object data) {
    if (data is String) return LimoConfirmFailure(data);
    try {
      return LimoConfirmSuccess();
    } catch (e) {
      print(e.toString());
      return LimoConfirmFailure(e.toString());
    }
  }

  LimoConfirmState _handleUpdateStatusCustomer(Object data,String idLaiXeTC) {
    if (data is String) return LimoConfirmFailure(data);
    try {
      if(socketIOService.socket.connected)
      {
        socketIOService.socket.emit("TAIXE_TRUNGCHUYEN_CAPNHAT_TRANGTHAI_KHACH");
      }
      return UpdateStatusCustomerConfirmSuccess();
    } catch (e) {
      print(e.toString());
      return LimoConfirmFailure(e.toString());
    }
  }

  LimoConfirmState _handleGetListConfirmLimo(Object data) {
    if (data is String) return LimoConfirmFailure(data);
    try {
      _mainBloc.tongKhachXacNhan = 0;
      _mainBloc.tongChuyenXacNhan = 0;
      _mainBloc.listCustomerConfirmLimo.clear();
      CustomerLimoConfirm response = CustomerLimoConfirm.fromJson(data);
      _mainBloc.listCustomerConfirm = response.data;
      response.data.forEach((element) {
        CustomerLimoConfirmBody customer = new CustomerLimoConfirmBody(
            idTrungChuyen: element.idTrungChuyen,
            hoTenTaiXe: element.hoTenTaiXe,
            dienThoaiTaiXe: element.dienThoaiTaiXe,
            tenKhachHang: element.tenKhachHang,
            soDienThoaiKhach: element.soDienThoaiKhach,
            tenTuyenDuong: element.tenTuyenDuong,
            ghiChuDatVe: element.ghiChuDatVe,
            ghiChuTrungChuyen: element.ghiChuTrungChuyen,
            loaiKhach: element.loaiKhach,
            ngayChay: element.ngayChay,
            thoiGianDi: element.thoiGianDi,
            idTaiXe: element.idTaiXe,
            soKhach: 1
        );
        var contain =  listCustomerConfirmLimos.where((item) => (
            item.idTaiXe == element.idTaiXe
            &&
            item.ngayChay == element.ngayChay
            &&
            item.thoiGianDi == element.thoiGianDi
            &&
            item.tenTuyenDuong == element.tenTuyenDuong
        ));
        if (contain.isEmpty){
          listCustomerConfirmLimos.add(customer);
        }
        else{
          final customerNews = listCustomerConfirmLimos.firstWhere((item) =>
          (
              item.idTaiXe == element.idTaiXe
              &&
              item.ngayChay == element.ngayChay
              &&
              item.thoiGianDi == element.thoiGianDi
              &&
              item.tenTuyenDuong == element.tenTuyenDuong
          ));
          if (customerNews != null){
            customerNews.soKhach = customerNews.soKhach + 1;
            String listIdTC = customerNews.idTrungChuyen + ',' + customer.idTrungChuyen;
            customerNews.idTrungChuyen = listIdTC;
          }
          listCustomerConfirmLimos.removeWhere((rm) => rm.idTaiXe == customerNews.idTaiXe && rm.ngayChay == customerNews.ngayChay && rm.thoiGianDi == customerNews.thoiGianDi && rm.tenTuyenDuong == customerNews.tenTuyenDuong);
          listCustomerConfirmLimos.add(customerNews);
        }
      });
      _mainBloc.listCustomerConfirmLimo = listCustomerConfirmLimos;
      _mainBloc.tongChuyenXacNhan = listCustomerConfirmLimos.length;
      _mainBloc.tongKhachXacNhan = response.data.length;
      return GetListCustomerConfirmLimoSuccess();
    } catch (e) {
      return LimoConfirmFailure(e.toString());
    }
  }

  void getMainBloc(BuildContext context) {
    _mainBloc = BlocProvider.of<MainBloc>(context);
  }
}