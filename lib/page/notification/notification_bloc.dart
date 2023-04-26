import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart' as libGetX;
import 'package:trungchuyen/models/network/response/notification_response.dart';
import 'package:trungchuyen/models/network/service/network_factory.dart';
import 'package:trungchuyen/utils/const.dart';
import 'package:trungchuyen/utils/utils.dart';

import 'notification_event.dart';
import 'notification_sate.dart';

class NotificationBloc extends Bloc<NotificationEvent,NotificationState>{
  NetWorkFactory? _networkFactory;
  BuildContext context;
  String? _accessToken;
  String? _refreshToken;
  String? _userId;
  SharedPreferences? _prefs;
  List<NotificationDataResponse> listNotification = [];
  bool isScroll = true;
  int _currentPage = 1;
  int _maxPage = 20;

  int? get currentPage => _currentPage;

  NotificationBloc(this.context) : super(NotificationInitial()){
    _networkFactory = NetWorkFactory(context);
    on<GetPrefs>(_getPrefs,);
    on<UpdateNotificationEvent>(_updateNotificationEvent);
    on<UpdateAllNotificationEvent>(_updateAllNotificationEvent);
    on<DeleteNotificationEvent>(_deleteNotificationEvent);
    on<GetListNotification>(_getListNotification);
  }

  void _getPrefs(GetPrefs event, Emitter<NotificationState> emitter)async{
    emitter(NotificationLoading());
    _prefs = await SharedPreferences.getInstance();
    _accessToken = _prefs!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _prefs!.getString(Const.REFRESH_TOKEN) ?? "";
    _userId = _prefs!.getString(Const.USER_ID) ?? "";
    emitter(GetPrefsSuccess());
  }

  void _updateNotificationEvent(UpdateNotificationEvent event, Emitter<NotificationState> emitter)async{
    emitter(NotificationLoading());
    NotificationState state = _handleUpdateNotification(await _networkFactory!.updateNotification(_accessToken!,event.notificationID));
    emitter(state);
  }

  void _updateAllNotificationEvent(UpdateAllNotificationEvent event, Emitter<NotificationState> emitter)async{
    emitter(NotificationLoading());
    NotificationState state = _handleUpdateNotification(await _networkFactory!.updateAllNotification(_accessToken!));
    emitter(state);
  }

  void _deleteNotificationEvent(DeleteNotificationEvent event, Emitter<NotificationState> emitter)async{
    emitter(NotificationLoading());
    NotificationState state = _handleUpdateNotification(await _networkFactory!.deleteNotification(_accessToken!,event.notificationID));
    emitter(state);
  }

  void _getListNotification(GetListNotification event, Emitter<NotificationState> emitter)async{
    emitter(NotificationLoading());
    bool isRefresh = event.isRefresh??false;
    bool isLoadMore = event.isLoadMore??false;
    bool isReload = event.isReLoad??false;
    emitter ((!isRefresh && !isLoadMore)
        ? NotificationLoading()
        : NotificationInitial());
    if(isReload == true){
      _currentPage = 1;
      NotificationState state = await handleCallApi(_currentPage);
      emitter(state);
    }
    if (isRefresh == true || isReload == true) {

      for (int i = 1; i <= _currentPage; i++) {
        NotificationState state = await handleCallApi(i);
        if (!(state is GetListNotificationSuccess)) return;
      }
      return;
    }
    if (isLoadMore && isScroll ==true) {
      isScroll = false;
      _currentPage++;
    }
    NotificationState state = await handleCallApi(_currentPage);
    emitter(state);
  }


  NotificationState _handleUpdateNotification(Object data){
    if(data is String) return UpdateNotificationFailure("Error".tr);
    try{
      return UpdateNotificationSuccess();
    }
    catch(e){
      return UpdateNotificationFailure(e.toString().tr);
    }
  }

  Future<NotificationState> handleCallApi(int pageIndex) async {
    NotificationState state = _handleGetListNotification(await _networkFactory!.getListNotification(_accessToken!,pageIndex,20),pageIndex);
    return state;
  }

  NotificationState _handleGetListNotification(Object data,int pageIndex){
    if(data is String) return GetListNotificationFailure("Error".tr);
    try{
      NotificationResponse response = NotificationResponse.fromJson(data as Map<String,dynamic>);
      _maxPage =  20;//Const.MAX_COUNT_ITEM
      List<NotificationDataResponse> list = response.data ?? [];
      if (!Utils.isEmpty(list) && listNotification.length >= (pageIndex - 1) * _maxPage + list.length) {
        listNotification.replaceRange((pageIndex - 1) * _maxPage, list.length < _maxPage ? (pageIndex * list.length) : (pageIndex * _maxPage), list);
      } else {
        if (_currentPage == 1) {
          listNotification = list;
        } else
          listNotification.addAll(list);
      }
      if (Utils.isEmpty(list))
        return EmptyDataState();
      else
        isScroll = true;
        return GetListNotificationSuccess();
    }catch(e){
      print(e.toString());
      return GetListNotificationFailure(e.toString().tr);
    }
  }
}