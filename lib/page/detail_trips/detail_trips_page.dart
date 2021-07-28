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
import 'package:trungchuyen/themes/images.dart';
import 'package:intl/intl.dart';
import 'package:trungchuyen/widget/separator.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailTripsPage extends StatefulWidget {

  final DateTime dateTime;
  final int idRoom;
  final int idTime;
  final int typeCustomer;

  const DetailTripsPage({Key key,this.dateTime, this.idRoom, this.idTime,this.typeCustomer}) : super(key: key);

  @override
  _DetailTripsPageState createState() => _DetailTripsPageState();
}

class _DetailTripsPageState extends State<DetailTripsPage> {

  DetailTripsBloc _bloc;
  List<DetailTripsResponseBody> _listOfDetailTrips = new List<DetailTripsResponseBody>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = DetailTripsBloc(context);
    _bloc.getMainBloc(context);
   // DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
    _bloc.add(GetListDetailTrips(widget.dateTime,widget.idRoom,widget.idTime,widget.typeCustomer));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Danh sách Khách Chờ',
            style: TextStyle(color: Colors.black),
          ),
           centerTitle: true,
        ),
        body:BlocListener<DetailTripsBloc,DetailTripsState>(
          bloc: _bloc,
          listener:  (context, state){
            if(state is GetListOfDetailTripsSuccess){
              _listOfDetailTrips = _bloc.listOfDetailTrips;
              print('ok');
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
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Scrollbar(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _listOfDetailTrips.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildListItem(_listOfDetailTrips[index]);
                      })
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom + 16,
            )
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

        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 16, top: 8, bottom: 8),
          child: ClipPath(
            clipper: CustomClipPath(),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.dienThoaiTaiXeLimousine??'',
                                      style: TextStyle(fontWeight: FontWeight.normal,fontSize: 11,color: Colors.grey),
                                    ),
                                  ), Text(
                                    '${item.bienSoXeLimousine??''}  ',
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
                        Text(
                          'Thông tin khách',
                          style: Theme.of(this.context).textTheme.caption.copyWith(
                            color: Theme.of(this.context).disabledColor,
                            fontWeight: FontWeight.normal,
                          ),
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
                                        color: Theme.of(this.context).textTheme.title.color,
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
                                SizedBox(height: 5,),
                                Text(
                                  'Số khách: ${item.soKhach??''} Khách.',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(this.context).textTheme.subtitle.copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.red,fontSize: 11,fontStyle: FontStyle.italic
                                  ),
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
                        SizedBox(height: 5,),
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
                                'Đi',
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
                              Icon(MdiIcons.panVertical),
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
                                    Icon(MdiIcons.mapMarker,color: Colors.black.withOpacity(0.4),size: 20,),
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
                                'Đến',
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
