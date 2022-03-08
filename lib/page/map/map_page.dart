import 'dart:async';

import 'package:animator/animator.dart';
import 'package:async/async.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animarker/lat_lng_interpolation.dart';
import 'package:flutter_animarker/models/lat_lng_delta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:trungchuyen/extension/default_grabbing.dart';
import 'package:trungchuyen/models/entity/customer.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
import 'package:trungchuyen/models/network/response/polyline_result_response.dart' as pp;
import 'package:trungchuyen/page/limo_confirm/limo_confirm_bloc.dart';
import 'package:trungchuyen/page/limo_confirm/limo_confirm_event.dart';
import 'package:trungchuyen/page/main/main_bloc.dart';
import 'package:trungchuyen/page/main/main_event.dart';
import 'package:trungchuyen/page/map/map_bloc.dart';
import 'package:trungchuyen/page/map/map_state.dart';
import 'package:trungchuyen/page/reason_cancel/reason_cancel_page.dart';
import 'package:trungchuyen/page/waiting/waiting_bloc.dart';
import 'package:trungchuyen/page/waiting/waiting_event.dart';
import 'package:trungchuyen/service/location_service.dart';
import 'package:trungchuyen/service/soket_io_service.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/themes/font.dart';
import 'package:trungchuyen/themes/images.dart';
import 'package:trungchuyen/utils/marker_icon.dart';
import 'package:trungchuyen/utils/utils.dart';
import 'package:trungchuyen/widget/marquee_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'map_event.dart';

class MapPage extends StatefulWidget {

  MapPage({Key key}) : super(key: key);

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage>{
  final scrollController = ScrollController();
  bool isOnline = false;
  bool isInProcessPickup = false;
  Polyline myPolyline;
  MainBloc _mainBloc;
  MapBloc _mapBloc;
  WaitingBloc _waitingBloc;
  List<DetailTripsResponseBody> _listOfCustomerTrips = new List<DetailTripsResponseBody>();

  StreamGroup<LatLngDelta> subscriptions = StreamGroup<LatLngDelta>();
  Completer<GoogleMapController> _controller = Completer();
  Location location = new Location();
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey keyMap;
  LimoConfirmBloc _limoConfirmBloc;
  bool flat = false;
  SocketIOService socketIOService;
  DateFormat format = DateFormat("dd/MM/yyyy");
  GoogleMapsController mapController = GoogleMapsController(
    initialCameraPosition: CameraPosition(
      target: LatLng(21.0003347, 105.8233759),
      zoom: 14.4746,
    ),
    onMapCreated: (GoogleMapController controller){
      // controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
      // controller.moveCamera(CameraUpdate.newLatLng(LatLng(markerLat,markerLng)));
    },
    onCameraMove: (CameraPosition cameraPosition){
      // mapController.animateCamera(cameraUpdate).moveCamera(cameraUpdate)
    },
    compassEnabled: true,
    myLocationEnabled: true,
    myLocationButtonEnabled: false,
    zoomControlsEnabled: false,
    //rotateGesturesEnabled: true,
  );



  @override
  void initState() {
    // TODO: implement initState
    socketIOService = Get.find<SocketIOService>();
    _mapBloc = MapBloc(context);
    _waitingBloc = WaitingBloc(context);
    _limoConfirmBloc = LimoConfirmBloc(context);
    _mainBloc = BlocProvider.of<MainBloc>(context);
    _mapBloc.getMainBloc(context);
    _mapBloc.add(CheckPermissionEvent());
    _mapBloc.add(GetCustomerList());
    super.initState();
  }

  drawMyLocation(LatLng position, double alpha) async {
    var iconCar = await getBitmapDescriptorFromAssetBytes('assets/images/carMarker.png', 50);
    var checkMarkerDriver = mapController.markers.where((element) => element.markerId.value == "DriverMarker").toList();
    if (checkMarkerDriver.length > 0) {
      mapController.removeMarker(checkMarkerDriver[0]);
    }
    mapController.addMarker(Marker(markerId: MarkerId("DriverMarker"), position: position, icon: iconCar, anchor: Offset(0.5, 0.5), rotation: alpha));
  }

  moveCameraPosition(LatLng position){
    CameraPosition cameraPosition = new CameraPosition(
        target: LatLng(position.latitude,position.longitude),
        zoom: 14.4746,
    );
    print('123:1234');
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MapBloc,MapState>(
      bloc: _mapBloc,
      listener:  (context, state){
        if(state is GetListCustomerSuccess){

        }else if(state is GetListTaiXeLimosSuccess){
          _mainBloc.listTaiXeLimo=_mapBloc.listTaiXeLimos;
          print( _mainBloc.listTaiXeLimo.length);
        }
        else if(state is CheckPermissionSuccess){
          subscriptions.add(_mapBloc.latLngStream.getAnimatedPosition("DriverMarker"));
          subscriptions.stream.listen((LatLngDelta delta) {
            // moveCameraPosition(LatLng(delta.from.latitude, delta.from.longitude));
            drawMyLocation(LatLng(delta.from.latitude, delta.from.longitude), delta.rotation);
          });
        }
        else if(state is GetListLocationPolylineSuccess){
          drawPolyline(state.lsPoints,);
        }
        else if(state is TransferCustomerToLimoSuccess){
          _mainBloc.listOfGroupAwaitingCustomer.clear();
          _mapBloc.add(UpdateStatusCustomerMapEvent(status: 10,idTrungChuyen: state.listIDTC.split(','),note: ''));
          _mainBloc.showDialogTransferCustomer(context: context);
        }
        else if(state is UpdateStatusCustomerMapSuccess){
          print('state.status: ${state.status}');
         if(state.status == 10 || state.status == 11){
           // DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
           // _waitingBloc.add(GetListGroupAwaitingCustomer(parseDate));
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
           // _limoConfirmBloc.add(GetListCustomerConfirmEvent());
         }
        }
        else if(state is GetListOfDetailTripsSuccess){
          // _mainBloc.listCustomer = _mapBloc.listDetailTripsCustomer;
          // _mainBloc.currentNumberCustomerOfList = _mapBloc.listDetailTripsCustomer.length;
        }
      },
      child: BlocBuilder<MapBloc,MapState>(
        bloc: _mapBloc,
        builder: (BuildContext context, MapState state) {
          return Scaffold(
            body: buildPage(context,state)
          );
        },
      ),
    );
  }

  Widget buildPage(BuildContext context,MapState state){
    return Stack(
      children: [
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                automaticallyImplyLeading: false,
                title: !isOnline ?  InkWell(
                  onTap: ()=>_mainBloc.listCustomer.length,
                  child: Text(
                    'OffLine',
                    style: Theme.of(context).textTheme.title.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.title.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
                    :
                Text(
                  'Online',
                  style: Theme.of(context).textTheme.title.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.title.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                centerTitle: true,
                actions: [
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    child: Switch(
                      activeColor: Colors.orange,
                      hoverColor: Colors.orange,
                      value: isOnline,
                      onChanged: (bool value) {
                        changeOnline();
                        setState(() {
                          if(value == true){
                            _mapBloc.add(UpdateStatusDriverEvent(1));
                          }else{
                            _mapBloc.add(UpdateStatusDriverEvent(0));
                          }
                          isOnline = value;
                          //isInProcessPickup = true;
                          print(isOnline);
                        });
                      },
                    ),
                  ),
                ],
              ),
              body:
              !isInProcessPickup ?  Stack(
                children: [
                  googleMap(),
                  isOnline ==false? offLineMode() : Container(),
                ],
              ) :
              SnappingSheet(
                lockOverflowDrag: false,
                snappingPositions: [
                  SnappingPosition.factor(
                    positionFactor: 0.0,
                    grabbingContentOffset: GrabbingContentOffset.top,
                  ),
                  SnappingPosition.factor(
                    snappingCurve: Curves.elasticOut,
                    snappingDuration: Duration(milliseconds: 1750),
                    positionFactor: 0.0,
                  ),
                  SnappingPosition.factor(positionFactor: 0.95),
                ],
                child: Stack(
                  children: <Widget>[
                    googleMap(),
                    !isOnline ? offLineMode() :
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(),
                        ),
                        myLocation(),
                        SizedBox(
                          height: 10,
                        ),
                        // onLineModeDetail()
                      ],
                    )
                  ],
                ),
                grabbingHeight: 50,
                grabbing: DefaultGrabbing(),
                sheetBelow: SnappingSheetContent(
                  childScrollController: scrollController,
                  draggable: false,
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.white,
                    child: Utils.isEmpty(_mainBloc.listCustomer)?
                    Container(
                      child: Center(child: Align(alignment: Alignment.center,child: Text('Hiện tại chưa có khách \n Hoặc \n Sang nhóm khách và chọn khách để đón.',textAlign: TextAlign.center,))),
                    )
                    :
                    SingleChildScrollView(
                      //reverse: this.widget.reverse,
                      padding: EdgeInsets.zero,
                      //padding: EdgeInsets.all(20).copyWith(top: 30),
                      controller: scrollController,
                      child:  _mainBloc.soKhachDaDonDuoc == (Utils.isEmpty(_mainBloc.listCustomer) ? 100 :  _mainBloc.listCustomer.length)
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
                                          child: Text(_mainBloc.listCustomer[0].loaiKhach == 1 ?
                                            'Điểm trả khách:' : 'Điểm nhận khách:',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(_mainBloc.listCustomer[0].loaiKhach == 1 ?
                                              _mainBloc.listCustomer[0].vanPhongDi.toString() : _mainBloc.listCustomer[0].vanPhongDen.toString(),
                                            style: TextStyle(color: Colors.black),
                                          ),
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
                                          child: Text(
                                            _mainBloc.listCustomer[0].chuyen.toString(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              Visibility(
                                  visible: _mainBloc.listCustomer[0].loaiKhach == 2,
                                  child: InkWell(
                                    onTap: (){
                                      List<String> idTC = new List<String>();
                                      _mainBloc.listCustomer.forEach((element) {
                                       idTC.add(element.idTrungChuyen);
                                      });
                                      String id = idTC.join(',');
                                      print(id.split(','));
                                      _mapBloc.add(UpdateStatusCustomerMapEvent(status: 11,idTrungChuyen: id.split(',')));
                                    },
                                    child: Container(
                                      height: 40.0,
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: Colors.blue
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Xác nhận trả khách thành công',
                                          style: TextStyle(fontFamily: fontSub, fontSize: 16, color: white,),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                  ),
                              ),
                              Visibility(
                                visible: _mainBloc.listCustomer[0].loaiKhach == 1,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16,right: 16),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: (){
                                                if(Utils.isEmpty(_mainBloc.listTaiXeLimo)){
                                                  _mainBloc.listCustomer.forEach((element) {
                                                    _mapBloc.add(UpdateTaiXeLimos(element));
                                                  });
                                                  _mapBloc.add(GetListTaiXeLimos());
                                                }
                                                else{
                                                  Utils.showToast('Cập nhật thành công');
                                                }
                                              },
                                              child: Container(
                                                height: 40.0,
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    color: Colors.blue
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Lấy DS LX Limo',
                                                    style: TextStyle(fontFamily: fontSub, fontSize: 13, color: white,),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Expanded(
                                            child: InkWell(
                                              onTap: (){
                                                if(!Utils.isEmpty(_mainBloc.listTaiXeLimo)){
                                                  _mapBloc.add(CustomerTransferToLimo(
                                                      'Thông báo',
                                                      '',
                                                      _mainBloc.listTaiXeLimo
                                                  ));
                                                }
                                                else{
                                                  Utils.showToast('Vui lòng lấy DS LX Limo');
                                                }
                                              },
                                              child: Container(
                                                height: 40.0,
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    color: Colors.orange
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Giao khách cho Limo',
                                                    style: TextStyle(fontFamily: fontSub, fontSize: 13, color: white,),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
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
                                        height: 600,
                                        child: ListView.separated(
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(left: 10, right: 16),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context).scaffoldBackgroundColor,
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
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      _mainBloc.listTaiXeLimo[index].hoTenTaiXeLimousine?.toString()??'',
                                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(' - ${_mainBloc.listTaiXeLimo[index].soKhach} khách', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                                                  ],
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
                                                        color: Theme.of(context).disabledColor,
                                                      ),

                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 14, left: 14, top: 15, bottom: 12),
                                                        child: GestureDetector(
                                                          onTap: () => launch("tel://${_mainBloc.listTaiXeLimo[index].dienThoaiTaiXeLimousine}"),
                                                          child: Container(
                                                            height: 35,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10),
                                                              color: Colors.blueAccent,
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                'Gọi Lái xe Limo',
                                                                style: Theme.of(context).textTheme.button.copyWith(
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
                              )
                            ],
                          ),
                        ),
                      )
                      :
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
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
                                                              _mainBloc.listCustomer[0].loaiKhach == 1 ?
                                                              _mainBloc.listCustomer[0].vanPhongDi?.toString()??'Không có địa chỉ chuyến'
                                                                  :
                                                              _mainBloc.listCustomer[0].vanPhongDen?.toString()??'Không có địa chỉ chuyến',
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
                                                  Text("Chuyến: " + _mainBloc.listCustomer[0].chuyen?.toString()??'', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                                  // SizedBox(
                                                  //   height: 5,
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: ()=>print(_mainBloc.listCustomer.length),
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.all(Radius.circular(8))),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                '${_mainBloc.soKhachDaDonDuoc.toString()}/${_mainBloc.listCustomer.length.toString()}',
                                                style: Theme.of(context).textTheme.title.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                'N-K',
                                                style: Theme.of(context).textTheme.caption.copyWith(
                                                  color: Theme.of(context).disabledColor,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height*0.7,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: Divider()),
                                    Utils.isEmpty(_mainBloc.listCustomer) ? Container() :
                                    Text('Danh sách Khách ${_mainBloc.listCustomer[0].loaiKhach == 1 ? 'Đón' : 'Trả'}',style: TextStyle(color: Colors.purple),),
                                    Expanded(child: Divider()),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: ListView.separated(
                                      padding: EdgeInsets.only(bottom: 100),
                                      itemBuilder: (BuildContext context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 10, right: 10,bottom: 0),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color:  Theme.of(this.context).scaffoldBackgroundColor,
                                              borderRadius: BorderRadius.circular(0),
                                              border: Border.all(
                                                  color: ((_mainBloc.listCustomer[index].trangThaiTC == 2 || _mainBloc.listCustomer[index].trangThaiTC == 5 || _mainBloc.listCustomer[index].trangThaiTC == 4 || _mainBloc.listCustomer[index].trangThaiTC == 8) ? Colors.transparent : Colors.red ),
                                                  width: 2
                                              ),
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
                                                  padding: const EdgeInsets.only(left: 8,top: 10,right: 10,bottom: 10),
                                                  color: Colors.grey.withOpacity(0.2),
                                                  child: Row(
                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(10),
                                                            child: Container(
                                                                padding: EdgeInsets.all(5),
                                                                height: 50,
                                                                width: 50,
                                                                decoration: BoxDecoration(
                                                                    color: Colors.blueAccent
                                                                ),
                                                                child: Center(child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Text('Mã',style: TextStyle(color: Colors.white),),
                                                                    SizedBox(height: 2,),
                                                                    Text(_mainBloc.listCustomer[index].maVe?.toString()??'',style: TextStyle(color: Colors.white,fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                                                  ],
                                                                ))),
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
                                                                    _mainBloc.listCustomer[index].tenKhachHang?.toString()??'',
                                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text('(${_mainBloc.listCustomer[index].soDienThoaiKhach})', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text('Số khách: (${_mainBloc.listCustomer[index].soKhach})', style: TextStyle(fontSize: 12, color: Colors.blue)),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      InkWell(
                                                        onTap: () => launch("tel://${_mainBloc.listCustomer[index].soDienThoaiKhach}"),
                                                        child: Container(
                                                            padding: EdgeInsets.all(5),
                                                            child: Icon(Icons.phone_callback_outlined)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(
                                                  height: 0.5,
                                                  color: Theme.of(context).disabledColor,
                                                ),

                                                Padding(
                                                  padding: const EdgeInsets.only(right: 8, left: 8, top: 10, bottom: 5),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Điểm đón: ',
                                                            style: Theme.of(context).textTheme.caption.copyWith(
                                                              color: Theme.of(context).disabledColor,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text( _mainBloc.listCustomer[index].loaiKhach == 1 ? _mainBloc.listCustomer[index].diaChiKhachDi?.toString()??'' :
                                                              _mainBloc.listCustomer[index].vanPhongDen?.toString()??'',textAlign: TextAlign.right,
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: Theme.of(context).textTheme.subtitle.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                color: _mainBloc.listCustomer[index].loaiKhach == 2 ? Colors.black : Colors.red,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 2,
                                                      ),
                                                      Divider(),
                                                      SizedBox(
                                                        height: 2,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Điểm trả  : ',
                                                            style: Theme.of(context).textTheme.caption.copyWith(
                                                              color: Theme.of(context).disabledColor,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text( _mainBloc.listCustomer[index].loaiKhach == 1 ? _mainBloc.listCustomer[index].vanPhongDi?.toString()??'' :
                                                              _mainBloc.listCustomer[index].diaChiKhachDen?.toString()??'',
                                                              maxLines: 2,textAlign: TextAlign.right,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,fontStyle:FontStyle.italic ,
                                                                color: _mainBloc.listCustomer[index].loaiKhach == 1 ? Colors.black : Colors.red,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 8, left: 8, top: 0, bottom: 0),
                                                  child: Divider(
                                                    height: 0.5,
                                                    color: Theme.of(context).disabledColor,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 0, left: 8, top: 10, bottom: 10),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Text(
                                                            'Thông tin LX Limousine',
                                                            style: Theme.of(context).textTheme.caption.copyWith(
                                                              color: Theme.of(context).disabledColor,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 3,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                _mainBloc.listCustomer[index].dienThoaiTaiXeLimousine?.toString()??'',
                                                                style: Theme.of(context).textTheme.subtitle.copyWith(
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Theme.of(context).textTheme.title.color,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 3,
                                                              ),
                                                              Text(
                                                                ' - ',
                                                                style: Theme.of(context).textTheme.subtitle.copyWith(
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.red,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 3,
                                                              ),
                                                              Text(
                                                                '( ${_mainBloc.listCustomer[index].bienSoXeLimousine?.toString()??""} )',
                                                                style: Theme.of(context).textTheme.subtitle.copyWith(fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 12),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      InkWell(
                                                          onTap: () => launch("tel://${_mainBloc.listCustomer[index].dienThoaiTaiXeLimousine}"),
                                                          child: Container(
                                                              padding: EdgeInsets.only(right: 20),
                                                              child: Icon(Icons.phone_callback_outlined))),
                                                      // SizedBox(width: 1,),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 8, left: 8, top: 0, bottom: 0),
                                                  child: Divider(
                                                    height: 0.5,
                                                    color: Theme.of(context).disabledColor,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 14, left: 14, top: 5, bottom: 5),
                                                  child:
                                                  (_mainBloc.listCustomer[index].trangThaiTC == 4 || _mainBloc.listCustomer[index].trangThaiTC == 8 )?
                                                  GestureDetector(
                                                    onTap: () {
                                                    },
                                                    child: Container(
                                                      height: 35,
                                                      child: Center(
                                                        child: Text(
                                                          'Đã hoàn thành',
                                                          style: Theme.of(context).textTheme.button.copyWith(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ):
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: GestureDetector(
                                                          child: InkWell(
                                                           onTap:(){
                                                             if(_mainBloc.listCustomer[index].trangThaiTC == 3 ){
                                                               _mainBloc.isLock = false;
                                                               _mapBloc.add(UpdateStatusCustomerMapEvent(status: 2,idTrungChuyen: _mainBloc.listCustomer[index].idTrungChuyen.split(',')));
                                                               _mapBloc.add(GetListDetailTripsCustomer(format.parse(_mainBloc.ngayTC),_mainBloc.idVanPhong,_mainBloc.idKhungGio,_mainBloc.loaiKhach));
                                                               mapController.removePolyline(myPolyline);
                                                               Utils.showToast('Bạn đã tạm dừng đón khách này.');
                                                             }else if( _mainBloc.listCustomer[index].trangThaiTC == 6){
                                                               _mainBloc.isLock = false;
                                                               _mapBloc.add(UpdateStatusCustomerMapEvent(status: 5,idTrungChuyen: _mainBloc.listCustomer[index].idTrungChuyen.split(',')));
                                                               _mapBloc.add(GetListDetailTripsCustomer(format.parse(_mainBloc.ngayTC),_mainBloc.idVanPhong,_mainBloc.idKhungGio,_mainBloc.loaiKhach));
                                                               mapController.removePolyline(myPolyline);
                                                               Utils.showToast('Bạn đã tạm dừng đón khách này.');
                                                             }
                                                           },
                                                            child: (_mainBloc.listCustomer[index].trangThaiTC == 3 || _mainBloc.listCustomer[index].trangThaiTC == 6 ) ?
                                                            Container(
                                                              height: 35,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(10),
                                                                color: Colors.grey,
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  'Tạm dừng',
                                                                  style: Theme.of(context).textTheme.button.copyWith(
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.black,
                                                                  ),
                                                                ),
                                                              ),
                                                            ) : Container(),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: GestureDetector(
                                                          onTap: (){
                                                            setState(() {
                                                              // don
                                                              if(_mainBloc.listCustomer[index].loaiKhach == 1){
                                                                if(_mainBloc.listCustomer[index].trangThaiTC == 2 && _mainBloc.isLock == false){
                                                                  /// next Đang đón
                                                                  _mainBloc.isLock = true;
                                                                  _mapBloc.add(GetListLocationPolylineEvent(_mainBloc.listCustomer[index].toaDoDiaChiKhachDi));
                                                                  _mapBloc.add(UpdateStatusCustomerMapEvent(status: 3,idTrungChuyen: _mainBloc.listCustomer[index].idTrungChuyen.split(',')));
                                                                  _mapBloc.add(GetListDetailTripsCustomer(format.parse(_mainBloc.ngayTC),_mainBloc.idVanPhong,_mainBloc.idKhungGio,_mainBloc.loaiKhach));
                                                                  Utils.showToast('Đang đi đón khách');
                                                                }
                                                                else if(_mainBloc.listCustomer[index].trangThaiTC == 3){
                                                                  /// nex Đã đón
                                                                  _mainBloc.isLock = false;
                                                                  DetailTripsResponseBody customer = new DetailTripsResponseBody(
                                                                      idTrungChuyen: _mainBloc.listCustomer[index].idTrungChuyen,
                                                                      idTaiXeLimousine : _mainBloc.listCustomer[index].idTaiXeLimousine,
                                                                      hoTenTaiXeLimousine : _mainBloc.listCustomer[index].hoTenTaiXeLimousine,
                                                                      dienThoaiTaiXeLimousine : _mainBloc.listCustomer[index].dienThoaiTaiXeLimousine,
                                                                      tenXeLimousine : _mainBloc.listCustomer[index].tenXeLimousine,
                                                                      bienSoXeLimousine : _mainBloc.listCustomer[index].bienSoXeLimousine,
                                                                      tenKhachHang : _mainBloc.listCustomer[index].tenKhachHang,
                                                                      soDienThoaiKhach :_mainBloc.listCustomer[index].soDienThoaiKhach,
                                                                      diaChiKhachDi :_mainBloc.listCustomer[index].diaChiKhachDi,
                                                                      toaDoDiaChiKhachDi:_mainBloc.listCustomer[index].toaDoDiaChiKhachDi,
                                                                      diaChiKhachDen:_mainBloc.listCustomer[index].diaChiKhachDen,
                                                                      toaDoDiaChiKhachDen:_mainBloc.listCustomer[index].toaDoDiaChiKhachDen,
                                                                      diaChiLimoDi:_mainBloc.listCustomer[index].diaChiLimoDi,
                                                                      toaDoLimoDi:_mainBloc.listCustomer[index].toaDoLimoDi,
                                                                      diaChiLimoDen:_mainBloc.listCustomer[index].diaChiLimoDen,
                                                                      toaDoLimoDen:_mainBloc.listCustomer[index].toaDoLimoDen,
                                                                      loaiKhach:_mainBloc.listCustomer[index].loaiKhach,
                                                                      trangThaiTC: 4,
                                                                      soKhach:_mainBloc.listCustomer[index].soKhach,
                                                                      chuyen: _mainBloc.listCustomer[index].chuyen,
                                                                      totalCustomer: _mainBloc.currentNumberCustomerOfList,
                                                                      idKhungGio:  _mainBloc.idKhungGio,
                                                                      idVanPhong:  _mainBloc.idVanPhong,
                                                                      ngayTC:_mainBloc.ngayTC,
                                                                      maVe: _mainBloc.listCustomer[index].maVe,
                                                                      vanPhongDi: _mainBloc.listCustomer[index].vanPhongDi,
                                                                      vanPhongDen: _mainBloc.listCustomer[index].vanPhongDen
                                                                  );
                                                                  _mapBloc.add(UpdateTaiXeLimos(customer));
                                                                  _mainBloc.soKhachDaDonDuoc++;
                                                                  _mapBloc.add(UpdateStatusCustomerMapEvent(status: 4,idTrungChuyen: _mainBloc.listCustomer[index].idTrungChuyen.split(',')));
                                                                  _mapBloc.add(GetListDetailTripsCustomer(format.parse(_mainBloc.ngayTC),_mainBloc.idVanPhong,_mainBloc.idKhungGio,_mainBloc.loaiKhach));
                                                                  Utils.showToast('Đón khách thành công - chuyển sang khách tiếp theo');
                                                                  mapController.removePolyline(myPolyline);
                                                                }
                                                                else if(_mainBloc.isLock == true && _mainBloc.listCustomer[index].trangThaiTC == 2){
                                                                  Utils.showToast('Bạn cần tạm dừng khách đang đón để chuyển sang khách mới.');
                                                                }
                                                              }
                                                              //tra
                                                              else{
                                                                /// bắn notification xác nhận - nhận được khách từ tài xế Limo
                                                                if( _mainBloc.listCustomer[index].trangThaiTC == 5 && _mainBloc.isLock == false){
                                                                  //statusTra = 7;/// nex Đang trả
                                                                  _mainBloc.isLock = true;
                                                                  _mapBloc.add(UpdateStatusCustomerMapEvent(status: 6,idTrungChuyen: _mainBloc.listCustomer[index].idTrungChuyen.split(',')));
                                                                  _mapBloc.add(GetListDetailTripsCustomer(format.parse(_mainBloc.ngayTC),_mainBloc.idVanPhong,_mainBloc.idKhungGio,_mainBloc.loaiKhach));
                                                                  Utils.showToast('Đang đi trả khách');
                                                                }
                                                                else if(_mainBloc.isLock == true && _mainBloc.listCustomer[index].trangThaiTC == 5){
                                                                  Utils.showToast('Bạn cần tạm dừng khách đang đón để chuyển sang khách mới.');
                                                                }
                                                                else if(_mainBloc.listCustomer[index].trangThaiTC == 6){
                                                                  /// Đã trả
                                                                  _mainBloc.isLock = false;
                                                                  _mapBloc.add(UpdateStatusCustomerMapEvent(status: 8,idTrungChuyen: _mainBloc.listCustomer[index].idTrungChuyen.split(',')));
                                                                  _mapBloc.add(GetListDetailTripsCustomer(format.parse(_mainBloc.ngayTC),_mainBloc.idVanPhong,_mainBloc.idKhungGio,_mainBloc.loaiKhach));
                                                                  _mainBloc.soKhachDaDonDuoc++;
                                                                  Utils.showToast('Trả khách thành công');
                                                                }
                                                              }
                                                            });
                                                          },
                                                          child: Container(
                                                            height: 35,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10),
                                                              color:
                                                              _mainBloc.listCustomer[index].loaiKhach == 1
                                                                  ?
                                                              (_mainBloc.listCustomer[index].trangThaiTC == 2 ? Colors.orange : (_mainBloc.listCustomer[index].trangThaiTC == 3 ? Colors.blueAccent : _mainBloc.listCustomer[index].trangThaiTC == 4 ? Colors.orange : Colors.orange))
                                                                  :
                                                              (_mainBloc.listCustomer[index].trangThaiTC == 5 ? Colors.orange : (_mainBloc.listCustomer[index].trangThaiTC == 6 ? Colors.blueAccent : _mainBloc.listCustomer[index].trangThaiTC == 7 ? Colors.orange : Colors.orange)),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                _mainBloc.listCustomer[index].loaiKhach == 1
                                                                    ?
                                                                (_mainBloc.listCustomer[index].trangThaiTC == 2 ? 'Đón khách' : (_mainBloc.listCustomer[index].trangThaiTC != 2 ? 'Xác nhận' : ''))// _mainBloc.listCustomer[index].trangThaiTC == 4 ? 'Đã đón' :
                                                                    :
                                                                (_mainBloc.listCustomer[index].trangThaiTC == 5 ? 'Nhận khách' : (_mainBloc.listCustomer[index].trangThaiTC != 5 ? 'Xác nhận'  : ''))//: _mainBloc.listCustomer[index].trangThaiTC == 8 ? 'Đã trả'
                                                                ,
                                                                style: Theme.of(context).textTheme.button.copyWith(
                                                                  fontWeight: FontWeight.bold,
                                                                  color:(_mainBloc.listCustomer[index].trangThaiTC == 2 || _mainBloc.listCustomer[index].trangThaiTC == 5) ? Colors.black : Colors.white,
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
                                      itemCount: _mainBloc.listCustomer.length),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ),
                  )
                ),
              )
          ),
        ),
        Visibility(
          visible: state is MapLoading,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  changeOnline() {
    try {
      // LocationService locationService = new LocationService();
      isOnline = !isOnline;
      if (isOnline) {
        //locationService.startListenChangeLocation();
        _mapBloc.add(OnlineEvent());
      } else {
        _mapBloc.add(OfflineEvent());
        // locationService.stopListenChangeLocation();
      }
    } catch (error) {
      print(error);
    }
  }

  Widget googleMap() {
    return GoogleMaps(controller: mapController);
  }

  Widget myLocation() {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          InkWell(
            onTap: () {},
            child: Container(
              decoration: new BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: primaryColor,
                    blurRadius: 12,
                    spreadRadius: -5,
                    offset: new Offset(0.0, 0),
                  )
                ],
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.my_location,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget offLineMode() {
    return Animator(
      duration: Duration(milliseconds: 400),
      cycles: 1,
      builder: (anim) => SizeTransition(
        sizeFactor: anim,
        axis: Axis.horizontal,
        child: Container(
          height: AppBar().preferredSize.height,
          color: Colors.orange,
          child: Padding(
            padding: const EdgeInsets.only(right: 14, left: 14),
            child: Row(
              children: <Widget>[
                DottedBorder(
                  color: Colors.white,
                  borderType: BorderType.Circle,
                  strokeWidth: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      FontAwesomeIcons.cloudMoon,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Bạn đang offline !',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Bật online để bắt đầu nhận việc.',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  drawPolyline(List<LatLng> lsPoint) {
      myPolyline = Polyline(polylineId: PolylineId('Id_Polyline'), points:lsPoint, color: Colors.deepPurpleAccent, width: 4);
      mapController.addPolyline(myPolyline);
    }
}

