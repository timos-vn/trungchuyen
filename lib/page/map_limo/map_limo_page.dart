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
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
import 'package:trungchuyen/page/main/main_bloc.dart';
import 'package:trungchuyen/page/main/main_event.dart';
import 'package:trungchuyen/page/map_limo/map_limo_bloc.dart';
import 'package:trungchuyen/service/location_service.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/themes/images.dart';
import 'package:trungchuyen/utils/marker_icon.dart';
import 'package:trungchuyen/utils/utils.dart';
import 'package:trungchuyen/widget/marquee_widget.dart';

import 'map_limo_event.dart';
import 'map_limo_state.dart';

class MapLimoPage extends StatefulWidget {

  MapLimoPage({Key key}) : super(key: key);

  @override
  MapLimoPageState createState() => MapLimoPageState();
}

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

  StreamGroup<LatLngDelta> subscriptions = StreamGroup<LatLngDelta>();
  LatLngInterpolationStream _latLngStream = LatLngInterpolationStream();
  Location location = new Location();
  var scaffoldKey = new GlobalKey<ScaffoldState>();

  GlobalKey keyMap;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mapLimoBloc = MapLimoBloc(context);
    _mainBloc = BlocProvider.of<MainBloc>(context);
    //_mapBloc.add(GetListCustomer(_mainBloc.listOfDetailTrips));
    subscriptions.add(_latLngStream.getAnimatedPosition("DriverMarker"));
    subscriptions.stream.listen((LatLngDelta delta) {
      drawMyLocation(LatLng(delta.from.latitude, delta.from.longitude), delta.rotation);
    });
    print('LengthABCCC123');
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
    return BlocListener<MapLimoBloc,MapLimoState>(
      cubit: _mapLimoBloc,
      listener:  (context, state){
        if(state is GetListCustomerLimoSuccess){

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

}

