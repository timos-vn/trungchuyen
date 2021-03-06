import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:trungchuyen/themes/images.dart';
import 'package:intl/intl.dart';
import 'package:trungchuyen/utils/utils.dart';
import 'package:trungchuyen/widget/bottom_sheet_action.dart';
import 'package:trungchuyen/widget/confirm_success.dart';
import 'package:trungchuyen/widget/separator.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailTripsPage extends StatefulWidget {
  final String tenChuyen;
  final DateTime dateTime;
  final int idRoom;
  final int idTime;
  final int typeCustomer;
  final int typeDetail;
  final String thoiGian;

  const DetailTripsPage({Key key,this.tenChuyen,this.dateTime, this.idRoom, this.idTime,this.typeCustomer,this.typeDetail,this.thoiGian}) : super(key: key);

  @override
  DetailTripsPageState createState() => DetailTripsPageState();
}

class DetailTripsPageState extends State<DetailTripsPage> {

  MainBloc _mainBloc;
  DetailTripsBloc _bloc;
  DateFormat format = DateFormat("dd/MM/yyyy");
  // List<DetailTripsResponseBody> _listOfDetailTrips = new List<DetailTripsResponseBody>();
  int tongKhach=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainBloc = BlocProvider.of<MainBloc>(context);
    _bloc = DetailTripsBloc(context);
    _bloc.getMainBloc(context);
   // DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
    if(widget.typeDetail == 1){
      // print('telete ${_mainBloc.tongKhach}');
      // _mainBloc.tongKhach =0;
      // _bloc.add(GetListDetailTrips(widget.dateTime,widget.idRoom,widget.idTime,widget.typeCustomer));
    }else{
      _bloc.add(GetListDetailTripsHistory(widget.dateTime,widget.idRoom,widget.idTime,widget.typeCustomer,));
    }
    if(!Utils.isEmpty(_mainBloc.listCustomer)){
      _mainBloc.listCustomer.forEach((element) {
        tongKhach = tongKhach + element.soKhach;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: ()=>print(_bloc.listOfDetailTrips.length),
            child: Text(widget.typeDetail == 1 ?
              'Danh s??ch Kh??ch Ch???' : 'Danh s??ch Kh??ch',
              style: TextStyle(color: Colors.black),
            ),
          ),
           centerTitle: true,
        ),
        body:BlocListener<DetailTripsBloc,DetailTripsState>(
          bloc: _bloc,
          listener:  (context, state){
            if(state is GetListOfDetailTripsSuccess){
              // _listOfDetailTrips = _bloc.listOfDetailTrips;
              print('ok');
            }
            else if(state is TCTransferCustomerToLimoSuccess){
              _mainBloc.listOfGroupAwaitingCustomer.clear();
              _bloc.add(UpdateStatusCustomerDetailEvent(status: 10,idTrungChuyen: state.listIDTC.split(','),note: ''));
              _mainBloc.showDialogTransferCustomer(context: context);
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
                  Utils.showToast('Ch??? T??i x??? Limo X??c nh???n.');
                }else{
                  Utils.showToast('X??c nh???n th??nh c??ng');
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
                            child: Center(child: Text( widget.typeCustomer == 1 ? 'Tr??? Kh??ch ???': '????n Kh??ch ???')),
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
                            child: Center(child: Text('Xu???t b???n')),
                          ),
                          Container(
                            height: 35,
                            child: widget.typeDetail == 1 ? Center(child: Text(widget.thoiGian.split('->')[0]?.toString()??'')  ) :
                            Center(child: Text(widget.thoiGian?.toString()??'')  ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 30,right: 30),
                            height: 35,
                            child: Center(child: Text('T???i b???n')),
                          ),
                          Container(
                            height: 35,
                            child:widget.typeDetail == 1 ? Center(child: Text(widget.thoiGian.split('->')[1]?.toString()??'')) :
                            Center(child: Text(widget.thoiGian?.toString()??'')),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Container(
                            height: 35,
                            child: Center(child: Text('${'Kh??ch ???? x??? l??'}',style: TextStyle(color: Colors.purple),)),
                          ),
                          Container(
                            height: 35,
                            child: Center(child: Text('${_mainBloc.tongKhach?.toString()??''} / ${_mainBloc.listCustomer.length?.toString()??0}',style: TextStyle(color: Colors.purple),)),
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
                            'Th??ng b??o',
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
                              'Giao kh??ch cho Limo',
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
                              'X??c nh???n chuy???n',
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
                        List<String> idTC = new List<String>();
                        _mainBloc.listCustomer.forEach((element) {
                          if(element.trangThaiTC != 12){
                            idTC.add(element.idTrungChuyen);
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
                              'X??c nh???n tr??? kh??ch th??nh c??ng',
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
                              'X??c nh???n chuy???n',
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
                      Text('Chi ti???t',style: TextStyle(color:Colors.grey,),),
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
                      height: 260,
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
                                    '${item.loaiKhach == 1 ? '????n kh??ch' : 'Tr??? kh??ch'}',
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
                                    'Kh??ch hu???',
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
                                  'G???i ??i???n cho Kh??ch',
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
                                  'G???i ??i???n cho T??i x??? Limo',
                                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
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
              if(value == 'ConfirmCustomer'){
                print(item.loaiKhach);print(item.trangThaiTC);
               if(item.loaiKhach == 1 && item.trangThaiTC != 4){
                 _mainBloc.add(UpdateStatusCustomerEvent(status: 4,idTrungChuyen: item.idTrungChuyen.split(','),));
                 _mainBloc.add(GetListDetailTripsTC(format.parse(_mainBloc.ngayTC),_mainBloc.idVanPhong,_mainBloc.idKhungGio,_mainBloc.loaiKhach));
                 Utils.showToast('????n kh??ch th??nh c??ng!');
               }else if(item.loaiKhach == 2 && item.trangThaiTC != 8){
                 _mainBloc.add(UpdateStatusCustomerEvent(status: 8,idTrungChuyen: item.idTrungChuyen.split(',')));
                 _mainBloc.add(GetListDetailTripsTC(format.parse(_mainBloc.ngayTC),_mainBloc.idVanPhong,_mainBloc.idKhungGio,_mainBloc.loaiKhach));
                 Utils.showToast('Tr??? kh??ch th??nh c??ng!');
               }
              }else if(value == 'CallCustomer'){
                if(!Utils.isEmpty(item.soDienThoaiKhachDatHo)){
                  launch("tel://${item.soDienThoaiKhachDatHo}");
                }else{
                  launch("tel://${item.soDienThoaiKhach}");
                }
              }else if(value == 'CallDriver'){
                launch("tel://${item.dienThoaiTaiXeLimousine}");
              }else if(value == 'CancelCustomer'){
                showDialog(
                    context: context,
                    builder: (context) {
                      return WillPopScope(
                        onWillPop: () async => false,
                        child: ConfirmSuccessPage(
                          title: 'B???n chu???n b??? HU??? m???t kh??ch',
                          content: 'H??y ch???c ch???n r???ng Kh??ch n??y mu???n hu??? chuy???n',
                          type: 0,
                        ),
                      );
                    }).then((value) {
                      if(value == 'Confirm'){
                        _mainBloc.add(UpdateStatusCustomerEvent(status: 12,idTrungChuyen: item.idTrungChuyen.split(','),));
                        _mainBloc.add(GetListDetailTripsTC(format.parse(_mainBloc.ngayTC),_mainBloc.idVanPhong,_mainBloc.idKhungGio,_mainBloc.loaiKhach));
                        Utils.showToast('Hu??? kh??ch th??nh c??ng!');
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
                      height: 150,
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
                                  'G???i ??i???n cho Kh??ch',
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
                                  'G???i ??i???n cho T??i x??? Limo',
                                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
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
                launch("tel://${item.soDienThoaiKhach}");
              }else if(value == 'CallDriver'){
                launch("tel://${item.dienThoaiTaiXeLimousine}");
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
                                  Text('M??',style: TextStyle(color: Colors.white),),
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
                              style: Theme.of(this.context).textTheme.caption.copyWith(
                                color: Colors.red,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              '${item.soKhach??''} Kh??ch.',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(this.context).textTheme.subtitle.copyWith(
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
                                      style: Theme.of(this.context).textTheme.subtitle.copyWith(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.red,
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
                                    Icon(MdiIcons.mapMarkerRadiusOutline,color: Colors.black.withOpacity(0.4),size: 20,),
                                    SizedBox(width: 15,),
                                    Expanded(
                                      child: Text(
                                        '${item.diaChiKhachDen??''}',
                                        maxLines: 1,
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
                                  Text('M??',style: TextStyle(color: Colors.white),),
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
                              style: Theme.of(this.context).textTheme.caption.copyWith(
                                color: Colors.red,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              '${item.soKhach??''} Kh??ch.',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(this.context).textTheme.subtitle.copyWith(
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
                                      style: Theme.of(this.context).textTheme.subtitle.copyWith(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.red,
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
                                    Icon(MdiIcons.mapMarkerRadiusOutline,color: Colors.black.withOpacity(0.4),size: 20,),
                                    SizedBox(width: 15,),
                                    Expanded(
                                      child: Text(
                                        '${item.diaChiKhachDen??''}',
                                        maxLines: 1,
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
