import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/models/network/response/report_reponse.dart';
import 'package:trungchuyen/models/network/service/network_factory.dart';
import 'package:trungchuyen/page/report_limo/report_limo_event.dart';
import 'package:trungchuyen/page/report_limo/report_limo_state.dart';
import 'package:trungchuyen/utils/const.dart';
import 'package:trungchuyen/utils/utils.dart';


class ReportLimoBloc extends Bloc<ReportLimoEvent,ReportLimoState> {

  BuildContext context;
  NetWorkFactory? _networkFactory;
  String? _accessToken;
  String? get accessToken => _accessToken;
  String? _refreshToken;
  String? get refreshToken => _refreshToken;
  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;

  List<DsKhachs> listReport = [];
  ReportReponseDetail? reponseDetail;
  int tongKhach = 0;
  String idNhaXe = '';


  ReportLimoBloc(this.context) : super(ReportLimoInitial()){
    _networkFactory = NetWorkFactory(context);

    on<GetPrefs>(_getPrefs,);
    on<GetReportLimoEvent>(_getReportLimoEvent);
  }

  void _getPrefs(GetPrefs event, Emitter<ReportLimoState> emitter)async{
    emitter(ReportLimoLoading());
    _prefs = await SharedPreferences.getInstance();
    _accessToken = _prefs!.getString(Const.ACCESS_TOKEN) ?? "";
    _refreshToken = _prefs!.getString(Const.REFRESH_TOKEN) ?? "";
    idNhaXe = _prefs!.getString(Const.NHA_XE)??"";
    emitter(GetPrefsSuccess());
  }

  void _getReportLimoEvent(GetReportLimoEvent event, Emitter<ReportLimoState> emitter)async{
    emitter(ReportLimoLoading());
    ReportLimoState state = _handleGetReportLimo(await _networkFactory!.getReportLimo(_accessToken!, event.dateFrom,event.dateTo,idNhaXe));
    emitter(state);
  }


  ReportLimoState _handleGetReportLimo(Object data) {
    if (data is String) return ReportLimoFailure(data);
    try {
      if(!Utils.isEmpty(listReport)) {
        tongKhach=0;
        listReport.clear();
      }
      ReportReponse reponse = ReportReponse.fromJson(data as Map<String,dynamic>);
      reponseDetail = reponse.data;
      tongKhach = reponseDetail!.tongKhach!;
      reponseDetail!.dsKhachs!.forEach((element) {
        DsKhachs customer = new DsKhachs(
            ngayChay: element.ngayChay,
            tenTuyenDuong: element.tenTuyenDuong,
            gioBatDau: element.gioBatDau,
            gioKetThuc: element.gioKetThuc,
            tenKhachHang: element.tenKhachHang,
            soDienThoaiKhach: element.soDienThoaiKhach,
            hoTenTaiXeLimousine: element.hoTenTaiXeLimousine,
            dienThoaiTaiXeLimousine: element.dienThoaiTaiXeLimousine,
            tenXeLimousine: element.tenXeLimousine,
            bienSoXeLimousine: element.bienSoXeLimousine,
            loaiKhach: element.loaiKhach,
            hoTenTaiXeTrungChuyen: element.hoTenTaiXeTrungChuyen,
            dienThoaiTaiXeTrungChuyen: element.dienThoaiTaiXeTrungChuyen,
            tenXeTrungChuyen: element.tenXeTrungChuyen,
            bienSoXeTrungChuyen: element.bienSoXeTrungChuyen,
            soKhach: 1,
        );
        var contain =  listReport.where((item) => (
                item.ngayChay == element.ngayChay
                &&
                item.gioBatDau == element.gioBatDau
                &&
                item.tenTuyenDuong == element.tenTuyenDuong
        ));
        if (contain.isEmpty){
          listReport.add(customer);
        }
        else{
          final customerNews = listReport.firstWhere((item) =>
          (
              item.ngayChay == element.ngayChay
                  &&
                  item.gioBatDau == element.gioBatDau
                  &&
                  item.tenTuyenDuong == element.tenTuyenDuong
          ));
          customerNews.soKhach = customerNews.soKhach! + 1;
          listReport.removeWhere((rm) => rm.ngayChay == customerNews.ngayChay && rm.gioBatDau == customerNews.gioBatDau && rm.tenTuyenDuong == customerNews.tenTuyenDuong);
          listReport.add(customerNews);
        }
      });
      return GetReportLimoEventSuccess();
    } catch (e) {
      print(e.toString());
      return ReportLimoFailure(e.toString());
    }
  }

}