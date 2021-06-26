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
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:location/location.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:trungchuyen/extension/default_grabbing.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
import 'package:trungchuyen/models/network/response/polyline_result_response.dart' as pp;
import 'package:trungchuyen/page/main/main_bloc.dart';
import 'package:trungchuyen/page/main/main_event.dart';
import 'package:trungchuyen/page/map/map_bloc.dart';
import 'package:trungchuyen/page/map/map_state.dart';
import 'package:trungchuyen/page/reason_cancel/reason_cancel_page.dart';
import 'package:trungchuyen/service/location_service.dart';
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
  List<DetailTripsResponseBody> _listOfCustomerTrips = new List<DetailTripsResponseBody>();
  GoogleMapsController mapController = GoogleMapsController(
    initialCameraPosition: CameraPosition(
      target: LatLng(21.0003347, 105.8233759),
      zoom: 14.4746,
    ),
    compassEnabled: true,
    myLocationEnabled: true,
    myLocationButtonEnabled: false,
    zoomControlsEnabled: false,
    //rotateGesturesEnabled: true,
  );

  StreamGroup<LatLngDelta> subscriptions = StreamGroup<LatLngDelta>();

  Location location = new Location();
  var scaffoldKey = new GlobalKey<ScaffoldState>();

  GlobalKey keyMap;
  int _countCustomerSuccessfulOrCancel=0;

  int statusDon=2;
  int statusTra=5;

  @override
  void initState() {
    // TODO: implement initState
    _mapBloc = MapBloc(context);
    _mainBloc = BlocProvider.of<MainBloc>(context);
    _mapBloc.add(CheckPermissionEvent());
    _mapBloc.add(GetListCustomer(_mainBloc.listOfDetailTrips));
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<MapBloc,MapState>(
      cubit: _mapBloc,
      listener:  (context, state){
        if(state is GetListCustomerSuccess){
          _listOfCustomerTrips =  state.listOfCustomerTrips;

        }else if(state is CheckPermissionSuccess){
          subscriptions.add(_mapBloc.latLngStream.getAnimatedPosition("DriverMarker"));
          subscriptions.stream.listen((LatLngDelta delta) {
            drawMyLocation(LatLng(delta.from.latitude, delta.from.longitude), delta.rotation);
          });
        }
        else if(state is GetListLocationPolylineSuccess){
          drawPolyline(state.lsPoints,);
        }else if(state is TransferCustomerToLimoSuccess){
          Utils.showDialogTransferCustomer(context: context,listOfDetailTripsSuccessful: _mainBloc.listTaiXeLimo);
        }
      },
      child: BlocBuilder<MapBloc,MapState>(
        cubit: _mapBloc,
        builder: (BuildContext context, MapState state) {
          return Scaffold(
            body: buildPage(context, state)
          );
        },
      ),
      //),
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
                title: !isOnline ?  Text(
                  'OffLine',
                  style: Theme.of(context).textTheme.title.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.title.color,
                  ),
                  textAlign: TextAlign.center,
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
                          isInProcessPickup = true;
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
                lockOverflowDrag: true,
                snappingPositions: [
                  SnappingPosition.factor(
                    positionFactor: 0.0,
                    grabbingContentOffset: GrabbingContentOffset.top,
                  ),
                  SnappingPosition.factor(
                    snappingCurve: Curves.elasticOut,
                    snappingDuration: Duration(milliseconds: 1750),
                    positionFactor: 0.4,
                  ),
                  SnappingPosition.factor(positionFactor: 0.9),
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
                  draggable: true,
                  child:
                  // DummyContent(
                  //   currentNumberCustomerOfList: _mainBloc.listOfDetailTrips.length,
                  //   listOfDetailTrips: _mainBloc.listOfDetailTrips,
                  //   controller: scrollController,
                  // ),
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.white,
                    child: SingleChildScrollView(
                      //reverse: this.widget.reverse,
                      padding: EdgeInsets.zero,
                      //padding: EdgeInsets.all(20).copyWith(top: 30),
                      controller: scrollController,
                      child: !Utils.isEmpty(_mainBloc.listOfDetailTrips)
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
                                                                  _mainBloc.listOfDetailTrips[0].diaChiKhachDi?.toString()??'Không có địa chỉ Khách',
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
                                                      Text("SĐT: " + _mainBloc.listOfDetailTrips[0].soDienThoaiKhach, style: TextStyle(fontSize: 12, color: Colors.grey)),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        'Tên KH: ${_mainBloc.listOfDetailTrips[0].tenKhachHang??''}',
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        style:TextStyle(
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.normal,
                                                          color: Theme.of(context).textTheme.title.color,
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
                                                  '${_countCustomerSuccessfulOrCancel.toString()}/${_mainBloc.currentNumberCustomerOfList.toString()}',
                                                  style: Theme.of(context).textTheme.title.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  'Khách',
                                                  style: Theme.of(context).textTheme.caption.copyWith(
                                                    color: Theme.of(context).disabledColor,
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
                                      color: Theme.of(context).disabledColor,
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
                                                style: Theme.of(context).textTheme.caption.copyWith(
                                                  color: Theme.of(context).disabledColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 3,),
                                              Text(
                                                _mainBloc.trips?.toString() ?? "",
                                                style: Theme.of(context).textTheme.subtitle.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context).textTheme.title.color,
                                                ),
                                              ),
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
                                      padding: const EdgeInsets.only(right: 20, left: 14, top: 5, bottom: 5),
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
                                                    _mainBloc.listOfDetailTrips[0].dienThoaiTaiXeLimousine?.toString()??"",
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
                                                    _mainBloc.listOfDetailTrips[0].bienSoXeLimousine?.toString()??"",
                                                    style: Theme.of(context).textTheme.subtitle.copyWith(fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () => launch("tel://${_mainBloc.listOfDetailTrips[0].dienThoaiTaiXeLimousine}"),
                                            child: Column(
                                              children: [
                                                Icon(Icons.phone_missed_outlined),
                                                Text(
                                                  'Lái xe',
                                                  style: Theme.of(context).textTheme.caption.copyWith(color: Theme.of(context).disabledColor, fontWeight: FontWeight.normal, fontSize: 13),
                                                ),
                                              ],
                                            ),
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
                                                    _mainBloc.add(UpdateStatusCustomerEvent(status: 9,idTrungChuyen: [_mainBloc.listOfDetailTrips[0].idTrungChuyen],note: value[0]));
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
                                                    style: Theme.of(context).textTheme.button.copyWith(
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
                                                  if(_mainBloc.listOfDetailTrips[0].loaiKhach == 1){
                                                    if(statusDon == 2){
                                                      /// next Đang đón
                                                      statusDon = 3;
                                                      print('123123');
                                                      _mapBloc.add(GetListLocationPolylineEvent(_mainBloc.listOfDetailTrips[0].toaDoDiaChiKhachDi));
                                                      _mainBloc.add(UpdateStatusCustomerEvent(status: 3,idTrungChuyen: [_mainBloc.listOfDetailTrips[0].idTrungChuyen]));
                                                      Utils.showToast('Đang đi đón khách');
                                                    }else if(statusDon == 3){
                                                      /// nex Đã đón
                                                      _mainBloc.add(UpdateStatusCustomerEvent(status: 4,idTrungChuyen: [_mainBloc.listOfDetailTrips[0].idTrungChuyen]));
                                                      _countCustomerSuccessfulOrCancel++;
                                                      statusDon = 2;
                                                      Utils.showToast('Đón khách thành công - chuyển sang khách tiếp theo');
                                                      mapController.removePolyline(myPolyline);
                                                      if(!Utils.isEmpty(_mainBloc.listOfDetailTrips)){
                                                        _mainBloc.listOfDetailTrips.removeAt(0);
                                                      }
                                                    }
                                                  }
                                                  //tra
                                                  else{

                                                    /// bắn notification xác nhận - nhận được khách từ tài xế Limo
                                                    if(statusTra == 6){
                                                      statusTra = 7;/// nex Đang trả
                                                      _mainBloc.add(UpdateStatusCustomerEvent(status: 7,idTrungChuyen: [_mainBloc.listOfDetailTrips[0].idTrungChuyen]));
                                                      Utils.showToast('Đang đi trả khách');
                                                    }else if(statusTra == 8){
                                                      /// Đã trả
                                                      _mainBloc.add(UpdateStatusCustomerEvent(status: 8,idTrungChuyen: [_mainBloc.listOfDetailTrips[0].idTrungChuyen]));
                                                      _countCustomerSuccessfulOrCancel++;
                                                      statusTra = 6;
                                                      Utils.showToast('Trả khách thành công');
                                                      if(!Utils.isEmpty(_mainBloc.listOfDetailTrips)){
                                                        _mainBloc.listOfDetailTrips.removeAt(0);
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
                                                  _mainBloc.listOfDetailTrips[0].loaiKhach == 1
                                                      ?
                                                  (statusDon == 2 ? Colors.orange : (statusDon == 3 ? Colors.blueAccent : statusDon == 4 ? Colors.orange : Colors.orange))
                                                      :
                                                  (statusTra == 6 ? Colors.orange : (statusTra == 7 ? Colors.blueAccent : statusTra == 8 ? Colors.orange : Colors.orange)),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    _mainBloc.listOfDetailTrips[0].loaiKhach == 1
                                                        ?
                                                    (statusDon == 2 ? 'Đón khách' : (statusDon == 3 ? 'Đang đón' : statusDon == 4 ? 'Đã đón' : ''))
                                                        :
                                                    (statusTra == 6 ? 'Nhận khách' : (statusTra == 7 ? 'Đang trả' : statusTra == 8 ? 'Đã trả' : ''))
                                                    ,
                                                    style: Theme.of(context).textTheme.button.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color:statusDon == 3 ? Colors.white : Colors.black,
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
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Row(
                                                            children: [
                                                              Text(
                                                                _mainBloc.listOfDetailTrips[index].tenKhachHang?.toString()??'',
                                                                style: TextStyle(fontWeight: FontWeight.bold),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text('(${_mainBloc.listOfDetailTrips[index].soDienThoaiKhach})', style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                                                  color: Theme.of(context).disabledColor,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 16, left: 16, top: 10, bottom: 5),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        'Pickup point (Điểm đón)',
                                                        style: Theme.of(context).textTheme.caption.copyWith(
                                                          color: Theme.of(context).disabledColor,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        _mainBloc.listOfDetailTrips[index].diaChiKhachDi?.toString()??'',
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: Theme.of(context).textTheme.subtitle.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          color: Theme.of(context).textTheme.title.color,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 16, left: 16, top: 0, bottom: 0),
                                                  child: Divider(
                                                    height: 0.5,
                                                    color: Theme.of(context).disabledColor,
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
                                                                _mainBloc.listOfDetailTrips[index].dienThoaiTaiXeLimousine?.toString()??'',
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
                                                                '( ${_mainBloc.listOfDetailTrips[index].dienThoaiTaiXeLimousine?.toString()??""} )',
                                                                style: Theme.of(context).textTheme.subtitle.copyWith(fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 12),
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
                                                    color: Theme.of(context).disabledColor,
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
                                                                }).then((value){
                                                              if(!Utils.isEmpty(value)){
                                                                //_mapBloc.add(UpdateStatusCustomerEvent());
                                                                _countCustomerSuccessfulOrCancel++;
                                                                _mainBloc.add(UpdateStatusCustomerEvent(status: 9,idTrungChuyen: [_mainBloc.listOfDetailTrips[0].idTrungChuyen],note: value[0]));
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
                                                                style: Theme.of(context).textTheme.button.copyWith(
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
                                                                style: Theme.of(context).textTheme.button.copyWith(
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
                                      itemCount: _mainBloc.listOfDetailTrips.length),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                          :
                      _mainBloc.currentNumberCustomerOfList == _countCustomerSuccessfulOrCancel && Utils.isEmpty(_mainBloc.listOfDetailTrips)
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
                                    print(_mainBloc.listTaiXeLimo.length.toString());
                                    _mapBloc.add(CustomerTransferToLimo(
                                      'Thông báo',
                                      'Bạn nhận được khách từ LX Trung chuyển.',
                                      _mainBloc.listTaiXeLimo
                                    ));
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
                        ),
                      )
                          :
                      Container(
                        child: Center(child: Align(alignment: Alignment.center,child: InkWell(
                            onTap: (){

                              print(_mainBloc.currentNumberCustomerOfList);
                              print(_countCustomerSuccessfulOrCancel);print(_mainBloc.listOfDetailTrips);
                            },
                            child: Text('Hiện tại chưa có khách \n Hoặc \n Sang nhóm khách và chọn khách để đón nhé.')))),
                      ),
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
      LocationService locationService = new LocationService();
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

  Widget onLineModeDetail() {
    return Padding(
      padding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
      child: Animator(
        tween: Tween<Offset>(
          begin: Offset(0, 0.4),
          end: Offset(0, 0),
        ),
        duration: Duration(milliseconds: 700),
        cycles: 1,
        builder: (anim) => SlideTransition(
          position: anim,
          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Container(
              decoration: BoxDecoration(
                color: black,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  new BoxShadow(
                    color: Colors.amberAccent,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: ClipRRect(
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
                                    userImage,
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
                                      Text(
                                        'Thông tin Khách',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,

                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text('0963004959', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          // Text('Khách: ', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                          Expanded(
                                              child: MarqueeWidget(
                                                direction: Axis.horizontal,
                                                child: Text(
                                                  'Khách ở: 262 nguyễn huy tưởng, thanh xuân, hà nội',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: primaryColor,
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(color: orange, borderRadius: BorderRadius.all(Radius.circular(8))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  '3/5',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Khách',
                                  style: TextStyle(
                                    color: Colors.black,
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
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 5),
                      child: Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Thông tin LX Limousine',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '0962983437',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    ' - ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    '( 90-B2 87206 )',
                                    style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 0.5,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 10),
                      child: Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Trip (Chuyến đi)',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '9h / Big C - Ninh Bình',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 0.5,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 14, left: 14, top: 15, bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: InkWell(
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
                                    _mainBloc.add(UpdateStatusCustomerEvent(status: 9,idTrungChuyen: [_mainBloc.listOfDetailTrips[0].idTrungChuyen],note: value[0]));
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
                                    style: TextStyle(
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
                            child: Container(
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.orange,
                              ),
                              child: Center(
                                child: Text(
                                  'Đón Khách',
                                  style:TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
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
            ),
          ),
        ),
      ),
    );
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

