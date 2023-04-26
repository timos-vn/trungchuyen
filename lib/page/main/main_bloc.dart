import 'dart:io';
import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart' as libGetX;
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/models/database/dbhelper.dart';
import 'package:trungchuyen/models/entity/customer.dart';
import 'package:trungchuyen/models/entity/notification_of_limo.dart';
import 'package:trungchuyen/models/network/request/tranfer_customer_request.dart';
import 'package:trungchuyen/models/network/request/update_status_customer_request.dart';
import 'package:trungchuyen/models/network/response/detail_trips_limo_reponse.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
import 'package:trungchuyen/models/network/response/list_customer_confirm_response.dart';
import 'package:trungchuyen/models/network/response/list_of_group_awaiting_customer_response.dart';
import 'package:trungchuyen/models/network/response/list_of_group_limo_customer_response.dart';
import 'package:trungchuyen/models/network/response/unread_count_response.dart';
import 'package:trungchuyen/models/network/service/network_factory.dart';
import 'package:trungchuyen/page/waiting/waiting_bloc.dart';
import 'package:trungchuyen/service/soket_io_service.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/utils/const.dart';
import 'package:trungchuyen/utils/utils.dart';
import '../notification_api.dart';
import 'main_event.dart';
import 'main_state.dart';



class MainBloc extends Bloc<MainEvent, MainState> {
  int userId = 0;
  NetWorkFactory? _networkFactory;
  BuildContext context;
  // MapLimoBloc _mapLimoBloc;

  SharedPreferences? _pref;
  int _prePosition = 0;
  SharedPreferences? get pref => _pref;
  late SocketIOService socketIOService;
  String? get token => _pref?.getString(Const.ACCESS_TOKEN) ?? "";

  List<ListOfGroupAwaitingCustomerBody> listOfGroupAwaitingCustomer = [];
  List<ListOfGroupLimoCustomerResponseBody> listCustomerLimo = [];
  List<DetailTripsResponseBody> listOfDetailTrips = [];
  List<DetailTripsResponseBody> listOfDetailTripsTC = [];
  List<DetailTripsResponseBody> listCustomerToPickUpSuccess = [];
  List<CustomerLimoConfirmBody> listCustomerConfirmLimo = [];
  List<CustomerLimoConfirmBody> listCustomerConfirm = [];
  List<DsKhachs> listOfDetailTripLimo = [];

  List<Customer> listTaiXeLimo = [];
  List<DsKhachs> listTaiXeTC = [];

  late WaitingBloc _waitingBloc;
  String trips = '';
  String timeStart = '';
  bool blocked = false;
  int idKhungGio = 0;
  int idVanPhong = 0;
  String ngayTC = '';
  int loaiKhach = 0;
  bool isOnline = false;
  bool isInProcessPickup = false;
  int currentNumberCustomerOfList=0;
  int soKhachDaDonDuoc = 0;
  int tongKhach = 0;
  int soKhachHuy = 0;
  bool viewDetailTC = false;

  // FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  // FirebaseMessaging firebaseMessaging;
  static final _messaging = FirebaseMessaging.instance;
  int countNotifyUnRead=0;
  String _deviceToken = '';
  String? _accessToken;
  String? get accessToken => _accessToken;
  String? _refreshToken;
  String? get refreshToken => _refreshToken;
  bool isLock = false;
  int role = 0;
  String username = '';
  List<String> listDriver = [];
  String idUser = '';
  int tongKhachXacNhan  = 0;
  int tongChuyenXacNhan = 0;
  List<Map<String, dynamic>> listLocation = [];
  DatabaseHelper db = DatabaseHelper();
  List<DetailTripsResponseBody> listCustomer = [];
  List<DetailTripsResponseBody> listDriverLimo = [];
  List<Customer> listInfo = [];
  DateFormat format = DateFormat("dd/MM/yyyy");
  DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
  List<NotificationOfLimo> listNotificationOfLimo = [];

  String? dateTimeDetailLimoTrips;
  int idLimoTrips = 0;
  int idLimoTime = 0;
  List<DsKhachs> listOfDetailLimoTrips = [];
  int totalCustomerCancel = 0;
  int totalCustomer = 0;


  init(BuildContext context) async{
    _waitingBloc = WaitingBloc(context);
    // _mapLimoBloc = MapLimoBloc(context);
    if (this.context == null) {
      this.context = context;
    }
  }

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    Utils.showForegroundNotification(context, message.notification!.title.toString(), message.notification!.body.toString(), onTapNotification: () {
    },);
  }


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
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (savedMessageId != message.messageId)
        savedMessageId  = message.messageId.toString();
      else
        return;
      print("onMessage$savedMessageId");
      subscribeToTopic(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (savedMessageId != message.messageId)
        savedMessageId  = message.messageId.toString();
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
        String title = message.notification!.title.toString();
        String body = message.notification!.body!;
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
            title:message.notification!.title.toString(),
            body: message.notification!.body!,
            payload:'LIMO_THONGBAO_TAIXETC'
        );
        listOfGroupAwaitingCustomer.clear();
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
           title:message.notification!.title.toString(),
           body: message.notification!.body!,
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
           title:message.notification!.title.toString(),
           body: 'Bạn nhận được $soKhach khách từ $_nameTXTC',
           payload:'TAIXE_TRUNGCHUYEN_GIAOKHACH_LIMO'
       );
       add(GetListCustomerConfirm());
     }
    }
    else if(message.data['EVENT'] == 'TAIXE_LIMO_XACNHAN'){
      NotificationApi.showNotification(
          title:message.notification!.title.toString(),
          body: message.notification!.body!,
          payload:'TAIXE_LIMO_XACNHAN'
      );
      add(GetListCustomerConfirm());
    }
    else{
      NotificationApi.showNotification(
          title:message.notification!.title.toString(),
          body: message.notification!.body!,
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

  MainBloc(this.context) : super(InitialMainState()){
    _networkFactory = NetWorkFactory(context);
    socketIOService = Get.find<SocketIOService>();
    registerUpPushNotification();
    _listenToPushNotifications();
    on<GetPrefsMain>(_getPrefs);
    on<GetListDetailTripsLimoMain>(_getListDetailTripsLimoMain);
    on<GetListDetailTripsTC>(_getListDetailTripsTC);
    on<AddNotificationOfLimo>(_addNotificationOfLimo);
    on<GetListNotificationOfLimo>(_getListNotificationOfLimo);
    on<AddOldCustomerItemList>(_addOldCustomerItemList);
    on<DeleteCustomerFormDB>(_deleteCustomerFormDB);
    on<GetListTaiXeLimo>(_getListTaiXeLimo);
    on<UpdateTaiXeLimo>(_updateTaiXeLimo);
    on<ConfirmWithTXTC>(_confirmWithTXTC);
    on<GetListCustomerConfirm>(_getListCustomerConfirm);
    on<GetListTripsLimo>(_getListTripsLimo);
    on<GetLocationEvent>(_getLocationEvent);
    on<UpdateStatusCustomerEvent>(_updateStatusCustomerEvent);
    on<GetListGroupCustomer>(_getListGroupCustomer);
    on<NavigateBottomNavigation>(_navigateBottomNavigation);
    on<NavigateProfile>(_navigateProfile);
    on<ChangeTitleAppbarEvent>(_changeTitleAppbarEvent);
    on<NavigateToPay>(_navigateToPay);
    on<NavigateToNotification>(_navigateToNotification);
    on<GetCountNotificationUnRead>(_getCountNotificationUnRead);
    on<LogoutMainEvent>(_logoutMainEvent);

  }

  void _getPrefs(GetPrefsMain event, Emitter<MainState> emitter)async{
    emitter(MainLoading());
    _pref = await SharedPreferences.getInstance();
    _accessToken = _pref!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _pref!.getString(Const.REFRESH_TOKEN) ?? "";
    username = _pref!.getString(Const.PHONE_NUMBER) ?? "";
    role = int.parse(_pref!.getString(Const.CHUC_VU) ?? '0');
    idUser = _pref!.getString(Const.USER_ID) ??'';
    emitter(GetPrefsSuccess());
  }

  void _getListDetailTripsLimoMain(GetListDetailTripsLimoMain event, Emitter<MainState> emitter)async{
    emitter(MainLoading());
    MainState state = _handleGetListOfDetailLimoTrips(await _networkFactory!.getDetailTripsLimo(_accessToken!,event.date.toString(),event.idTrips
        .toString(),event.idTime.toString()));
    emitter(state);
  }

  void _getListDetailTripsTC(GetListDetailTripsTC event, Emitter<MainState> emitter)async{
    emitter(MainLoading());
    MainState state = _handleGetListOfDetailTrips(
        await _networkFactory!.getDetailTrips(
            event.date.toString(),_accessToken!,event.date,event.idRoom.toString(),
            event.idTime.toString(),event.typeCustomer.toString()
        ),event.date,event.idRoom,event.idTime,event.typeCustomer
    );
    emitter(state);
  }

  void _addNotificationOfLimo(AddNotificationOfLimo event, Emitter<MainState> emitter)async{
    emitter(MainLoading());
    await db.addNotificationLimo(event.notificationOfLimo);
    listNotificationOfLimo = await getListNotificationOfLimoFromDb();
    emitter(GetListNotificationOfLimoSuccess());
  }

  void _getListNotificationOfLimo(GetListNotificationOfLimo event, Emitter<MainState> emitter)async{
    emitter(MainLoading());
    listNotificationOfLimo = await getListNotificationOfLimoFromDb();
    if (!Utils.isEmpty(listNotificationOfLimo)) {
      listNotificationOfLimo.forEach((element) {
        Utils.showDialogReceiveCustomerFormTC(context: context, laiXeTC: element.nameTC.toString(),
            sdtLaiXeTC:  element.phoneTC, soKhach:  element.numberCustomer,date: '').then((value){
          if(value == true){
            db.removeNotificationLimo(element.idTrungChuyen.toString());
            print('Xac Nhan');
            add(UpdateStatusCustomerEvent(status: 10,idTrungChuyen: element.idTrungChuyen?.split(',')));
            add(ConfirmWithTXTC(
                'Thông báo','Xác nhận thành công',element.idDriverTC!.split(',')
            ));
          }else{
            print('Update Huy');
          }
        });
      });
      emitter(GetListNotificationOfLimoSuccess());
      return;
    }
    emitter(GetListNotificationOfLimoSuccess());
  }

  void _addOldCustomerItemList(AddOldCustomerItemList event, Emitter<MainState> emitter)async{
    emitter(MainLoading());
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
    emitter(GetCustomerListSuccess());
    add(GetCustomerItemList());
  }

  void _deleteCustomerFormDB(DeleteCustomerFormDB event, Emitter<MainState> emitter)async{
    emitter(MainLoading());
    await db.remove(event.idTC);
    listInfo = await getListFromDb();
    emitter(GetCustomerListSuccess());
    add(GetCustomerItemList());
  }

  void _getListTaiXeLimo(GetListTaiXeLimo event, Emitter<MainState> emitter)async{
    emitter(MainLoading());
    listTaiXeLimo = await getListTXLimoFromDb();
    if (Utils.isEmpty(listTaiXeLimo)) {
      emitter (GetListTaiXeLimoSuccess());
      return;
    }
    emitter(GetListTaiXeLimoSuccess());
  }

  void _updateTaiXeLimo(UpdateTaiXeLimo event, Emitter<MainState> emitter)async{
    emitter(MainLoading());
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
    emitter(GetListTaiXeLimoSuccess());
    add(GetListTaiXeLimo());
  }

  void _confirmWithTXTC(ConfirmWithTXTC event, Emitter<MainState> emitter)async{
    emitter(MainLoading());
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
    MainState state =  _handleLimoConfirmWithTC(await _networkFactory!.sendNotification(request,_accessToken!));
    emitter(state);
  }

  void _getListCustomerConfirm(GetListCustomerConfirm event, Emitter<MainState> emitter)async{
    emitter(MainLoading());
    MainState state = _handleGetListConfirmLimo(await _networkFactory!.getListCustomerConfirmLimo(_accessToken!));
    emitter(state);
  }

  void _getListTripsLimo(GetListTripsLimo event, Emitter<MainState> emitter)async{
    emitter(MainLoading());
    MainState state = _handleAwaitingCustomer(await _networkFactory!.getListCustomerLimo(_accessToken!,event.date));
    emitter(state);
  }

  void _getLocationEvent(GetLocationEvent event, Emitter<MainState> emitter)async{
    emitter(MainLoading());
    emitter(GetLocationSuccess(event.makerID,event.lat,event.lng));
  }

  void _updateStatusCustomerEvent(UpdateStatusCustomerEvent event, Emitter<MainState> emitter)async{
    emitter(MainLoading());
    UpdateStatusCustomerRequestBody request = UpdateStatusCustomerRequestBody(
        id:event.idTrungChuyen,
        status: event.status,
        ghiChu: event.note
    );
    MainState state = _handleUpdateStatusCustomer(await _networkFactory!.updateGroupStatusCustomer(request,_accessToken!),event.status!);
    emitter(state);
  }

  void _getListGroupCustomer(GetListGroupCustomer event, Emitter<MainState> emitter)async{
    emitter(MainLoading());
    MainState state = _handleGroupCustomer(await _networkFactory!.groupCustomerAWaiting(_accessToken!,event.date));
    emitter(state);
  }

  void _navigateBottomNavigation(NavigateBottomNavigation event, Emitter<MainState> emitter)async{
    emitter(MainLoading());
    int position = event.position;
    if (state is MainPageState) {
      if (_prePosition == position) return;
    }
    _prePosition = position;
    emitter(MainPageState(position));
  }

  void _navigateProfile(NavigateProfile event, Emitter<MainState> emitter)async{
    emitter(MainLoading());
    emitter(MainProfile());
  }

  void _changeTitleAppbarEvent(ChangeTitleAppbarEvent event, Emitter<MainState> emitter)async{
    emitter(MainLoading());
    emitter(ChangeTitleAppbarSuccess(title: event.title));
  }

  void _navigateToPay(NavigateToPay event, Emitter<MainState> emitter)async{
    emitter(MainLoading());
    emitter(NavigateToPayState());
  }

  void _navigateToNotification(NavigateToNotification event, Emitter<MainState> emitter)async{
    emitter(MainLoading());
    emitter(NavigateToNotificationState());
  }

  void _getCountNotificationUnRead(GetCountNotificationUnRead event, Emitter<MainState> emitter)async{
    emitter(MainLoading());
    MainState  state = _handleUnreadCountNotify(await _networkFactory!.readNotification(_accessToken!));
    emitter(state);
  }

  void _logoutMainEvent(LogoutMainEvent event, Emitter<MainState> emitter)async{
    emitter(MainLoading());
    Utils.removeData(_pref!);
    _prePosition = 0;
    countNotifyUnRead = 0;
    emitter(LogoutSuccess());
  }


  MainState _handleGetListOfDetailLimoTrips(Object data) {
    if (data is String) return MainFailure(data);
    try {
      DetailTripsLimo response = DetailTripsLimo.fromJson(data as Map<String,dynamic>);
      listOfDetailLimoTrips = response.data!.dsKhachs!;
      totalCustomerCancel = response.data!.khachHuy!;
      totalCustomer = response.data!.tongKhach!;
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
      DetailTripsResponse response = DetailTripsResponse.fromJson(data as Map<String,dynamic>);
      //listOfDetailTrips = response.data;
      listCustomer = response.data!;
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
            tongKhach = tongKhach + element.soKhach!;
          }
        });
      }
      listCustomer.sort((a,b){
        //a.trangThaiTC.compareTo(b.trangThaiTC)
        if(a.trangThaiTC == 5) return -1;
        if(b.trangThaiTC == 5) return 1;
        if(a.trangThaiTC == 2) return -1;
        if(b.trangThaiTC == 2) return 1;
        if(a.trangThaiTC! > b.trangThaiTC!) return 1;
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
      ListOfGroupLimoCustomerResponse response = ListOfGroupLimoCustomerResponse.fromJson(data as Map<String,dynamic>);
      listCustomerLimo = response.data!;
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
      CustomerLimoConfirm response = CustomerLimoConfirm.fromJson(data as Map<String,dynamic>);
      listCustomerConfirm = response.data!;
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
          customerNews.soKhach = customerNews.soKhach! + 1;
          String listIdTC = customerNews.idTrungChuyen.toString()+ ',' + customer.idTrungChuyen.toString();
          customerNews.idTrungChuyen = listIdTC;
          listCustomerConfirmLimo.remove(customerNews);
          listCustomerConfirmLimo.add(customerNews);
        }
      });
      tongChuyenXacNhan = listCustomerConfirmLimo.length;
      tongKhachXacNhan = response.data!.length;
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
      ListOfGroupAwaitingCustomer response = ListOfGroupAwaitingCustomer.fromJson(data as Map<String,dynamic>);
      listOfGroupAwaitingCustomer = response.data!;
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
      UnreadCountResponse response = UnreadCountResponse.fromJson(data as Map<String,dynamic>);
      countNotifyUnRead = response.unreadTotal ?? 0;
      return CountNotificationSuccess();
    } catch (e) {
      print(e.toString());
      return MainFailure('Error'.tr);
    }
  }

  Future showDialogTransferCustomer({required BuildContext context, required String content, Function? accept, Function? cancel, bool dismissible: false}) => showDialog(
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
                                            child: SpinKitPouringHourGlass(
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
