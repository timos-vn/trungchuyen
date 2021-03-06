import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:trungchuyen/page/options_input/options_input_pages.dart';
import 'package:trungchuyen/page/report_limo/report_limo_bloc.dart';
import 'package:trungchuyen/page/report_limo/report_limo_event.dart';
import 'package:trungchuyen/page/report_limo/report_limo_state.dart';
import 'package:trungchuyen/themes/images.dart';
import 'package:trungchuyen/utils/utils.dart';

class ReportLimoPage extends StatefulWidget {
  @override
  _ReportLimoPageState createState() => _ReportLimoPageState();
}

class _ReportLimoPageState extends State<ReportLimoPage> {

  ReportLimoBloc _bloc;
  void onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: ${DateFormat("yyyy-MM-dd").parse(day.toString())}');
    _bloc.add(GetReportLimoEvent(DateFormat("yyyy-MM-dd").parse(day.toString()).toString(),DateFormat("yyyy-MM-dd").parse(day.toString()).toString()));
  }
  CalendarController calendarController;
  int countTotalCustomer = 0;
  String toDate,fromDate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = ReportLimoBloc(context);
    calendarController = CalendarController();
    _bloc.add(GetReportLimoEvent(DateFormat("yyyy-MM-dd").parse(DateTime.now().toString()).toString(),DateFormat("yyyy-MM-dd").parse(DateTime.now().toString()).toString()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportLimoBloc,ReportLimoState>(
        bloc: _bloc,
        listener: (context,state){
          if(state is GetReportLimoEventSuccess){
            countTotalCustomer = _bloc.tongKhach;
          }
        },
        child: BlocBuilder<ReportLimoBloc,ReportLimoState>(
          bloc: _bloc,
          builder: (BuildContext context, ReportLimoState state){
            return buildPage(context,state);
          },
        ),
    );
  }

  Widget buildPage(BuildContext context,ReportLimoState state){
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: [
            GestureDetector(
                onTap: ()=> showDialog(
                    context: context,
                    builder: (context) => OptionsInputPage()).then(
                        (value){
                      if(!Utils.isEmpty(value)){
                        if(!Utils.isEmpty(value[0]?.toString()) || !Utils.isEmpty(value[1]?.toString())){
                          fromDate = value[0]?.toString();
                          toDate = value[1]?.toString();
                          _bloc.add(GetReportLimoEvent(fromDate,toDate));
                        }else{
                          print('Cancel');
                        }
                      }
                    }),
                child: Icon(Icons.filter_alt_outlined,color: Colors.black,)),
            SizedBox(width: 16,),
          ],
          title: Text(
            'B??o c??o & Th???ng k??',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 2.0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Stack(
          children: [
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.0),
                    child: TableCalendar(
                      locale: 'vi_VN',
                      initialCalendarFormat: CalendarFormat.week,
                      calendarStyle: CalendarStyle(
                        todayColor: Theme.of(context).primaryColor,
                        selectedColor: Theme.of(context).primaryColor,
                        todayStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.white),
                        weekendStyle:
                        TextStyle(color: Colors.black.withOpacity(0.3)),
                        outsideDaysVisible: false,
                      ),
                      headerStyle: HeaderStyle(
                          centerHeaderTitle: true,
                          formatButtonDecoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          formatButtonTextStyle:
                          TextStyle(color: Colors.white),
                          formatButtonShowsNext: false),
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          weekendStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      onDaySelected: onDaySelected,
                      builders: CalendarBuilders(
                          selectedDayBuilder: (context, date, events) =>
                              Container(
                                  margin: EdgeInsets.all(4),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.pink,
                                      shape: BoxShape.circle),
                                  child: Text(
                                    date.day.toString(),
                                    style: TextStyle(color: Colors.white),
                                  )),
                          todayDayBuilder: (context, date, enevts) =>
                              Container(
                                  margin: EdgeInsets.all(4),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle),
                                  child: Text(
                                    date.day.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ))),
                      calendarController: calendarController,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20,right: 20,top: 2,bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.orange,
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            height: 70,
                            width: MediaQuery.of(context).size.width*0.4,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.directions_car_outlined,size: 30.0,color: Colors.black,),
                                SizedBox(width: 10,),
                                Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text("T???ng kh??ch",style: TextStyle(color: Colors.black,fontSize: 13),),
                                        SizedBox(height: 5,),
                                        Text(countTotalCustomer.toString(),style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                                      ],
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                        Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.orange,
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            height: 70,
                            width: MediaQuery.of(context).size.width*0.4,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.monetization_on_sharp,size: 30.0,color: Colors.black,),
                                SizedBox(width: 10,),
                                Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text("Earned",style: TextStyle(color: Colors.black,fontSize: 13),),
                                        SizedBox(height: 5,),
                                        Text("0.0",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                                      ],
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(child: Divider()),
                      Text('Danh s??ch chuy???n'),
                      Expanded(child: Divider()),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      !Utils.isEmpty(fromDate) ?
                      Text('T??? ng??y: ${fromDate?.toString()} - ?????n ng??y: ${toDate?.toString()}',style: TextStyle(color: Colors.grey,fontSize: 10),) : Container(),
                      Expanded(child: Container()),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Expanded(
                    child: Utils.isEmpty(_bloc.listReport) ? Center(child: Text('D??? li???u tr???ng'),) : Scrollbar(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _bloc.listReport.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                                onTap: () {
                                  print('$index');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10,right: 16,top: 8,bottom: 8),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey,
                                            width: 1.0
                                        )
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
                                                  Text(
                                                    '${ _bloc.listReport[index].tenTuyenDuong?.toString()??''}',
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(2),
                                                    child: Center(
                                                      child: Text(
                                                        '${_bloc.listReport[index].ngayChay?.toString()??''}  -  ${_bloc.listReport[index].gioBatDau?.toString()??''}',
                                                        style: TextStyle(color: Colors.blue,fontSize: 12,fontStyle: FontStyle.italic),
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(15),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Expanded(
                                                child: SizedBox(),
                                              ),
                                              Visibility(
                                                visible: _bloc.listReport[index].khachTrungChuyen == 1,
                                                child: Container(
                                                  height: 45,
                                                  width: 45,
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                      color:_bloc.listReport[index].loaiKhach == 1 ? Colors.orange  : Colors.blue,
                                                      borderRadius: BorderRadius.all(Radius.circular(32))
                                                  ),
                                                  child: Center(
                                                    child: Text(_bloc.listReport[index].loaiKhach == 1 ? '????n' : 'Tr???',
                                                      style:TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.normal,
                                                        fontSize: 12
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          height: 0.5,
                                          color: Colors.grey,
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.only(right: 16, left: 16, top: 10, bottom: 10),
                                        //   child: Column(
                                        //     crossAxisAlignment: CrossAxisAlignment.start,
                                        //     children: <Widget>[
                                        //       Text(
                                        //         'Th??ng tin kh??ch h??ng',
                                        //         style: Theme.of(Get.context).textTheme.caption.copyWith(
                                        //           color: Theme.of(Get.context).disabledColor,
                                        //           fontWeight: FontWeight.normal,
                                        //         ),
                                        //       ),
                                        //       SizedBox(height: 5,),
                                        //       Text(
                                        //         'Kh??ch ${index.toString()}' + ' - ' + '0962983437',
                                        //         maxLines: 2,
                                        //         overflow: TextOverflow.ellipsis,
                                        //         style: Theme.of(Get.context).textTheme.subtitle.copyWith(
                                        //           fontWeight: FontWeight.normal,
                                        //           color: Theme.of(Get.context).textTheme.title.color,
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        // Padding(
                                        //   padding: const EdgeInsets.only(right: 16, left: 16, top: 0, bottom: 0),
                                        //   child: Divider(
                                        //     height: 0.5,
                                        //     color: Theme.of(Get.context).disabledColor,
                                        //   ),
                                        // ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 16, left: 16, top: 10, bottom: 10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'T???ng s??? kh??ch',
                                                style:TextStyle(
                                                  color:Colors.grey,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                              Text(
                                                '${_bloc.listReport[index].soKhach?.toString()??''} Kh??ch',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.red,fontStyle: FontStyle.italic
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                )
                            );
                          }
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: state is ReportLimoLoading,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        )
    );
  }
}
