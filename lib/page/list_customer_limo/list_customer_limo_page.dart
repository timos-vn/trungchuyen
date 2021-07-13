import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:trungchuyen/extension/popup_picker.dart';
import 'package:trungchuyen/models/network/response/list_of_group_awaiting_customer_response.dart';
import 'package:trungchuyen/models/network/response/list_of_group_limo_customer_response.dart';
import 'package:trungchuyen/page/detail_trips/detail_trips_page.dart';
import 'package:trungchuyen/page/detail_trips_limo/detail_trips_limo_bloc.dart';
import 'package:trungchuyen/page/detail_trips_limo/detail_trips_limo_event.dart';
import 'package:trungchuyen/page/detail_trips_limo/detail_trips_limo_page.dart';
import 'package:trungchuyen/page/list_customer_limo/list_customer_limo_bloc.dart';
import 'package:trungchuyen/page/list_customer_limo/list_customer_limo_state.dart';
import 'package:trungchuyen/page/main/main_bloc.dart';
import 'package:trungchuyen/page/main/main_event.dart';
import 'package:trungchuyen/page/options_input/options_input_pages.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/themes/images.dart';
import 'package:intl/intl.dart';
import 'package:trungchuyen/utils/utils.dart';

import 'list_customer_limo_event.dart';

class ListCustomerLimoPage extends StatefulWidget {

  ListCustomerLimoPage({Key key}) : super(key: key);

  @override
  ListCustomerLimoPageState createState() => ListCustomerLimoPageState();

}

class ListCustomerLimoPageState extends State<ListCustomerLimoPage> {

  ListCustomerLimoBloc _bloc;
  MainBloc _mainBloc;
  DateTime dateTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = ListCustomerLimoBloc(context);
    _mainBloc = BlocProvider.of<MainBloc>(context);
    DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
    _bloc.add(GetListCustomerLimo(parseDate));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Lịch Chuyến',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: [
          InkWell(
            onTap: ()async {
              final DateTime result = await showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return DateRangePicker(
                      dateTime ?? DateTime.now(),
                      null,
                      minDate: DateTime.now().subtract(const Duration(days: 10000)),
                      maxDate:
                      DateTime.now().add(const Duration(days: 10000)),
                      displayDate: dateTime ?? DateTime.now(),
                    );
                  });
              if (result != null) {
                print(result);
                dateTime = result;
                _bloc.add(GetListCustomerLimo(dateTime));
              }},
            child: Icon(
                Icons.event
            ),
          ),
          SizedBox(width: 20,),
          InkWell(
              onTap: (){
                if(Utils.isEmpty(dateTime)){
                  dateTime = DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
                }
                _bloc.add(GetListCustomerLimo(dateTime));
              },
              child: Icon(MdiIcons.reload)),
          SizedBox(width: 20,)
        ],
      ),
      body:BlocListener<ListCustomerLimoBloc,ListCustomerLimoState>(
        bloc: _bloc,
        /// khach Trung Chuyen
        // 1. Khách trung chuyển
        // 0: Không cần TC
        listener:  (context, state){
          if(state is GetListCustomerLimoSuccess){
           _mainBloc.listCustomerLimo = _bloc.listCustomerLimo;
          }else if(state is GetListOfDetailTripLimoSuccess){
            _mainBloc.listOfDetailTripLimo.clear();
            _mainBloc.listOfDetailTripLimo = _bloc.listOfDetailTripsLimo;
            int _countExitsCustomer = 0;

            _bloc.listOfDetailTripsLimo.forEach((element) {
              if(Utils.isEmpty(_mainBloc.listTaiXeTC)){
                _countExitsCustomer++;
                element.soKhach = _countExitsCustomer;
                _mainBloc.listTaiXeTC.add(element);
              }
              else{
                var contain =  _mainBloc.listTaiXeTC.where((phone) => phone.dienThoaiTaiXeTrungChuyen == element.dienThoaiTaiXeTrungChuyen);
                if (contain.isEmpty){
                  _mainBloc.listTaiXeTC.add(element);
                }else{
                  _countExitsCustomer++;
                  final tile = _mainBloc.listTaiXeTC.firstWhere((item) => item.dienThoaiTaiXeTrungChuyen == element.dienThoaiTaiXeTrungChuyen);
                  if (tile != null) tile.soKhach = _countExitsCustomer;
                }
              }
            });
            /// bắn notification

            //_bloc.add(CustomerTransferToTC('Thông báo','Bạn nhận được khách từ Limo, vui lòng xác nhận.',_mainBloc.listTaiXeTC,));
          }else if(state is TransferLimoSuccess){
            Utils.showDialogTransferCustomerLimo(context: context,listOfDetailTripsSuccessful: _mainBloc.listTaiXeTC);
          }
        },
        child: BlocBuilder<ListCustomerLimoBloc,ListCustomerLimoState>(
          bloc: _bloc,
          builder: (BuildContext context, ListCustomerLimoState state) {
            return buildPage(context,state);
          },
        ),
    )
    );
  }

  Stack buildPage(BuildContext context,ListCustomerLimoState state){
    return Stack(
      children: [
        !Utils.isEmpty(_mainBloc.listCustomerLimo) ?
        Column(
          children: <Widget>[
            Container(
              height: AppBar().preferredSize.height,
              color: orange,
              child: Padding(
                padding: const EdgeInsets.only(right: 14, left: 14),
                child: Row(
                  children: <Widget>[
                    Text(
                      _mainBloc.listCustomerLimo.length <= 0 ?
                      'Bạn có không Chuyến nào trong ngày hôm nay!!!' : 'Bạn có ${_mainBloc.listCustomerLimo.length} Chuyến trong ngày hôm nay',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: LiquidPullToRefresh(
                showChildOpacityTransition: false,
                onRefresh: () => Future.delayed(Duration.zero).then(
                        (_) {
                          if(Utils.isEmpty(dateTime)){
                            dateTime = DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
                          }
                          _bloc.add(GetListCustomerLimo(dateTime));
                        }),
                child: Scrollbar(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _mainBloc.listCustomerLimo.length,
                        itemBuilder: (BuildContext context, int index) {
                          return buildListItem(_mainBloc.listCustomerLimo[index],index);
                        })
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom + 16,
            )
          ],
        )
            : Container(
          child: Center(
            child: Text('Chưa có chuyến nào'),
          ),
        ),
        Visibility(
          visible: state is ListCustomerLimoLoading,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  Widget buildListItem(ListOfGroupLimoCustomerResponseBody item,int index) {
    return GestureDetector(
        onTap: () {
          DateFormat format = DateFormat("dd/MM/yyyy");
          Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailTripsLimoPage(dateTime: format.parse(item.ngayChay).toString(),idTrips: item.idTuyenDuong,idTime: item.idKhungGio)));
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
                  color: Colors.grey,
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
                      Text(
                          item.tenTuyenDuong??'',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),

                    ],
                  ),
                ),
                Divider(
                  height: 0.5,
                  color: Theme.of(this.context).disabledColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16, left: 16, top: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Thông tin chuyến',
                        style: Theme.of(this.context).textTheme.caption.copyWith(
                          color: Theme.of(this.context).disabledColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        //'dateStartingOrFinishing',
                        '${item.thoiGianDi??''}' + " / " + '${item.ngayChay??''}',
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
                Padding(
                  padding: const EdgeInsets.only(right: 16, left: 16, top: 0, bottom: 0),
                  child: Divider(
                    height: 0.5,
                    color: Theme.of(this.context).disabledColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8, left: 16, top: 10, bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Số khách',
                              style: Theme.of(this.context).textTheme.caption.copyWith(
                                color: Theme.of(this.context).disabledColor,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${item.soKhach??''}',
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
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:  Colors.purple,
                          borderRadius: BorderRadius.all(Radius.circular(16))
                        ),
                        child: Text('Xem thêm',style: TextStyle(color:Colors.white,fontSize: 10),),
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
