import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timelines/timelines.dart';
import 'package:trungchuyen/extension/customer_clip_path.dart';
import 'package:trungchuyen/models/network/response/detail_trips_limo_reponse.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
import 'package:trungchuyen/models/network/response/list_of_group_limo_customer_response.dart';
import 'package:trungchuyen/page/detail_trips_limo/detail_trips_limo_event.dart';
import 'package:trungchuyen/page/note/note_page.dart';
import 'package:trungchuyen/page/reason_cancel/reason_cancel_page.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/themes/font.dart';
import 'package:trungchuyen/themes/images.dart';
import 'package:intl/intl.dart';
import 'package:trungchuyen/utils/utils.dart';
import 'package:trungchuyen/widget/separator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'detail_trips_limo_bloc.dart';
import 'detail_trips_limo_state.dart';

class DetailTripsLimoPage extends StatefulWidget {

  final String dateTime;
  final int idTrips;
  final int idTime;
  final String tuyenDuong;
  final String tenTuyenDuong;
  final String thoiGianDi;

  const DetailTripsLimoPage({Key key,this.dateTime, this.idTrips, this.idTime,this.tuyenDuong,this.tenTuyenDuong,this.thoiGianDi}) : super(key: key);

  @override
  _DetailTripsLimoPageState createState() => _DetailTripsLimoPageState();
}

class _DetailTripsLimoPageState extends State<DetailTripsLimoPage> {

  DetailTripsLimoBloc _bloc;
  List<DsKhachs> _listOfDetailTripsLimo = new List<DsKhachs>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = DetailTripsLimoBloc(context);
    _bloc.add(GetListDetailTripsLimo(widget.dateTime,widget.idTrips,widget.idTime));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.tenTuyenDuong?.toString()??"",
              style: TextStyle(color: Colors.black),
            ),
             centerTitle: true,
          ),
          body:BlocListener<DetailTripsLimoBloc,DetailTripsLimoState>(
            bloc: _bloc,
            listener:  (context, state){
              if(state is GetListOfDetailTripsLimoSuccess){
                _listOfDetailTripsLimo = _bloc.listOfDetailTripsLimo;
                print('ok');
              }
              else if(state is ConfirmCustomerLimoSuccess){
                if(state.status == 3){
                  Utils.showToast('Huỷ khách thành công');
                }else if(state.status == 5){
                  Utils.showToast('Nhận khách thành công');
                }
                _bloc.add(GetListDetailTripsLimo(widget.dateTime,widget.idTrips,widget.idTime));
              }
            },
            child: BlocBuilder<DetailTripsLimoBloc,DetailTripsLimoState>(
              bloc: _bloc,
              builder: (BuildContext context, DetailTripsLimoState state) {
                return buildPage(context,state);
              },
            ),
            //),
          )
      ),
    );
  }

  Stack buildPage(BuildContext context,DetailTripsLimoState state){
    return Stack(
      children: [
        Column(
          children: <Widget>[
            Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: {
                0: IntrinsicColumnWidth(),
                1: FlexColumnWidth(),
                2: FlexColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 30,right: 30),
                      height: 35,
                      child: Center(child: Text('Chuyến')),
                    ),
                    Container(
                      height: 35,
                      child: Center(child: Text(widget.thoiGianDi?.toString()??'')),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      height: 35,
                      child: Center(child: Text('Tổng khách')),
                    ),
                    Container(
                      height: 35,
                      child: Center(child: Text(_bloc.totalCustomer?.toString()??'')),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      height: 35,
                      child: Center(child: Text('Số khách huỷ')),
                    ),
                    Container(
                      height: 35,
                      child:Center(child: Text( _bloc.totalCustomerCancel?.toString()??'',style: TextStyle(fontSize: 12,color: red),textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,)) ,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(child: Divider()),
                Text('Chi tiết',style: TextStyle(color:Colors.grey,),),
                Expanded(child: Divider()),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Scrollbar(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _listOfDetailTripsLimo.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildListItem(_listOfDetailTripsLimo[index],index);
                      })
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom + 16,
            )
          ],
        ),
        Visibility(
          visible: state is DetailTripsLimoLoading,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  Widget buildListItem(DsKhachs item, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 16, top: 8, bottom: 8),
      child: Stack(
        children: [
          ClipPath(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(14),
                    color: Colors.grey.withOpacity(0.2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                       Row(
                         children: [
                           ClipRRect(
                             borderRadius: BorderRadius.circular(10),
                             child: Container(
                               padding: EdgeInsets.all(5),
                                 height: 50,
                                 decoration: BoxDecoration(
                                   color: Colors.blueAccent
                                 ),
                                 child: Center(child: Column(
                                   children: [
                                     Text('Mã',style: TextStyle(color: Colors.white),),
                                     Text(item.maVe?.toString()??'',style: TextStyle(color: Colors.white),),
                                   ],
                                 ))),
                           ),
                           SizedBox(width: 6,),
                           Visibility(
                             visible:item.khachTrungChuyen == 1 ,
                             child: GestureDetector(
                               onTap: () => launch("tel://${item.dienThoaiTaiXeTrungChuyen}"),
                               child: Container(
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text(item.hoTenTaiXeTrungChuyen?.toString()??''),
                                     SizedBox(height: 4,),
                                     Text(item.dienThoaiTaiXeTrungChuyen?.toString()??'',style: TextStyle(color: Colors.blue,fontSize: 11),),
                                   ],
                                 ),
                               ),
                             ),
                           ),
                         ],
                       ),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(16))
                          ),
                          child: Center(
                            child: Text(item.khachTrungChuyen == 1 ?
                              "Khách Trung chuyển" : "Khách thường",
                              style: Theme.of(this.context).textTheme.caption.copyWith(
                                color: Colors.pink,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 0.5,
                    color: Theme.of(this.context).disabledColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5, left: 5, top: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Thông tin khách',
                              style: Theme.of(this.context).textTheme.caption.copyWith(
                                color: Theme.of(this.context).disabledColor,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: (item.trangThaiTC == 9 || item.trangThaiVe == 3) ? Colors.black : (item.trangThaiTC == 11 || item.trangThaiVe == 6) ? Colors.grey : (item.trangThaiTC == 2 || item.trangThaiTC == 3) ? Colors.red : (item.trangThaiTC == 10) ? Colors.indigo : Colors.green,
                                  borderRadius: BorderRadius.all(Radius.circular(16))
                              ),
                              child: Center(
                                child: //
                                item.khachTrungChuyen == 1 ? Text(
                                  '${(
                                  item.trangThaiTC == 10 ? 'Bạn Chưa Xác Nhận'
                                      :
                                  (item.trangThaiTC == 9 ? 'Khách Huỷ'
                                      :
                                  item.trangThaiTC == 11 ? 'Hoàn Thành'
                                      :
                                  item.trangThaiTC == 2  ? 'Chờ đón'
                                      :
                                  item.trangThaiTC == 3 ? 'Đang đón'
                                      :
                                  (item.trangThaiTC == 6  || item.trangThaiTC == 7) ? 'TC đang trả khách'
                                      :
                                  item.trangThaiTC == 8 ? 'Trả khách thành công'
                                      :
                                 'Đợi ĐH TC xử lý')
                                  )}',
                                  style: Theme.of(this.context).textTheme.caption.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ) :
                                Text(
                                  '${(
                                      item.trangThaiVe == 1 ? "Đang đợi xếp lịch"
                                          :
                                      item.trangThaiVe == 2 ? 'Đã xếp lịch tài xế'
                                          :
                                      (item.trangThaiVe == 3 ? 'Đã xếp lịch trung chuyển'
                                          :
                                      item.trangThaiVe == 4 ? 'Khách huỷ'
                                          :
                                      item.trangThaiVe == 5 ? 'Đợi admin xử lý'
                                          :
                                      'Hoàn Thành')
                                  )}',
                                  style: Theme.of(this.context).textTheme.caption.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Separator(color: Colors.grey),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${item.tenKhachHang??''}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(this.context).textTheme.subtitle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(this.context).textTheme.title.color,
                                      ),
                                    ),
                                    SizedBox(width: 4,),
                                    Text(
                                      ' / ${item.soDienThoaiKhach??''}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(this.context).textTheme.subtitle.copyWith(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,fontSize: 11
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Số ghế: ${item.soGhe??''}' ,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(this.context).textTheme.subtitle.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.red,
                                    fontStyle: FontStyle.italic
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () => launch("tel://${item.soDienThoaiKhach}"),
                              child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(Icons.phone_callback_outlined)),
                            )
                          ],
                        ),
                        SizedBox(height: 5,),
                        Separator(color: Colors.grey),
                        SizedBox(height: 5,),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(MdiIcons.mapMarker,color: Colors.black.withOpacity(0.4),size: 20,),
                                    SizedBox(width: 15,),
                                    Expanded(
                                      child: Text(
                                        '${item.diaChiKhachDi??''}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(this.context).textTheme.subtitle.copyWith(
                                          fontWeight: FontWeight.normal,
                                          color: Theme.of(this.context).textTheme.title.color,
                                          fontStyle: FontStyle.italic
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              Text(
                                'Đi',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(this.context).textTheme.subtitle.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Theme.of(this.context).textTheme.title.color.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10,top: 5,bottom: 5),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 20.0,
                                child: DashedLineConnector(space: 20,gap: 3,dash: 1,),
                              ),
                              SizedBox(width: 15,),
                              Expanded(child: Divider(color: Colors.grey,)),
                              SizedBox(width: 15,),
                              Icon(MdiIcons.panVertical),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(MdiIcons.mapMarker,color: Colors.black.withOpacity(0.4),size: 20,),
                                    SizedBox(width: 15,),
                                    Expanded(
                                      child: Text(
                                        '${item.diaChiKhachDen??''}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(this.context).textTheme.subtitle.copyWith(
                                          fontWeight: FontWeight.normal,
                                          color: Theme.of(this.context).textTheme.title.color,
                                            fontStyle: FontStyle.italic
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Đến',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(this.context).textTheme.subtitle.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Theme.of(this.context).textTheme.title.color.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5,),
                        Separator(color: Colors.grey),
                        SizedBox(height: 5,),
                        Text(
                          'Ghi chú: ${item.ghiChu??''}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(this.context).textTheme.subtitle.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height:10,),
                        Visibility(
                          visible: item.khachTrungChuyen == 0 && ( item.trangThaiVe != 3 && item.trangThaiVe != 5), /// == 0 Khong TC
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap:(){
                                  // print(item.idDatVe);
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return WillPopScope(
                                          onWillPop: () async => false,
                                          child: ReasonCancelPage(),
                                        );
                                      }).then((value){
                                    if(!Utils.isEmpty(value)){
                                     _bloc.add(ConfirmCustomerLimoEvent(item.idDatVe, 4,value));
                                    }
                                  });
                                },
                                child: Container(
                                  width: 148.0,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18.0),
                                      color: Colors.grey
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Khách huỷ',
                                      style: TextStyle(fontFamily: fontSub, fontSize: 13, color: white,),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap:(){
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return WillPopScope(
                                          onWillPop: () async => false,
                                          child: NotePage(),
                                        );
                                      }).then((value){
                                    if(!Utils.isEmpty(value)){
                                      _bloc.add(ConfirmCustomerLimoEvent(item.idDatVe, 6,value));
                                    }
                                  });
                                },
                                child: Container(
                                  width: 148.0,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18.0),
                                      color: Colors.blue
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Xác nhận đón',
                                      style: TextStyle(fontFamily: fontSub, fontSize: 13, color: white,),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            clipper: CustomClipPath(),
          ),
          Visibility(
            visible: item.daThanhToan == 1 && item.trangThaiVe != 4 && item.trangThaiTC != 9,
            child: Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.all(10),
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(44)),
                    border: Border.all(
                        color: Colors.grey
                    )
                ),
                child: Center(
                  child: Text('Đã\nthanh toán',style: TextStyle(
                      color: Colors.white,fontSize: 11,
                  ),textAlign: TextAlign.center,),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
