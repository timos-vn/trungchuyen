import 'dart:convert';
import 'dart:io';
import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart' as libGetX;
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/models/network/request/tranfer_customer_request.dart';
import 'package:trungchuyen/models/network/request/update_status_customer_request.dart';
import 'package:trungchuyen/models/network/request/update_token_request.dart';
import 'package:trungchuyen/models/network/response/detail_trips_limo_reponse.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
import 'package:trungchuyen/models/network/response/list_notification_response.dart';
import 'package:trungchuyen/models/network/response/list_of_group_awaiting_customer_response.dart';
import 'package:trungchuyen/models/network/service/network_factory.dart';
import 'package:flutter_animarker/lat_lng_interpolation.dart';
import 'package:trungchuyen/page/map_limo/map_limo_bloc.dart';
import 'package:trungchuyen/page/map_limo/map_limo_event.dart';
import 'package:trungchuyen/utils/const.dart';
import 'package:trungchuyen/utils/log.dart';
import 'package:trungchuyen/utils/utils.dart';
import 'main_event.dart';
import 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  int userId;
  NetWorkFactory _networkFactory;
  BuildContext context;
  MapLimoBloc _mapLimoBloc;
  SharedPreferences _pref;
  int _prePosition = 0;
  SharedPreferences get pref => _pref;

  String get token => _pref?.getString(Const.ACCESS_TOKEN) ?? "";

  List<ListOfGroupAwaitingCustomerBody> listOfGroupAwaitingCustomer = new List<ListOfGroupAwaitingCustomerBody>();
  List<ListOfGroupAwaitingCustomerBody> listCustomerLimo = new List<ListOfGroupAwaitingCustomerBody>();
  List<DetailTripsResponseBody> listOfDetailTrips = new List<DetailTripsResponseBody>();

  List<DetailTripsLimoReponseBody> listOfDetailTripLimo = new List<DetailTripsLimoReponseBody>();

  List<DetailTripsResponseBody> listTaiXeLimo = new List<DetailTripsResponseBody>();
  List<DetailTripsLimoReponseBody> listTaiXeTC = new List<DetailTripsLimoReponseBody>();

  String trips;
  String timeStart;
  String testing = 'A';
  bool blocked;
  int indexAwaitingList;
  bool isOnline = false;
  bool isInProcessPickup = false;
  int currentNumberCustomerOfList=0;

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  FirebaseMessaging _firebaseMessaging;
  int countNotifyUnRead;
  String _deviceToken;
  int countApproval = 0;
  String _accessToken;
  String get accessToken => _accessToken;
  String _refreshToken;
  String get refreshToken => _refreshToken;

  String _role;
  String username;
  Iterable markers;
  List<Map<String, dynamic>> listLocation = new List<Map<String, dynamic>>();


  void setCountAfterRead() {
    countNotifyUnRead = countNotifyUnRead <= 0 ? 0 : countNotifyUnRead - 1;
  }

  Future<void> updateCount(int count) async {
    countApproval = countApproval - count;
    print('updateCount: $countApproval');
  }

  MainBloc() : super(null) {
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((token) {
      print("token");
      print(token);
      _deviceToken = token;
     _pref?.setString(Const.DEVICE_TOKEN, token);
      add(UpdateTokenDiveEvent(_deviceToken));
    });
   _registerNotification();
//    add(GetCountProduct());
//    add(GetCountNoti(isRefresh: true));
  }

  init(BuildContext context) {
    _mapLimoBloc = MapLimoBloc(context);
    if (this.context == null) {
      this.context = context;
      _networkFactory = NetWorkFactory(context);

      // _orderBloc = ManageShopOrderBloc();
//      add(GetCountProduct());
//      add(GetCountNoti(isRefresh: true));
    }
  }

  @override
  MainState get initialState => InitialMainState();

  void _registerNotification() {
    if (Platform.isIOS) getIosPermission();
    _firebaseMessaging.configure(
      // ignore: missing_return
      onMessage: (Map<String, dynamic> message) {
        try {
          if(Platform.isAndroid){
            String title = message['notification']['title'];
            String body = message['notification']['body'];
            Utils.showForegroundNotification(context, title, body, onTapNotification: () {
              add(NavigateToNotification());
            });
          }
          else if(Platform.isIOS){
            String title = message['notification']['title'];
            String body = message['notification']['body'];
            // print(title);
            // print(body);
            Utils.showForegroundNotification(context, title, body, onTapNotification: () {
              add(NavigateToNotification());
            });
          }
          FlutterRingtonePlayer.play(
            android: AndroidSounds.notification,
            ios: IosSounds.triTone,
          );
          // NotificationData data = NotificationData.fromJson(json.decode(
          //     Platform.isAndroid
          //         ? message['data']//['payload']
          //         : message['data']));
          if(message['data']['EVENT'] == 'TRUNGCHUYEN_THONGBAO_TAIXE' && _role == '3'){
            String item = message['data']['IdChuyenTruyens'];
            List<String> listId = item.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').split(',');
            // Utils.showDialogAssign2(context: context, tripName: message['data']['Chuyen'], date: message['data']['ThoiGian'], typeCustomer: message['data']['LoaiKhach']).then((value){
            //   if(value == true){
            //     /// 1. don
            //     if( message['data']['LoaiKhach'] == '1'){
            //       add(UpdateStatusCustomerEvent(status: 2,idTrungChuyen:listId));
            //       print('Update Nhan don');
            //     }else{
            //       add(UpdateStatusCustomerEvent(status: 5,idTrungChuyen: listId));
            //       print('Update Nhan tra');
            //     }
            //   }else{
            //     add(UpdateStatusCustomerEvent(status: 1,idTrungChuyen: listId));
            //     print('Update Huy');
            //   }
            // });
          }
          /// đây là chỗ nhận data
          else if(message['data']['EVENT'] == 'TAIXE_TRUNGCHUYEN_CAPNHAT_TOADO' && _role != '3'){
            String item = message['data']['LOCATION'];
            String _location = item.replaceAll('{', '').replaceAll('}', '').replaceAll("\"","").replaceAll('lat', '').replaceAll('lng', '').replaceAll(':', '');

            var obj = {
              {"title": message['data']['FULLNAME'], "id": message['data']['PHONE'], "lat": _location.split(',')[0], "lon": _location.split(',')[1]},
            };

            try   {
              //0974629615
              //  subscriptions.add(_mapBloc.latLngStream.getAnimatedPosition("DriverMarker"));
           //   if(_mapLimoBloc.latLngStream.)
              String makerId = message['data']['PHONE'];
              add(GetLocationEvent(
                  makerId,double.parse( _location.split(',')[0]), double.parse( _location.split(',')[1])
              ));
             //  if(_mapLimoBloc.lsMarkerId.where((id) => id==makerId).length==0)
             //    {
             //      _mapLimoBloc.lsMarkerId.add(makerId);
             //      _mapLimoBloc.subscriptions.add(_mapLimoBloc.latLngStream.getAnimatedPosition(makerId));
             //    }
             // _mapLimoBloc.latLngStream.addLatLng(new LatLngInfo(double.parse( _location.split(',')[0]), double.parse( _location.split(',')[1]),makerId));
            }
            catch(e){}

            // lại như hôm trước. làm thế nào để lấy cái add ở đây
            // listLocation.addAll(obj);
            //  markers = Iterable.generate(AppConstant.list.length, (index) {
            //   return Marker(
            //       markerId: MarkerId(AppConstant.list[index]['id']),
            //       position: LatLng(
            //         AppConstant.list[index]['lat'],
            //         AppConstant.list[index]['lon'],
            //       ),
            //       infoWindow: InfoWindow(title: AppConstant.list[index]["title"])
            //   );
            // });
          }
          else if(message['data']['EVENT'] == 'TAIXE_TRUNGCHUYEN_GIAOKHACH_LIMO' && _role == '3'){
            String soKhach = message['data']['numberCustomer'];
            List<String> listSoKhach = soKhach.split('|');
            String item = message['data']['listId'];
            List<String> listId = item.split(',');
            String itemIdTC = message['data']['listIdTC'];
            List<String> listIdTC = itemIdTC.split(',');
            String numberCustomer;

            listId.forEach((element) {
              if(element == username){
                numberCustomer = listSoKhach[listId.indexOf(element)];
              }
            });
            print('numberCustomer : ${numberCustomer.toString()}');
            Utils.showDialogReceiveCustomerFormTC(context: context, laiXeTC: message['data']['nameTC'],
                sdtLaiXeTC: message['data']['phoneTC'], soKhach: numberCustomer.toString(),date: 'Null').then((value){
              if(value == true){
                print('Xac Nhan');
                add(UpdateStatusCustomerEvent(status: 10,idTrungChuyen: listId));
                add(ConfirmWithTXTC(
                  'Thông báo','Xác nhận thành công',listIdTC
                ));
              }else{

                print('Update Huy');
              }
            });
          }
          else if(message['data']['EVENT'] =='TAIXE_LIMO_XACNHAN' && _role == '3'){
            ///close popup
          }
          //add(GetCountNoti());
          // add(GetCountNotiSMS());
        } catch (e) {
          logger.e(e.toString());
        }
      },
      // ignore: missing_return
      onResume: (Map<String, dynamic> message) {
        logger.d('on resume $message');
        add(NavigateToNotification());
      },
      // ignore: missing_return
      onLaunch: (Map<String, dynamic> message) {
        logger.d('on launch $message');
        add(NavigateToNotification());
      },
    );
    _firebaseMessaging.subscribeToTopic(Const.TOPIC);
  }

  void getIosPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      logger.d("Settings registered: $settings");
    });
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
      _role = _pref.getString(Const.CHUC_VU) ?? "";
    }

    if(event is ConfirmWithTXTC){
      yield MainLoading();
      var objData = {
        'EVENT':'TAIXE_LIMO_XACNHAN',
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

    if(event is GetLocationEvent){
      yield InitialMainState();

      yield GetLocationSuccess(event.makerID,event.lat,event.lng);
    }
    if(event is UpdateStatusCustomerEvent){
      yield MainLoading();

      UpdateStatusCustomerRequestBody request = UpdateStatusCustomerRequestBody(
        id:event.idTrungChuyen,
        status: event.status,
        ghiChu: event.note
      );

      MainState state = _handleUpdateStatusCustomer(await _networkFactory.updateGroupStatusCustomer(request,_accessToken));
      yield state;
    }

    if(event is GetListGroupCustomer){
      yield MainLoading();
      MainState state = _handleGroupCustomer(await _networkFactory.groupCustomerAWaiting(_accessToken,event.date));
      yield state;
    }

    if(event is UpdateTokenDiveEvent){
      yield MainLoading();
      UpdateTokenRequestBody request = UpdateTokenRequestBody(
        deviceToken: event.deviceToken
      );
      await _networkFactory.updateToken(request,_accessToken);
      yield UpdateTokenSuccessState();
    }

    if (event is NavigateBottomNavigation) {
      int position = event.position;
      if (state is MainPageState) {
        if (_prePosition == position) return;
      }
      _prePosition = position;
      yield MainLoading();
      yield MainPageState(position);
    }
    if (event is NavigateProfile) {
      // For background and terminal
      yield MainLoading();
      yield MainProfile();
    }
    if (event is ChangeTitleAppbarEvent) {
      yield ChangeTitleAppbarSuccess(title: event.title);
    }
    if (event is GetCountProduct) {
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

    if (event is NavigateToPay) {
      yield MainLoading();
      yield NavigateToPayState();
    }

    if (event is NavigateToNotification) {
      yield MainLoading();
      yield NavigateToNotificationState();
    }

    // if (event is GetCountNoti) {
    //   yield MainLoading();
    //   MainState state = MainPageState(_prePosition);
    //     state = _handleUnreadCountNotify(await _networkFactory.countNotification(_accessToken));
    //   if (countNotifyUnRead == null || countNotifyUnRead < 0) countNotifyUnRead = 0;
    //   yield state;
    // }
      if (event is LogoutMainEvent) {
        yield MainLoading();
        Utils.removeData(_pref);
        _prePosition = 0;
        countNotifyUnRead = null;
        countApproval = 0;
        yield LogoutSuccess();
      }
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

  // MainState _handleUnreadCountNotify(Object data) {
  //   if (data is String) return MainFailure(data);
  //   try {
  //     UnreadCountResponse response = UnreadCountResponse.fromJson(data);
  //     countNotifyUnRead = response.unreadTotal ?? 0;
  //     return RefreshMainState();
  //   } catch (e) {
  //     print(e.toString());
  //     return MainFailure('Error'.tr);
  //   }
  // }

}
