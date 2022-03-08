import 'dart:convert';
import 'dart:io';
import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart' as libGetX;
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/models/database/dbhelper.dart';
import 'package:trungchuyen/models/entity/customer.dart';
import 'package:trungchuyen/models/entity/notification_of_limo.dart';
import 'package:trungchuyen/models/entity/notification_trung_chuyen.dart';
import 'package:trungchuyen/models/network/request/tranfer_customer_request.dart';
import 'package:trungchuyen/models/network/request/update_status_customer_request.dart';
import 'package:trungchuyen/models/network/request/update_token_request.dart';
import 'package:trungchuyen/models/network/response/detail_trips_limo_reponse.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
import 'package:trungchuyen/models/network/response/list_customer_confirm_response.dart';
import 'package:trungchuyen/models/network/response/list_of_group_awaiting_customer_response.dart';
import 'package:trungchuyen/models/network/response/list_of_group_limo_customer_response.dart';
import 'package:trungchuyen/models/network/response/unread_count_response.dart';
import 'package:trungchuyen/models/network/service/network_factory.dart';
import 'package:trungchuyen/page/map_limo/map_limo_bloc.dart';
import 'package:trungchuyen/page/waiting/waiting_bloc.dart';
import 'package:trungchuyen/page/waiting/waiting_event.dart';
import 'package:trungchuyen/service/soket_io_service.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/utils/const.dart';
import 'package:trungchuyen/utils/log.dart';
import 'package:trungchuyen/utils/utils.dart';
import '../../test.dart';
import '../notification_api.dart';
import 'main_event.dart';
import 'main_state.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background Notification");
  NotificationApi.showNotification(
      title:message.notification.title,
      body: message.notification.body,
      payload:'Background Notification'
  );
}
BuildContext contexts;
class MainBloc extends Bloc<MainEvent, MainState> {
  int userId;
  NetWorkFactory _networkFactory;
  BuildContext context;
  MapLimoBloc _mapLimoBloc;

  SharedPreferences _pref;
  int _prePosition = 0;
  SharedPreferences get pref => _pref;
  SocketIOService socketIOService;
  String get token => _pref?.getString(Const.ACCESS_TOKEN) ?? "";

  List<ListOfGroupAwaitingCustomerBody> listOfGroupAwaitingCustomer = new List<ListOfGroupAwaitingCustomerBody>();
  List<ListOfGroupLimoCustomerResponseBody> listCustomerLimo = new List<ListOfGroupLimoCustomerResponseBody>();
  List<DetailTripsResponseBody> listOfDetailTrips = new List<DetailTripsResponseBody>();
  List<DetailTripsResponseBody> listOfDetailTripsTC = new List<DetailTripsResponseBody>();
  List<DetailTripsResponseBody> listCustomerToPickUpSuccess = new List<DetailTripsResponseBody>();
  List<CustomerLimoConfirmBody> listCustomerConfirmLimo = new List<CustomerLimoConfirmBody>();
  List<CustomerLimoConfirmBody> listCustomerConfirm = new List<CustomerLimoConfirmBody>();
  List<DsKhachs> listOfDetailTripLimo = new List<DsKhachs>();

  List<Customer> listTaiXeLimo = new List<Customer>();
  List<DsKhachs> listTaiXeTC = new List<DsKhachs>();

  WaitingBloc _waitingBloc;
  String trips;
  String timeStart;
  bool blocked;
  int idKhungGio;
  int idVanPhong;
  String ngayTC;
  int loaiKhach;
  bool isOnline = false;
  bool isInProcessPickup = false;
  int currentNumberCustomerOfList=0;
  int soKhachDaDonDuoc = 0;
  int tongKhach = 0;
  int soKhachHuy = 0;
  bool viewDetailTC = false;

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  FirebaseMessaging firebaseMessaging;
  int countNotifyUnRead=0;
  String _deviceToken;
  String _accessToken;
  String get accessToken => _accessToken;
  String _refreshToken;
  String get refreshToken => _refreshToken;
  bool isLock = false;
  int role;
  String username;
  List<String> listDriver = List<String>();
  String idUser;
  int tongKhachXacNhan;
  int tongChuyenXacNhan;
  List<Map<String, dynamic>> listLocation = new List<Map<String, dynamic>>();
  DatabaseHelper db = DatabaseHelper();
  List<DetailTripsResponseBody> listCustomer = new List<DetailTripsResponseBody>();
  List<DetailTripsResponseBody> listDriverLimo = new List<DetailTripsResponseBody>();
  List<Customer> listInfo = new List<Customer>();
  DateFormat format = DateFormat("dd/MM/yyyy");
  DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
  List<NotificationOfLimo> listNotificationOfLimo = new List<NotificationOfLimo>();
  static final _messaging = FirebaseMessaging.instance;

  String dateTimeDetailLimoTrips;int idLimoTrips;int idLimoTime;
  List<DsKhachs> listOfDetailLimoTrips = new List<DsKhachs>();
  int totalCustomerCancel;
  int totalCustomer;

  MainBloc()   {
    socketIOService = Get.find<SocketIOService>();
    registerUpPushNotification();
    _listenToPushNotifications();

  }

  init(BuildContext context) async{
    _waitingBloc = WaitingBloc(context);
    _mapLimoBloc = MapLimoBloc(context);
    if (this.context == null) {
      this.context = context;
      _networkFactory = NetWorkFactory(context);
    }
  }



  @override
  MainState get initialState => InitialMainState();

  registerUpPushNotification() {
    //REGISTER REQUIRED FOR IOS
    if (Platform.isIOS) {
      _messaging.requestPermission();
    }
    _messaging.getToken().then((value) {
      if (value == null) return;

      print('token $value');
    });
  }

  String savedMessageId  = "";

  _listenToPushNotifications() {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(badge: true, alert: true, sound: true);
    contexts = context;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (savedMessageId != message.messageId)
        savedMessageId  = message.messageId;
      else
        return;
      print("onMessage$savedMessageId");
      subscribeToTopic(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (savedMessageId != message.messageId)
        savedMessageId  = message.messageId;
      else
        return;
      subscribeToTopic(message);
      print('onMessageOpenedApp');
    });
  }

  void subscribeToTopic(RemoteMessage message){
    if(message.data['EVENT'] == 'LIMO_THONGBAO_TAIXE' || message.data['EVENT'] == 'THONGBAO_DANHSACHVE_THAYDOI_CHO_TAIXE_LIMO' ){
      if(role == 7){
        print('role: $role - $parseDate');
        String title = message.notification.title;
        String body = message.notification.body;
        add(GetListTripsLimo(parseDate));
        if(dateTimeDetailLimoTrips != null && idLimoTrips > 0 && idLimoTime > 0){
          print('TXLIMO Chức vụ = 7');
          add(GetListDetailTripsLimoMain(
              date: dateTimeDetailLimoTrips,
              idTrips: idLimoTrips,idTime: idLimoTime
          ));
        }
        NotificationApi.showNotification(
            title:title,
            body: body,
            payload:'LIMO_THONGBAO_TAIXE'
        );
      }
    }
    else if(message.data['EVENT'] == 'LIMO_THONGBAO_TAIXETC' || message.data['EVENT'] == 'TRUNGCHUYEN_THONGBAO_TAIXE'){
      ///Limo sửa thông tin Khách hàng.
      ///Unable to log event: analytics library is missing => đã fix
      if(role == 3){
        NotificationApi.showNotification(
            title:message.notification.title,
            body: message.notification.body,
            payload:'LIMO_THONGBAO_TAIXETC'
        );
        if(listOfGroupAwaitingCustomer != null){
          listOfGroupAwaitingCustomer.clear();
        }
        if(viewDetailTC == false){
         add(GetListGroupCustomer(parseDate));
        }else{
          add(GetListDetailTripsTC(format.parse(ngayTC),idVanPhong,idKhungGio,loaiKhach));
        }
      }
    }
    else if((message.data['EVENT'] == 'TRUNGCHUYEN_THONGBAO_TAIXE_TDK' || message.data['EVENT'] == 'TRUNGCHUYEN_THONGBAO_TAIXE_KHACHHUY')){
      ///Limo huỷ Khách.
      /// Điều hành Trung chuyển : Chuyển tài xế
     if(role == 3){
       NotificationApi.showNotification(
           title:message.notification.title,
           body: message.notification.body,
           payload:'TRUNGCHUYEN_THONGBAO_TAIXE_TDK'
       );
       isLock = false;
       if(!Utils.isEmpty(listOfGroupAwaitingCustomer)){
         listOfGroupAwaitingCustomer.clear();
       }
       if(listCustomer.length == 1 && listCustomer[0].soKhach == 1){
         db.deleteAll();
         blocked = false;
         idKhungGio = 0;
         idVanPhong = 0;
         loaiKhach = 0;
         ngayTC = '';
         trips ='';
         listCustomer.clear();
       }
       if(viewDetailTC == false){
         add(GetListGroupCustomer(parseDate));
       }else{
         add(GetListDetailTripsTC(format.parse(ngayTC),idVanPhong,idKhungGio,loaiKhach));
       }
     }
    }
    else if(message.data['EVENT'] == 'TAIXE_TRUNGCHUYEN_GIAOKHACH_LIMO'){
      ///Bạn nhận được $numberCustomer khách từ LXTC $_nameLXTC.
     if(role == 7){

       List<String> listIdTXLimo = message.data['listIdTXLimo'].toString().split(',');
       List<String> listSoKhach = message.data['numberCustomer'].toString().split(',');
       String _nameTXTC = message.data['nameLXTC'];
       String soKhach = '';
       listIdTXLimo.forEach((element) {
         if(idUser == element){
           int index = listIdTXLimo.indexOf(element);
           soKhach = listSoKhach[index];
         }
       });
       NotificationApi.showNotification(
           title:message.notification.title,
           body: 'Bạn nhận được $soKhach khách từ $_nameTXTC',
           payload:'TAIXE_TRUNGCHUYEN_GIAOKHACH_LIMO'
       );
       add(GetListCustomerConfirm());
     }
    }
    else if(message.data['EVENT'] == 'TAIXE_LIMO_XACNHAN'){
      NotificationApi.showNotification(
          title:message.notification.title,
          body: message.notification.body,
          payload:'TAIXE_LIMO_XACNHAN'
      );
      add(GetListCustomerConfirm());
    }
    else{
      NotificationApi.showNotification(
          title:message.notification.title,
          body: message.notification.body,
          payload:"None"
      );
    }
  }

  void handleTypeNotification(String type) {
    switch (type) {
      default:
        add(NavigateProfile());
    }
  }

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (_pref == null) {
      _pref = await SharedPreferences.getInstance();
      _accessToken = _pref.getString(Const.ACCESS_TOKEN) ?? "";
      _refreshToken = _pref.getString(Const.REFRESH_TOKEN) ?? "";
      username = _pref.getString(Const.PHONE_NUMBER) ?? "";
      role = int.parse(_pref.getString(Const.CHUC_VU) ?? 0);
      idUser = _pref.getString(Const.USER_ID) ??'';

    }
    if(event is GetListDetailTripsLimoMain){
      yield MainLoading();
      MainState state = _handleGetListOfDetailLimoTrips(await _networkFactory.getDetailTripsLimo(_accessToken,event.date,event.idTrips
          .toString(),event.idTime.toString()));
      yield state;
    }
    else if(event is GetListDetailTripsTC){
      yield MainLoading();
      MainState state = _handleGetListOfDetailTrips(
          await _networkFactory.getDetailTrips(
              event.date.toString(),_accessToken,event.date,event.idRoom.toString(),
              event.idTime.toString(),event.typeCustomer.toString()
          ),event.date,event.idRoom,event.idTime,event.typeCustomer
      );
      yield state;
    }
    else if(event is AddNotificationOfLimo) {
      yield InitialMainState();
      await db.addNotificationLimo(event.notificationOfLimo);
      listNotificationOfLimo = await getListNotificationOfLimoFromDb();
      yield GetListNotificationOfLimoSuccess();
    }

    else if(event is GetListNotificationOfLimo){
      yield InitialMainState();
      listNotificationOfLimo = await getListNotificationOfLimoFromDb();
      if (!Utils.isEmpty(listNotificationOfLimo)) {
        listNotificationOfLimo.forEach((element) {
          Utils.showDialogReceiveCustomerFormTC(context: context, laiXeTC: element.nameTC,
              sdtLaiXeTC:  element.phoneTC, soKhach:  element.numberCustomer,date: '').then((value){
            if(value == true){
              db.removeNotificationLimo(element.idTrungChuyen);
              print('Xac Nhan');
              add(UpdateStatusCustomerEvent(status: 10,idTrungChuyen: element.idTrungChuyen.split(',')));
              add(ConfirmWithTXTC(
                'Thông báo','Xác nhận thành công',element.idDriverTC.split(',')
              ));
            }else{
              print('Update Huy');
            }
          });
        });
        yield GetListNotificationOfLimoSuccess();
        return;
      }
      yield GetListNotificationOfLimoSuccess();
    }

    else if (event is AddOldCustomerItemList) {
      yield InitialMainState();
      Customer customer = new Customer(
        idTrungChuyen: event.customer.idTrungChuyen,
        idTaiXeLimousine : event.customer.idTaiXeLimousine,
        hoTenTaiXeLimousine : event.customer.hoTenTaiXeLimousine,
        dienThoaiTaiXeLimousine : event.customer.dienThoaiTaiXeLimousine,
        tenXeLimousine : event.customer.tenXeLimousine,
        bienSoXeLimousine : event.customer.bienSoXeLimousine,
        tenKhachHang : event.customer.tenKhachHang,
        soDienThoaiKhach :event.customer.soDienThoaiKhach,
        diaChiKhachDi :event.customer.diaChiKhachDi,
        toaDoDiaChiKhachDi:event.customer.toaDoDiaChiKhachDi,
        diaChiKhachDen:event.customer.diaChiKhachDen,
        toaDoDiaChiKhachDen:event.customer.toaDoDiaChiKhachDen,
        diaChiLimoDi:event.customer.diaChiLimoDi,
        toaDoLimoDi:event.customer.toaDoLimoDi,
        diaChiLimoDen:event.customer.diaChiLimoDen,
        toaDoLimoDen:event.customer.toaDoLimoDen,
        loaiKhach:event.customer.loaiKhach,
        trangThaiTC: event.customer.trangThaiTC,
        soKhach:1,
        chuyen: trips,
        totalCustomer: event.customer.totalCustomer,
        idKhungGio: idKhungGio,
        idVanPhong: idVanPhong,
        ngayTC: ngayTC,
      );
      await db.addNew(customer);
      listInfo = await getListFromDb();
      yield GetCustomerListSuccess();
      add(GetCustomerItemList());
    }

    else if (event is DeleteCustomerFormDB) {
      yield InitialMainState();
      await db.remove(event.idTC);
      listInfo = await getListFromDb();
      yield GetCustomerListSuccess();
      add(GetCustomerItemList());
    }

    else if(event is GetListTaiXeLimo){
          yield MainLoading();
          listTaiXeLimo = await getListTXLimoFromDb();
          if (Utils.isEmpty(listTaiXeLimo)) {
            yield GetListTaiXeLimoSuccess();
            return;
          }
          yield GetListTaiXeLimoSuccess();
        }

    else if(event is UpdateTaiXeLimo){
      yield InitialMainState();
      Customer customer = new Customer(
        idTrungChuyen: event.customer.idTrungChuyen,
        idTaiXeLimousine : event.customer.idTaiXeLimousine,
        hoTenTaiXeLimousine : event.customer.hoTenTaiXeLimousine,
        dienThoaiTaiXeLimousine : event.customer.dienThoaiTaiXeLimousine,
        tenXeLimousine : event.customer.tenXeLimousine,
        bienSoXeLimousine : event.customer.bienSoXeLimousine,
        tenKhachHang : event.customer.tenKhachHang,
        soDienThoaiKhach :event.customer.soDienThoaiKhach,
        diaChiKhachDi :event.customer.diaChiKhachDi,
        toaDoDiaChiKhachDi:event.customer.toaDoDiaChiKhachDi,
        diaChiKhachDen:event.customer.diaChiKhachDen,
        toaDoDiaChiKhachDen:event.customer.toaDoDiaChiKhachDen,
        diaChiLimoDi:event.customer.diaChiLimoDi,
        toaDoLimoDi:event.customer.toaDoLimoDi,
        diaChiLimoDen:event.customer.diaChiLimoDen,
        toaDoLimoDen:event.customer.toaDoLimoDen,
        loaiKhach:event.customer.loaiKhach,
        trangThaiTC: event.customer.trangThaiTC,
        soKhach:1,
        chuyen: trips,
        totalCustomer: event.customer.totalCustomer,
        idKhungGio: event.customer.idKhungGio,
        idVanPhong: event.customer.idVanPhong,
        ngayTC: event.customer.ngayTC,
      );
      await db.addDriverLimo(customer);
      listTaiXeLimo = await getListTXLimoFromDb();
      yield GetListTaiXeLimoSuccess();
      add(GetListTaiXeLimo());
    }

    else if(event is ConfirmWithTXTC){
      yield MainLoading();
      var objData = {
        'EVENT':'TAIXE_LIMO_XACNHAN',
        'idLimo':idUser
      };
      TranferCustomerRequestBody request = TranferCustomerRequestBody(
          title: event.title,
          body: event.body,
          data: objData,
          idTaiKhoans: event.listId
      );
      MainState state =  _handleLimoConfirmWithTC(await _networkFactory.sendNotification(request,_accessToken));
      yield state;
    }

    else if(event is GetListCustomerConfirm){
      yield MainLoading();
      MainState state = _handleGetListConfirmLimo(await _networkFactory.getListCustomerConfirmLimo(_accessToken));
      yield state;
    }

    else if(event is GetListTripsLimo){
      yield MainLoading();
      MainState state = _handleAwaitingCustomer(await _networkFactory.getListCustomerLimo(_accessToken,event.date));
      yield state;
    }

    else if(event is GetLocationEvent){
      yield InitialMainState();

      yield GetLocationSuccess(event.makerID,event.lat,event.lng);
    }

    else if(event is UpdateStatusCustomerEvent){
      yield MainLoading();
      UpdateStatusCustomerRequestBody request = UpdateStatusCustomerRequestBody(
        id:event.idTrungChuyen,
        status: event.status,
        ghiChu: event.note
      );
      MainState state = _handleUpdateStatusCustomer(await _networkFactory.updateGroupStatusCustomer(request,_accessToken),event.status);
      yield state;
    }

    else if(event is GetListGroupCustomer){
      yield MainLoading();
      MainState state = _handleGroupCustomer(await _networkFactory.groupCustomerAWaiting(_accessToken,event.date));
      yield state;
    }

    else if (event is NavigateBottomNavigation) {
      int position = event.position;
      if (state is MainPageState) {
        if (_prePosition == position) return;
      }
      _prePosition = position;
      yield MainLoading();
      yield MainPageState(position);
    }
    else if (event is NavigateProfile) {
      // For background and terminal
      yield MainLoading();
      yield MainProfile();
    }
    else if (event is ChangeTitleAppbarEvent) {
      yield ChangeTitleAppbarSuccess(title: event.title);
    }

    else if (event is NavigateToPay) {
      yield MainLoading();
      yield NavigateToPayState();
    }

    else if (event is NavigateToNotification) {
      yield MainLoading();
      yield NavigateToNotificationState();
    }
    else if (event is GetCountNotificationUnRead) {
      yield InitialMainState();
      MainState  state = _handleUnreadCountNotify(await _networkFactory.readNotification(_accessToken));
      yield state;
    }
    else if (event is LogoutMainEvent) {
        yield MainLoading();
        Utils.removeData(_pref);
        _prePosition = 0;
        countNotifyUnRead = 0;
        yield LogoutSuccess();
      }
  }

  MainState _handleGetListOfDetailLimoTrips(Object data) {
    if (data is String) return MainFailure(data);
    try {
      DetailTripsLimo response = DetailTripsLimo.fromJson(data);
      listOfDetailLimoTrips = response.data.dsKhachs;
      totalCustomerCancel = response.data.khachHuy;
      totalCustomer = response.data.tongKhach;
      return GetListOfDetailLimoTripsSuccess();
    } catch (e) {
      return MainFailure(e.toString());
    }
  }

  MainState _handleGetListOfDetailTrips(Object data, DateTime ngayChay, int idRoom, int idTime, int typeCustomer) {
    if (data is String) return MainFailure(data);
    try {

      listCustomer.clear();
      soKhachDaDonDuoc = 0;
      db.deleteAll();
      DetailTripsResponse response = DetailTripsResponse.fromJson(data);
      //listOfDetailTrips = response.data;
      listCustomer = response.data;
      // listOfDetailTrips.forEach((element) {
      //   DetailTripsResponseBody customer = new DetailTripsResponseBody(
      //       idTrungChuyen: element.idTrungChuyen,
      //       idTaiXeLimousine : element.idTaiXeLimousine,
      //       hoTenTaiXeLimousine : element.hoTenTaiXeLimousine,
      //       dienThoaiTaiXeLimousine : element.dienThoaiTaiXeLimousine,
      //       tenXeLimousine : element.tenXeLimousine,
      //       bienSoXeLimousine : element.bienSoXeLimousine,
      //       tenKhachHang : element.tenKhachHang,
      //       soDienThoaiKhach :element.soDienThoaiKhach,
      //       diaChiKhachDi :element.diaChiKhachDi,
      //       toaDoDiaChiKhachDi:element.toaDoDiaChiKhachDi,
      //       diaChiKhachDen:element.diaChiKhachDen,
      //       toaDoDiaChiKhachDen:element.toaDoDiaChiKhachDen,
      //       diaChiLimoDi:element.diaChiLimoDi,
      //       toaDoLimoDi:element.toaDoLimoDi,
      //       diaChiLimoDen:element.diaChiLimoDen,
      //       toaDoLimoDen:element.toaDoLimoDen,
      //       loaiKhach:element.loaiKhach,
      //       trangThaiTC: element.trangThaiTC,
      //       soKhach:1,
      //       chuyen: trips,
      //       totalCustomer: listOfDetailTripsTC.length,
      //       idKhungGio: idKhungGio,
      //       idVanPhong: idVanPhong,
      //       ngayTC: ngayTC,maVe: element.maVe,
      //       vanPhongDi: element.vanPhongDi,
      //       vanPhongDen: element.vanPhongDen
      //   );
      //   var contain =  listCustomer.where((phone) => phone.soDienThoaiKhach == element.soDienThoaiKhach);
      //   if (contain.isEmpty){
      //     listCustomer.add(customer);
      //     add(AddOldCustomerItemList(customer));
      //   }
      //   else {
      //     final customerNews = listCustomer.firstWhere((item) => item.soDienThoaiKhach == element.soDienThoaiKhach);
      //     if (customerNews != null){
      //       customerNews.soKhach = customerNews.soKhach + 1;
      //       String listIdTC = customerNews.idTrungChuyen + ',' + customer.idTrungChuyen;
      //       customerNews.idTrungChuyen = listIdTC;
      //     }
      //     listCustomer.removeWhere((item) => item.soDienThoaiKhach == customerNews.soDienThoaiKhach);
      //     listCustomer.add(customerNews);
      //     add(DeleteCustomerFormDB(customer.idTrungChuyen));
      //     add(AddOldCustomerItemList(customerNews));
      //   }
      // });
      tongKhach = 0;
      soKhachHuy = 0;
      if(!Utils.isEmpty(listCustomer)){
        listCustomer.forEach((element) {
          if(element.trangThaiTC == 12){
            soKhachHuy = soKhachHuy  + 1;
          }
          if(element.trangThaiTC == 4 || element.trangThaiTC == 8 || element.trangThaiTC == 12){
            soKhachDaDonDuoc =  soKhachDaDonDuoc + 1;
            tongKhach = tongKhach + element.soKhach;
          }
        });
      }
      listCustomer.sort((a,b){
        //a.trangThaiTC.compareTo(b.trangThaiTC)
        if(a.trangThaiTC == 5) return -1;
        if(b.trangThaiTC == 5) return 1;
        if(a.trangThaiTC == 2) return -1;
        if(b.trangThaiTC == 2) return 1;
        if(a.trangThaiTC > b.trangThaiTC) return 1;
        return 0;
      });
      print('131avb: ${soKhachHuy.toString()} / ${tongKhach.toString()}');
      currentNumberCustomerOfList = listCustomer.length;
      return GetListOfDetailTripsTCSuccess(ngayChay,idRoom,idTime,typeCustomer);
    } catch (e) {
      print(e.toString());
      return MainFailure(e.toString());
    }
  }

  MainState _handleAwaitingCustomer(Object data) {
    if (data is String) return MainFailure(data);
    try {
      ListOfGroupLimoCustomerResponse response = ListOfGroupLimoCustomerResponse.fromJson(data);
      listCustomerLimo = response.data;
      return GetListCustomerLimoSuccess();
    } catch (e) {
      print(e.toString());
      return MainFailure(e.toString());
    }
  }

  MainState _handleGetListConfirmLimo(Object data) {
    if (data is String) return MainFailure(data);
    try {
      tongKhachXacNhan = 0;
      tongChuyenXacNhan = 0;
      listCustomerConfirmLimo.clear();
      CustomerLimoConfirm response = CustomerLimoConfirm.fromJson(data);
      listCustomerConfirm = response.data;
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
        var contain =  listCustomerConfirmLimo.where((item) => (
            item.idTaiXe == element.idTaiXe
                &&
                item.ngayChay == element.ngayChay
                &&
                item.thoiGianDi == element.thoiGianDi
                &&
                item.tenTuyenDuong == element.tenTuyenDuong
        ));
        if (contain.isEmpty){
          listCustomerConfirmLimo.add(customer);
        }
        else{
          final customerNews = listCustomerConfirmLimo.firstWhere((item) =>
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
          listCustomerConfirmLimo.remove(customerNews);
          listCustomerConfirmLimo.add(customerNews);
        }
      });
      tongChuyenXacNhan = listCustomerConfirmLimo.length;
      tongKhachXacNhan = response.data.length;
      return GetListCustomerConfirmLimo();
    } catch (e) {
      print('Check: ${e.toString()}');
      return MainFailure(e.toString());
    }
  }

  Future<List<Customer>> getListFromDb() {
    return db.fetchAll();
  }
  Future<List<NotificationOfLimo>> getListNotificationOfLimoFromDb() {
    return db.fetchAllNotificationLimo();
  }

  Future<List<Customer>> getListTXLimoFromDb() {
    return db.fetchAllDriverLimo();
  }

  void deleteItems(int index) {
    listCustomer.removeAt(index);
  }

  DetailTripsResponseBody getCustomer(int i) {
    return listCustomer.elementAt(i);
  }


  MainState _handleLimoConfirmWithTC(Object data) {
    if (data is String) return MainFailure(data);
    try {
      return TXLimoConfirmWithTXTCSuccess();
    } catch (e) {
      print(e.toString());
      return MainFailure(e.toString());
    }
  }

  MainState _handleGroupCustomer(Object data) {
    if (data is String) return MainFailure(data);
    try {
      ListOfGroupAwaitingCustomer response = ListOfGroupAwaitingCustomer.fromJson(data);
      listOfGroupAwaitingCustomer = response.data;
      return GetListOfGroupCustomerSuccess();
    } catch (e) {
      print(e.toString());
      return MainFailure(e.toString());
    }
  }

  MainState _handleUpdateStatusCustomer(Object data, int status) {
    if (data is String) return MainFailure(data);
    try {
      return UpdateStatusCustomerSuccess();
    } catch (e) {
      print(e.toString());
      return MainFailure(e.toString());
    }
  }

  MainState _handleUnreadCountNotify(Object data) {
    if (data is String) return MainFailure(data);
    try {
      UnreadCountResponse response = UnreadCountResponse.fromJson(data);
      countNotifyUnRead = response.unreadTotal ?? 0;
      return CountNotificationSuccess();
    } catch (e) {
      print(e.toString());
      return MainFailure('Error'.tr);
    }
  }

  Future<bool> showDialogTransferCustomer({@required BuildContext context, @required String content, Function accept, Function cancel, bool dismissible: false}) => showDialog(
      barrierDismissible: dismissible,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return true;
          },
          child:  Center(
            child: Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
                height: 350,
                width: double.infinity,
                child: Material(
                    animationDuration: Duration(seconds: 3),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    child: Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16))),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Giao khách cho Limo',
                                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                      )),
                                ),
                              ),
                            )),
                        Expanded(
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(bottomRight: Radius.circular(16), bottomLeft: Radius.circular(16))),
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  separatorBuilder: (BuildContext context, int index) => Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                    ),
                                    child: Divider(),
                                  ),
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Lái xe Limo: ',
                                                      style: TextStyle(color: Colors.grey),
                                                    ),
                                                    Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text(
                                                          listDriverLimo[index].hoTenTaiXeLimousine?.toString()??"",
                                                          style: TextStyle(color: Colors.black),overflow: TextOverflow.ellipsis,maxLines: 2,
                                                        )),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          'SĐT: ',
                                                          style: TextStyle(color: Colors.grey),
                                                        )),
                                                    Expanded(
                                                        flex: 2,
                                                        child: Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Text(
                                                              "( ${listDriverLimo[index].dienThoaiTaiXeLimousine?.toString()??""} )",
                                                              style: TextStyle(color: Colors.grey,fontSize: 10),
                                                            )),),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          'BSX: ',
                                                          style: TextStyle(color: Colors.grey),
                                                        )),
                                                    Expanded(
                                                        flex: 2,
                                                        child: Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Text(
                                                              listDriverLimo[index].bienSoXeLimousine?.toString()??'',
                                                              style: TextStyle(color: Colors.black),
                                                            ))),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          'Số khách: ',
                                                          style: TextStyle(color: Colors.grey),
                                                        )),
                                                    Expanded(
                                                        flex: 2,
                                                        child: Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Text(
                                                              '${listDriverLimo[index].soKhach?.toString()??'0'}',
                                                              style: TextStyle(color: Colors.black),
                                                            ))),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Center(
                                            child: SpinKitPouringHourglass(
                                              color: Colors.orange,
                                              size: 40,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  itemCount: listDriverLimo.length),
                            )),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: Text(
                              'Xác nhận',
                              style: TextStyle(color: white),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.orange),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ),
        );
      });


}
