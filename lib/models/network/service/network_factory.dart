import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' as libGetX;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/models/network/request/change_password_request.dart';
import 'package:trungchuyen/models/network/request/login_request.dart';
import 'package:trungchuyen/models/network/request/push_location_request.dart';
import 'package:trungchuyen/models/network/request/tranfer_customer_request.dart';
import 'package:trungchuyen/models/network/request/update_info_request.dart';
import 'package:trungchuyen/models/network/request/update_status_customer_request.dart';
import 'package:trungchuyen/models/network/request/update_token_request.dart';
import 'package:trungchuyen/page/login/login_page.dart';
import 'package:trungchuyen/utils/const.dart';
import 'package:trungchuyen/utils/log.dart';
import 'package:trungchuyen/utils/utils.dart';
import 'host.dart';

class NetWorkFactory {
  BuildContext context;
  Dio _dio;
  SharedPreferences _sharedPreferences;
  bool isGoogle;

  // constructor
  NetWorkFactory(this.context) {
    HostSingleton hostSingleton = HostSingleton();
    hostSingleton.showError();
    String host = hostSingleton.host;
    int port = hostSingleton.port;
    if (!host.contains("http")) {
      host = "http://" + host;
      print('Check host=> ' + host);
    }
    // print('test connection');
    // print("$host:$port");
    _dio = Dio(BaseOptions(
      baseUrl: "$host${port!=0?":$port":""}",
      receiveTimeout: 60000,
      connectTimeout: 60000,
    ));
    _setupLoggingInterceptor();
  }

  void _setupLoggingInterceptor() {
    int maxCharactersPerLine = 200;
    _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options) async {
      // Do something before request is sent
      logger.d("--> ${options.method} ${options.path}");
      logger.d("Content type: ${options.contentType}");
      logger.d("Request body: ${options.data}");
      logger.d("<-- END HTTP");
      return options; //continue
      // If you want to resolve the request with some custom data???
      // you can return a `Response` object or return `dio.resolve(data)`.
      // If you want to reject the request with a error message,
      // you can return a `DioError` object or return `dio.reject(errMsg)`
    }, onResponse: (Response response) {
      // Do something with response data
      logger.d("<-- ${response.statusCode} ${response.request.method} ${response.request.path}");
      String responseAsString = response.data.toString();
      if (responseAsString.length > maxCharactersPerLine) {
        int iterations = (responseAsString.length / maxCharactersPerLine).floor();
        for (int i = 0; i <= iterations; i++) {
          int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
          if (endingIndex > responseAsString.length) {
            endingIndex = responseAsString.length;
          }
          print(responseAsString.substring(i * maxCharactersPerLine, endingIndex));
        }
      } else {
        logger.d(response.data);
      }
      logger.d("<-- END HTTP");
      return response; // continue
    }, onError: (DioError error) {
      // Do something with response error
      logger.e("DioError: ${error?.message}");
      if (error.response?.statusCode == 401) {
        Utils.showToast('H???t phi??n l??m vi???c');
        libGetX.Get.offAll(LoginPage());
        RequestOptions options = error.response.request;
        _dio.interceptors.requestLock.lock();
        _dio.interceptors.responseLock.lock();
        return _dio.get("/api/auth/refresh-token").then((response) {
          String token = response.data['data']['token'];
          _sharedPreferences.setString(Const.ACCESS_TOKEN, token);
        }).whenComplete(() {
          _dio.interceptors.requestLock.unlock();
          _dio.interceptors.responseLock.unlock();
        }).then((e) {
          //repeat
          return _dio.request(options.path, options: options, queryParameters: options.queryParameters);
        });
      }
      return error; //continue
    }));
  }

  Future<Object> requestApi(Future<Response> request) async {
    try {
      Response response = await request;
//      var data = json.decode(response.data);
      var data = response.data;
//      if (!data.toString().contains("status"))
//        return data;
      if (data["statusCode"] == 200 || data["status"] == 200 || data["status"] == "OK")
        return data;
      else {
        if (data["statusCode"] == 423) {
          //showOverlay((context, t) => UpgradePopup(message: data["message"],));
        } else if (data["statusCode"] == 401) {
          try {
            Utils.showToast(data["message"].toString());
            try {

              // MainBloc mainBloc = BlocProvider.of<MainBloc>(context);
              // mainBloc.add(LogoutMainEvent());
            } catch (e) {
              debugPrint(e.toString());
            }
            // Authen authBloc =
            // BlocProvider.of<AuthenticationBloc>(context);
            // authBloc.add(LoggedOut());
          } catch (e) {
            debugPrint(e.toString());
          }
        }
        return data["message"];
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return _handleError(error);
    }
  }

  String _handleError(dynamic error) {
    String errorDescription = "";
    logger.e(error?.toString());
    if (error is DioError) {
//      print(error?.response?.toString() ?? "");
      switch (error.type) {
        case DioErrorType.SEND_TIMEOUT:
          errorDescription = 'ErrorRTS'.tr;
          break;
        case DioErrorType.CANCEL:
          errorDescription = 'ErrorSWC'.tr;
          break;
        case DioErrorType.CONNECT_TIMEOUT:
          errorDescription = 'ErrorCTS'.tr;
          break;
        case DioErrorType.DEFAULT:
          errorDescription = 'ErrorTSF'.tr;
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          errorDescription = 'ErrorRTR'.tr;
          break;
        case DioErrorType.RESPONSE:
          var errorData = error?.response?.data;
          String message;
          int code;
          if (!Utils.isEmpty(errorData)) {
            if(errorData is String){
              message = 'Error404'.tr;
              code = 404;
            } else{
              message = errorData["message"].toString();
              code = errorData["statusCode"];
            }
          } else {
            code = error?.response?.statusCode;
          }
          errorDescription = message ?? "ErrorCode".tr + ': $code';
          if (code == 401) {
            Utils.showToast(errorData["message"].toString());
            try {
              libGetX.Get.offAll(LoginPage());
              // MainBloc mainBloc = BlocProvider.of<MainBloc>(context);
              // mainBloc.add(LogoutMainEvent());
            } catch (e) {
              debugPrint(e.toString());
            }
          } else if (code == 423) {
            try {
              // AuthenticationBloc authBloc =
              // BlocProvider.of<AuthenticationBloc>(context);
              // authBloc.add(ShowUpgradeDialogEvent(message ?? ""));
            } catch (e) {
              debugPrint(e.toString());
            }
            //showOverlay((context, t) => UpgradePopup(message: message ?? "",), duration: Duration.zero);
          }
          break;
        default:
          errorDescription = 'C?? l???i x???y ra.';
      }
    } else {
      errorDescription = 'C?? l???i x???y ra.';
    }
    return errorDescription;
  }

  /// List API
  Future<Object> getConnection() async {
    return await requestApi(_dio.get('api/check-connect'));
  }

  Future<Object> login(LoginRequestBody request) async {
    return await requestApi(_dio.post('/api/v1/taikhoan/dangnhap', data: request.toJson()));
  }
  Future<Object> updateToken(UpdateTokenRequestBody request,String token) async {
    return await requestApi(_dio.post('/api/v1/taikhoan/capnhat-device-token', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> groupCustomerAWaiting(String token, DateTime date) async {
    return await requestApi(_dio.get('/api/v1/trungchuyen/nhomkhachcho', options: Options(headers: {"Authorization": "Bearer $token"}),queryParameters: {
      "ngayTrungChuyen": date,
    }));
  }

  Future<Object> getDetailTrips(String ngayChay,String token, DateTime date, String idRoom, String idTime, String typeCustomer) async {
    return await requestApi(_dio.get('/api/v1/trungchuyen/dskhachcho', options: Options(headers: {"Authorization": "Bearer $token"}),queryParameters: {
      "ngayChay": ngayChay,
      "ngayTrungChuyen": date,
      "idVanPhong": idRoom,
      "idKhungGio": idTime,
      "loaiKhachTC": typeCustomer,
    })); //["Authorization"] = "Bearer " + token
  }

  Future<Object> getDetailTripsHistory(String token, String idRoom, String idTime, String typeCustomer,String ngayChay) async {
    return await requestApi(_dio.get('/api/v1/trungchuyen/dskhach-trongngay', options: Options(headers: {"Authorization": "Bearer $token"}),queryParameters: {
      "ngayChay": ngayChay,
      "idVanPhong": idRoom,
      "idKhungGio": idTime,
      "loaiKhachTC": typeCustomer,
    })); //["Authorization"] = "Bearer " + token
  }
  ///0 : Offline
  ///1 : Online
  Future<Object> updateStatusDriver(String token,int statusDriver) async {
    return await requestApi(_dio.get('/api/v1/taikhoan/capnhat-trangthai-online/' + statusDriver.toString(), options: Options(headers: {"Authorization": "Bearer $token"}))); //["Authorization"] = "Bearer " + token
  }
  /// 1. T??? ch???i
  /// 2. Ch???p nh???n (Ch??? ????n - N???u l?? kh??ch c???n ????n)
  /// 5. Ch???p nh???n (Ch??? nh???n - N???u l?? kh??ch c???n tr???)
  // Future<Object> updateStatusCustomer(UpdateStatusCustomerRequestBody request,String token) async {
  //   return await requestApi(_dio.post('/api/v1/trungchuyen/capnhat-trangthai', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  // }
  Future<Object> updateGroupStatusCustomer(UpdateStatusCustomerRequestBody request,String token) async {
    return await requestApi(_dio.post('/api/v1/trungchuyen/capnhat-trangthai-nhom', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }
  Future<Object> getReport(String token,String dateTimeFrom, String dateTimeTo,String idNhaXe) async {
    return await requestApi(_dio.get('/api/v1/thongke/taixe-trungchuyen/khach-trung-chuyen/' + idNhaXe + "/" + dateTimeFrom.toString() + '/' + dateTimeTo.toString(), options: Options(headers: {"Authorization": "Bearer $token"}))); //["Authorization"] = "Bearer " + token
  }
  Future<Object> getReportLimo(String token,String dateTimeFrom, String dateTimeTo,String idNhaXe) async {
    return await requestApi(_dio.get('/api/v1/thongke/taixe-limo/thongkekhach/' + idNhaXe + "/" + dateTimeFrom.toString() + '/' + dateTimeTo.toString(), options: Options(headers: {"Authorization": "Bearer $token"}))); //["Authorization"] = "Bearer " + token
  }

  Future<Object> getListCustomerLimo(String token,DateTime dateTime) async {
    return await requestApi(_dio.get('/api/v1/limo/nhomkhachcho', options: Options(headers: {"Authorization": "Bearer $token"}), queryParameters: {
      "ngayChay": dateTime,
    })); //["Authorization"] = "Bearer " + token
  }

  Future<Object> getListHistoryLimo(String token,String dateTime) async {
    return await requestApi(_dio.get('/api/v1/limo/nhomkhach-xuly-trongngay/'+ dateTime, options: Options(headers: {"Authorization": "Bearer $token"}))); //["Authorization"] = "Bearer " + token
  }
  Future<Object> getListHistoryTC(String token,String dateTime) async {
    return await requestApi(_dio.get('/api/v1/trungchuyen/nhomkhach-xuly-trongngay/' + dateTime, options: Options(headers: {"Authorization": "Bearer $token"}))); //["Authorization"] = "Bearer " + token
  }

  Future<Object> getDetailTripsLimo(String token, String date, String idTrips, String idTime) async {
    return await requestApi(_dio.get('/api/v1/limo/dskhachcho' , options: Options(headers: {"Authorization": "Bearer $token"}),queryParameters: {
      "ngayChay": date,
      "idTuyenDuong": idTrips,
      "idKhungGio": idTime,
    })); //["Authorization"] = "Bearer " + token
  }

  Future<Object> sendNotification(TranferCustomerRequestBody request,String token) async {
    return await requestApi(_dio.post('/api/v1/thongbao/send-notification', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> pushLocationToLimo(PushLocationRequestBody request,String token) async {
    return await requestApi(_dio.post('/api/v1/trungchuyen/cap-nhat-toa-do', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> logOut(String token) async {
    return await requestApi(_dio.post('/api/v1/taikhoan/dangxuat', options: Options(headers: {"Authorization": "Bearer $token"})));
  }

  Future<Object> getListLocationPolyline(String token,String currentLocation, String customerlocation) async {
    return await requestApi(_dio.get('/api/v1/google-map/direction', options: Options(headers: {"Authorization": "Bearer $token"}), queryParameters: {
      "origin": currentLocation,
      "destination": customerlocation,
    })); //["Authorization"] = "Bearer " + token
  }

  Future<Object> confirmCustomerLimo(String token, String idDatVe, int trangThai,String note) async {
    return await requestApi(_dio.get('/api/v1/limo/xacnhan-donkhach', options: Options(headers: {"Authorization": "Bearer $token"}),queryParameters: {
      "idDatVe": idDatVe,
      "trangThai": trangThai,
      "ghiChu": note,
    }));
  }

  Future<Object> getListCustomerConfirmLimo(String token) async {
    return await requestApi(_dio.get('/api/v1/trungchuyen/dskhach-choxacnhan', options: Options(headers: {"Authorization": "Bearer $token"})));
  }

  Future<Object> getListNotification(String token,int pageIndex,int pageSize) async {
    return await requestApi(_dio.get('/api/v1/thongbao', options: Options(headers: {"Authorization": "Bearer $token"}), queryParameters: {
      "PageIndex": pageIndex,
      "pageSize": pageSize,
    })); //["Authorization"] = "Bearer " + token
  }

  Future<Object> updateAllNotification(String token) async {
    return await requestApi(_dio.put('/api/v1/thongbao/read-all', options: Options(headers: {"Authorization": "Bearer $token"}))); //["Authorization"] = "Bearer " + token
  }

  Future<Object> updateNotification(String token,String idNotification) async {
    return await requestApi(_dio.put('/api/v1/thongbao/' + idNotification, options: Options(headers: {"Authorization": "Bearer $token"},))); //["Authorization"] = "Bearer " + token
  }

  Future<Object> deleteNotification(String token,String idNotification) async {
    return await requestApi(_dio.delete('/api/v1/thongbao/' + idNotification, options: Options(headers: {"Authorization": "Bearer $token"}))); //["Authorization"] = "Bearer " + token
  }
  Future<Object> deleteAllNotification(String token) async {
    return await requestApi(_dio.delete('/api/v1/thongbao/xoahet', options: Options(headers: {"Authorization": "Bearer $token"}))); //["Authorization"] = "Bearer " + token
  }
  Future<Object> readNotification(String token) async {
    return await requestApi(_dio.get('/api/v1/thongbao/chuadoc', options: Options(headers: {"Authorization": "Bearer $token"}))); //["Authorization"] = "Bearer " + token
  }
  Future<Object> updateInfo(String token,UpdateInfoRequestBody updateInfoRequestBody) async {
    return await requestApi(_dio.put('/api/v1/taikhoan/capnhat', options: Options(headers: {"Authorization": "Bearer $token"}), data: updateInfoRequestBody.toJson()));
  }

  Future<Object> changePassword(ChangePasswordRequest request,String token) async {
    return await requestApi(_dio.post('/api/v1/taikhoan/capnhat-matkhau', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

}
