import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:trungchuyen/page/options_input/options_input_pages.dart';
import 'package:trungchuyen/page/report_limo/report_limo_bloc.dart';
import 'package:trungchuyen/page/report_limo/report_limo_event.dart';
import 'package:trungchuyen/page/report_limo/report_limo_state.dart';
import 'package:trungchuyen/themes/images.dart';
import 'package:trungchuyen/utils/utils.dart';

import '../../widget/m.dart';

class ReportLimoPage extends StatefulWidget {
  @override
  _ReportLimoPageState createState() => _ReportLimoPageState();
}

class _ReportLimoPageState extends State<ReportLimoPage> {

  late ReportLimoBloc _bloc;
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    print('CALLBACK: ${DateFormat("yyyy-MM-dd").parse(selectedDay.toString())}');
    _bloc.add(GetReportLimoEvent(DateFormat("yyyy-MM-dd").parse(selectedDay.toString()).toString(),DateFormat("yyyy-MM-dd").parse(selectedDay.toString()).toString()));
  }
  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  int countTotalCustomer = 0;
  String? toDate,fromDate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDay = _focusedDay;
    _bloc = ReportLimoBloc(context);
    _bloc.add(GetPrefs());

  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportLimoBloc,ReportLimoState>(
        bloc: _bloc,
        listener: (context,state){
          if(state is GetPrefsSuccess){
            _bloc.add(GetReportLimoEvent(DateFormat("yyyy-MM-dd").parse(DateTime.now().toString()).toString(),DateFormat("yyyy-MM-dd").parse(DateTime.now().toString()).toString()));
          }
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
                        if(!Utils.isEmpty(value[0].toString()) || !Utils.isEmpty(value[1].toString())){
                          fromDate = value[0]?.toString();
                          toDate = value[1]?.toString();
                          _bloc.add(GetReportLimoEvent(fromDate.toString(),toDate.toString()));
                        }else{
                          print('Cancel');
                        }
                      }
                    }),
                child: Icon(Icons.filter_alt_outlined,color: Colors.black,)),
            SizedBox(width: 16,),
          ],
          title: Text(
            'Báo cáo & Thống kê',
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
                  TableCalendar(
                    rowHeight: 70,
                    daysOfWeekHeight: 20,
                    calendarBuilders: CalendarBuilders(
                      // todayBuilder: (context, date, _){
                      //   return Padding(
                      //     padding: const EdgeInsets.only(bottom: 11),
                      //     child: Container(
                      //       decoration: new BoxDecoration(
                      //         color: mainColor.withOpacity(0.8),
                      //         shape: BoxShape.circle,
                      //       ),
                      //       // margin: const EdgeInsets.all(4.0),
                      //       width: 45,
                      //       height: 45,
                      //       child: Center(
                      //         child: Text(
                      //           '${date.day}',
                      //           style: TextStyle(
                      //             fontSize: 16.0,
                      //             color: Colors.white,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   );
                      // },
                        selectedBuilder: (context, date, _) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 11),
                            child: Container(
                              decoration:  BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                shape: BoxShape.circle,
                                // borderRadius: BorderRadius.circular(150)
                              ),
                              // margin: const EdgeInsets.all(4.0),
                              width: 45,
                              height: 45,
                              child: Center(
                                child: Text(
                                  '${date.day}',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        markerBuilder: (context,date, event){
                          return Container(
                            // margin: const EdgeInsets.only(top: 10,bottom: 0),
                            // padding: const EdgeInsets.all(1),
                            //height: 12,
                            //child: Icon(MdiIcons.emoticonPoop,color: Colors.blueGrey.withOpacity(0.5),),
                          );
                        }
                    ),
                    firstDay: kFirstDay,
                    lastDay: kLastDay,
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    // rangeStartDay: _rangeStart,
                    // rangeEndDay: _rangeEnd,
                    formatAnimationCurve: Curves.elasticInOut,
                    formatAnimationDuration: const Duration(milliseconds: 500),
                    calendarFormat: _calendarFormat,
                    rangeSelectionMode: _rangeSelectionMode,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    onHeaderTapped: (_){
                      //print(_);
                    },
                    locale: 'vi',
                    daysOfWeekStyle: DaysOfWeekStyle(
                        weekendStyle: TextStyle(
                          color: Colors.red,
                        ),
                        weekdayStyle: TextStyle(
                          color: Colors.black,
                        )
                    ),
                    headerVisible: false,
                    // headerStyle: HeaderStyle(
                    //   leftChevronIcon: Icon(Icons.arrow_back_ios, size: 15, color: Colors.black),
                    //   rightChevronIcon: Icon(Icons.arrow_forward_ios, size: 15, color: Colors.black),
                    //   titleTextStyle: GoogleFonts.montserrat(
                    //       color: Colors.yellow,
                    //       fontSize: 16),
                    //   titleCentered: true,
                    //   formatButtonDecoration: BoxDecoration(
                    //     color: Colors.white60,
                    //     borderRadius: BorderRadius.circular(20),
                    //   ),
                    //   formatButtonVisible: false,
                    //   formatButtonTextStyle: GoogleFonts.montserrat(
                    //       color: Colors.black,
                    //       fontSize: 13,
                    //       fontWeight: FontWeight.bold),
                    // ),
                    calendarStyle: CalendarStyle(
                      // selectedTextStyle: TextStyle(
                      //   backgroundColor: Colors.white,
                      //   color: mainColor
                      // ),
                        todayTextStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16),
                        weekendTextStyle: TextStyle(
                            color: Colors.red,
                            fontSize: 16),
                        outsideTextStyle: const TextStyle(color: Colors.blueGrey),
                        withinRangeTextStyle: const TextStyle(color: Colors.grey),
                        defaultTextStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16),
                        canMarkersOverflow: true,
                        outsideDaysVisible: false,
                        holidayTextStyle: const TextStyle(
                            color: Colors.yellow
                        )
                    ),
                    onDaySelected: _onDaySelected,
                    // onRangeSelected: _onRangeSelected,
                    onFormatChanged: (format) {

                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                    },
                  ),
                  // Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 16.0),
                  //   child: TableCalendar(
                  //     locale: 'vi_VN',
                  //     initialCalendarFormat: CalendarFormat.week,
                  //     calendarStyle: CalendarStyle(
                  //       todayColor: Theme.of(context).primaryColor,
                  //       selectedColor: Theme.of(context).primaryColor,
                  //       todayStyle: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 18.0,
                  //           color: Colors.white),
                  //       weekendStyle:
                  //       TextStyle(color: Colors.black.withOpacity(0.3)),
                  //       outsideDaysVisible: false,
                  //     ),
                  //     headerStyle: HeaderStyle(
                  //         centerHeaderTitle: true,
                  //         formatButtonDecoration: BoxDecoration(
                  //           color: Colors.teal,
                  //           borderRadius: BorderRadius.circular(20.0),
                  //         ),
                  //         formatButtonTextStyle:
                  //         TextStyle(color: Colors.white),
                  //         formatButtonShowsNext: false),
                  //     startingDayOfWeek: StartingDayOfWeek.monday,
                  //     daysOfWeekStyle: DaysOfWeekStyle(
                  //         weekdayStyle: TextStyle(
                  //             color: Colors.black,
                  //             fontWeight: FontWeight.bold),
                  //         weekendStyle: TextStyle(
                  //             color: Colors.black,
                  //             fontWeight: FontWeight.bold)),
                  //     onDaySelected: onDaySelected,
                  //     builders: CalendarBuilders(
                  //         selectedDayBuilder: (context, date, events) =>
                  //             Container(
                  //                 margin: EdgeInsets.all(4),
                  //                 alignment: Alignment.center,
                  //                 decoration: BoxDecoration(
                  //                     color: Colors.pink,
                  //                     shape: BoxShape.circle),
                  //                 child: Text(
                  //                   date.day.toString(),
                  //                   style: TextStyle(color: Colors.white),
                  //                 )),
                  //         todayDayBuilder: (context, date, enevts) =>
                  //             Container(
                  //                 margin: EdgeInsets.all(4),
                  //                 alignment: Alignment.center,
                  //                 decoration: BoxDecoration(
                  //                     color: Colors.grey,
                  //                     shape: BoxShape.circle),
                  //                 child: Text(
                  //                   date.day.toString(),
                  //                   style: TextStyle(color: Colors.white),
                  //                 ))),
                  //     calendarController: calendarController,
                  //   ),
                  // ),
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
                                        Text("Tổng khách",style: TextStyle(color: Colors.black,fontSize: 13),),
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
                      Text('Danh sách chuyến'),
                      Expanded(child: Divider()),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      !Utils.isEmpty(fromDate.toString()) ?
                      Text('Từ ngày: ${fromDate?.toString()} - Đến ngày: ${toDate?.toString()}',style: TextStyle(color: Colors.grey,fontSize: 10),) : Container(),
                      Expanded(child: Container()),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Expanded(
                    child: Utils.isEmpty(_bloc.listReport) ? Center(child: Text('Dữ liệu trống'),) : Scrollbar(
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
                                                    child: Text(_bloc.listReport[index].loaiKhach == 1 ? 'Đón' : 'Trả',
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
                                        //         'Thông tin khách hàng',
                                        //         style: Theme.of(Get.context).textTheme.caption.copyWith(
                                        //           color: Theme.of(Get.context).disabledColor,
                                        //           fontWeight: FontWeight.normal,
                                        //         ),
                                        //       ),
                                        //       SizedBox(height: 5,),
                                        //       Text(
                                        //         'Khách ${index.toString()}' + ' - ' + '0962983437',
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
                                                'Tổng số khách',
                                                style:TextStyle(
                                                  color:Colors.grey,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                              Text(
                                                '${_bloc.listReport[index].soKhach?.toString()??''} Khách',
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
