import 'package:dio/dio.dart';
import 'package:trungchuyen/utils/const.dart';


var dioGoogle = Dio(BaseOptions(
  baseUrl: Const.HOST_GOOGLE_MAP_URL,
  receiveTimeout: 10000,
  connectTimeout: 10000,
));