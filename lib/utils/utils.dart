
// import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:trungchuyen/models/network/response/detail_trips_limo_reponse.dart';
import 'package:trungchuyen/models/network/response/login_response.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/themes/font.dart';
import '../widget/custom_toast.dart';
import 'const.dart';

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



  static divider(){
    return Divider(height: 1,color: blue.withOpacity(0.8),);
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
    if (text is String) return text.isEmpty;
    if (text is List) return text.isEmpty;
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
    return formatNumber(money) + "K";
  }



  static DateTime parseStringToDate(String dateStr, String format) {
    DateTime date = DateTime.now();
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
    try {
      date = DateFormat(format).format(dateTime);
    } on FormatException catch (e) {
      print(e);
    }
    return date;
  }





  static Future navigatePage(BuildContext context, Widget widget) {
    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => widget, ));
  }

  static void saveDataLogin(SharedPreferences _prefs, LoginResponseData data,String accessToken, String refreshToken,String username,String pass) {
    _prefs.setString(Const.USER_ID, data.taiKhoan!.id.toString());
    _prefs.setString(Const.ACCESS_TOKEN, accessToken);
    _prefs.setString(Const.REFRESH_TOKEN, refreshToken);
    _prefs.setString(Const.CHUC_VU, data.taiKhoan!.chucVu.toString());
    _prefs.setString(Const.FULL_NAME, data.taiKhoan!.hoTen.toString());
    _prefs.setString(Const.PHONE_NUMBER, data.taiKhoan!.dienThoai.toString().trim());
    _prefs.setString(Const.NHA_XE, data.taiKhoan!.idNhaXe.toString());

    _prefs.setString(Const.USER_NAME, username);
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
      {required BuildContext context,
        String? title,
        required Widget contentWidget,
        required List<Widget> actions,
        bool dismissible = false}) =>
      showDialog(
          barrierDismissible: dismissible,
          context: context,
          builder: (context) {
            return AlertDialog(
                title: title != null ? Text(title) : null,
                content: contentWidget,
                actions: actions);
          });

  static void showForegroundNotification(BuildContext context, String title, String text, {VoidCallback? onTapNotification}) {
    showOverlayNotification((context) {
      return Padding(
        padding: const EdgeInsets.only(top: 38,left: 8,right: 8),
        child: Material(
          color: Colors.transparent,
          child: Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white70, width: 1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: InkWell(
                onTap: () {
                  OverlaySupportEntry.of(context)!.dismiss();
                  onTapNotification!();
                },
                child: ListTile(
                  leading: Container(
                    height: 50,
                    width: 50,
                    padding: const EdgeInsets.all(1.5),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60.0),
                      child: Image.asset("assets/icons/logo_dms.png",fit: BoxFit.contain,scale: 1,),
                    ),
                  ),
                  title: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                  ),
                  subtitle: Text(text,style:  const TextStyle(color: Colors.black),),
                ),
              ),
            ),
          ),
        ),
      );
    }, duration: const Duration(milliseconds: 4000));
  }


  // static void showDialogAssignReceiveCustomer(BuildContext context, String tripName,String date, String typeCustomer,  String title, String body, {VoidCallback onTapAcceptNotification,VoidCallback onTapCancelNotification}) =>
  //     showOverlayNotification((context){
  //       return Center(
  //         child: Padding(
  //           padding: EdgeInsets.only(left: 30, right: 30, top: 200),
  //           child: Container(
  //             decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
  //             height: 300,
  //             width: double.infinity,
  //             child: Material(
  //                 animationDuration: Duration(seconds: 3),
  //                 borderRadius: BorderRadius.all(Radius.circular(16)),
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(20),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       CircularCountDownTimer(
  //                         autoStart: true,
  //                         duration: 180,
  //                         initialDuration: 0,
  //                         width: 80,
  //                         height: 80,
  //                         ringColor: Colors.grey[300],
  //                         ringGradient: null,
  //                         fillColor: Colors.purpleAccent[100],
  //                         fillGradient: null,
  //                         backgroundColor: Colors.white,
  //                         backgroundGradient: null,
  //                         strokeWidth: 5,
  //                         strokeCap: StrokeCap.round,
  //                         textStyle: TextStyle(fontSize: 24.0, color: Colors.amberAccent, fontWeight: FontWeight.bold),
  //                         isReverse: true,
  //                         isReverseAnimation: true,
  //                         isTimerTextShown: true,
  //                         onComplete: () {
  //                           OverlaySupportEntry.of(context).dismiss();
  //                           onTapCancelNotification();
  //                         },
  //                       ),
  //                       Table(
  //                         border: TableBorder.all(color: Colors.orange),
  //                         columnWidths: const <int, TableColumnWidth>{
  //                           0: FixedColumnWidth(120),
  //                           1: FlexColumnWidth(),
  //                         },
  //                         defaultVerticalAlignment: TableCellVerticalAlignment.middle,
  //                         children: [
  //                           TableRow(
  //                             children: [
  //                               TableCell(
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Text(
  //                                     'Chuyến:',
  //                                     style: TextStyle(fontWeight: FontWeight.bold),
  //                                   ),
  //                                 ),
  //                               ),
  //                               TableCell(
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Text('$tripName'),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           TableRow(
  //                             children: [
  //                               TableCell(
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Text(
  //                                     'Ngày',
  //                                     style: TextStyle(fontWeight: FontWeight.bold),
  //                                   ),
  //                                 ),
  //                               ),
  //                               TableCell(
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Text(date),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           TableRow(children: [
  //                             TableCell(
  //                               child: Padding(
  //                                 padding: const EdgeInsets.all(8.0),
  //                                 child: Text(
  //                                   'Thời gian:',
  //                                   style: TextStyle(fontWeight: FontWeight.bold),
  //                                 ),
  //                               ),
  //                             ),
  //                             TableCell(
  //                               child: Padding(
  //                                 padding: const EdgeInsets.all(8.0),
  //                                 child: Text(typeCustomer == '1' ? 'Khách đón' : 'Khách trả'),
  //                               ),
  //                             ),
  //                           ]),
  //                         ],
  //                       ),
  //                       Container(
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Expanded(
  //                               child: SizedBox(
  //                                   width: double.infinity,
  //                                   child: ElevatedButton(
  //                                     onPressed: () {
  //                                       OverlaySupportEntry.of(context).dismiss();
  //                                       onTapCancelNotification();
  //                                     },
  //                                     child: Text('Từ chối'),
  //                                   )),
  //                             ),
  //                             SizedBox(
  //                               width: 15,
  //                             ),
  //                             Expanded(
  //                               child: SizedBox(
  //                                 width: double.infinity,
  //                                 child: ElevatedButton(
  //                                   onPressed: () {
  //                                     OverlaySupportEntry.of(context).dismiss();
  //                                     onTapAcceptNotification();
  //                                   },
  //                                   child: Text(
  //                                     'Nhận ${typeCustomer == '1' ? 'đón' : 'trả'}',
  //                                     style: TextStyle(color: white),
  //                                   ),
  //                                   style: ButtonStyle(
  //                                     backgroundColor: MaterialStateProperty.all(Colors.orange),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 )),
  //           ),
  //         ),
  //       );
  //     },duration: Duration(seconds: 180));

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

  // static Future<List<String>> showDialogAssign({@required BuildContext context, @required String titleHintText, Function accept, Function cancel, bool dismissible: false})
  // => showDialog(
  //     barrierDismissible: dismissible,
  //     context: context,
  //     builder: (context) {
  //       return Center(
  //         child: Padding(
  //           padding: EdgeInsets.only(left: 30, right: 30),
  //           child: Container(
  //             decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
  //             height: 250,
  //             width: double.infinity,
  //             child: Material(
  //                 animationDuration: Duration(seconds: 3),
  //                 borderRadius: BorderRadius.all(Radius.circular(16)),
  //                 child: Column(
  //                   children: [
  //                     Expanded(
  //                         flex: 3,
  //                         child: Container(
  //                           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16))),
  //                           child: Align(
  //                             alignment: Alignment.centerLeft,
  //                             child: Padding(
  //                               padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 mainAxisAlignment: MainAxisAlignment.start,
  //                                 children: [
  //                                   Align(
  //                                       alignment: Alignment.centerLeft,
  //                                       child: Text(
  //                                         titleHintText,
  //                                         style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
  //                                       )),
  //                                   SizedBox(
  //                                     height: 10,
  //                                   ),
  //                                   Divider(),
  //                                   SizedBox(
  //                                     height: 10,
  //                                   ),
  //                                   SizedBox(
  //                                     height: 8,
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         )),
  //                     Expanded(
  //                         child: Container(
  //                           padding: const EdgeInsets.only(right: 20),
  //                           decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.only(bottomRight: Radius.circular(16), bottomLeft: Radius.circular(16))),
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.end,
  //                             crossAxisAlignment: CrossAxisAlignment.center,
  //                             mainAxisSize: MainAxisSize.max,
  //                             children: [
  //                               InkWell(
  //                                 onTap: ()=>Navigator.pop(context),
  //                                 child: Text(
  //                                   'Huỷ',
  //                                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
  //                                 ),
  //                               ),
  //                               SizedBox(
  //                                 width: 60,
  //                               ),
  //                               InkWell(
  //                                 onTap: ()=>Navigator.pop(context,['OK']),
  //                                 child: Text(
  //                                   'Nhận',
  //                                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
  //                                 ),
  //                               )
  //                             ],
  //                           ),
  //                         )),
  //                   ],
  //                 )),
  //           ),
  //         ),
  //       );
  //     });

  // Future<Uint8List> getBytesFromAsset(String path, int width) async {
  //   ByteData data = await rootBundle.load(path);
  //   ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  //   ui.FrameInfo fi = await codec.getNextFrame();
  //   return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  // }

  // Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(String path, int width) async {
  //   final Uint8List imageData = await getBytesFromAsset(path, width);
  //   return BitmapDescriptor.fromBytes(imageData);
  // }

  // static Future<bool> showDialogAssign2({@required BuildContext context, @required String tripName, @required String date, @required String typeCustomer, @required int type}) => showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) {
  //       return WillPopScope(
  //         onWillPop: () async {
  //           return false;
  //         },
  //         child: Center(
  //           child: Padding(
  //             padding: EdgeInsets.only(left: 30, right: 30),
  //             child: Container(
  //               decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
  //               height: 300,
  //               width: double.infinity,
  //               child: Material(
  //                   animationDuration: Duration(seconds: 3),
  //                   borderRadius: BorderRadius.all(Radius.circular(16)),
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(20),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         CircularCountDownTimer(
  //                           autoStart: true,
  //                           duration: 180,
  //                           initialDuration: 0,
  //                           width: 80,
  //                           height: 80,
  //                           ringColor: Colors.grey[300],
  //                           ringGradient: null,
  //                           fillColor: Colors.purpleAccent[100],
  //                           fillGradient: null,
  //                           backgroundColor: Colors.white,
  //                           backgroundGradient: null,
  //                           strokeWidth: 5,
  //                           strokeCap: StrokeCap.round,
  //                           textStyle: TextStyle(fontSize: 24.0, color: Colors.amberAccent, fontWeight: FontWeight.bold),
  //                           isReverse: true,
  //                           isReverseAnimation: true,
  //                           isTimerTextShown: true,
  //                           onComplete: () {
  //                             Navigator.pop(context, false);
  //                           },
  //                         ),
  //                         Table(
  //                           border: TableBorder.all(color: Colors.orange),
  //                           columnWidths: const <int, TableColumnWidth>{
  //                             0: FixedColumnWidth(120),
  //                             1: FlexColumnWidth(),
  //                           },
  //                           defaultVerticalAlignment: TableCellVerticalAlignment.middle,
  //                           children: [
  //                             TableRow(
  //                               children: [
  //                                 TableCell(
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(8.0),
  //                                     child: Text(
  //                                       'Chuyến:',
  //                                       style: TextStyle(fontWeight: FontWeight.bold),
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 TableCell(
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(8.0),
  //                                     child: Text('$tripName'),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             TableRow(
  //                               children: [
  //                                 TableCell(
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(8.0),
  //                                     child: Text(
  //                                       'Ngày',
  //                                       style: TextStyle(fontWeight: FontWeight.bold),
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 TableCell(
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(8.0),
  //                                     child: Text(date),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             TableRow(children: [
  //                               TableCell(
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Text(
  //                                     'Thời gian:',
  //                                     style: TextStyle(fontWeight: FontWeight.bold),
  //                                   ),
  //                                 ),
  //                               ),
  //                               TableCell(
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Text(typeCustomer == '1' ? 'Khách đón' : 'Khách trả'),
  //                                 ),
  //                               ),
  //                             ]),
  //                           ],
  //                         ),
  //                         Container(
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               Expanded(
  //                                 child: SizedBox(
  //                                     width: double.infinity,
  //                                     child: ElevatedButton(
  //                                       onPressed: () {
  //                                         Navigator.pop(context, false);
  //                                       },
  //                                       child: Text('Từ chối'),
  //                                     )),
  //                               ),
  //                               SizedBox(
  //                                 width: 15,
  //                               ),
  //                               Expanded(
  //                                 child: SizedBox(
  //                                   width: double.infinity,
  //                                   child: ElevatedButton(
  //                                     onPressed: () {
  //                                       Navigator.pop(context, true);
  //                                     },
  //                                     child: Text(
  //                                       'Nhận ${typeCustomer == '1' ? 'đón' : 'trả'}',
  //                                       style: TextStyle(color: white),
  //                                     ),
  //                                     style: ButtonStyle(
  //                                       backgroundColor: MaterialStateProperty.all(Colors.orange),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   )),
  //             ),
  //           ),
  //         ),
  //       );
  //     });

  static Future showDialogReceiveCustomerFormTC({required BuildContext context, required String laiXeTC,String? sdtLaiXeTC,String? soKhach, required String date}) => showDialog(
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
                            child: SpinKitPouringHourGlass(
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
                                      child: Text(sdtLaiXeTC.toString()),
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


  static void showCustomToast(BuildContext context,IconData icon, String title){
    showToastWidget(
      customToast(context, icon, title),
      duration: const Duration(seconds: 3),
      onDismiss: () {},
    );
  }



  static Future showDialogTransferCustomerLimo({required BuildContext context, required List<DsKhachs> listOfDetailTripsSuccessful, required String content, Function? accept, Function? cancel, bool dismissible: false}) => showDialog(
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
                                            child: SpinKitPouringHourGlass(
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