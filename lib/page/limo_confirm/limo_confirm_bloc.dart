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
  late SocketIOService socketIOService;
  List<CustomerLimoConfirmBody> listCustomerConfirmLimos = [];
  String role = '';


  LimoConfirmBloc(this.context) : super(LimoConfirmInitial()){
    _networkFactory = NetWorkFactory(context);
    socketIOService = Get.find<SocketIOService>();
    on<GetPrefs>(_getPrefs,);
    on<GetListCustomerConfirmEvent>(_getListCustomerConfirmEvent);
    on<UpdateStatusCustomerConfirmMapEvent>(_updateStatusCustomerConfirmMapEvent);
    on<LimoConfirm>(_limoConfirm);
  }

  void _getPrefs(GetPrefs event, Emitter<LimoConfirmState> emitter)async{
    emitter(LimoConfirmLoading());
    _prefs = await SharedPreferences.getInstance();
    _accessToken = _prefs!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _prefs!.getString(Const.REFRESH_TOKEN) ?? "";
    emitter(GetPrefsSuccess());
  }

  void _getListCustomerConfirmEvent(GetListCustomerConfirmEvent event, Emitter<LimoConfirmState> emitter)async{
    emitter(LimoConfirmLoading());
    LimoConfirmState state = _handleGetListConfirmLimo(await _networkFactory!.getListCustomerConfirmLimo(_accessToken!));
    emitter(state);
  }

  void _updateStatusCustomerConfirmMapEvent(UpdateStatusCustomerConfirmMapEvent event, Emitter<LimoConfirmState> emitter)async{
    emitter(LimoConfirmLoading());
    UpdateStatusCustomerRequestBody request = UpdateStatusCustomerRequestBody(
        id:event.idTrungChuyen.toString().split(','),
        status: event.status,
        ghiChu:""
    );
    LimoConfirmState state = _handleUpdateStatusCustomer(await _networkFactory!.updateGroupStatusCustomer(request,_accessToken!),event.idLaiXeTC.toString());
    emitter(state);
  }

  void _limoConfirm(LimoConfirm event, Emitter<LimoConfirmState> emitter)async{
    emitter(LimoConfirmLoading());
    var objData = {
      'EVENT':'TAIXE_LIMO_XACNHAN',
    };
    List<String> idLXTC = [];
    idLXTC.add(event.listTaiXeTC);
    TranferCustomerRequestBody request = TranferCustomerRequestBody(
        title: event.title,
        body: event.body,
        data:objData,
        idTaiKhoans: idLXTC
    );
    LimoConfirmState state =  _handleTransferCustomerLimo(await _networkFactory!.sendNotification(request,_accessToken!));
    emitter(state);
  }


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
      CustomerLimoConfirm response = CustomerLimoConfirm.fromJson(data as Map<String,dynamic>);
      _mainBloc.listCustomerConfirm = response.data!;
      response.data!.forEach((element) {
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
          customerNews.soKhach = customerNews.soKhach! + 1;
          String listIdTC = customerNews.idTrungChuyen.toString() + ',' + customer.idTrungChuyen.toString();
          customerNews.idTrungChuyen = listIdTC;
          listCustomerConfirmLimos.removeWhere((rm) => rm.idTaiXe == customerNews.idTaiXe && rm.ngayChay == customerNews.ngayChay && rm.thoiGianDi == customerNews.thoiGianDi && rm.tenTuyenDuong == customerNews.tenTuyenDuong);
          listCustomerConfirmLimos.add(customerNews);
        }
      });
      _mainBloc.listCustomerConfirmLimo = listCustomerConfirmLimos;
      _mainBloc.tongChuyenXacNhan = listCustomerConfirmLimos.length;
      _mainBloc.tongKhachXacNhan = response.data!.length;
      return GetListCustomerConfirmLimoSuccess();
    } catch (e) {
      return LimoConfirmFailure(e.toString());
    }
  }

  void getMainBloc(BuildContext context) {
    _mainBloc = BlocProvider.of<MainBloc>(context);
  }
}