import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/models/network/response/report_reponse.dart';
import 'package:trungchuyen/models/network/service/network_factory.dart';
import 'package:trungchuyen/page/report/report_event.dart';
import 'package:trungchuyen/page/report/report_state.dart';
import 'package:trungchuyen/page/report_limo/report_limo_event.dart';
import 'package:trungchuyen/page/report_limo/report_limo_state.dart';
import 'package:trungchuyen/utils/const.dart';


class ReportLimoBloc extends Bloc<ReportLimoEvent,ReportLimoState> {

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

  ReportLimoBloc(this.context) : super(null){
    _networkFactory = NetWorkFactory(context);
  }

  // TODO: implement initialState
  ReportLimoState get initialState => ReportLimoInitial();

  @override
  Stream<ReportLimoState> mapEventToState(ReportLimoEvent event) async*{
    // TODO: implement mapEventToState
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      _accessToken = _prefs.getString(Const.ACCESS_TOKEN) ?? "";
      _refreshToken = _prefs.getString(Const.REFRESH_TOKEN) ?? "";
    }
    if(event is GetReportLimoEvent){
      yield ReportLimoLoading();
      //ReportLimoState state = _handleGetReportLimo(await _networkFactory.getReport(_accessToken, event.dateFrom,event.dateTo));
      yield state;
    }
  }


  ReportLimoState _handleGetReportLimo(Object data) {
    if (data is String) return ReportLimoFailure(data);
    try {
      ReportReponse reponse = ReportReponse.fromJson(data);
      reponseDetail = reponse.data;
      tongKhach = reponseDetail.tongKhach;
      listReport = reponseDetail.dsKhachs;
      return GetReportLimoEventSuccess();
    } catch (e) {
      print(e.toString());
      return ReportLimoFailure(e.toString());
    }
  }

}