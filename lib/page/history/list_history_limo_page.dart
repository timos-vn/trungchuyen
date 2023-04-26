import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:trungchuyen/models/network/response/list_of_group_limo_customer_response.dart';
import 'package:trungchuyen/page/detail_trips_limo/detail_trips_limo_page.dart';
import 'package:trungchuyen/themes/images.dart';
import 'package:trungchuyen/utils/utils.dart';

import '../../utils/const.dart';
import 'list_history_limo_bloc.dart';
import 'list_history_limo_event.dart';
import 'list_history_limo_state.dart';

class ListHistoryLimoPage extends StatefulWidget {

  ListHistoryLimoPage({Key? key}) : super(key: key);

  @override
  ListHistoryLimoPageState createState() => ListHistoryLimoPageState();

}

class ListHistoryLimoPageState extends State<ListHistoryLimoPage> {

  late ListHistoryLimoBloc _bloc;
  DateTime dateTime = DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
  DateFormat format = DateFormat("dd/MM/yyyy");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateTime = DateTime.now();
    _bloc = ListHistoryLimoBloc(context);
    _bloc.add(GetPrefs());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
          onTap: ()=> Navigator.pop(context),
          child: Container(
            width: 40,
            height: double.infinity,
            child: Icon(Icons.arrow_back,color: Colors.black,),
          ),
        ),
        title: Text(
          'Lịch Sử',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: [
          SizedBox(
            // height: 40,
            width: 50,
            child: DateTimePicker(
              type: DateTimePickerType.date,
              // dateMask: 'd MMM, yyyy',
              initialValue: DateTime.now().toString(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              decoration:const InputDecoration(
                suffixIcon: Icon(Icons.event,color: Colors.orange,size: 22,),
                contentPadding: EdgeInsets.only(left: 12),
                border: InputBorder.none,
              ),
              style:const TextStyle(fontSize: 13),
              locale: const Locale("vi", "VN"),
              // icon: Icon(Icons.event),
              selectableDayPredicate: (date) {
                return true;
              },
              onChanged: (result){
                DateTime? dateOrder = result as DateTime?;
                dateTime = Utils.parseStringToDate(dateOrder.toString(), Const.DATE_SV_FORMAT_2);
                _bloc.add(GetListHistoryLimo(dateTime.toString()));
              },
              validator: (result) {

                return null;
              },
              onSaved: (val){
                print('asd$val');
              },
            ),
          ),
          // InkWell(
          //   onTap: ()async {
          //     final DateTime result = await showDialog<dynamic>(
          //         context: context,
          //         builder: (BuildContext context) {
          //           return DateRangePicker(
          //             dateTime ?? DateTime.now(),
          //             null,
          //             minDate: DateTime.now().add(Duration(days: -365)),
          //             maxDate: DateTime.now().add(const Duration(days: 10000)),
          //             displayDate: dateTime ?? DateTime.now(),
          //           );
          //         });
          //     if (result != null) {
          //       print(result);
          //       dateTime = DateFormat("yyyy-MM-dd").parse(result.toString());
          //
          //     }
          //   },
          //   child: Icon(
          //     Icons.event,
          //     color: Colors.black,
          //   ),
          // ),
          SizedBox(width: 20,),
          InkWell(
              onTap: (){
                if(Utils.isEmpty(dateTime)){
                  dateTime = DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
                }
                _bloc.add(GetListHistoryLimo(dateTime.toString()));
              },
              child: Icon(MdiIcons.reload,color: Colors.black,)),
          SizedBox(width: 20,)
        ],
      ),
      body:BlocListener<ListHistoryLimoBloc,ListHistoryLimoState>(
        bloc: _bloc,
        /// khach Trung Chuyen
        // 1. Khách trung chuyển
        // 0: Không cần TC
        listener:  (context, state){
          if(state is GetPrefsSuccess){
            _bloc.add(GetListHistoryLimo(DateFormat("yyyy-MM-dd").parse(DateTime.now().toString()).toString()));
          }
        },
        child: BlocBuilder<ListHistoryLimoBloc,ListHistoryLimoState>(
          bloc: _bloc,
          builder: (BuildContext context, ListHistoryLimoState state) {
            return buildPage(context,state);
          },
        ),
    )
    );
  }

  Stack buildPage(BuildContext context,ListHistoryLimoState state){
    return Stack(
      children: [
        _bloc.listCustomerLimo.isEmpty ? Container() : Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Table(
                border: TableBorder.all(color: Colors.grey),
                columnWidths: {
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 30,right: 30),
                        height: 35,
                        child: Center(child: Text('Tổng số chuyến',style: TextStyle(fontStyle: FontStyle.italic),)),
                      ),
                      Container(
                        height: 35,
                        child: Center(child: Text(_bloc.listCustomerLimo.length.toString())),
                      ),
                    ],
                  ),TableRow(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 30,right: 30),
                        height: 35,
                        child: Center(child: Text('Tổng số khách',style: TextStyle(fontStyle: FontStyle.italic),)),
                      ),
                      Container(
                        height: 35,
                        child: Center(child: Text('${_bloc.tongSoKhach.toString()}' + " Khách")),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Container(
                        height: 35,
                        child: Center(child: Text('Ngày chạy',style: TextStyle(fontStyle: FontStyle.italic),)),
                      ),
                      Container(
                        height: 35,
                        child: Center(child: Text(Jiffy(dateTime, "yyyy-MM-dd").format("dd-MM-yyyy").toString())),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(child: Divider()),
                Text('Danh sách chuyến',style: TextStyle(color:Colors.grey,),),
                Expanded(child: Divider()),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Scrollbar(
                  child: ListView.builder(
                      padding: EdgeInsets.only(bottom:  MediaQuery.of(context).padding.bottom + 16),
                      shrinkWrap: true,
                      itemCount: _bloc.listCustomerLimo.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildListItem(_bloc.listCustomerLimo[index],index);
                      })
              ),
            ),
          ],
        ),
        Visibility(
          visible: state is ListHistoryLimoLoading,
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
          Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailTripsLimoPage(typeHistory: 2,dateTime: format.parse(item.ngayChay.toString()).toString(),idTrips: item.idTuyenDuong,idTime: item.idKhungGio,tenTuyenDuong: item.tenTuyenDuong,thoiGianDi:(item.ngayChay.toString() +' - ' + item.thoiGianDi.toString()))));
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
                          color: Theme.of(this.context).disabledColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${item.thoiGianDi??''}' + " / " + '${item.ngayChay??''}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
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
                              style: TextStyle(
                                color: Theme.of(this.context).disabledColor,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  '${item.khachCanXuLy??''} khách / ',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  'Xe ${item.tongSoGhe?.toString() ?? ''} chỗ',
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
