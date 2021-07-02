import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class Const {
  /// DF server
  // ignore: non_constant_identifier_names
  static  String HOST_URL = "https://apidev.trungchuyenhn.com";
  // ignore: non_constant_identifier_names
  static  int PORT_URL = 0;

  /// DF base URL Dio
  static const String HOST_GOOGLE_MAP_URL = "https://maps.googleapis.com/maps/api/";


  static const WAITING= 0;
  static const MAP = 1;
  static const REPORT = 2;
  static const ACCOUNT = 3;

  static const String ACTION_UPDATE = '1';
  static const String ACTION_DELETE = '4';
  static const String TYPE_ONE = '1';
  static const String TYPE_ALL = '0';


  static TextInputFormatter FORMAT_DECIMA_NUMBER = BlacklistingTextInputFormatter(RegExp('[\\-|\\ |\\/|\\*|\$|\\#|\\+|\\|]'));
  static const String DATE_FORMAT = "dd/MM/yyyy";
  static const String DATE_TIME_FORMAT_LOCAL = "dd/MM/yyyy HH:mm:ss";
  static const String DATE_TIME_FORMAT = "yyyy-MM-dd HH:mm:ss";
  static const String DATE_FORMAT_1 = "dd-MM-yyyy";
  static const String DATE_SV = "yyyy-MM-dd'T'HH:mm:ss";
  static const String DATE_SV_FORMAT = "yyyy/MM/dd";
  static const String DATE_SV_FORMAT_1 = "MM/dd/yyyy";
  static const String DATE = "EEE";
  static const String DAY = "dd";
  static const String YEAR = "yyyy";
  static const String TIME = "hh:mm aa";
  static const String REFRESH = "REFRESH";
  static const String DEFAULT_LANGUAGE = 'Default Language';
  static const String CODE_LANGUAGE = 'Code Lang';
  static const String Name_LANGUAGE = 'Name Lang';
  static const String DEVICE_TOKEN = "Device Token";
  static const String TOPIC = "TOPIC";
  static const String FULL_NAME = "Full Name";

  static const int MAX_COUNT_ITEM = 20;

  static const String ACCESS_TOKEN = "Token";
  static const String REFRESH_TOKEN = "Refresh token";
  static const String USER_ID = 'User id';
  static const String PASS_WORD = 'Password';
  static const String USER_NAME = "User name";
  static const String CHUC_VU = "Full name";
  static const String NHA_XE = "Host id";


  // static const String ROLE = "Role";
  static const String PHONE_NUMBER = "Phone number";
  static const String EMAIL = "Email";



}