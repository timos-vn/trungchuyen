import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
import 'package:trungchuyen/models/network/response/list_of_group_awaiting_customer_response.dart';
import 'package:trungchuyen/models/network/service/network_factory.dart';
import 'package:trungchuyen/page/main/main_bloc.dart';
import 'package:trungchuyen/page/waiting/waiting_event.dart';
import 'package:trungchuyen/page/waiting/waiting_sate.dart';
import 'package:trungchuyen/utils/const.dart';


class WaitingBloc extends Bloc<WaitingEvent,WaitingState> {

 // MainBloc _mainBloc;
  BuildContext context;
  NetWorkFactory _networkFactory;
  String _accessToken;
  String get accessToken => _accessToken;
  String _refreshToken;
  String get refreshToken => _refreshToken;
  SharedPreferences _prefs;
  SharedPreferences get prefs => _prefs;
  List<ListOfGroupAwaitingCustomerBody> listOfGroupAwaitingCustomer;
  List<DetailTripsReponseBody> listOfDetailTrips = new List<DetailTripsReponseBody>();

  WaitingBloc(this.context) : super(null){
    _networkFactory = NetWorkFactory(context);
    // _mainBloc = BlocProvider.of<MainBloc>(context);
  }

  // TODO: implement initialState
  WaitingState get initialState => WaitingInitial();

  @override
  Stream<WaitingState> mapEventToState(WaitingEvent event) async* {
    // TODO: implement mapEventToState
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      _accessToken = _prefs.getString(Const.ACCESS_TOKEN) ?? "";
      _refreshToken = _prefs.getString(Const.REFRESH_TOKEN) ?? "";
    }
    if(event is GetListGroupAwaitingCustomer){
      yield WaitingLoading();
      WaitingState state = _handleAwaitingCustomer(await _networkFactory.groupCustomerAWaiting(_accessToken,event.date));
      yield state;
    }

    if(event is GetListDetailTripsOfPageWaiting){
      yield WaitingLoading();
      WaitingState state = _handleGetListOfDetailTrips(await _networkFactory.getDetailTrips(_accessToken,event.date,event.idTrips.toString(),event.idTime.toString()));
      yield state;
    }
  }

  WaitingState _handleGetListOfDetailTrips(Object data) {
    if (data is String) return WaitingFailure(data);
    try {
      DetailTripsReponse response = DetailTripsReponse.fromJson(data);
      listOfDetailTrips = response.data;
      return GetListOfDetailTripsOfWaitingPageSuccess();
    } catch (e) {
      print(e.toString());
      return WaitingFailure(e.toString());
    }
  }

  WaitingState _handleAwaitingCustomer(Object data) {
    if (data is String) return WaitingFailure(data);
    try {
      ListOfGroupAwaitingCustomer response = ListOfGroupAwaitingCustomer.fromJson(data);
      listOfGroupAwaitingCustomer = response.data;
      return GetListOfWaitingCustomerSuccess();
    } catch (e) {
      print(e.toString());
      return WaitingFailure(e.toString());
    }
  }
}