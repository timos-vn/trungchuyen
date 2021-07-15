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
import 'main_event.dart';
import 'main_state.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background Notification");
  Utils.showForegroundNotification(contexts, message.notification.title, message.notification.body, onTapNotification: () {
  },);
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
  List<DetailTripsLimoReponseBody> listOfDetailTripLimo = new List<DetailTripsLimoReponseBody>();

  List<Customer> listTaiXeLimo = new List<Customer>();
  List<DetailTripsLimoReponseBody> listTaiXeTC = new List<DetailTripsLimoReponseBody>();

  WaitingBloc _waitingBloc;
  String trips;
  String timeStart;
  String testing = 'A';
  bool blocked;
  int idKhungGio;
  int idVanPhong;
  String ngayTC;
  int loaiKhach;
  bool isOnline = false;
  bool isInProcessPickup = false;
  int currentNumberCustomerOfList=0;
  int soKhachDaDonDuoc = 0;

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  FirebaseMessaging firebaseMessaging;
  int countNotifyUnRead;
  String _deviceToken;
  int countApproval = 0;
  String _accessToken;
  String get accessToken => _accessToken;
  String _refreshToken;
  String get refreshToken => _refreshToken;
  bool isLock = false;
  bool isDeleteAll = false;
  String role;
  String username;
  Iterable markers;
  String idUser;
  List<Map<String, dynamic>> listLocation = new List<Map<String, dynamic>>();
  DatabaseHelper db = DatabaseHelper();
  List<Customer> listCustomer = new List<Customer>();
  List<NotificationCustomerOfTC> listNotificationCustomer = new List<NotificationCustomerOfTC>();
  List<NotificationOfLimo> listNotificationOfLimo = new List<NotificationOfLimo>();
  static final _messaging = FirebaseMessaging.instance;
  void setCountAfterRead() {
    countNotifyUnRead = countNotifyUnRead <= 0 ? 0 : countNotifyUnRead - 1;
  }

  Future<void> updateCount(int count) async {
    countApproval = countApproval - count;
    print('updateCount: $countApproval');
  }

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
      add(GetCountNotificationUnRead());
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

  _listenToPushNotifications() {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(badge: true, alert: true, sound: true);
    contexts = context;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage");
      subscribeToTopic(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      subscribeToTopic(message);
      print('onMessageOpenedApp');
    });

  }

  void subscribeToTopic(RemoteMessage message){
    if(message.data['EVENT'] == 'TRUNGCHUYEN_THONGBAO_TAIXE'){
      String item = message.data['IdTrungChuyen'];
      List<String> listId = item.replaceAll('[', '').replaceAll(']', '').replaceAll('\"', '').split(',');
      NotificationCustomerOfTC notificationCustomer = new NotificationCustomerOfTC(
          idTrungChuyen: item,
          chuyen: message.data['Chuyen'],
          thoiGian: message.data['ThoiGian'],
          loaiKhach: message.data['LoaiKhach']
      );
      Utils.showForegroundNotification(context, message.notification.title, message.notification.body, onTapNotification: () {
        add(NavigateToNotification());
      },);
      add(AddNotificationOfTC(notificationCustomer));

      if(socketIOService.socket.connected)
      {
        socketIOService.socket.emit("TAIXE_TRUNGCHUYEN_CAPNHAT_TRANGTHAI_KHACH");
      }
      if( message.data['LoaiKhach'] == '1'){
        add(UpdateStatusCustomerEvent(status: 2,idTrungChuyen:listId));
        print('Update Nhan don');
      }else{
        add(UpdateStatusCustomerEvent(status: 5,idTrungChuyen: listId));
        print('Update Nhan tra');
      }
      if(!Utils.isEmpty(listOfGroupAwaitingCustomer)){
        listOfGroupAwaitingCustomer.clear();
      }
      DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
      add(GetListGroupCustomer(parseDate));
      if(!Utils.isEmpty(listCustomer) && (listCustomer[0].idKhungGio.toString().trim() == message.data['IdKhungGio'].toString().trim() && listCustomer[0].idVanPhong.toString().trim() == message.data['IdVanPhong'].toString().trim())){
       trips = message.data['ThoiGian'] + ' - ' + message.data['NgayTrungChuyen'];
       idKhungGio = int.parse(message.data['IdKhungGio']);
       idVanPhong = int.parse(message.data['IdVanPhong']);
        DateFormat format = DateFormat("dd/MM/yyyy");
        add(GetListDetailTripsTC(format.parse(message.data['NgayTrungChuyen']),message.data['IdVanPhong'],message.data['IdKhungGio'],message.data['LoaiKhach']));
      }
    }
    else if(message.data['EVENT'] == 'LIMO_THONGBAO_TAIXE'){
      String title = message.notification.title;
      String body = message.notification.body;
      Utils.showForegroundNotification(context, title, body, onTapNotification: () {},);
      DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
      add(GetListTripsLimo(parseDate));
    }
    else if(message.data['EVENT'] == 'LIMO_THONGBAO_TAIXETC'){
      if(!Utils.isEmpty(listOfGroupAwaitingCustomer)){
        listOfGroupAwaitingCustomer.clear();
      }
      DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
      add(GetListGroupCustomer(parseDate));
      if(!Utils.isEmpty(listCustomer)){
        DateFormat format = DateFormat("dd/MM/yyyy");
        add(GetListDetailTripsTC(format.parse(ngayTC),idVanPhong.toString(),idKhungGio.toString(),loaiKhach.toString()));
      }
    }
    else if((message.data['EVENT'] == 'TRUNGCHUYEN_THONGBAO_TAIXE_TDK' || message.data['EVENT'] == 'TRUNGCHUYEN_THONGBAO_TAIXE_KHACHHUY')){
      Utils.showForegroundNotification(context, message.notification.title, message.notification.body, onTapNotification: () {
        add(NavigateToNotification());
      },);
      String item = message.data['IdTrungChuyen'];
      isLock = false;
      add(KhachHuyOrDoiTaiXe(item));
      DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
      add(GetListGroupCustomer(parseDate));
    }
    else if(message.data['EVENT'] == 'TAIXE_TRUNGCHUYEN_GIAOKHACH_LIMO'){
      Utils.showForegroundNotification(context, message.notification.title, message.notification.body, onTapNotification: () {
        add(NavigateToNotification());
      },);
      add(GetListCustomerConfirm());
    }
    else if(message.data['EVENT'] == 'TAIXE_LIMO_XACNHAN'){

      Utils.showForegroundNotification(context, message.notification.title, message.notification.body, onTapNotification: () {
        add(NavigateToNotification());
      },);
      add(GetListCustomerConfirm());
    }
    else{
      String title = message.notification.title;
      String body = message.notification.body;
      Utils.showForegroundNotification(context, title, body, onTapNotification: () {
        add(NavigateToNotification());
      },);
    }
  }
///
//   void _registerNotification() {
//
//     print('_registerNotification');
//     if (Platform.isIOS) getIosPermission();
//     firebaseMessaging.configure(
//       // ignore: missing_return
//       onMessage: (Map<String, dynamic> message) {
//         print("-------- $message");
//         print("--------");
//         print(role);
//         print(message['EVENT']);
//         print(message['aps']['alert']['title']);
//         print(message['aps']['alert']['body']);
//         print(message['ThoiGian']);
//         print(message['LoaiKhach']);
//         print("--------");
//         try {
//           FlutterRingtonePlayer.play(
//             android: AndroidSounds.notification,
//             ios: IosSounds.triTone,
//           );
//           if(Platform.isAndroid){
//             if(message['data']['EVENT'] == 'TRUNGCHUYEN_THONGBAO_TAIXE'){
//               /// trong chuyến vẫn thêm được khách - giống như trong chuyến huỷ được khách
//               ///
//               ///
//               ///
//               String item = message['data']['IdTrungChuyen'];
//               List<String> listId = item.replaceAll('[', '').replaceAll(']', '').replaceAll('\"', '').split(',');
//               NotificationCustomerOfTC notificationCustomer = new NotificationCustomerOfTC(
//                   idTrungChuyen: item,
//                   chuyen: message['data']['Chuyen'],
//                   thoiGian: message['data']['ThoiGian'],
//                   loaiKhach: message['data']['LoaiKhach']
//               );
//               String title = message['notification']['title'];
//               String body = message['notification']['body'];
//               Utils.showForegroundNotification(context, title, body, onTapNotification: () {
//                 add(NavigateToNotification());
//               },);
//               add(AddNotificationOfTC(notificationCustomer));
//
//               if(socketIOService.socket.connected)
//               {
//                 socketIOService.socket.emit("TAIXE_TRUNGCHUYEN_CAPNHAT_TRANGTHAI_KHACH");
//               }
//               if( message['data']['LoaiKhach'] == '1'){
//                 add(UpdateStatusCustomerEvent(status: 2,idTrungChuyen:listId));
//                 print('Update Nhan don');
//               }else{
//                 add(UpdateStatusCustomerEvent(status: 5,idTrungChuyen: listId));
//                 print('Update Nhan tra');
//               }
//               listOfGroupAwaitingCustomer.clear();
//               DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
//               add(GetListGroupCustomer(parseDate));
//             }
//             else if((message['data']['EVENT'] == 'TRUNGCHUYEN_THONGBAO_TAIXE_TDK' || message['data']['EVENT'] == 'TRUNGCHUYEN_THONGBAO_TAIXE_KHACHHUY')){
//               String title = message['notification']['title'];
//               String body = message['notification']['body'];
//               Utils.showForegroundNotification(context, title, body, onTapNotification: () {
//                 add(NavigateToNotification());
//               },);
//               String item = message['data']['IdTrungChuyen'];
//               isLock = false;
//               add(KhachHuyOrDoiTaiXe(item));
//               DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
//               add(GetListGroupCustomer(parseDate));
//             }
//             else if(message['data']['EVENT'] == 'TAIXE_TRUNGCHUYEN_GIAOKHACH_LIMO'){
//               String title = message['notification']['title'];
//               String body = message['notification']['body'];
//               Utils.showForegroundNotification(context, title, body, onTapNotification: () {
//                 add(NavigateToNotification());
//               },);
//               add(GetListCustomerConfirm());
//             }
//             else if(message['data']['EVENT'] == 'TAIXE_LIMO_XACNHAN'){
//               String title = message['notification']['title'];
//               String body = message['notification']['body'];
//               Utils.showForegroundNotification(context, title, body, onTapNotification: () {
//                 add(NavigateToNotification());
//               },);
//               add(GetListCustomerConfirm());
//             }
//             else{
//               if(Platform.isAndroid){
//                 String title = message['notification']['title'];
//                 String body = message['notification']['body'];
//                 Utils.showForegroundNotification(context, title, body, onTapNotification: () {
//                   add(NavigateToNotification());
//                 },);
//               }
//               else if(Platform.isIOS){
//                 String title = message['notification'];
//                 String body = message['notification']['body'];
//                 print(title);
//                 print(body);
//                 Utils.showForegroundNotification(context, title, body, onTapNotification: () {
//                   add(NavigateToNotification());
//                 });
//               }
//             }
//           }
//           else if(Platform.isIOS){
//             if(message['EVENT'] == 'TRUNGCHUYEN_THONGBAO_TAIXE'){
//               /// trong chuyến vẫn thêm được khách - giống như trong chuyến huỷ được khách
//               ///
//               ///
//               ///
//               String item = message['IdTrungChuyen'];
//               List<String> listId = item.replaceAll('[', '').replaceAll(']', '').replaceAll('\"', '').split(',');
//               NotificationCustomerOfTC notificationCustomer = new NotificationCustomerOfTC(
//                   idTrungChuyen: item,
//                   chuyen: message['Chuyen'],
//                   thoiGian: message['ThoiGian'],
//                   loaiKhach: message['LoaiKhach']
//               );
//               Utils.showForegroundNotification(context,message['aps']['alert']['title'], message['aps']['alert']['body'], onTapNotification: () {
//                 add(NavigateToNotification());
//               },);
//               add(AddNotificationOfTC(notificationCustomer));
//               if(socketIOService.socket.connected)
//               {
//                 socketIOService.socket.emit("TAIXE_TRUNGCHUYEN_CAPNHAT_TRANGTHAI_KHACH");
//               }
//               if( message['LoaiKhach'] == '1'){
//                 add(UpdateStatusCustomerEvent(status: 2,idTrungChuyen:listId));
//                 print('Update Nhan don');
//               }else{
//                 add(UpdateStatusCustomerEvent(status: 5,idTrungChuyen: listId));
//                 print('Update Nhan tra');
//               }
//               listOfGroupAwaitingCustomer.clear();
//               DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
//               add(GetListGroupCustomer(parseDate));
//             }
//             else if((message['EVENT'] == 'TRUNGCHUYEN_THONGBAO_TAIXE_TDK' || message['EVENT'] == 'TRUNGCHUYEN_THONGBAO_TAIXE_KHACHHUY')){
//               Utils.showForegroundNotification(context,message['aps']['alert']['title'], message['aps']['alert']['body'], onTapNotification: () {
//                 add(NavigateToNotification());
//               },);
//               String item = message['IdTrungChuyen'];
//               isLock = false;
//               add(KhachHuyOrDoiTaiXe(item));
//               DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
//               add(GetListGroupCustomer(parseDate));
//             }
//             else if(message['EVENT'] == 'TAIXE_TRUNGCHUYEN_GIAOKHACH_LIMO'){
//               String title = message['aps']['alert']['title'];
//               String body = message['aps']['alert']['body'];
//               Utils.showForegroundNotification(context, title, body, onTapNotification: () {
//                 add(NavigateToNotification());
//               });
//               add(GetListCustomerConfirm());
//             }
//             else if(message['EVENT'] == 'TAIXE_LIMO_XACNHAN'){
//               String title = message['aps']['alert']['title'];
//               String body = message['aps']['alert']['body'];
//               Utils.showForegroundNotification(context, title, body, onTapNotification: () {
//                 add(NavigateToNotification());
//               });
//               add(GetListCustomerConfirm());
//             }
//             else{
//               String title = message['aps']['alert']['title'];
//               String body = message['aps']['alert']['body'];
//               print(title);
//               print(body);
//               Utils.showForegroundNotification(context, title, body, onTapNotification: () {
//                 add(NavigateToNotification());
//               });
//             }
//           }
//         } catch (e) {
//           logger.e(e.toString());
//         }
//       },
//       // ignore: missing_return
//       onResume: (Map<String, dynamic> message) {
//         print('on resume $message');
//         add(NavigateToNotification());
//       },
//       // ignore: missing_return
//       onLaunch: (Map<String, dynamic> message) {
//         print('on launch $message');
//         add(NavigateToNotification());
//       },
//     );
//     print('subscribeToTopic 1');
//     firebaseMessaging.subscribeToTopic(Const.TOPIC);
//   }
///
//   void getIosPermission() {
//     print('subscribeToTopic 2');
//     firebaseMessaging.requestNotificationPermissions(
//         IosNotificationSettings(sound: true, badge: true, alert: true));
//     firebaseMessaging.onIosSettingsRegistered
//         .listen((IosNotificationSettings settings) {
//       logger.d("Settings registered: $settings");
//     });
//   }

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
      role = _pref.getString(Const.CHUC_VU) ?? "";
      idUser = _pref.getString(Const.USER_ID) ??'';
    }
    else if(event is GetListDetailTripsTC){
      yield MainLoading();
      MainState state = _handleGetListOfDetailTrips(await _networkFactory.getDetailTrips(_accessToken,event.date,event.idRoom.toString(),event.idTime.toString(),event.typeCustomer.toString()));
      yield state;
    }
    else if(event is KhachHuyOrDoiTaiXe){
      yield InitialMainState();
      listCustomer = await getListFromDb();
      Customer oldCustomer = Customer();
      List<String> listIdTCNew = new List<String>();
      if (!Utils.isEmpty(listCustomer)) {
        String deleteIdTC;
        Customer newsCustomer;
        List<String> listId = event.idTC.replaceAll('[', '').replaceAll(']', '').replaceAll('\"', '').split(',');
        String idTCOld;
        int counter = 0;
        listCustomer.forEach((element) {
          counter = listCustomer.length;
          newsCustomer = element;
          List<String> listIdTCOld = element.idTrungChuyen.split(',');
          idTCOld = element.idTrungChuyen;
          listIdTCNew.addAll(listIdTCOld);
         try{
           listIdTCOld.forEach((itemOld) {
             final customerIDTCNews = listId.firstWhere((item) => item == itemOld, orElse: () => null);
             if (customerIDTCNews != null){
               print('TRUE 2: ${itemOld.toString()}');

               newsCustomer.soKhach = element.soKhach - 1;
               if(counter >0){
                 counter--;
               }
               if(newsCustomer.soKhach == 0){
                 print('TRUE 3: ${newsCustomer.soKhach}');
                 if(counter == 0){
                   blocked = false;
                 }
                 // isDeleteAll = true;
                 add(DeleteCustomerHuyOrDoiTaiFormDB(customerIDTCNews));
                 // deleteIdTC = idTCOld;
               }else{
                 print('TRUE 4: ${newsCustomer.idTrungChuyen}');
                 if(newsCustomer.idTrungChuyen.split(',').length == 1){
                   listIdTCNew.remove(customerIDTCNews);
                   newsCustomer.idTrungChuyen = listIdTCNew.join(',');
                   blocked = false;
                   add(DeleteCustomerHuyOrDoiTaiFormDB(idTCOld));
                 }else{
                   listIdTCNew.remove(customerIDTCNews);
                   newsCustomer.idTrungChuyen = listIdTCNew.join(',');
                   add(UpdateKhachHuyOrDoiTaiXe(idTCOld,newsCustomer));
                 }
               }
             }
           });
         }catch(e){
           print(e);
         }
        });
        if(isDeleteAll == true){
          isDeleteAll = false;

        }
        add(GetCustomerItemList());
      }
      yield GetListOfDetailTripsTCSuccess();
    }

    else if(event is AddNotificationOfLimo) {
      yield InitialMainState();
      await db.addNotificationLimo(event.notificationOfLimo);
      listNotificationOfLimo = await getListNotificationOfLimoFromDb();
      yield GetListNotificationOfLimoSuccess();
      // add(GetCustomerItemList());
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

    else if(event is GetListNotificationCustomerTC){
      yield InitialMainState();
      listNotificationCustomer = await getListNotificationOfTCFromDb();
      if (!Utils.isEmpty(listNotificationCustomer)) {

        listNotificationCustomer.forEach((element) {
          List<String> listId = element.idTrungChuyen.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').split(',');
          Utils.showDialogAssignReceiveCustomer(context,element.chuyen,element.thoiGian,element.loaiKhach, "title", 'body',
              onTapCancelNotification: () {
                print('onTapCancelNotification');
                db.removeNotificationCustomer(element.idTrungChuyen);
                if(socketIOService.socket.connected)
                {
                  socketIOService.socket.emit("TAIXE_TRUNGCHUYEN_CAPNHAT_TRANGTHAI_KHACH");
                }
                add(UpdateStatusCustomerEvent(status: 1,idTrungChuyen: listId));
                print('Update Huy');
              },
              onTapAcceptNotification: (){
                print('onTapAcceptNotification');
                /// 1. don
               db.removeNotificationCustomer(element.idTrungChuyen);
                if(socketIOService.socket.connected)
                {
                  socketIOService.socket.emit("TAIXE_TRUNGCHUYEN_CAPNHAT_TRANGTHAI_KHACH");
                }
                if( element.loaiKhach == '1'){
                  add(UpdateStatusCustomerEvent(status: 2,idTrungChuyen:listId));
                  print('Update Nhan don');
                }else{
                  add(UpdateStatusCustomerEvent(status: 5,idTrungChuyen: listId));
                  print('Update Nhan tra');
                }
              }
          );
        });
        yield GetListNotificationCustomerSuccess();
        return;
      }
      yield GetListNotificationCustomerSuccess();
    }

    else if (event is AddNotificationOfTC) {
      yield InitialMainState();
      await db.addNotificationCustomer(event.notificationCustomerOfTC);
      listNotificationCustomer = await getListNotificationOfTCFromDb();
      yield GetListNotificationOfTC();
      // add(GetCustomerItemList());
    }

    else if (event is AddOldCustomerItemList) {
      yield InitialMainState();
      await db.addNew(event.customer);
      listCustomer = await getListFromDb();
      yield GetCustomerListSuccess();
      add(GetCustomerItemList());
    }

    else if (event is DeleteCustomerFormDB) {
      yield InitialMainState();
      await db.remove(event.idTC);
      listCustomer = await getListFromDb();
      yield GetCustomerListSuccess();
      add(GetCustomerItemList());
    }

    else if (event is DeleteCustomerHuyOrDoiTaiFormDB) {
      yield InitialMainState();
      await db.remove(event.idTC);
      listCustomer = await getListFromDb();
      yield GetCustomerListSuccess();
      // add(GetCustomerItemList());
    }

    else if(event is UpdateKhachHuyOrDoiTaiXe){
      yield InitialMainState();
      await db.updateCustomerHuyOrDoiTaiXe(event.idTCOld,event.customer);
      //listCustomer = await getListFromDb();
      yield GetListOfDetailTripsTCSuccess();
      // add(GetCustomerItemList());
    }
    else if(event is UpdateCustomerItemList){
      yield InitialMainState();
      await db.updateCustomer(event.customer);
      listCustomer = await getListFromDb();
      yield GetCustomerListSuccess();
      add(GetCustomerItemList());
    }

    else if (event is DeleteItem) {
      yield MainLoading();
      deleteItems(event.index);
      await db.remove(event.idTC);
      listCustomer = await getListFromDb();
      yield GetCustomerListSuccess();
  //    add(GetCustomerItemList());
    }

    else if(event is GetCustomerItemList){
      yield InitialMainState();
      listCustomer = await getListFromDb();
      if (Utils.isEmpty(listCustomer)) {
        yield GetListOfDetailTripsTCSuccess();
        return;
      }
      yield GetListOfDetailTripsTCSuccess();
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
      await db.addDriverLimo(event.customer);
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
      MainState state = _handleUpdateStatusCustomer(await _networkFactory.updateGroupStatusCustomer(request,_accessToken));
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
    else if (event is GetCountProduct) {
      yield InitializeDb();
      await updateCount(event.count);
      yield GetCountNotiSuccess();
    }

    // if (event is GetPermissionEvent) {
    //   yield MainLoading();
    //   await updateCount();
    //   Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
    //   GeolocationStatus geolocationStatus =
    //       await geolocator.checkGeolocationPermissionStatus();
    //   yield InitializeDb();
    // }

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
      // if (countNotifyUnRead == null || countNotifyUnRead < 0) countNotifyUnRead = 0;
      yield state;
    }
    else if (event is LogoutMainEvent) {
        yield MainLoading();
        Utils.removeData(_pref);
        _prePosition = 0;
        countNotifyUnRead = 0;
        countApproval = 0;
        yield LogoutSuccess();
      }
  }

  MainState _handleGetListOfDetailTrips(Object data) {
    if (data is String) return MainFailure(data);
    try {
      listCustomer.clear();
      soKhachDaDonDuoc = 0;
      DetailTripsResponse response = DetailTripsResponse.fromJson(data);
      listOfDetailTrips = response.data;
      db.deleteAll();
      listOfDetailTrips.forEach((element) {
        Customer customer = new Customer(
            idTrungChuyen: element.idTrungChuyen,
            idTaiXeLimousine : element.idTaiXeLimousine,
            hoTenTaiXeLimousine : element.hoTenTaiXeLimousine,
            dienThoaiTaiXeLimousine : element.dienThoaiTaiXeLimousine,
            tenXeLimousine : element.tenXeLimousine,
            bienSoXeLimousine : element.bienSoXeLimousine,
            tenKhachHang : element.tenKhachHang,
            soDienThoaiKhach :element.soDienThoaiKhach,
            diaChiKhachDi :element.diaChiKhachDi,
            toaDoDiaChiKhachDi:element.toaDoDiaChiKhachDi,
            diaChiKhachDen:element.diaChiKhachDen,
            toaDoDiaChiKhachDen:element.toaDoDiaChiKhachDen,
            diaChiLimoDi:element.diaChiLimoDi,
            toaDoLimoDi:element.toaDoLimoDi,
            diaChiLimoDen:element.diaChiLimoDen,
            toaDoLimoDen:element.toaDoLimoDen,
            loaiKhach:element.loaiKhach,
            trangThaiTC: element.trangThaiTC,
            soKhach:1,
            statusCustomer: element.trangThaiTC,
            chuyen: trips,
            totalCustomer: listOfDetailTripsTC.length,
            idKhungGio: idKhungGio,
            idVanPhong: idVanPhong,
            ngayTC: ngayTC
        );
        if(element.trangThaiTC == 4){
          soKhachDaDonDuoc = soKhachDaDonDuoc +1;
        }
        var contain =  listCustomer.where((phone) => phone.soDienThoaiKhach == element.soDienThoaiKhach);
        if (contain.isEmpty){
          listCustomer.add(customer);
          db.addNew(customer);
        }else{
          final customerNews = listCustomer.firstWhere((item) => item.soDienThoaiKhach == element.soDienThoaiKhach);
          if (customerNews != null){
            customerNews.soKhach = customerNews.soKhach + 1;
            String listIdTC = customerNews.idTrungChuyen + ',' + customer.idTrungChuyen;
            customerNews.idTrungChuyen = listIdTC;
          }
          listCustomer.remove(customerNews);
          listCustomer.add(customerNews);
          add(DeleteCustomerFormDB(customer.idTrungChuyen));
          add(AddOldCustomerItemList(customerNews));
        }
      });
      currentNumberCustomerOfList = listCustomer.length;
      return GetListOfDetailTripsTCSuccess();
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
      CustomerLimoConfirm response = CustomerLimoConfirm.fromJson(data);
      listCustomerConfirmLimo.clear();
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
            soKhach: 1
        );
        var contain =  listCustomerConfirmLimo.where((phone) => phone.soDienThoaiKhach == element.soDienThoaiKhach);
        if (contain.isEmpty){
          listCustomerConfirmLimo.add(customer);
        }else{
          final customerNews = listCustomerConfirmLimo.firstWhere((item) => item.soDienThoaiKhach == element.soDienThoaiKhach);
          if (customerNews != null){
            customerNews.soKhach = customerNews.soKhach + 1;
            String listIdTC = customerNews.idTrungChuyen + ',' + customer.idTrungChuyen;
            customerNews.idTrungChuyen = listIdTC;
          }
          listCustomerConfirmLimo.remove(customerNews);
          listCustomerConfirmLimo.add(customerNews);
        }
      });
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
  Future<List<NotificationCustomerOfTC>> getListNotificationOfTCFromDb() {
    return db.fetchAllNotificationCustomer();
  }

  Future<List<Customer>> getListTXLimoFromDb() {
    return db.fetchAllDriverLimo();
  }

  void deleteItems(int index) {
    listCustomer.removeAt(index);
  }

  Customer getCustomer(int i) {
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

  MainState _handleUpdateStatusCustomer(Object data) {
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
      return RefreshMainState();
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
                                                          listTaiXeLimo[index].hoTenTaiXeLimousine?.toString()??"",
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
                                                              "( ${listTaiXeLimo[index].dienThoaiTaiXeLimousine?.toString()??""} )",
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
                                                              listTaiXeLimo[index].bienSoXeLimousine?.toString()??'',
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
                                                              '${listTaiXeLimo[index].soKhach?.toString()??'0'}',
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
                                  itemCount: listTaiXeLimo.length),
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
