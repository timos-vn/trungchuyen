import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:trungchuyen/extension/customer_clip_path.dart';
import 'package:trungchuyen/extension/popup_picker.dart';
import 'package:trungchuyen/models/network/response/list_of_group_awaiting_customer_response.dart';
import 'package:trungchuyen/page/detail_trips/detail_trips_page.dart';
import 'package:trungchuyen/page/history_tc/list_history_tc_bloc.dart';
import 'package:trungchuyen/page/history_tc/list_history_tc_state.dart';
import 'package:trungchuyen/page/main/main_bloc.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/themes/images.dart';
import 'package:trungchuyen/utils/utils.dart';

import 'list_history_tc_event.dart';


class ListHistoryTCPage extends StatefulWidget {

  ListHistoryTCPage({Key key}) : super(key: key);

  @override
  ListHistoryTCPageState createState() => ListHistoryTCPageState();

}

class ListHistoryTCPageState extends State<ListHistoryTCPage> {
  DateFormat format = DateFormat("dd/MM/yyyy");
  ListHistoryTCBloc _bloc;
  MainBloc _mainBloc;

  DateTime dateTime = DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = ListHistoryTCBloc(context);
    _bloc.getMainBloc(context);
    _mainBloc = BlocProvider.of<MainBloc>(context);
    DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
    _bloc.add(GetListHistoryTC(parseDate.toString()));
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
          actions: [
            InkWell(
              onTap: ()async {
                final DateTime result = await showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return DateRangePicker(
                        dateTime ?? DateTime.now(),
                        null,
                        minDate: DateTime.now().add(Duration(days: -365)),
                        maxDate: DateTime.now().add(const Duration(days: 10000)),
                        displayDate: dateTime ?? DateTime.now(),
                      );
                    });
                if (result != null) {
                  print(result);
                  dateTime = DateFormat("yyyy-MM-dd").parse(result.toString());
                  _bloc.add(GetListHistoryTC(dateTime.toString()));
                }
              },
              child: Icon(
                Icons.event,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 20,),
            InkWell(
                onTap: (){
                  if(Utils.isEmpty(dateTime)){
                    dateTime = DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
                  }
                  _bloc.add(GetListHistoryTC(dateTime.toString()));
                },
                child: Icon(MdiIcons.reload,color: Colors.black,)),
            SizedBox(width: 20,)
          ],
          backgroundColor: Colors.white,
        ),
        body:BlocListener<ListHistoryTCBloc,ListHistoryTCState>(
          bloc: _bloc,
          listener:  (context, state){

          },
          child: BlocBuilder<ListHistoryTCBloc,ListHistoryTCState>(
            bloc: _bloc,
            builder: (BuildContext context, ListHistoryTCState state) {
              return buildPage(context,state);
            },
          ),
        )
    );
  }

  Stack buildPage(BuildContext context,ListHistoryTCState state){
    return Stack(
      children: [
        !Utils.isEmpty(_bloc.listCustomerTC) ?
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Table(
                border: TableBorder.all(color: Colors.grey),
                columnWidths: {
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(),
                  2: FlexColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 30,right: 30),
                        height: 35,
                        child: Center(child: Text('Tổng số chuyến',style: TextStyle(fontStyle: FontStyle.normal),)),
                      ),
                      Container(
                        height: 35,
                        child: Center(child: Text(_bloc.listCustomerTC.length?.toString()??'0')),
                      ),
                    ],
                  ),TableRow(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 30,right: 30),
                        height: 35,
                        child: Center(child: Text('Khách thành công',style: TextStyle(fontStyle: FontStyle.normal,color: Colors.purple),)),
                      ),
                      Container(
                        height: 35,
                        child: Center(child: Text('${_bloc.tongKhachThanhCong?.toString()??'0'}',style: TextStyle(color: Colors.purple),)),
                      ),
                    ],
                  ),TableRow(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 30,right: 30),
                        height: 35,
                        child: Center(child: Text('Khách Huỷ',style: TextStyle(fontStyle: FontStyle.normal,color: Colors.red),)),
                      ),
                      Container(
                        height: 35,
                        child: Center(child: Text('${_bloc.tongKhachHuy?.toString()??'0'}',style: TextStyle(color: Colors.red),)),
                      ),
                    ],
                  ),

                  TableRow(
                    children: [
                      Container(
                        height: 35,
                        child: Center(child: Text('Ngày chạy',style: TextStyle(fontStyle: FontStyle.normal),)),
                      ),
                      Container(
                        height: 35,
                        child: Center(child: Text(Jiffy(dateTime, "yyyy-MM-dd").format("dd-MM-yyyy")?.toString()??'')),
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
                      itemCount: _bloc.listCustomerTC.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildListItem(_bloc.listCustomerTC[index],index);
                      })
              ),
            ),
          ],
        ) : Container(),
        Visibility(
          visible: state is ListHistoryTCLoading,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  Widget buildListItem(ListOfGroupAwaitingCustomerBody item,int index) {
    return GestureDetector(
        onTap: () {

          DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(Jiffy(item.ngayChay, "dd/MM/yyyy").format("yyyy-MM-dd"));
          Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailTripsPage(dateTime: parseDate,typeDetail: 2,idRoom: item.idVanPhong,idTime: item.idKhungGio,typeCustomer: item.loaiKhach,)));///item.idTuyenDuong.toString()
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 16, top: 8, bottom: 8),
          child: Stack(
            children: [
              ClipPath(
                clipper: CustomClipPath(),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: (item.idKhungGio == _mainBloc.idKhungGio && item.loaiKhach == _mainBloc.loaiKhach && _mainBloc.blocked == true && item.idVanPhong == _mainBloc.idVanPhong) ?  Colors.black.withOpacity(0.5) : Theme.of(this.context).scaffoldBackgroundColor,
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.tenVanPhong?? '',maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Số khách:  ',
                                      style: Theme.of(this.context).textTheme.subtitle.copyWith(
                                        color: Colors.red,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Text(
                                      '${item.soKhach??''}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(this.context).textTheme.subtitle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Container(
                              height: 45,
                              width: 45,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color:   (item.idKhungGio == _mainBloc.idKhungGio && item.loaiKhach == _mainBloc.loaiKhach && _mainBloc.blocked == true&& item.idVanPhong == _mainBloc.idVanPhong) ? (item.loaiKhach == 1 ? Colors.orange.withOpacity(0.5) : Colors.blue.withOpacity(0.5)) : (item.loaiKhach == 1 ? Colors.orange : Colors.blue),
                                  borderRadius: BorderRadius.all(Radius.circular(32))),
                              child: Center(
                                child: Text(
                                  '${item.loaiKhach == 1 ? 'Đón' : 'Trả'}',
                                  style: Theme.of(this.context).textTheme.caption.copyWith(
                                    color: (item.idKhungGio == _mainBloc.idKhungGio && item.loaiKhach == _mainBloc.loaiKhach && _mainBloc.blocked == true&& item.idVanPhong == _mainBloc.idVanPhong)? Colors.white.withOpacity(0.5) :Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                    ],
                  ),
                ),
              ),
              Visibility(
                visible:  (item.idKhungGio == _mainBloc.idKhungGio && item.loaiKhach == _mainBloc.loaiKhach && _mainBloc.blocked == true&& item.idVanPhong == _mainBloc.idVanPhong),
                child: Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(
                    child: Text('Đang đón',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
