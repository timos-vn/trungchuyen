import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/models/network/response/report_reponse.dart';
import 'package:trungchuyen/models/network/service/network_factory.dart';
import 'package:trungchuyen/page/report/report_event.dart';
import 'package:trungchuyen/page/report/report_state.dart';
import 'package:trungchuyen/utils/const.dart';


class ReportBloc extends Bloc<ReportEvent,ReportState> {

  BuildContext context;
  NetWorkFactory _networkFactory;
  String _accessToken;
  String get accessToken => _accessToken;
  String _refreshToken;
  String get refreshToken => _refreshToken;
  SharedPreferences _prefs;
  SharedPreferences get prefs => _prefs;

  List<DsKhachs> listReport = new List<DsKhachs>();
  ReportReponseDetail reponseDetail;
  int tongKhach = 0;

  ReportBloc(this.context)  {
    _networkFactory = NetWorkFactory(context);
  }

  // TODO: implement initialState
  ReportState get initialState => ReportInitial();

  @override
  Stream<ReportState> mapEventToState(ReportEvent event) async*{
    // TODO: implement mapEventToState
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      _accessToken = _prefs.getString(Const.ACCESS_TOKEN) ?? "";
      _refreshToken = _prefs.getString(Const.REFRESH_TOKEN) ?? "";
    }
    if(event is GetReportEvent){
      yield ReportLoading();
      ReportState state = _handleGetReport(await _networkFactory.getReport(_accessToken, event.dateFrom,event.dateTo));
      yield state;
    }
  }


  ReportState _handleGetReport(Object data) {
    if (data is String) return ReportFailure(data);
    try {
      ReportReponse reponse = ReportReponse.fromJson(data);
      reponseDetail = reponse.data;
      tongKhach = reponseDetail.tongKhach;
      listReport = reponseDetail.dsKhachs;
      return GetReportEventSuccess();
    } catch (e) {
      print(e.toString());
      return ReportFailure(e.toString());
    }
  }

}