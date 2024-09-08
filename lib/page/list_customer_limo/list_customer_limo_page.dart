// import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:trungchuyen/models/network/response/list_of_group_limo_customer_response.dart';
import 'package:trungchuyen/page/detail_trips_limo/detail_trips_limo_page.dart';
import 'package:trungchuyen/page/list_customer_limo/list_customer_limo_bloc.dart';
import 'package:trungchuyen/page/list_customer_limo/list_customer_limo_state.dart';
import 'package:trungchuyen/page/main/main_bloc.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/themes/images.dart';
import 'package:intl/intl.dart';
import 'package:trungchuyen/utils/utils.dart';

import '../../utils/const.dart';
import 'list_customer_limo_event.dart';

class ListCustomerLimoPage extends StatefulWidget {

  ListCustomerLimoPage({Key? key}) : super(key: key);

  @override
  ListCustomerLimoPageState createState() => ListCustomerLimoPageState();

}

class ListCustomerLimoPageState extends State<ListCustomerLimoPage> {

  late ListCustomerLimoBloc _bloc;
  late MainBloc _mainBloc;
  DateTime dateTime = DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
  DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
  DateFormat format = DateFormat("dd/MM/yyyy");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateTime = DateTime.now();
    _bloc = ListCustomerLimoBloc(context);
    _mainBloc = BlocProvider.of<MainBloc>(context);

    _bloc.add(GetPrefs());

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
          // SizedBox(
          //   // height: 40,
          //   width: 50,
          //   child: DateTimePicker(
          //     type: DateTimePickerType.date,
          //     // dateMask: 'd MMM, yyyy',
          //     initialValue: DateTime.now().toString(),
          //     firstDate: DateTime(2000),
          //     lastDate: DateTime(2100),
          //     decoration:const InputDecoration(
          //       suffixIcon: Icon(Icons.event,color: Colors.orange,size: 22,),
          //       contentPadding: EdgeInsets.only(left: 12),
          //       border: InputBorder.none,
          //     ),
          //     style:const TextStyle(fontSize: 13),
          //     locale: const Locale("vi", "VN"),
          //     // icon: Icon(Icons.event),
          //     selectableDayPredicate: (date) {
          //       return true;
          //     },
          //     onChanged: (result){
          //       DateTime? dateOrder = result as DateTime?;
          //       dateTime = Utils.parseStringToDate(dateOrder.toString(), Const.DATE_SV_FORMAT_2);
          //       _bloc.add(GetListCustomerLimo(dateTime));
          //     },
          //     validator: (result) {
          //
          //       return null;
          //     },
          //     onSaved: (val){
          //       print('asd$val');
          //     },
          //   ),
          // ),

          SizedBox(width: 20,),
          InkWell(
              onTap: (){
                print('role check:${_mainBloc.role}');
                if(Utils.isEmpty(dateTime)){
                  dateTime = DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
                }
                _bloc.add(GetListCustomerLimo(dateTime));
              },
              child: Icon(MdiIcons.reload,color: Colors.black,)),
          SizedBox(width: 20,)
        ],
      ),
      body:BlocListener<ListCustomerLimoBloc,ListCustomerLimoState>(
        bloc: _bloc,
        /// khach Trung Chuyen
        // 1. Khách trung chuyển
        // 0: Không cần TC
        listener:  (context, state){
          if(state is GetPrefsSuccess){
            _bloc.add(GetListCustomerLimo(parseDate));
          }
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
 tile.soKhach = _countExitsCustomer;
                }
              }
            });
            /// bắn notification

            //_bloc.add(CustomerTransferToTC('Thông báo','Bạn nhận được khách từ Limo, vui lòng xác nhận.',_mainBloc.listTaiXeTC,));
          }else if(state is TransferLimoSuccess){
            Utils.showDialogTransferCustomerLimo(context: context,listOfDetailTripsSuccessful: _mainBloc.listTaiXeTC, content: '');
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
                    Expanded(
                      child: Text(
                        _mainBloc.listCustomerLimo.length <= 0 ?
                        'Bạn có không Chuyến nào trong ngày ${DateFormat('dd-MM-yyyy').format(DateTime.parse(dateTime.toString()))}!!!' : 'Bạn có ${_mainBloc.listCustomerLimo.length} Chuyến trong ngày ${DateFormat('dd-MM-yyyy').format(DateTime.parse(dateTime.toString()))}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: RefreshIndicator(
                color: Colors.orange,
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
            child: Text('Ngày ${DateFormat('dd-MM-yyyy').format(DateTime.parse(dateTime.toString()))} \n \nChưa có chuyến nào',textAlign: TextAlign.center,),
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
          _mainBloc.dateTimeDetailLimoTrips = format.parse(item.ngayChay.toString()).toString();
          _mainBloc.idLimoTrips = item.idTuyenDuong!;
          _mainBloc.idLimoTime = item.idKhungGio!;
          Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailTripsLimoPage(typeHistory: 1,dateTime: format.parse(item.ngayChay.toString()).toString(),idTrips: item.idTuyenDuong,idTime: item.idKhungGio,tenTuyenDuong: item.tenTuyenDuong,thoiGianDi:(item.ngayChay.toString() +' - ' + item.thoiGianDi.toString())))).then((value){
            print('checking');
            _mainBloc.dateTimeDetailLimoTrips = '';
            _mainBloc.idLimoTrips = 0;
            _mainBloc.idLimoTime = 0;
            _bloc.add(GetListCustomerLimo(dateTime));
          });
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
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${item.thoiGianDi??''}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),Text(
                            '${item.ngayChay??''}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ],
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
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  '${item.khachCanXuLy??''} khách cần xử lý / ',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  '${item.tongSoGhe?.toString() ?? ''} ghế',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ),
                              ],
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
