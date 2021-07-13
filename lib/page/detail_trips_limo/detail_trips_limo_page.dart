import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:url_launcher/url_launcher.dart';

import 'detail_trips_limo_bloc.dart';
import 'detail_trips_limo_state.dart';

class DetailTripsLimoPage extends StatefulWidget {

  final String dateTime;
  final int idTrips;
  final int idTime;
  final String tuyenDuong;

  const DetailTripsLimoPage({Key key,this.dateTime, this.idTrips, this.idTime,this.tuyenDuong}) : super(key: key);

  @override
  _DetailTripsLimoPageState createState() => _DetailTripsLimoPageState();
}

class _DetailTripsLimoPageState extends State<DetailTripsLimoPage> {

  DetailTripsLimoBloc _bloc;
  List<DetailTripsLimoReponseBody> _listOfDetailTripsLimo = new List<DetailTripsLimoReponseBody>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = DetailTripsLimoBloc(context);
    _bloc.add(GetListDetailTripsLimo(widget.dateTime,widget.idTrips,widget.idTime));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Danh sách Khách',
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
    );
  }

  Stack buildPage(BuildContext context,DetailTripsLimoState state){
    return Stack(
      children: [
        Column(
          children: <Widget>[
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

  Widget buildListItem(DetailTripsLimoReponseBody item, int index) {
    return GestureDetector(
        onTap: () {

        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 16, top: 8, bottom: 8),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(this.context).scaffoldBackgroundColor,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                     Row(
                       children: [
                         ClipRRect(
                           borderRadius: BorderRadius.circular(10),
                           child: Image.asset(
                             icLogo,
                             height: 40,
                             width: 40,
                           ),
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
                  padding: const EdgeInsets.only(right: 16, left: 16, top: 0, bottom: 0),
                  child: Divider(
                    height: 0.5,
                    color: Theme.of(this.context).disabledColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16, left: 16, top: 10, bottom: 10),
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
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.all(Radius.circular(16))
                            ),
                            child: Center(
                              child: //
                              item.khachTrungChuyen == 1 ? Text(
                                '${(item.trangThaiTC == 10
                                    ? 'Chờ Limo Xác Nhận'
                                    :
                                (item.trangThaiTC == 9 ? 'Khách Huỷ'
                                    :
                                item.trangThaiTC == 11 ? 'Hoàn Thành'
                                    :
                                (item.trangThaiTC == 2 || item.trangThaiTC == 3) ? 'Đang đón'
                                    :
                               'Đang xử lý')
                                )}',
                                style: Theme.of(this.context).textTheme.caption.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ) :
                              Text(
                                '${(item.trangThaiVe == 1 || item.trangThaiVe == 2
                                    ? 'Chờ Limo Xác Nhận'
                                    :
                                (item.trangThaiVe == 3
                                    ? 'Khách Huỷ'
                                    :
                                item.trangThaiVe == 4 ? 'Chờ Admin xử lý' :
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
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item.tenKhachHang??''}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(this.context).textTheme.subtitle.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Theme.of(this.context).textTheme.title.color,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '${item.soDienThoaiKhach??''}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(this.context).textTheme.subtitle.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Theme.of(this.context).textTheme.title.color,
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
                      Divider(),
                      Text(
                        'Địa chỉ khách đến: ${item.diaChiKhachDen??''}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(this.context).textTheme.subtitle.copyWith(
                          fontWeight: FontWeight.normal,
                          color: Theme.of(this.context).textTheme.title.color,
                        ),
                      ),
                      Divider(),
                      Text(
                        'Địa chỉ khách đi: ${item.diaChiKhachDi??''}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(this.context).textTheme.subtitle.copyWith(
                          fontWeight: FontWeight.normal,
                          color: Theme.of(this.context).textTheme.title.color,
                        ),
                      ),
                      Divider(),
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
                                   _bloc.add(ConfirmCustomerLimoEvent(item.idDatVe, 3,value));
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
                                  _bloc.add(ConfirmCustomerLimoEvent(item.idDatVe, 5,value));
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
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
