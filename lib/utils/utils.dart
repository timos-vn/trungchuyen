import 'dart:typed_data';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart' as libGetX;
import 'package:trungchuyen/models/network/response/detail_trips_limo_reponse.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
import 'package:trungchuyen/models/network/response/login_response.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/themes/font.dart';
import 'package:trungchuyen/themes/images.dart';
import 'package:trungchuyen/widget/text_field_widget.dart';
import 'const.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

class Utils {

  static paint(Canvas canvas) {
    final p1 = Offset(50, 50);
    final p2 = Offset(250, 150);
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4;
    canvas.drawLine(p1, p2, paint);
  }

  static textStyle(double size,){
    TextStyle(
      fontSize: size,
      fontWeight: FontWeight.normal,
      fontFamily: fontApp
    );
  }

  static String base64Image(File file) {
    if (file == null) return null;
    List<int> imageBytes = file.readAsBytesSync();
    return base64Encode(imageBytes);
  }

  static divider(){
    return Divider(height: 1,color: blue.withOpacity(0.8),);
  }

  static showNotification(String title, String content){
    libGetX.Get.snackbar(title,content,snackPosition: libGetX.SnackPosition.BOTTOM, margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5));
  }

  static Future pushAndRemoveUtilPage(BuildContext context, Widget widget) {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => widget),
            (Route<dynamic> route) => false);
  }

  static void popUtilRoot(BuildContext context) {
    return Navigator.popUntil(
        context, ModalRoute.withName(Navigator.defaultRouteName));
  }

  static void popUtil(BuildContext context) {
    return Navigator.of(context).popUntil((Route<dynamic> route) => false);
  }

  static Future pushAndRemoveUtilKeepFirstPage(
      BuildContext context, Widget widget) {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => widget),
        ModalRoute.withName(Navigator.defaultRouteName));
  }

  static navigateNextFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static bool isEmpty(Object text) {
    if (text is String) return text == null || text.isEmpty;
    if (text is List) return text == null || text.isEmpty;
    return text == null;
  }

  static void showToast(String text) {
    if (Utils.isEmpty(text))
      return;
    Fluttertoast.showToast(msg: text, backgroundColor: accent);
  }

  static bool isInteger(num value) => value is int || value == value.roundToDouble();

  static String formatNumber(num amount) {
    return isInteger(amount) ? amount.toStringAsFixed(0) : amount.toString();
  }

  static String formatMoney(dynamic amount) {
    // if( amount.toString().contains('.')) {
    //   return NumberFormat.simpleCurrency(locale: "en_US").format(amount);
    //       // .replaceAll(' ', '').replaceAll('.', ' ')
    //       // .replaceAll('₫', '');
    // }else{
    //   return NumberFormat.simpleCurrency(locale: "vi_VN").format(amount)
    //       .replaceAll(' ', '').replaceAll('.', ' ')
    //       .replaceAll('₫', '');
    // }

      return NumberFormat.simpleCurrency(locale: "vi_VN").format(amount)
          .replaceAll(' ', '').replaceAll('.', ' ')
          .replaceAll('₫', '');
  }

  static String formatTotalMoney(dynamic amount) {

    String totalMoney = NumberFormat.simpleCurrency(locale: "vi_VN").format(amount)
        .replaceAll(' ', '').replaceAll('.', ' ')
        .replaceAll('₫', '').toString();
    if(totalMoney.split(' ').length == 1 || totalMoney.split(' ').length == 2){
      return totalMoney;
    }else{
      return totalMoney.split(' ')[0] + ' '+ totalMoney.split(' ')[1];
    }
  }

  static String formatMoneyVN(num money) {
    String convertMoney = money.toString();
    if(convertMoney.split('.')[0].length > 3){
      String m = convertMoney.split('.')[0].substring(0,convertMoney.split('.')[0].length-3);
      money = num.parse(m);
      print('--->>>> ${convertMoney.split('.')[0].toString()}');
    }
    if (money <= 0) return "0K";
    return formatNumber(money / 1000) + "K";
  }

  static bool isNumeric(String text) {
    if(text == null) {
      return false;
    }
    return int.parse(text, onError: (e) => null) != null;
  }

  static DateTime parseStringToDate(String dateStr, String format) {
    DateTime date;
    if (dateStr != null)
      try {
        date = DateFormat(format).parse(dateStr);
      } on FormatException catch (e) {
        print(e);
      }
    return date;
  }

  static String parseDateTToString(String dateInput,String format){
    String date = "";
    DateTime parseDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(dateInput);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat(format);
    date = outputFormat.format(inputDate);
    return date;
  }

  static String parseStringDateToString(String dateSv, String fromFormat, String toFormat) {
    String date = "";
    if (dateSv != null)
      try {
        date = DateFormat(toFormat, "en_US")
            .format(DateFormat(fromFormat).parse(dateSv));
      } on FormatException catch (e) {
        print(e);
      }
    return date;
  }
  static String parseDateToString(DateTime dateTime, String format) {
    String date = "";
    if (dateTime != null)
      try {
        date = DateFormat(format).format(dateTime);
      } on FormatException catch (e) {
        print(e);
      }
    return date;
  }
  // static void selectDatePicker(
  //     BuildContext context, ValueChanged<DateTime> chooseDate,
  //     {DateTime initDate}) async {
  //   DatePicker.showDatePicker(context,
  //       currentTime: initDate,
  //       showTitleActions: true,
  //       minTime: DateTime.utc(1899, 12, 31),
  //       maxTime: DateTime.now(),
  //       locale: LocaleType.vi, onConfirm: (date) {
  //         chooseDate(date);
  //       });
  // }

  static Future<DateTime> selectDate(BuildContext context,
      {DateTime initDate}) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: initDate ?? DateTime.now(),
        firstDate: DateTime.utc(1899, 12, 31),
        lastDate: DateTime.now());
    return picked;
  }

  static Future navigatePage(BuildContext context, Widget widget) {
    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => widget, ));
  }

  static void saveDataLogin(SharedPreferences _prefs, LoginResponseData data,String accessToken, String refreshToken,String username,String pass) {
    String currentUsername = _prefs.getString(Const.USER_NAME);
    if (!Utils.isEmpty(currentUsername) &&
        currentUsername?.trim() != data.taiKhoan.hoTen?.trim()) {
      // DatabaseHelper db = DatabaseHelper();
      // db.deleteAllProduct();
    }
    _prefs.setString(Const.USER_ID, data.taiKhoan.id.toString());
    _prefs.setString(Const.ACCESS_TOKEN, accessToken);
    _prefs.setString(Const.REFRESH_TOKEN, refreshToken);
    _prefs.setString(Const.CHUC_VU, data.taiKhoan.chucVu?.toString());
    _prefs.setString(Const.FULL_NAME, data.taiKhoan.hoTen?.toString());
    _prefs.setString(Const.PHONE_NUMBER, data.taiKhoan.dienThoai?.trim());
    _prefs.setString(Const.NHA_XE, data.taiKhoan.nhaXe?.toString());

    _prefs.setString(Const.USER_NAME, data.taiKhoan.tenDangNhap?.trim());
    _prefs.setString(Const.PASS_WORD, pass);
  }

  static void removeData(SharedPreferences _prefs) {
    _prefs.remove(Const.USER_ID);
    _prefs.remove(Const.USER_NAME);
    _prefs.remove(Const.ACCESS_TOKEN);
    _prefs.remove(Const.REFRESH_TOKEN);
    _prefs.remove(Const.CHUC_VU);
    _prefs.remove(Const.PHONE_NUMBER);
    _prefs.remove(Const.EMAIL);
    _prefs.remove(Const.PASS_WORD);
    // _prefs.remove(Const.ADDRESS);
    // _prefs.remove(Const.DETAIL_ADDRESS);
    // _prefs.remove(Const.LOCATION_ADDRESS);
    // _prefs.remove(Const.CHANGE_LOCATION);
    // _prefs.remove(Const.PHONE_VERIFIED);
    // _prefs.remove(Const.SHARE_ID);
    // _prefs.remove(Const.SHOP_ID);
    // _prefs.remove(Const.SHOP_NAME);
    // _prefs.remove(Const.INVITED_BY);
  }

  static void showDialogTwoButton(
      {@required BuildContext context,
        String title,
        @required Widget contentWidget,
        @required List<Widget> actions,
        bool dismissible: false}) =>
      showDialog(
          barrierDismissible: dismissible,
          context: context,
          builder: (context) {
            return AlertDialog(
                title: title != null ? Text(title) : null,
                content: contentWidget,
                actions: actions);
          });
  static void showForegroundNotification(BuildContext context, String title, String text, {VoidCallback onTapNotification}) {
    showOverlayNotification((context) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: SafeArea(
            bottom: false,
            child: InkWell(
              onTap: () {
                OverlaySupportEntry.of(context).dismiss();
                onTapNotification();
              },
              child: ListTile(
                leading: SizedBox.fromSize(
                    size: const Size(40, 40),
                    child: ClipOval(child: Image.asset(icLogo))),
                title: Text(
                  title ?? "",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(text ?? ""),
                trailing: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      OverlaySupportEntry.of(context).dismiss();
                    }),
              ),
            ),
          ),
        ),
      );
    }, duration: Duration(milliseconds: 4000));
  }

  static void onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  static void showNotifySnackBar(BuildContext context, String text) {
    onWidgetDidBuild(() => showSnackBar(context, text));
  }

  static void showSnackBar(BuildContext context, String text) {
    if (Utils.isEmpty(text))
      return;
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: primaryColor,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  static Future<List<String>> showDialogAssign({@required BuildContext context, @required String titleHintText, Function accept, Function cancel, bool dismissible: false})
  => showDialog(
      barrierDismissible: dismissible,
      context: context,
      builder: (context) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
              height: 250,
              width: double.infinity,
              child: Material(
                  animationDuration: Duration(seconds: 3),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  child: Column(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16))),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          titleHintText,
                                          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                      Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.only(bottomRight: Radius.circular(16), bottomLeft: Radius.circular(16))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                InkWell(
                                  onTap: ()=>Navigator.pop(context),
                                  child: Text(
                                    'Huỷ',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                                  ),
                                ),
                                SizedBox(
                                  width: 60,
                                ),
                                InkWell(
                                  onTap: ()=>Navigator.pop(context,['OK']),
                                  child: Text(
                                    'Nhận',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                                  ),
                                )
                              ],
                            ),
                          )),
                    ],
                  )),
            ),
          ),
        );
      });

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(String path, int width) async {
    final Uint8List imageData = await getBytesFromAsset(path, width);
    return BitmapDescriptor.fromBytes(imageData);
  }

  static Future<bool> showDialogAssign2({@required BuildContext context, @required String tripName, @required String date, @required String typeCustomer, @required int type}) => showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
                height: 300,
                width: double.infinity,
                child: Material(
                    animationDuration: Duration(seconds: 3),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircularCountDownTimer(
                            autoStart: true,
                            duration: 180,
                            initialDuration: 0,
                            width: 80,
                            height: 80,
                            ringColor: Colors.grey[300],
                            ringGradient: null,
                            fillColor: Colors.purpleAccent[100],
                            fillGradient: null,
                            backgroundColor: Colors.white,
                            backgroundGradient: null,
                            strokeWidth: 5,
                            strokeCap: StrokeCap.round,
                            textStyle: TextStyle(fontSize: 24.0, color: Colors.amberAccent, fontWeight: FontWeight.bold),
                            isReverse: true,
                            isReverseAnimation: true,
                            isTimerTextShown: true,
                            onComplete: () {
                              Navigator.pop(context, false);
                            },
                          ),
                          Table(
                            border: TableBorder.all(color: Colors.orange),
                            columnWidths: const <int, TableColumnWidth>{
                              0: FixedColumnWidth(120),
                              1: FlexColumnWidth(),
                            },
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Chuyến:',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('$tripName'),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Ngày',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(date),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Thời gian:',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(typeCustomer == '1' ? 'Khách đón' : 'Khách trả'),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: Text('Từ chối'),
                                      )),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: Text(
                                        'Nhận ${typeCustomer == '1' ? 'đón' : 'trả'}',
                                        style: TextStyle(color: white),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Colors.orange),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          ),
        );
      });

  static Future<bool> showDialogReceiveCustomerFormTC({@required BuildContext context, @required String laiXeTC,String sdtLaiXeTC,String soKhach, @required String date}) => showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
                height: 300,
                width: double.infinity,
                child: Material(
                    animationDuration: Duration(seconds: 3),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Center(
                            child: SpinKitPouringHourglass(
                              color: Colors.orange,
                              size: 40,
                            ),
                          ),
                          SizedBox(height: 5,),
                          Center(child: Text('Bạn nhận được khách từ LX Trung Chuyển',style: TextStyle(color: Colors.grey,fontSize: 11),)),
                          SizedBox(height: 5,),
                          Table(
                            border: TableBorder.all(color: Colors.orange),
                            columnWidths: const <int, TableColumnWidth>{
                              0: FixedColumnWidth(120),
                              1: FlexColumnWidth(),
                            },
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'LXTC:',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('$laiXeTC'),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'SĐT LX TC:',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(sdtLaiXeTC),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Số khách:',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('${soKhach.toString()}'),
                                  ),
                                ),
                              ]),
                              TableRow(children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Thời gian:',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(date),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                      width: double.infinity,
                                      ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: Text(
                                        'Xác nhận',
                                        style: TextStyle(color: white),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Colors.orange),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          ),
        );
      });

  static Future<bool> showDialogTransferCustomer({@required BuildContext context, @required List<DetailTripsResponseBody> listOfDetailTripsSuccessful, @required String content, Function accept, Function cancel, bool dismissible: false}) => showDialog(
      barrierDismissible: dismissible,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child:  Center(
            child: Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
                height: 350,
                width: double.infinity,
                child: Material(
                    animationDuration: Duration(seconds: 3),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    child: Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16))),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Giao khách cho Limo',
                                        style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                                      )),
                                ),
                              ),
                            )),
                        Expanded(
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(bottomRight: Radius.circular(16), bottomLeft: Radius.circular(16))),
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  separatorBuilder: (BuildContext context, int index) => Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                    ),
                                    child: Divider(),
                                  ),
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          'Lái xe Limo: ',
                                                          style: TextStyle(color: Colors.grey),
                                                        )),
                                                    Expanded(
                                                        flex: 2,
                                                        child: Row(
                                                          children: [
                                                            Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: Text(
                                                                  listOfDetailTripsSuccessful[index].hoTenTaiXeLimousine?.toString()??"",
                                                                  style: TextStyle(color: Colors.black),
                                                                )),
                                                            SizedBox(width: 3,),
                                                            Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: Text(
                                                                  "( ${listOfDetailTripsSuccessful[index].dienThoaiTaiXeLimousine?.toString()??""} )",
                                                                  style: TextStyle(color: Colors.grey,fontSize: 10),
                                                                )),
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          'BSX: ',
                                                          style: TextStyle(color: Colors.grey),
                                                        )),
                                                    Expanded(
                                                        flex: 2,
                                                        child: Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Text(
                                                              listOfDetailTripsSuccessful[index].bienSoXeLimousine?.toString()??'',
                                                              style: TextStyle(color: Colors.black),
                                                            ))),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          'Số khách: ',
                                                          style: TextStyle(color: Colors.grey),
                                                        )),
                                                    Expanded(
                                                        flex: 2,
                                                        child: Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Text(
                                                              '${listOfDetailTripsSuccessful[index].soKhach?.toString()??'0'}',
                                                              style: TextStyle(color: Colors.black),
                                                            ))),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Center(
                                            child: SpinKitPouringHourglass(
                                              color: Colors.orange,
                                              size: 40,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  itemCount: listOfDetailTripsSuccessful.length),
                            )),
                      ],
                    )),
              ),
            ),
          ),
        );
      });



  static Future<bool> showDialogTransferCustomerLimo({@required BuildContext context, @required List<DetailTripsLimoReponseBody> listOfDetailTripsSuccessful, @required String content, Function accept, Function cancel, bool dismissible: false}) => showDialog(
      barrierDismissible: dismissible,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child:  Center(
            child: Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
                height: 350,
                width: double.infinity,
                child: Material(
                    animationDuration: Duration(seconds: 3),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    child: Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16))),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Giao khách cho Trung chuyển',
                                        style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                                      )),
                                ),
                              ),
                            )),
                        Expanded(
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(bottomRight: Radius.circular(16), bottomLeft: Radius.circular(16))),
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  separatorBuilder: (BuildContext context, int index) => Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                    ),
                                    child: Divider(),
                                  ),
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          'Lái xe Limo: ',
                                                          style: TextStyle(color: Colors.grey),
                                                        )),
                                                    Expanded(
                                                        flex: 2,
                                                        child: Row(
                                                          children: [
                                                            Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: Text(
                                                                  listOfDetailTripsSuccessful[index].hoTenTaiXeTrungChuyen?.toString()??"",
                                                                  style: TextStyle(color: Colors.black),
                                                                )),
                                                            SizedBox(width: 3,),
                                                            Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: Text(
                                                                  "( ${listOfDetailTripsSuccessful[index].dienThoaiTaiXeTrungChuyen?.toString()??""} )",
                                                                  style: TextStyle(color: Colors.grey,fontSize: 10),
                                                                )),
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          'BSX: ',
                                                          style: TextStyle(color: Colors.grey),
                                                        )),
                                                    Expanded(
                                                        flex: 2,
                                                        child: Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Text(
                                                              listOfDetailTripsSuccessful[index].bienSoXeTrungChuyen?.toString()??'',
                                                              style: TextStyle(color: Colors.black),
                                                            ))),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          'Số khách: ',
                                                          style: TextStyle(color: Colors.grey),
                                                        )),
                                                    Expanded(
                                                        flex: 2,
                                                        child: Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Text(
                                                              '${listOfDetailTripsSuccessful[index].soKhach?.toString()??'0'}',
                                                              style: TextStyle(color: Colors.black),
                                                            ))),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Center(
                                            child: SpinKitPouringHourglass(
                                              color: Colors.orange,
                                              size: 40,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  itemCount: listOfDetailTripsSuccessful.length),
                            )),
                      ],
                    )),
              ),
            ),
          ),
        );
      });
}