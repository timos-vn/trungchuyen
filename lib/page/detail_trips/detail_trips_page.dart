import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timelines/timelines.dart';
import 'package:trungchuyen/extension/customer_clip_path.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
import 'package:trungchuyen/page/detail_trips/detail_trips_bloc.dart';
import 'package:trungchuyen/page/detail_trips/detail_trips_event.dart';
import 'package:trungchuyen/page/detail_trips/detail_trips_state.dart';
import 'package:trungchuyen/page/main/main_bloc.dart';
import 'package:trungchuyen/page/main/main_event.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:intl/intl.dart';
import 'package:trungchuyen/utils/utils.dart';
import 'package:trungchuyen/widget/confirm_success.dart';
import 'package:trungchuyen/widget/separator.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailTripsPage extends StatefulWidget {
  final String? tenChuyen;
  final DateTime? dateTime;
  final int? idRoom;
  final int? idTime;
  final int? typeCustomer;
  final int? typeDetail;
  final String? thoiGian;

  const DetailTripsPage({Key? key,this.tenChuyen,this.dateTime, this.idRoom, this.idTime,this.typeCustomer,this.typeDetail,this.thoiGian}) : super(key: key);

  @override
  DetailTripsPageState createState() => DetailTripsPageState();
}

class DetailTripsPageState extends State<DetailTripsPage> {

  late DetailTripsBloc _bloc;
  DateFormat format = DateFormat("dd/MM/yyyy");
  // List<DetailTripsResponseBody> _listOfDetailTrips = new List<DetailTripsResponseBody>();
  int tongKhach=0;
  late MainBloc _mainBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark, statusBarColor: Colors.white));
    _mainBloc = BlocProvider.of<MainBloc>(context);
    _bloc = DetailTripsBloc(context);
    _bloc.add(GetPrefs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            widget.typeDetail == 1 ?
            'Danh sách Khách Chờ' : 'Danh sách Khách',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          actions: [
            Icon(MdiIcons.reload,color: Colors.transparent,),
            SizedBox(width: 20,)
          ],
        ),
        body:BlocListener<DetailTripsBloc,DetailTripsState>(
          bloc: _bloc,
          listener:  (context, state){
            if(state is GetPrefsSuccess){

              // _mainBloc = BlocProvider.of<MainBloc>(context);
              // DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
              if(widget.typeDetail == 1){
                // print('telete ${_mainBloc.tongKhach}');
                // _mainBloc.tongKhach =0;
                // _bloc.add(GetListDetailTrips(widget.dateTime,widget.idRoom,widget.idTime,widget.typeCustomer));
              }else{
                _bloc.add(GetListDetailTripsHistory(widget.dateTime!,widget.idRoom!,widget.idTime!,widget.typeCustomer!,));
              }
              if(!Utils.isEmpty(_mainBloc.listCustomer)){
                _mainBloc.listCustomer.forEach((element) {
                  tongKhach = tongKhach + element.soKhach!;
                });
              }
            }
            if(state is DetailTripsFailure){
              Utils.showToast(state.error.toString());
            }
            if(state is GetListOfDetailTripsSuccess){
              // _listOfDetailTrips = _bloc.listOfDetailTrips;
              print('ok');
            }
            else if(state is TCTransferCustomerToLimoSuccess){
              _mainBloc.listOfGroupAwaitingCustomer.clear();
              _bloc.add(UpdateStatusCustomerDetailEvent(status: 10,idTrungChuyen: state.listIDTC.split(','),note: ''));
              _mainBloc.showDialogTransferCustomer(context: context, content: '');
            }
            else if(state is UpdateStatusCustomerSuccess){
              if(state.status == 10 || state.status == 11){
                _mainBloc.db.deleteAllDriverLimo();
                _mainBloc.blocked = false;
                _mainBloc.db.deleteAll();
                _mainBloc.soKhachDaDonDuoc = 0;
                _mainBloc.listTaiXeLimo.clear();
                _mainBloc.listOfDetailTrips.clear();
                _mainBloc.listCustomer.clear();
                _mainBloc.listInfo.clear();
                if(state.status == 10){
                  Utils.showToast('Chờ Tài xế Limo Xác nhận.');
                }else{
                  Utils.showToast('Xác nhận thành công');
                }
                Navigator.pop(context);
              }
            }
          },
          child: BlocBuilder<DetailTripsBloc,DetailTripsState>(
            bloc: _bloc,
            builder: (BuildContext context, DetailTripsState state) {
              return buildPage(context,state);
            },
          ),
          //),
        )
    );
  }

  Stack buildPage(BuildContext context,DetailTripsState state){
    return Stack(
      children: [
        Column(
          children: <Widget>[
            Visibility(
              visible: widget.typeDetail == 1,
              child: Column(
                children: [
                  Table(
                    border: TableBorder.all(color: Colors.grey),
                    columnWidths: {
                      0: IntrinsicColumnWidth(),
                      1: FlexColumnWidth(),
                      2: FlexColumnWidth(),
                      3: FlexColumnWidth(),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 30,right: 30),
                            height: 35,
                            child: Center(child: Text( widget.typeCustomer == 1 ? 'Trả Khách ở': 'Đón Khách ở')),
                          ),
                          Container(
                            height: 35,
                            child: Center(child: Text(widget.tenChuyen?.toString()??'',style: TextStyle(color: Colors.red),)),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 30,right: 30),
                            height: 35,
                            child: Center(child: Text('Xuất bến')),
                          ),
                          Container(
                            height: 35,
                            child: widget.typeDetail == 1 ? Center(child: Text(widget.thoiGian?.split('->')[0].toString()??'')  ) :
                            Center(child: Text(widget.thoiGian?.toString()??'')  ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 30,right: 30),
                            height: 35,
                            child: Center(child: Text('Tới bến')),
                          ),
                          Container(
                            height: 35,
                            child:widget.typeDetail == 1 ? Center(child: Text(widget.thoiGian?.split('->')[1].toString()??'')) :
                            Center(child: Text(widget.thoiGian?.toString()??'')),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Container(
                            height: 35,
                            child: Center(child: Text('${'Khách đã xử lý'}',style: TextStyle(color: Colors.purple),)),
                          ),
                          Container(
                            height: 35,
                            child: Center(child: Text('${_mainBloc.tongKhach.toString()} / ${_mainBloc.listCustomer.length.toString()}',style: TextStyle(color: Colors.purple),)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: widget.typeCustomer == 1 && _mainBloc.soKhachDaDonDuoc == _mainBloc.listCustomer.length && _mainBloc.soKhachHuy < _mainBloc.listCustomer.length,
                    child: InkWell(
                      onTap: (){
                        print(_mainBloc.listTaiXeLimo);
                        _bloc.add(TCTransferCustomerToLimoEvent(
                            'Thông báo',
                            '',
                            _mainBloc.listCustomer
                        ));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 16,right: 16),
                        child: Container(
                          height: 40.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.orange
                          ),
                          child: Center(
                            child: Text(
                              'Giao khách cho Limo',
                              style: TextStyle(fontSize: 15, color: white,fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.typeCustomer == 1 && _mainBloc.soKhachHuy == _mainBloc.listCustomer.length,
                    child: InkWell(
                      onTap: (){
                        _mainBloc.db.deleteAllDriverLimo();
                        _mainBloc.blocked = false;
                        _mainBloc.soKhachDaDonDuoc = 0;
                        _mainBloc.listTaiXeLimo.clear();
                        _mainBloc.listOfDetailTrips.clear();
                        _mainBloc.listCustomer.clear();
                        _mainBloc.listInfo.clear();
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 16,right: 16),
                        child: Container(
                          height: 40.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.orange
                          ),
                          child: Center(
                            child: Text(
                              'Xác nhận chuyến',
                              style: TextStyle(fontSize: 15, color: white,fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.typeCustomer == 2 && _mainBloc.soKhachDaDonDuoc == _mainBloc.listCustomer.length && _mainBloc.soKhachHuy < _mainBloc.listCustomer.length ,
                    child: InkWell(
                      onTap: (){
                        List<String> idTC = [];
                        _mainBloc.listCustomer.forEach((element) {
                          if(element.trangThaiTC != 12){
                            idTC.add(element.idTrungChuyen.toString());
                          }
                        });
                        String id = idTC.join(',');
                        _bloc.add(UpdateStatusCustomerDetailEvent(status: 10,idTrungChuyen: id.split(',')));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 16,right: 16),
                        child: Container(
                          height: 40.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.orange
                          ),
                          child: Center(
                            child: Text(
                              'Xác nhận trả khách thành công',
                              style: TextStyle(fontSize: 15, color: white,fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.typeCustomer == 2 && _mainBloc.soKhachHuy == _mainBloc.listCustomer.length,
                    child: InkWell(
                      onTap: (){
                        _mainBloc.db.deleteAllDriverLimo();
                        _mainBloc.blocked = false;
                        _mainBloc.soKhachDaDonDuoc = 0;
                        _mainBloc.listTaiXeLimo.clear();
                        _mainBloc.listOfDetailTrips.clear();
                        _mainBloc.listCustomer.clear();
                        _mainBloc.listInfo.clear();
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 16,right: 16),
                        child: Container(
                          height: 40.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.orange
                          ),
                          child: Center(
                            child: Text(
                              'Xác nhận chuyến',
                              style: TextStyle(fontSize: 15, color: white,fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                    ),
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
                ],
              ),
            ),
            Expanded(
              child: Scrollbar(
                  child: ListView.builder(
                      padding: EdgeInsets.only(bottom:  MediaQuery.of(context).padding.bottom + 16),
                      shrinkWrap: true,
                      itemCount: widget.typeDetail == 1 ?  _mainBloc.listCustomer.length : _bloc.listOfDetailTrips.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildListItem(widget.typeDetail == 1 ?_mainBloc.listCustomer[index] :
                        _bloc.listOfDetailTrips[index]);
                      })
              ),
            ),
            const SizedBox(height: 50,)
          ],
        ),
        Visibility(
          visible: state is DetailTripsLoading,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  Widget buildListItem(DetailTripsResponseBody item) {
    return GestureDetector(
        onTap: () {
          if(widget.typeDetail == 1){
            showModalBottomSheet(
                backgroundColor: transparent,
                context: context,
                builder: (BuildContext context){
                  return Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: Container(
                      height: 365,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Visibility(
                            visible: item.trangThaiTC != 4 && item.trangThaiTC != 8 && item.trangThaiTC != 12 && item.trangThaiTC != 13 ,
                            child: GestureDetector(
                              onTap: (){
                                Navigator.pop(context,'ConfirmCustomer');
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
                                    '${item.loaiKhach == 1 ? 'Đón khách' : 'Trả khách'}',
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15,),
                          Visibility(
                            visible: item.trangThaiTC != 4 && item.trangThaiTC != 8 && item.trangThaiTC != 12 && item.trangThaiTC != 13,
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
                                    'Khách huỷ',
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15,),
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
                                  'Gọi điện cho Khách',
                                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15,),
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
                                  'Gọi điện cho Tài xế Limo',
                                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 90,),
                        ],
                      ),
                    ),
                  );
                }
            ).then((value) async{
              if(value == 'ConfirmCustomer'){
                print(item.loaiKhach);print(item.trangThaiTC);
               if(item.loaiKhach == 1 && item.trangThaiTC != 4){
                 _mainBloc.add(UpdateStatusCustomerEvent(status: 4,idTrungChuyen: item.idTrungChuyen?.split(','),));
                 _mainBloc.add(GetListDetailTripsTC(format.parse(_mainBloc.ngayTC),_mainBloc.idVanPhong,_mainBloc.idKhungGio,_mainBloc.loaiKhach));
                 Utils.showToast('Đón khách thành công!');
               }else if(item.loaiKhach == 2 && item.trangThaiTC != 8){
                 _mainBloc.add(UpdateStatusCustomerEvent(status: 8,idTrungChuyen: item.idTrungChuyen?.split(',')));
                 _mainBloc.add(GetListDetailTripsTC(format.parse(_mainBloc.ngayTC),_mainBloc.idVanPhong,_mainBloc.idKhungGio,_mainBloc.loaiKhach));
                 Utils.showToast('Trả khách thành công!');
               }
              }
              else if(value == 'CallCustomer'){
                print(item.soDienThoaiKhach);
                print(item.soDienThoaiKhachDatHo);
                if(item.soDienThoaiKhachDatHo != 'null' && item.soDienThoaiKhachDatHo != null){
                  final Uri launchUri = Uri(
                    scheme: 'tel',
                    path: '${item.soDienThoaiKhachDatHo.toString().trim()}',
                  );
                  await launchUrl(launchUri);
                }else if(item.soDienThoaiKhach != 'null' && item.soDienThoaiKhach != null) {
                  final Uri launchUri = Uri(
                    scheme: 'tel',
                    path: '${item.soDienThoaiKhach}',
                  );
                  await launchUrl(launchUri);
                }else{
                  Utils.showToast('Không có SĐT Khách hàng');
                }
              }
              else if(value == 'CallDriver'){
                if(item.dienThoaiTaiXeLimousine != 'null' && item.dienThoaiTaiXeLimousine != null){
                  final Uri launchUri = Uri(
                    scheme: 'tel',
                    path: '${item.dienThoaiTaiXeLimousine.toString().trim()}',
                  );
                  await launchUrl(launchUri);
                }else{
                  Utils.showToast('Không có SĐT TX Limousine');
                }
              }
              else if(value == 'CancelCustomer'){
                showDialog(
                    context: context,
                    builder: (context) {
                      return WillPopScope(
                        onWillPop: () async => false,
                        child: ConfirmSuccessPage(
                          title: 'Bạn chuẩn bị HUỶ một khách',
                          content: 'Hãy chắc chắn rằng Khách này muốn huỷ chuyến',
                          type: 0,
                        ),
                      );
                    }).then((value) {
                      if(value == 'Confirm'){
                        _mainBloc.add(UpdateStatusCustomerEvent(status: 12,idTrungChuyen: item.idTrungChuyen?.split(','),));
                        _mainBloc.add(GetListDetailTripsTC(format.parse(_mainBloc.ngayTC),_mainBloc.idVanPhong,_mainBloc.idKhungGio,_mainBloc.loaiKhach));
                        Utils.showToast('Huỷ khách thành công!');
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
                      height: 190,
                      child: Column(
                        children: [
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
                                  'Gọi điện cho Khách',
                                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15,),
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
                                  'Gọi điện cho Tài xế Limo',
                                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
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
                }else {
                  Utils.showToast('Không có SĐT của Khách hàng');
                }
              }else if(value == 'CallDriver'){
                if(item.dienThoaiTaiXeLimousine != null && item.dienThoaiTaiXeLimousine != 'null'){
                  final Uri launchUri = Uri(
                    scheme: 'tel',
                    path: '${item.dienThoaiTaiXeLimousine}',
                  );
                  await launchUrl(launchUri);
                }else{
                  Utils.showToast('Không có SĐT TX Limousine');
                }
              }
            });
          }
        },
        child: widget.typeDetail == 1
            ?
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 16, top: 8, bottom: 8),
          child: ClipPath(
            clipper: CustomClipPath(),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                  image: DecorationImage(
                    image: (item.trangThaiTC == 4) ? AssetImage("assets/images/dadon.jpg")
                        :
                    (item.trangThaiTC == 8) ? AssetImage("assets/images/dahoanthanh.jpg") :
                    (item.trangThaiTC == 12) ? AssetImage("assets/images/dahuy.jpg") :
                    AssetImage("assets/images/background_white.png"),
                    fit: BoxFit.cover,
                  ),
                border: Border.all(
                  color: Colors.grey,width: 1.0
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(14),
                    color: Colors.grey.withOpacity(0.2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
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
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.hoTenTaiXeLimousine??'',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),Text(
                                    item.tenXeLimousine??'',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.dienThoaiTaiXeLimousine??'',
                                      style: TextStyle(fontWeight: FontWeight.normal,fontSize: 11,color: Colors.grey),
                                    ),
                                  ), Text(
                                    '${item.bienSoXeLimousine??''}',
                                    style: TextStyle(fontWeight: FontWeight.normal,fontSize: 11,color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
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
                              '${item.tenNhaXe??''}',
                              style: TextStyle(color: Colors.red,)
                            ),
                            Text(
                              '${item.soKhach??''} Khách.',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,fontSize: 11,fontStyle: FontStyle.italic
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Separator(color: Colors.grey),
                        SizedBox(height: 10,),
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.red,
                                      ),
                                    ),
                                    SizedBox(width: 4,),
                                    Text(
                                      ' / ${item.soDienThoaiKhach??''}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,fontSize: 11
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // InkWell(
                            //   onTap: () => launch("tel://${item.soDienThoaiKhach}"),
                            //   child: Container(
                            //       padding: EdgeInsets.all(8),
                            //       child: Icon(Icons.phone_callback_outlined)),
                            // )
                          ],
                        ),
                        SizedBox(height: 5,),
                        Separator(color: Colors.grey),
                        SizedBox(height: 5,),
                        Padding(
                          padding: const EdgeInsets.only(right: 15,top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(MdiIcons.mapMarker,color: Colors.green,size: 20,),
                                    SizedBox(width: 15,),
                                    Expanded(
                                      child: Text(
                                        '${item.diaChiKhachDi??''}',
                                        maxLines: 1,
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
                                    Icon(MdiIcons.mapMarkerRadiusOutline,color: Colors.black.withOpacity(0.4),size: 20,),
                                    SizedBox(width: 15,),
                                    Expanded(
                                      child: Text(
                                        '${item.diaChiKhachDen??''}',
                                        maxLines: 1,
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
            :
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 16, top: 8, bottom: 8),
          child: ClipPath(
            clipper: CustomClipPath(),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  image: DecorationImage(
                    image:
                    ((item.trangThaiTC == 4) || (item.trangThaiTC == 8) || (item.trangThaiTC == 10) || (item.trangThaiTC == 11)) ? AssetImage("assets/images/dahoanthanh.jpg") :
                    ((item.trangThaiTC == 12) || (item.trangThaiTC == 9) || (item.trangThaiTC == 13)) ? AssetImage("assets/images/dahuy.jpg") :
                    AssetImage("assets/images/background_white.png"),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                      color: Colors.grey,width: 1.0
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(14),
                    color: Colors.grey.withOpacity(0.2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
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
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.hoTenTaiXeLimousine??'',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),Text(
                                    item.tenXeLimousine??'',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.dienThoaiTaiXeLimousine??'',
                                      style: TextStyle(fontWeight: FontWeight.normal,fontSize: 11,color: Colors.grey),
                                    ),
                                  ), Text(
                                    '${item.bienSoXeLimousine??''}',
                                    style: TextStyle(fontWeight: FontWeight.normal,fontSize: 11,color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
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
                              '${item.tenNhaXe??''}',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              '${item.soKhach??''} Khách.',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,fontSize: 11,fontStyle: FontStyle.italic
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Separator(color: Colors.grey),
                        SizedBox(height: 10,),
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.red,
                                      ),
                                    ),
                                    SizedBox(width: 4,),
                                    Text(
                                      ' / ${item.soDienThoaiKhach??''}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey,fontSize: 11
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // InkWell(
                            //   onTap: () => launch("tel://${item.soDienThoaiKhach}"),
                            //   child: Container(
                            //       padding: EdgeInsets.all(8),
                            //       child: Icon(Icons.phone_callback_outlined)),
                            // )
                          ],
                        ),
                        SizedBox(height: 5,),
                        Separator(color: Colors.grey),
                        SizedBox(height: 5,),
                        Padding(
                          padding: const EdgeInsets.only(right: 15,top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(MdiIcons.mapMarker,color: Colors.green,size: 20,),
                                    SizedBox(width: 15,),
                                    Expanded(
                                      child: Text(
                                        '${item.diaChiKhachDi??''}',
                                        maxLines: 1,
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
                                    Icon(MdiIcons.mapMarkerRadiusOutline,color: Colors.black.withOpacity(0.4),size: 20,),
                                    SizedBox(width: 15,),
                                    Expanded(
                                      child: Text(
                                        '${item.diaChiKhachDen??''}',
                                        maxLines: 1,
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
