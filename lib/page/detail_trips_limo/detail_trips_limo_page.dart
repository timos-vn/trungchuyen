import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timelines/timelines.dart';
import 'package:trungchuyen/extension/customer_clip_path.dart';
import 'package:trungchuyen/models/network/response/detail_trips_limo_reponse.dart';
import 'package:trungchuyen/page/detail_trips_limo/detail_trips_limo_event.dart';
import 'package:trungchuyen/page/main/main_bloc.dart';
import 'package:trungchuyen/page/main/main_event.dart';
import 'package:trungchuyen/page/note/note_page.dart';
import 'package:trungchuyen/page/reason_cancel/reason_cancel_page.dart';
import 'package:trungchuyen/themes/colors.dart';
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
  final int typeHistory;

  const DetailTripsLimoPage({Key key,this.dateTime, this.idTrips, this.idTime,this.tuyenDuong,this.tenTuyenDuong,this.thoiGianDi,this.typeHistory}) : super(key: key);

  @override
  _DetailTripsLimoPageState createState() => _DetailTripsLimoPageState();
}

class _DetailTripsLimoPageState extends State<DetailTripsLimoPage> {

  DetailTripsLimoBloc _bloc;
  MainBloc _mainBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainBloc = BlocProvider.of<MainBloc>(context);
    _bloc = DetailTripsLimoBloc(context);
    _mainBloc.add(GetListDetailTripsLimoMain(date: widget.dateTime,idTrips: widget.idTrips,idTime: widget.idTime));
    // _bloc.add(GetListDetailTripsLimo(widget.dateTime,widget.idTrips,widget.idTime));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: InkWell(
              onTap: ()=> Navigator.pop(context),
              child: Container(
                width: 40,
                height: double.infinity,
                child: Icon(Icons.arrow_back,color: Colors.black,),
              ),
            ),
            title: Text(
              widget.tenTuyenDuong?.toString()??"",
              style: TextStyle(color: Colors.black),
            ),
             centerTitle: true,
            backgroundColor: Colors.white,
            actions: [
              InkWell(
                  onTap: (){
                    _mainBloc.add(GetListDetailTripsLimoMain(date: widget.dateTime,idTrips: widget.idTrips,idTime: widget.idTime));
                  },
                  child: Icon(MdiIcons.reload,color: Colors.black,)),
              SizedBox(width: 20,)
            ],
          ),
          body:BlocListener<DetailTripsLimoBloc,DetailTripsLimoState>(
            bloc: _bloc,
            listener:  (context, state){
              if(state is ConfirmCustomerLimoSuccess){
                if(state.status == 4){
                  Utils.showToast('Hu??? kh??ch th??nh c??ng');
                }else if(state.status == 6){
                  Utils.showToast('Nh???n kh??ch th??nh c??ng');
                }
                //_bloc.add(GetListDetailTripsLimo(widget.dateTime,widget.idTrips,widget.idTime));
                _mainBloc.add(GetListDetailTripsLimoMain(date: widget.dateTime,idTrips: widget.idTrips,idTime: widget.idTime));
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
                      child: Center(child: Text('Chuy???n')),
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
                      child: Center(child: Text('T???ng kh??ch')),
                    ),
                    Container(
                      height: 35,
                      child: Center(child: Text(_mainBloc.totalCustomer?.toString()??'')),//_bloc.totalCustomer
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      height: 35,
                      child: Center(child: Text('S??? kh??ch hu???')),
                    ),
                    Container(
                      height: 35,
                      child:Center(child: Text( _mainBloc.totalCustomerCancel?.toString()??'',style: TextStyle(fontSize: 12,color: red),textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,)) ,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(child: Divider()),
                Text('Danh s??ch Kh??ch',style: TextStyle(color:Colors.grey,),),
                Expanded(child: Divider()),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(height: 1,color: Colors.black.withOpacity(0.5),),
            Expanded(
              child: Container(
                color: dark_text.withOpacity(0.3),
                child: Scrollbar(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _mainBloc.listOfDetailLimoTrips.length,
                        itemBuilder: (BuildContext context, int index) {
                          return buildListItem(_mainBloc.listOfDetailLimoTrips[index],index);
                        })
                ),
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
    return GestureDetector(
      onTap: (){
        if(widget.typeHistory == 1){
          showModalBottomSheet(
              backgroundColor: transparent,
              context: context,
              builder: (BuildContext context){
                return Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10),
                  child: Container(
                    height:item.khachTrungChuyen == 1 ? 220 : 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ///X??c nh???n kh??ch kh??ng trung chuy???n
                        Visibility(
                          visible: item.khachTrungChuyen == 0 && ( item.trangThaiVe != 4 && item.trangThaiVe != 6) && widget.typeHistory == 1, /// == 0 Khong TC
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pop(context,'ConfirmKhachThuong');
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(16)),
                                  color: Colors.white
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'X??c nh???n ????n',
                                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        ///X??c nh???n kh??ch trung chuy???n
                        // Visibility(
                        //   visible: item.khachTrungChuyen == 1 && ( item.trangThaiVe != 4 && item.trangThaiVe != 6) && widget.typeHistory == 1, /// == 0 Khong TC
                        //   child: GestureDetector(
                        //     onTap: (){
                        //       Navigator.pop(context,'ConfirmKhachTC');
                        //     },
                        //     child: Container(
                        //       height: 50,
                        //       decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.all(Radius.circular(16)),
                        //           color: Colors.white
                        //       ),
                        //       child: Align(
                        //         alignment: Alignment.center,
                        //         child: Text(
                        //           'X??c nh???n Kh??ch t??? trung chuy???n',
                        //           style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        //SizedBox(height: 15,),
                        ///Hu??? kh??ch
                        Visibility(
                          visible: (item.trangThaiVe != 7 && item.trangThaiVe != 4 && item.trangThaiVe != 6 && item.trangThaiVe != 8 && item.trangThaiVe != 9) && item.khachTrungChuyen != 1,
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pop(context,'CancelCustomer');
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(16)),
                                  color: Colors.white
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Kh??ch hu???',
                                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        /// G???i ??i???n cho Kh??ch
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context,'CallCustomer');
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                color: Colors.white
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'G???i ??i???n cho Kh??ch',
                                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        ///G???i ??i???n cho l??i xe trung chuy???n
                        Visibility(
                          visible: item.khachTrungChuyen == 1,
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pop(context,'CallLaiXeTC');
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(16)),
                                  color: Colors.white
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'G???i cho l??i xe trung chuy???n',
                                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                );
              }
          ).then((value) {
            if(value == 'ConfirmKhachThuong'){
              if(widget.typeHistory == 1){
                bool typeView = false;
                if(!(item.daThanhToan == 1 && item.trangThaiVe != 4 && item.trangThaiTC != 9)){
                  typeView = true;
                }
                showDialog(
                    context: context,
                    builder: (context) {
                      return WillPopScope(
                        onWillPop: () async => false,
                        child: NotePage(typeView: typeView,reasonOld: item.ghiChu,),
                      );
                    }).then((value){
                  if(!Utils.isEmpty(value)){
                    print(value);
                    _bloc.add(ConfirmCustomerLimoEvent(item.idDatVe, 6,value));
                  }
                });
              }
              else if(widget.typeHistory == 0){
                print('321');
              }
            }
            else if(value == 'ConfirmKhachTC'){

            }
            else if(value == 'CallCustomer'){
              if(Utils.isEmpty(item.soDienThoaiKhachDatHo)){
                if(!Utils.isEmpty(item.soDienThoaiKhach)) {
                  launch("tel://${item.soDienThoaiKhach}");
                }else{
                  Utils.showToast('Ch??a c?? s??? ??i???n tho???i c???a Kh??ch');
                }
              }else {
                if(!Utils.isEmpty(item.soDienThoaiKhachDatHo)) {
                  launch("tel://${item.soDienThoaiKhachDatHo}");
                }else{
                  Utils.showToast('Ch??a c?? s??? ??i???n tho???i c???a Kh??ch');
                }
              }
            }
            else if(value == 'CallLaiXeTC'){
              if(!Utils.isEmpty(item.dienThoaiTaiXeTrungChuyen)){
                launch("tel://${item.dienThoaiTaiXeTrungChuyen}");
              }else{
                Utils.showToast('Ch??a c?? s??? ??i???n tho???i c???a LXTC');
              }
            }
            else if(value == 'CancelCustomer'){
              showDialog(
                  context: context,
                  builder: (context) {
                    return WillPopScope(
                      onWillPop: () async => false,
                      child: ReasonCancelPage(),
                    );
                  }).then((value){
                if(!Utils.isEmpty(value)){
                  _bloc.add(ConfirmCustomerLimoEvent(item.idDatVe, 9,value));
                }
              });
            }
          });
        }
        else{
          showModalBottomSheet(
              backgroundColor: transparent,
              context: context,
              builder: (BuildContext context){
                return Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10),
                  child: Container(
                    height:150,
                    child: Column(
                      children: [
                        /// G???i ??i???n cho Kh??ch
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context,'CallDriver');
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                color: Colors.white
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'G???i ??i???n cho Kh??ch',
                                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        ///G???i ??i???n cho l??i xe trung chuy???n
                        Visibility(
                          visible: item.khachTrungChuyen == 1,
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pop(context,'CallLaiXeTC');
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(16)),
                                  color: Colors.white
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'G???i cho l??i xe trung chuy???n',
                                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                );
              }
          ).then((value) {
            if(value == 'CallCustomer'){
              if(!Utils.isEmpty(item.soDienThoaiKhach)){
                launch("tel://${item.soDienThoaiKhach}");
              }else{
                Utils.showToast('Ch??a c?? s??? ??i???n tho???i c???a Kh??ch');
              }
            }
            else if(value == 'CallLaiXeTC'){
              if(!Utils.isEmpty(item.dienThoaiTaiXeTrungChuyen)){
                launch("tel://${item.dienThoaiTaiXeTrungChuyen}");
              }else{
                Utils.showToast('Ch??a c?? s??? ??i???n tho???i c???a LXTC');
              }
            }
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 16, top: 8, bottom: 8),
        child: ClipPath(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                (item.daThanhToan == 0 && item.trangThaiVe == 6)?
                AssetImage("assets/images/dahoanthanh.jpg") :
                (item.daThanhToan == 1  && item.trangThaiVe == 6)
                    ? AssetImage("assets/images/dathanhtoan.png")
                    : (item.trangThaiVe == 4 || item.trangThaiVe == 7 || item.trangThaiVe == 8 || item.trangThaiVe == 9 || item.trangThaiTC == 9)
                    ? AssetImage("assets/images/dahuy.jpg")
                    : AssetImage("assets/images/background_white.png")
                ,
                fit: BoxFit.cover,
              ),

            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                  color: item.khachTrungChuyen == 1 ?  Colors.orange.withOpacity(0.8) : Colors.grey.withOpacity(0.8),
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
                                   Text('M??',style: TextStyle(color: Colors.white),),
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
                                   Text(item.hoTenTaiXeTrungChuyen?.toString()??'Loading'),
                                   SizedBox(height: 4,),
                                   Text(item.dienThoaiTaiXeTrungChuyen?.toString()??'................',style: TextStyle(color: Colors.black,fontSize: 11),),
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
                            "Kh??ch Trung chuy???n" : "Kh??ch th?????ng",
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
                  padding: const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Th??ng tin kh??ch',
                            style: Theme.of(this.context).textTheme.caption.copyWith(
                              color: Theme.of(this.context).disabledColor,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: (item.trangThaiTC == 9 || item.trangThaiVe == 4) ? Colors.black.withOpacity(0.7) : (item.trangThaiTC == 11 || item.trangThaiVe == 6) ? Colors.grey : (item.trangThaiTC == 2 || item.trangThaiTC == 3) ? Colors.red : (item.trangThaiTC == 10) ? Colors.indigo : Colors.green,
                                borderRadius: BorderRadius.all(Radius.circular(16))
                            ),
                            child: Center(
                              child: //
                              item.khachTrungChuyen == 1 ? Text(
                                '${(
                                item.trangThaiTC == 10 ? 'B???n Ch??a X??c Nh???n'
                                    :
                                (item.trangThaiTC == 9 ? 'Kh??ch Hu???'
                                    :
                                item.trangThaiTC == 11 ? 'Ho??n Th??nh'
                                    :
                                item.trangThaiTC == 2  ? 'Ch??? ????n'
                                    :
                                item.trangThaiTC == 3 ? '??ang ????n'
                                    :
                                (item.trangThaiTC == 6  || item.trangThaiTC == 7) ? 'TC ??ang tr??? kh??ch'
                                    :
                                item.trangThaiTC == 8 ? 'Tr??? kh??ch th??nh c??ng'
                                    :
                                (item.trangThaiTC == 5 && item.hoTenTaiXeTrungChuyen != null)?  'T??i x??? TC ??ang x??? l??' :
                               '?????i ??H TC x??? l??')
                                )}',
                                style: Theme.of(this.context).textTheme.caption.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ) :
                              Text(
                                '${(
                                    item.trangThaiVe == 1 ? "??ang ?????i x???p l???ch"
                                        :
                                    item.trangThaiVe == 2 ? '???? x???p l???ch t??i x???'
                                        :
                                    (item.trangThaiVe == 3 ? '???? x???p l???ch trung chuy???n'
                                        :
                                    item.trangThaiVe == 4 ? 'Kh??ch hu???'
                                        :
                                    item.trangThaiVe == 5 ? '?????i admin x??? l??'
                                        :
                                    'Ho??n Th??nh')
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${Utils.isEmpty(item.hoTenKhachDatHo) ? item.tenKhachHang??'' : item.hoTenKhachDatHo??'' }',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(this.context).textTheme.subtitle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(this.context).textTheme.title.color,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${Utils.isEmpty(item.soDienThoaiKhachDatHo) ? item.soDienThoaiKhach??'' : item.soDienThoaiKhachDatHo??''}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(this.context).textTheme.subtitle.copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,fontSize: 11
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'S??? gh???: ${item.soGhe??''}' ,
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
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Row(
                                    children: [
                                      Text('Gi?? v??:     ',style: TextStyle(color: Colors.grey),),
                                      Text(Utils.formatMoneyVN(item.tienVe??0),style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                                    ],
                                  )),
                              Container(
                                  padding: EdgeInsets.only(top: 3,right: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Ti???n c???c: ',style: TextStyle(color: Colors.grey),),
                                      Text(Utils.formatMoneyVN(item.soTienCoc??0),style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                                    ],
                                  ))
                            ],
                          )
                        ],
                      ),
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
                              '??i',
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
                            Icon(MdiIcons.panVertical,color: Colors.black),
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
                                  Icon(MdiIcons.mapMarkerRadiusOutline,color: Colors.green.withOpacity(0.8),size: 20,),
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
                              '?????n',
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
                        'Note: ${item.ghiChu??''}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(this.context).textTheme.subtitle.copyWith(
                          fontWeight: FontWeight.normal,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height:10,),
                      // Visibility(
                      //   visible: item.khachTrungChuyen == 0 && ( item.trangThaiVe != 4 && item.trangThaiVe != 6) && widget.typeHistory == 1, /// == 0 Khong TC
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       InkWell(
                      //         onTap:(){
                      //
                      //         },
                      //         child: Container(
                      //           width: 148.0,
                      //           height: 30.0,
                      //           decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(18.0),
                      //               color: Colors.grey
                      //           ),
                      //           child: Center(
                      //             child: Text(
                      //               'Kh??ch hu???',
                      //               style: TextStyle(fontFamily: fontSub, fontSize: 13, color: white,),
                      //               textAlign: TextAlign.left,
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       InkWell(
                      //         onTap:(){
                      //
                      //         },
                      //         child: Container(
                      //           width: 148.0,
                      //           height: 30.0,
                      //           decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(18.0),
                      //               color: Colors.blue
                      //           ),
                      //           child: Center(
                      //             child: Text(
                      //               'X??c nh???n ????n',
                      //               style: TextStyle(fontFamily: fontSub, fontSize: 13, color: white,),
                      //               textAlign: TextAlign.left,
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          clipper: CustomClipPath(),
        ),
      ),
    );
  }
}


