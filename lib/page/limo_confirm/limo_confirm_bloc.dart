import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/models/network/request/update_status_customer_request.dart';
import 'package:trungchuyen/models/network/response/list_customer_confirm_response.dart';
import 'package:trungchuyen/models/network/service/network_factory.dart';
import 'package:trungchuyen/service/soket_io_service.dart';
import 'package:trungchuyen/utils/const.dart';

import 'limo_confirm_event.dart';
import 'limo_confirm_state.dart';

class LimoConfirmBloc extends Bloc<LimoConfirmEvent,LimoConfirmState> {

  BuildContext context;
  NetWorkFactory _networkFactory;
  String _accessToken;
  String get accessToken => _accessToken;
  String _refreshToken;
  String get refreshToken => _refreshToken;
  SharedPreferences _prefs;
  SharedPreferences get prefs => _prefs;
  SocketIOService socketIOService;
  List<CustomerLimoConfirmBody> listCustomerConfirmLimo = new List<CustomerLimoConfirmBody>();
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
      LimoConfirmState state = _handleUpdateStatusCustomer(await _networkFactory.updateGroupStatusCustomer(request,_accessToken));
      yield state;
    }
  }

  @override
  // TODO: implement initialState
  LimoConfirmState get initialState => LimoConfirmInitial();

  LimoConfirmState _handleUpdateStatusCustomer(Object data) {
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
      CustomerLimoConfirm response = CustomerLimoConfirm.fromJson(data);
      listCustomerConfirmLimo = response.data;
      return GetListCustomerConfirmLimoSuccess();
    } catch (e) {
      print(e.toString());
      return LimoConfirmFailure(e.toString());
    }
  }
}