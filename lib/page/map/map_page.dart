import 'package:animator/animator.dart';
import 'package:async/async.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animarker/lat_lng_interpolation.dart';
import 'package:flutter_animarker/models/lat_lng_delta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:location/location.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:trungchuyen/extension/default_grabbing.dart';
import 'package:trungchuyen/page/dummy_content/dummy_content.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
import 'package:trungchuyen/page/main/main_bloc.dart';
import 'package:trungchuyen/page/main/main_event.dart';
import 'package:trungchuyen/page/map/map_bloc.dart';
import 'package:trungchuyen/page/map/map_state.dart';
import 'package:trungchuyen/service/location_service.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/themes/images.dart';
import 'package:trungchuyen/utils/marker_icon.dart';
import 'package:trungchuyen/utils/utils.dart';
import 'package:trungchuyen/widget/marquee_widget.dart';

import 'map_event.dart';

class MapPage extends StatefulWidget {

  MapPage({Key key}) : super(key: key);

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  final scrollController = ScrollController();
  bool isOnline = false;
  bool isInProcessPickup = false;

  MainBloc _mainBloc;
  MapBloc _mapBloc;
  List<DetailTripsReponseBody> _listOfCustomerTrips = new List<DetailTripsReponseBody>();
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
  LatLngInterpolationStream _latLngStream = LatLngInterpolationStream();
  Location location = new Location();
  var scaffoldKey = new GlobalKey<ScaffoldState>();

  GlobalKey keyMap;

  @override
  void initState() {
    // TODO: implement initState
    _mapBloc = MapBloc(context);
    _mainBloc = BlocProvider.of<MainBloc>(context);
    _mapBloc.add(GetListCustomer(_mainBloc.listOfDetailTrips));

    subscriptions.add(_latLngStream.getAnimatedPosition("DriverMarker"));
    subscriptions.stream.listen((LatLngDelta delta) {
      drawMyLocation(LatLng(delta.from.latitude, delta.from.longitude), delta.rotation);
    });
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
                title: !isOnline ?  GestureDetector(
                  onTap: (){
                    _mapBloc.add(UpdateStatusDriverEvent(0));
                  },
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
                GestureDetector(
                  onTap: () async{
                    _mainBloc.add(UpdateStatusCustomerEvent());
                  },
                  child: Text(
                    'Online',
                    style: Theme.of(context).textTheme.title.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.title.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
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
                  child: DummyContent(
                    currentNumberCustomerOfList: _mainBloc.listOfDetailTrips.length,
                    listOfDetailTrips: _mainBloc.listOfDetailTrips,
                    controller: scrollController,
                  ),
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
        locationService.startListenChangeLocation();
      } else {
        locationService.stopListenChangeLocation();
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

}

