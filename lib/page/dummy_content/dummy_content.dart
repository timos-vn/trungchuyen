import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
import 'package:trungchuyen/page/main/main_bloc.dart';
import 'package:trungchuyen/page/main/main_event.dart';
import 'package:trungchuyen/page/map/map_bloc.dart';
import 'package:trungchuyen/page/reason_cancel/reason_cancel_page.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/themes/font.dart';
import 'package:trungchuyen/themes/images.dart';
import 'package:trungchuyen/utils/utils.dart';
import 'package:trungchuyen/widget/marquee_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class DummyContent extends StatefulWidget {
  final bool reverse;
  final ScrollController controller;
  final List<DetailTripsReponseBody> listOfDetailTrips;
  final int currentNumberCustomerOfList;

  const DummyContent({Key key, this.controller, this.reverse = false,this.listOfDetailTrips,this.currentNumberCustomerOfList}) : super(key: key);

  @override
  _DummyContentState createState() => _DummyContentState();
}

class _DummyContentState extends State<DummyContent> {

  MainBloc _mainBloc;
  MapBloc _mapBloc;
/*
  Khách đón:
    2. Chờ đón.
    3. Đang đón.
    4. Đã đón.
  Khách trả:
    5: Chờ nhận
    6. Đã nhận
    7. Đang trả
    8. Đã trả
 */

  int _countCustomerSuccessfulOrCancel=0;
//  int _currentNumberCustomerOfList =0;

  int statusDon=2;
  int statusTra=5;

  // bool codeGiaoKhachChoLimo;
  //
  // String statusDangDon;
  // int codeDangdon = 3;
  // String statusDaDon;
  // int codeDaDon =4;
  //
  // String statusDaNhan;
  // int codeDaNhan = 6;
  // String statusDangTra;
  // int codeDangTra =7;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // if(_currentNumberCustomerOfList == 0)  _currentNumberCustomerOfList = widget.listOfDetailTrips.length;
    _mainBloc = BlocProvider.of<MainBloc>(context);
    _mapBloc = MapBloc(context);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: SingleChildScrollView(
        reverse: this.widget.reverse,
        padding: EdgeInsets.zero,
        //padding: EdgeInsets.all(20).copyWith(top: 30),
        controller: widget.controller,
        child: !Utils.isEmpty(widget.listOfDetailTrips)
            ?
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.asset(
                                      icLogo,
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Expanded(
                                                child: MarqueeWidget(
                                                  direction: Axis.horizontal,
                                                  child: Text(
                                                    widget.listOfDetailTrips[0].diaChiKhachDi?.toString()??'Không có địa chỉ Khách',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: primaryColor,
                                                      fontWeight: FontWeight.bold
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                )),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),

                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text("SĐT: " + widget.listOfDetailTrips[0].soDienThoaiKhach, style: TextStyle(fontSize: 12, color: Colors.grey)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'Tên KH: ${widget.listOfDetailTrips[0].tenKhachHang??''}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style:TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.normal,
                                            color: Theme.of(Get.context).textTheme.title.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.all(Radius.circular(8))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    '${_countCustomerSuccessfulOrCancel.toString()}/${widget.currentNumberCustomerOfList.toString()}',
                                    style: Theme.of(Get.context).textTheme.title.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                  ),
                                  Text(
                                    'Khách',
                                    style: Theme.of(Get.context).textTheme.caption.copyWith(
                                          color: Theme.of(Get.context).disabledColor,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 0.5,
                        color: Theme.of(Get.context).disabledColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20, left: 14, top: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Trip (Chuyến đi)',
                                  style: Theme.of(Get.context).textTheme.caption.copyWith(
                                        color: Theme.of(Get.context).disabledColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                SizedBox(height: 3,),
                                Text(
                                  _mainBloc.trips?.toString() ?? "",
                                  style: Theme.of(Get.context).textTheme.subtitle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(Get.context).textTheme.title.color,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 0.5,
                        color: Theme.of(Get.context).disabledColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20, left: 14, top: 5, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Thông tin LX Limousine',
                                  style: Theme.of(Get.context).textTheme.caption.copyWith(
                                        color: Theme.of(Get.context).disabledColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      widget.listOfDetailTrips[0].dienThoaiTaiXeLimousine?.toString()??"",
                                      style: Theme.of(Get.context).textTheme.subtitle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(Get.context).textTheme.title.color,
                                          ),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      ' - ',
                                      style: Theme.of(Get.context).textTheme.subtitle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      widget.listOfDetailTrips[0].bienSoXeLimousine?.toString()??"",
                                      style: Theme.of(Get.context).textTheme.subtitle.copyWith(fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => launch("tel://${widget.listOfDetailTrips[0].dienThoaiTaiXeLimousine}"),
                              child: Column(
                                children: [
                                  Icon(Icons.phone_missed_outlined),
                                  Text(
                                    'Lái xe',
                                    style: Theme.of(Get.context).textTheme.caption.copyWith(color: Theme.of(Get.context).disabledColor, fontWeight: FontWeight.normal, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 0.5,
                        color: Theme.of(Get.context).disabledColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 14, left: 14, top: 15, bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return WillPopScope(
                                          onWillPop: () async => false,
                                          child: ReasonCancelPage(),
                                        );
                                      }).then((value){
                                        if(!Utils.isEmpty(value)){
                                          //_mapBloc.add(UpdateStatusCustomerEvent());
                                          _countCustomerSuccessfulOrCancel++;
                                          _mainBloc.add(UpdateStatusCustomerEvent(status: 9,idTrungChuyen: [widget.listOfDetailTrips[0].idTrungChuyen],note: value[0]));
                                          Utils.showToast('Huỷ khách thành công');
                                        }
                                  });
                                },
                                child: Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Huỷ Khách',
                                      style: Theme.of(Get.context).textTheme.button.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  /// chuyển trạng thái đang đón khách
                                  setState(() {
                                    // don
                                    if(widget.listOfDetailTrips[0].loaiKhach == 1){
                                      if(statusDon == 2){
                                        /// next Đang đón
                                        statusDon = 3;
                                        _mainBloc.add(UpdateStatusCustomerEvent(status: 3,idTrungChuyen: [widget.listOfDetailTrips[0].idTrungChuyen]));
                                        Utils.showToast('Đang đi đón khách');
                                      }else if(statusDon == 3){
                                        /// nex Đã đón
                                        _mainBloc.add(UpdateStatusCustomerEvent(status: 4,idTrungChuyen: [widget.listOfDetailTrips[0].idTrungChuyen]));
                                        _countCustomerSuccessfulOrCancel++;
                                        statusDon = 2;
                                        Utils.showToast('Đón khách thành công - chuyển sang khách tiếp theo');
                                        if(!Utils.isEmpty(widget.listOfDetailTrips)){
                                          widget.listOfDetailTrips.removeAt(0);
                                        }
                                      }
                                    }
                                    //tra
                                    else{

                                      /// bắn notification xác nhận - nhận được khách từ tài xế Limo
                                      if(statusTra == 6){
                                        statusTra = 7;/// nex Đang trả
                                        _mainBloc.add(UpdateStatusCustomerEvent(status: 7,idTrungChuyen: [widget.listOfDetailTrips[0].idTrungChuyen]));
                                        Utils.showToast('Đang đi trả khách');
                                      }else if(statusTra == 8){
                                        /// Đã trả
                                        _mainBloc.add(UpdateStatusCustomerEvent(status: 8,idTrungChuyen: [widget.listOfDetailTrips[0].idTrungChuyen]));
                                        _countCustomerSuccessfulOrCancel++;
                                        statusTra = 6;
                                        Utils.showToast('Trả khách thành công');
                                        if(!Utils.isEmpty(widget.listOfDetailTrips)){
                                          widget.listOfDetailTrips.removeAt(0);
                                        }
                                      }
                                    }
                                  });
                                },
                                child: Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                    widget.listOfDetailTrips[0].loaiKhach == 1
                                        ?
                                    (statusDon == 2 ? Colors.orange : (statusDon == 3 ? Colors.blueAccent : statusDon == 4 ? Colors.orange : Colors.orange))
                                        :
                                    (statusTra == 6 ? Colors.orange : (statusTra == 7 ? Colors.blueAccent : statusTra == 8 ? Colors.orange : Colors.orange)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.listOfDetailTrips[0].loaiKhach == 1
                                          ?
                                      (statusDon == 2 ? 'Đón khách' : (statusDon == 3 ? 'Đang đón' : statusDon == 4 ? 'Đã đón' : ''))
                                          :
                                      (statusTra == 6 ? 'Nhận khách' : (statusTra == 7 ? 'Đang trả' : statusTra == 8 ? 'Đã trả' : ''))
                                      ,
                                      style: Theme.of(Get.context).textTheme.button.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
              ],
            ),
            Container(
              height: 600,
              child: Column(
                children: [
                  // SizedBox(height: 35,),
                  Row(
                    children: [
                      Expanded(child: Divider()),
                      Text('Danh sách Khách Đón/Trả'),
                      Expanded(child: Divider()),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 10, right: 16),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(Get.context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(0),
                                boxShadow: [
                                  new BoxShadow(
                                    //color: Theme.of(Get.context).accentColor,
                                    blurRadius: 1,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(14),
                                    color: Colors.grey.withOpacity(0.2),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.asset(
                                            icLogo,
                                            height: 40,
                                            width: 40,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Text(
                                                  widget.listOfDetailTrips[index].tenKhachHang?.toString()??'',
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text('(${widget.listOfDetailTrips[index].soDienThoaiKhach})', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                              ],
                                            ),
                                            // SizedBox(
                                            //   height: 4,
                                            // ),
                                            // Container(
                                            //   width: 74,
                                            //   padding: EdgeInsets.all(2),
                                            //   child: Center(
                                            //     child: Text(
                                            //       '2 Khách',
                                            //       style: TextStyle(color: Colors.black, fontSize: 12),
                                            //     ),
                                            //   ),
                                            //   decoration: BoxDecoration(
                                            //     borderRadius: BorderRadius.all(
                                            //       Radius.circular(15),
                                            //     ),
                                            //     color: Colors.orange,
                                            //   ),
                                            // )
                                          ],
                                        ),
                                        Expanded(
                                          child: SizedBox(),
                                        ),
                                        // Column(
                                        //   crossAxisAlignment: CrossAxisAlignment.end,
                                        //   children: <Widget>[
                                        //     Text(
                                        //       '5 phút',
                                        //       style: TextStyle(fontWeight: FontWeight.bold),
                                        //     ),
                                        //     Text(
                                        //       '2.2 km',
                                        //       style: Theme.of(Get.context).textTheme.caption.copyWith(
                                        //             color: Theme.of(Get.context).disabledColor,
                                        //             fontWeight: FontWeight.bold,
                                        //           ),
                                        //     ),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 0.5,
                                    color: Theme.of(Get.context).disabledColor,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16, left: 16, top: 10, bottom: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Pickup point (Điểm đón)',
                                          style: Theme.of(Get.context).textTheme.caption.copyWith(
                                                color: Theme.of(Get.context).disabledColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          widget.listOfDetailTrips[index].diaChiKhachDi?.toString()??'',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(Get.context).textTheme.subtitle.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(Get.context).textTheme.title.color,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16, left: 16, top: 0, bottom: 0),
                                    child: Divider(
                                      height: 0.5,
                                      color: Theme.of(Get.context).disabledColor,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8, left: 16, top: 10, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Thông tin LX Limousine',
                                              style: Theme.of(Get.context).textTheme.caption.copyWith(
                                                color: Theme.of(Get.context).disabledColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  widget.listOfDetailTrips[index].dienThoaiTaiXeLimousine?.toString()??'',
                                                  style: Theme.of(Get.context).textTheme.subtitle.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(Get.context).textTheme.title.color,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  ' - ',
                                                  style: Theme.of(Get.context).textTheme.subtitle.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  '( ${widget.listOfDetailTrips[index].dienThoaiTaiXeLimousine?.toString()??""} )',
                                                  style: Theme.of(Get.context).textTheme.subtitle.copyWith(fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        // GestureDetector(
                                        //   onTap: () => launch("tel://0963004959"),
                                        //   child: Container(
                                        //     padding: EdgeInsets.all(5),
                                        //     decoration: BoxDecoration(
                                        //       borderRadius: BorderRadius.all(Radius.circular(8)),
                                        //       color: Colors.orange
                                        //     ),
                                        //     child: Column(
                                        //       children: [
                                        //         Icon(Icons.phone_missed_outlined,color: Colors.white,),
                                        //         Text(
                                        //           'Lái xe',
                                        //           style: Theme.of(Get.context).textTheme.caption.copyWith(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 13),
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16, left: 16, top: 0, bottom: 0),
                                    child: Divider(
                                      height: 0.5,
                                      color: Theme.of(Get.context).disabledColor,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 14, left: 14, top: 15, bottom: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return WillPopScope(
                                                      onWillPop: () async => false,
                                                      child: ReasonCancelPage(),
                                                    );
                                                  });
                                            },
                                            child: Container(
                                              height: 35,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.grey,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Huỷ Khách',
                                                  style: Theme.of(Get.context).textTheme.button.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            child: Container(
                                              height: 35,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.orange,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Gọi Khách',
                                                  style: Theme.of(Get.context).textTheme.button.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) => Container(
                              height: 16,
                            ),
                        itemCount: widget.listOfDetailTrips.length),
                  ),
                ],
              ),
            )
          ],
        )
            :
        widget.currentNumberCustomerOfList == _countCustomerSuccessfulOrCancel && !Utils.isEmpty(widget.listOfDetailTrips)
            ?
        Padding(
          padding: const EdgeInsets.only(left: 10,right: 10,top: 2),
          child: Container(
            child: Column(
              children: [
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
                              'Điểm đến:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(_mainBloc.trips.toString().split(' / ')[0] ?? "",),
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
                              'Thời gian chạy:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text( !Utils.isEmpty(_mainBloc.trips) ? _mainBloc.trips.toString().split(' / ')[1] ?? "" : "",),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(left: 16,right: 16),
                  child: InkWell(
                    onTap: (){
                      print(_mainBloc.listTaiXeLimo[0].soKhach.toString());
                      //_mainBloc.add(UpdateStatusCustomerEvent(status: 10,idTrungChuyen: [widget.listOfDetailTrips[0].idTrungChuyen]));
                     Utils.showDialogTransferCustomer(context: context,listOfDetailTripsSuccessful: _mainBloc.listTaiXeLimo);
                    },
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.orange
                      ),
                      child: Center(
                        child: Text(
                          'Giao khách cho Limo',
                          style: TextStyle(fontFamily: fontSub, fontSize: 16, color: white,),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Text('Danh sách Lái xe Limo cần giao khách',style: TextStyle(color: Colors.grey,fontSize: 11),),
                    Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 20,),
                Container(
                  height: 300,
                  child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10, right: 16),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(Get.context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(0),
                              boxShadow: [
                                new BoxShadow(
                                  //color: Theme.of(Get.context).accentColor,
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  color: Colors.grey.withOpacity(0.2),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          icLogo,
                                          height: 40,
                                          width: 40,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _mainBloc.listTaiXeLimo[index].hoTenTaiXeLimousine?.toString()??'',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text('Số điện thoại: ${_mainBloc.listTaiXeLimo[index].dienThoaiTaiXeLimousine}', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text('Biển số xe: ${_mainBloc.listTaiXeLimo[index].bienSoXeLimousine}', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                Divider(
                                  height: 0.5,
                                  color: Theme.of(Get.context).disabledColor,
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(right: 14, left: 14, top: 15, bottom: 12),
                                  child: GestureDetector(
                                    child: Container(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.blueAccent,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Gọi Lái xe Limo',
                                          style: Theme.of(Get.context).textTheme.button.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => Container(
                        height: 16,
                      ),
                      itemCount: _mainBloc.listTaiXeLimo.length)
                )
              ],
            ),
          ),
        )
            :
        Container(
          child: Center(child: Align(alignment: Alignment.center,child: Text('Hiện tại chưa có khách \n Hoặc \n Sang nhóm khách và chọn khách để đón nhé.'))),
        ),
      ),
    );
  }
}
