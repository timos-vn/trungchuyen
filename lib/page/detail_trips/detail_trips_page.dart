import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
import 'package:trungchuyen/page/detail_trips/detail_trips_bloc.dart';
import 'package:trungchuyen/page/detail_trips/detail_trips_event.dart';
import 'package:trungchuyen/page/detail_trips/detail_trips_state.dart';
import 'package:trungchuyen/themes/images.dart';
import 'package:intl/intl.dart';

class DetailTripsPage extends StatefulWidget {

  final DateTime dateTime;
  final String idTrips;
  final String idTime;

  const DetailTripsPage({Key key,this.dateTime, this.idTrips, this.idTime}) : super(key: key);

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
   // DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
    _bloc.add(GetListDetailTrips(widget.dateTime,widget.idTrips,widget.idTime));
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
          cubit: _bloc,
          listener:  (context, state){
            if(state is GetListOfDetailTripsSuccess){
              _listOfDetailTrips = _bloc.listOfDetailTrips;
              print('ok');
            }
          },
          child: BlocBuilder<DetailTripsBloc,DetailTripsState>(
            cubit: _bloc,
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
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(this.context).scaffoldBackgroundColor,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                        children: [
                          Text(
                            item.tenXeLimousine??'',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            item.bienSoXeLimousine??'',
                            style: TextStyle(fontWeight: FontWeight.normal,fontSize: 10,color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            item.dienThoaiTaiXeLimousine??'',
                            style: TextStyle(fontWeight: FontWeight.normal,color: Colors.grey),
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
                // Padding(
                //   padding: const EdgeInsets.only(right: 16, left: 16, top: 10, bottom: 10),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: <Widget>[
                //       Text(
                //         'Thông tin chuyến',
                //         style: Theme.of(this.context).textTheme.caption.copyWith(
                //           color: Theme.of(this.context).disabledColor,
                //           fontWeight: FontWeight.normal,
                //         ),
                //       ),
                //       SizedBox(
                //         height: 5,
                //       ),
                //       Text(
                //         //'dateStartingOrFinishing',
                //         '${item.thoiGianChay??''}' + " / " + '${item.ngayChay??''}',
                //         maxLines: 2,
                //         overflow: TextOverflow.ellipsis,
                //         style: Theme.of(this.context).textTheme.subtitle.copyWith(
                //           fontWeight: FontWeight.normal,
                //           color: Theme.of(this.context).textTheme.title.color,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(right: 16, left: 16, top: 0, bottom: 0),
                  child: Divider(
                    height: 0.5,
                    color: Theme.of(this.context).disabledColor,
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
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${item.tenKhachHang??''}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(this.context).textTheme.subtitle.copyWith(
                          fontWeight: FontWeight.normal,
                          color: Theme.of(this.context).textTheme.title.color,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${item.soDienThoaiKhach??''}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(this.context).textTheme.subtitle.copyWith(
                          fontWeight: FontWeight.normal,
                          color: Theme.of(this.context).textTheme.title.color,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Địa chỉ khách đển: ${item.diaChiKhachDen??''}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(this.context).textTheme.subtitle.copyWith(
                          fontWeight: FontWeight.normal,
                          color: Theme.of(this.context).textTheme.title.color,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Địa chỉ khách đi: ${item.diaChiKhachDi??''}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(this.context).textTheme.subtitle.copyWith(
                          fontWeight: FontWeight.normal,
                          color: Theme.of(this.context).textTheme.title.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
