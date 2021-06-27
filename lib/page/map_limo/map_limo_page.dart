import 'package:animator/animator.dart';
import 'package:async/async.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animarker/lat_lng_interpolation.dart';
import 'package:flutter_animarker/models/lat_lng_delta.dart';
import 'package:flutter_animarker/models/lat_lng_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_controller/google_maps_controller.dart';

import 'package:trungchuyen/page/main/main_bloc.dart';
import 'package:trungchuyen/page/map_limo/map_limo_bloc.dart';
import 'package:trungchuyen/service/soket_io_service.dart';
import 'package:trungchuyen/utils/marker_icon.dart';


import 'map_limo_event.dart';
import 'map_limo_state.dart';



class MapLimoPage extends StatefulWidget {

  MapLimoPage({Key key}) : super(key: key);

  @override
  MapLimoPageState createState() => MapLimoPageState();
}
/// đây là map limo
class MapLimoPageState extends State<MapLimoPage> {
  final scrollController = ScrollController();
  bool isOnline = false;
  bool isInProcessPickup = false;
  MainBloc _mainBloc;
  MapLimoBloc _mapLimoBloc;

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

  LatLngInterpolationStream latLngStream = LatLngInterpolationStream();
  List<String> lsMarkerId = [];
  // cái này này để samg bloc
  // lấy cái
  StreamGroup<LatLngDelta> subscriptions = StreamGroup<LatLngDelta>();
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  SocketIOService socketIOService;
  GlobalKey keyMap;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mapLimoBloc = MapLimoBloc(context);
    _mainBloc = BlocProvider.of<MainBloc>(context);
    socketIOService = Get.find<SocketIOService>();
    socketIOService.socket.on("TAIXE_TRUNGCHUYEN_CAPNHAT_TOADO", (data){
      String item = data['LOCATION'];
      String _location = item.replaceAll('{', '').replaceAll('}', '').replaceAll("\"","").replaceAll('lat', '').replaceAll('lng', '').replaceAll(':', '');
      String makerId = data['PHONE'];
      setState(() {
        if(lsMarkerId.where((id) => id==makerId).length==0){
          lsMarkerId.add(makerId);
          subscriptions.add(latLngStream.getAnimatedPosition(makerId));
          subscriptions.stream.listen((LatLngDelta delta) {
            drawMyLocation(LatLng(delta.from.latitude, delta.from.longitude), delta.rotation,delta.markerId);
          });
        }
        latLngStream.addLatLng(new LatLngInfo(double.parse( _location.split(',')[0]), double.parse( _location.split(',')[1]),makerId));
      });
      print('TAIXE_TRUNGCHUYEN_CAPNHAT_TOADO => ${data.toString()}');
    });

    print('LengthABCCC123');
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<MapLimoBloc,MapLimoState>(
      cubit: _mapLimoBloc,
      listener:  (context, state){
        if(state is GetListCustomerLimoSuccess){

        }else if(state is GetEventStateSuccess){
          print('RELOAD AGAIN1');

        }
      },
      child: BlocBuilder<MapLimoBloc,MapLimoState>(
        cubit: _mapLimoBloc,
        builder: (BuildContext context, MapLimoState state) {
          return Scaffold(
            body: buildPage(context, state)
          );
        },
      ),
    );
  }

  Widget buildPage(BuildContext context,MapLimoState state){
    print('RELOAD AGAIN2');
    return Stack(
      children: [
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Scaffold(
              key: scaffoldKey,
              body: googleMap()
          ),
        ),
        Visibility(
          visible: state is MapLimoLoading,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  Widget googleMap() {
    return GoogleMaps(controller: mapController);
  }

  drawMyLocation(LatLng position, double alpha, String markerId) async {
    var iconCar = await getBitmapDescriptorFromAssetBytes('assets/images/carMarker.png', 50);
    var checkMarkerDriver = mapController.markers.where((element) => element.markerId.value == markerId).toList();
    if (checkMarkerDriver.length > 0) {
      mapController.removeMarker(checkMarkerDriver[0]);
    }
    mapController.addMarker(Marker(markerId: MarkerId(markerId), position: position, icon: iconCar, anchor: Offset(0.5, 0.5), rotation: alpha));
  }
}

