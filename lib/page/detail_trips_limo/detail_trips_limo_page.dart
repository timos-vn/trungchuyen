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

  final String? dateTime;
  final int? idTrips;
  final int? idTime;
  final String? tuyenDuong;
  final String? tenTuyenDuong;
  final String? thoiGianDi;
  final int? typeHistory;

  const DetailTripsLimoPage({Key? key,this.dateTime, this.idTrips, this.idTime,this.tuyenDuong,this.tenTuyenDuong,this.thoiGianDi,this.typeHistory}) : super(key: key);

  @override
  _DetailTripsLimoPageState createState() => _DetailTripsLimoPageState();
}

class _DetailTripsLimoPageState extends State<DetailTripsLimoPage> {

  late DetailTripsLimoBloc _bloc;
  late MainBloc _mainBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainBloc = BlocProvider.of<MainBloc>(context);
    _bloc = DetailTripsLimoBloc(context);
    _bloc.add(GetPrefs());
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
              widget.tenTuyenDuong.toString(),
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
              if(state is GetPrefsSuccess){
                _mainBloc.add(GetListDetailTripsLimoMain(date: widget.dateTime,idTrips: widget.idTrips,idTime: widget.idTime));
              }
              if(state is ConfirmCustomerLimoSuccess){
                if(state.status == 4){
                  Utils.showToast('Huỷ khách thành công');
                }else if(state.status == 6){
                  Utils.showToast('Nhận khách thành công');
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
                      child: Center(child: Text(_mainBloc.totalCustomer.toString())),//_bloc.totalCustomer
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
                      child:Center(child: Text( _mainBloc.totalCustomerCancel.toString(),style: TextStyle(fontSize: 12,color: red),textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,)) ,
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
                Text('Danh sách Khách',style: TextStyle(color:Colors.grey,),),
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
                  child: Container( color: Colors.red,
                    height: item.khachTrungChuyen == 1? 230 : 350,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ///Xác nhận khách không trung chuyển
                        Visibility(
                          visible: item.khachTrungChuyen == 0 && ( item.trangThaiVe != 4 && item.trangThaiVe != 6) && widget.typeHistory == 1, /// == 0 Khong TC
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pop(context,'ConfirmKhachThuong');
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(16)),
                                    color: Colors.white
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Xác nhận đón',
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ///Xác nhận khách trung chuyển
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
                        //           'Xác nhận Khách từ trung chuyển',
                        //           style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        //SizedBox(height: 15,),
                        ///Huỷ khách
                        Visibility(
                          visible: (item.trangThaiVe != 7 && item.trangThaiVe != 4 && item.trangThaiVe != 6 && item.trangThaiVe != 8 && item.trangThaiVe != 9) && item.khachTrungChuyen != 1,
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pop(context,'CancelCustomer');
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(16)),
                                    color: Colors.white
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Khách huỷ',
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        /// Gọi điện cho Khách
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context,'CallCustomer');
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(16)),
                                  color: Colors.white
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Gọi điện cho Khách',
                                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ///Gọi điện cho lái xe trung chuyển
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
                                  'Gọi cho lái xe trung chuyển',
                                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50,),
                      ],
                    ),
                  ),
                );
              }
          ).then((value) async{
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
                    _bloc.add(ConfirmCustomerLimoEvent(item.idDatVe.toString(), 6,value));
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
              if(item.soDienThoaiKhach != null && item.soDienThoaiKhach != 'null') {
                final Uri launchUri = Uri(
                  scheme: 'tel',
                  path: '${item.soDienThoaiKhach}',
                );
                await launchUrl(launchUri);
              }else if(item.soDienThoaiKhachDatHo != null && item.soDienThoaiKhachDatHo != 'null') {
                final Uri launchUri = Uri(
                  scheme: 'tel',
                  path: '${item.soDienThoaiKhachDatHo}',
                );
                await launchUrl(launchUri);
              }
              else{
                Utils.showToast('Chưa có số điện thoại của Khách');
              }
            }
            else if(value == 'CallLaiXeTC'){
              if(item.dienThoaiTaiXeTrungChuyen != null && item.dienThoaiTaiXeTrungChuyen != 'null'){
                final Uri launchUri = Uri(
                  scheme: 'tel',
                  path: '${item.dienThoaiTaiXeTrungChuyen}',
                );
                await launchUrl(launchUri);
              }else{
                Utils.showToast('Chưa có số điện thoại của LXTC');
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
                  _bloc.add(ConfirmCustomerLimoEvent(item.idDatVe.toString(), 9,value));
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
                    height:220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// Gọi điện cho Khách
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
                                'Gọi điện cho Khách',
                                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        ///Gọi điện cho lái xe trung chuyển
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
                                  'Gọi cho lái xe trung chuyển',
                                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50,),
                      ],
                    ),
                  ),
                );
              }
          ).then((value) async{
            if(value == 'CallCustomer'){
              if(item.soDienThoaiKhach != null && item.soDienThoaiKhach != 'null'){
                final Uri launchUri = Uri(
                  scheme: 'tel',
                  path: '${item.soDienThoaiKhach}',
                );
                await launchUrl(launchUri);
              }else{
                Utils.showToast('Chưa có số điện thoại của Khách');
              }
            }
            else if(value == 'CallLaiXeTC'){
              if(item.dienThoaiTaiXeTrungChuyen != null && item.dienThoaiTaiXeTrungChuyen != 'null'){
                final Uri launchUri = Uri(
                  scheme: 'tel',
                  path: '${item.dienThoaiTaiXeTrungChuyen}',
                );
                await launchUrl(launchUri);
              }else{
                Utils.showToast('Chưa có số điện thoại của LXTC');
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
                                   Text('Mã',style: TextStyle(color: Colors.white),),
                                   Text(item.maVe?.toString()??'',style: TextStyle(color: Colors.white),),
                                 ],
                               ))),
                         ),
                         SizedBox(width: 6,),
                         Visibility(
                           visible:item.khachTrungChuyen == 1 ,
                           child: GestureDetector(
                             onTap: ()async{
                               if(item.dienThoaiTaiXeTrungChuyen != null && item.dienThoaiTaiXeTrungChuyen != 'null'){
                                 final Uri launchUri = Uri(
                                   scheme: 'tel',
                                   path: '${item.dienThoaiTaiXeTrungChuyen}',
                                 );
                                 await launchUrl(launchUri);
                               }else{
                                 Utils.showToast('Chưa có số điện thoại của TXTC');
                               }
                             },
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
                            "Khách Trung chuyển" : "Khách thường",
                            style: TextStyle(
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
                            'Thông tin khách',
                            style: TextStyle(
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
                                (item.trangThaiTC == 5 && item.hoTenTaiXeTrungChuyen != null)?  'Tài xế TC đang xử lý' :
                               'Đợi ĐH TC xử lý')
                                )}',
                                style: TextStyle(
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
                                style: TextStyle(
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
                                  '${Utils.isEmpty(item.hoTenKhachDatHo.toString()) ? item.tenKhachHang??'' : item.hoTenKhachDatHo??'' }',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${Utils.isEmpty(item.soDienThoaiKhachDatHo.toString()) ? item.soDienThoaiKhach??'' : item.soDienThoaiKhachDatHo??''}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,fontSize: 11
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Số ghế: ${item.soGhe??''}' ,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
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
                                      Text('Giá vé:     ',style: TextStyle(color: Colors.grey),),
                                      Text(Utils.formatMoneyVN(item.tienVe??0),style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                                    ],
                                  )),
                              Container(
                                  padding: EdgeInsets.only(top: 3,right: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Tiền cọc: ',style: TextStyle(color: Colors.grey),),
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
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
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black.withOpacity(0.6),
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
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
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black.withOpacity(0.6),
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
                        style: TextStyle(
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
                      //               'Khách huỷ',
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
                      //               'Xác nhận đón',
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


