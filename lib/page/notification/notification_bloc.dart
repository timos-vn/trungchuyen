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
  NetWorkFactory _networkFactory;
  BuildContext context;
  String _accessToken;
  String _refreshToken;
  String _userId;
  SharedPreferences _prefs;
  List<NotificationDataResponse> listNotification = new List<NotificationDataResponse>();
  bool isScroll = true;
  int _currentPage = 1;
  int _maxPage = Const.MAX_COUNT_ITEM;
  int get maxPage => _maxPage;
  int get currentPage => _currentPage;

  NotificationBloc(BuildContext context) {
    this.context = context;
    _networkFactory = NetWorkFactory(context);
  }

  @override
  // TODO: implement initialState
  NotificationState get initialState => NotificationInitial();

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event)async* {
    // TODO: implement mapEventToState
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      _accessToken = _prefs.getString(Const.ACCESS_TOKEN) ?? "";
      _refreshToken = _prefs.getString(Const.REFRESH_TOKEN) ?? "";
      _userId = _prefs.getString(Const.USER_ID) ?? "";
    }
    if(event is GetListNotification){
      bool isRefresh = event.isRefresh;
      bool isLoadMore = event.isLoadMore;
      bool isReload = event.isReLoad;
      yield ((!isRefresh && !isLoadMore))
          ? NotificationLoading()
          : NotificationInitial();
      if(isReload == true){
        _currentPage = 1;
        yield await handleCallApi(_currentPage);
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
      yield await handleCallApi(_currentPage);
    }
    if(event is UpdateNotificationEvent){
      yield NotificationLoading();
      NotificationState state = _handleUpdateNotification(await _networkFactory.updateNotification(_accessToken,event.notificationID));
      yield state;
    }
    if(event is DeleteNotificationEvent){
      yield NotificationLoading();
      NotificationState state = _handleUpdateNotification(await _networkFactory.deleteNotification(_accessToken,event.notificationID));
      yield state;
    }
    if(event is UpdateAllNotificationEvent){
      yield NotificationLoading();
      NotificationState state = _handleUpdateNotification(await _networkFactory.updateAllNotification(_accessToken));
      yield state;
    }else if(event is DeleteAllNotificationEvent){
      yield NotificationLoading();
      NotificationState state = _handleUpdateNotification(await _networkFactory.deleteAllNotification(_accessToken));
      yield state;
    }
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
    NotificationState state = _handleGetListNotification(await _networkFactory.getListNotification(_accessToken,pageIndex,20),pageIndex);
    return state;
  }

  NotificationState _handleGetListNotification(Object data,int pageIndex){
    if(data is String) return GetListNotificationFailure("Error".tr);
    try{
      NotificationResponse response = NotificationResponse.fromJson(data);
      _maxPage =  20;//Const.MAX_COUNT_ITEM
      List<NotificationDataResponse> list = response.data ?? List();
      if (!Utils.isEmpty(list) && listNotification.length >= (pageIndex - 1) * _maxPage + list.length) {
        listNotification.replaceRange((pageIndex - 1) * maxPage, list.length < _maxPage ? (pageIndex * list.length) : (pageIndex * maxPage), list);
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