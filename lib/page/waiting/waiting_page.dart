// import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:trungchuyen/extension/customer_clip_path.dart';
import 'package:trungchuyen/models/database/dbhelper.dart';
import 'package:trungchuyen/models/network/response/list_of_group_awaiting_customer_response.dart';
import 'package:trungchuyen/page/detail_trips/detail_trips_page.dart';
import 'package:trungchuyen/page/main/main_bloc.dart';
import 'package:trungchuyen/page/waiting/waiting_bloc.dart';
import 'package:trungchuyen/page/waiting/waiting_event.dart';
import 'package:trungchuyen/page/waiting/waiting_sate.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/themes/images.dart';
import 'package:intl/intl.dart';
import 'package:trungchuyen/utils/utils.dart';

import '../../utils/const.dart';

class WaitingPage extends StatefulWidget {

  WaitingPage({Key? key}) : super(key: key);

  @override
  WaitingPageState createState() => WaitingPageState();

}

class WaitingPageState extends State<WaitingPage> {
  DateFormat format = DateFormat("dd/MM/yyyy");
  late WaitingBloc _bloc;
  late MainBloc _mainBloc;
  DatabaseHelper db = DatabaseHelper();
  DateTime dateTime = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
  bool viewDetail = false;
  String? tenChuyen;
  String? thoiGian;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainBloc = BlocProvider.of<MainBloc>(context);
    _bloc = WaitingBloc(context);
    _bloc.add(GetPrefs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark_text.withOpacity(0.7),
      appBar: AppBar(
        title: Text(
          'Lịch Khách Chờ',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          // Container(
          //   padding: EdgeInsets.only(top: 5),
          //   // height: 40,
          //   width: 50,
          //   child: DateTimePicker(
          //     type: DateTimePickerType.date,
          //     // dateMask: 'd MMM, yyyy',
          //     initialValue: DateTime.now().toString(),
          //     firstDate: DateTime(2000),
          //     lastDate: DateTime(2100),
          //     decoration:const InputDecoration(
          //       suffixIcon: Icon(Icons.event,color: Colors.orange),
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
          //       _bloc.add(GetListGroupAwaitingCustomer(dateTime));
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

          InkWell(
            onTap: ()async {
              Utils.dateTimePickerCustom(context).then((value){
                if(value != null){
                  dateTime = value;
                  _bloc.add(GetListGroupAwaitingCustomer(dateTime));
                }
              });
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
                _bloc.add(GetListGroupAwaitingCustomer(dateTime));
              },
              child: Icon(MdiIcons.reload,color: Colors.black,)),
          SizedBox(width: 20,)
        ],
        backgroundColor: Colors.white,
      ),
      body:BlocListener<WaitingBloc,WaitingState>(
        bloc: _bloc,
        listener:  (context, state){
          if(state is GetPrefsSuccess){
            _bloc.getMainBloc(context);
            DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
            _bloc.add(GetListGroupAwaitingCustomer(parseDate));
            if(!Utils.isEmpty(_mainBloc.idKhungGio) && !Utils.isEmpty(_mainBloc.ngayTC) && !Utils.isEmpty(_mainBloc.idVanPhong) && !Utils.isEmpty(_mainBloc.idKhungGio) && !Utils.isEmpty(_mainBloc.loaiKhach)){
              //_bloc.add(GetListDetailTripsOfPageWaiting(format.parse(_mainBloc.ngayTC),_mainBloc.idVanPhong,_mainBloc.idKhungGio,_mainBloc.loaiKhach));
            }
          }
          if(state is GetListOfWaitingCustomerSuccess){
           _mainBloc.listOfGroupAwaitingCustomer = _bloc.listOfGroupAwaitingCustomer;
          }
          else if(state is GetListOfDetailTripsOfWaitingPageSuccess){
            if(viewDetail == true){
              _mainBloc.viewDetailTC = true;
              DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(Jiffy(_mainBloc.ngayTC, "dd/MM/yyyy").format("yyyy-MM-dd"));
              Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailTripsPage(
                tenChuyen: tenChuyen,
                typeDetail: 1,dateTime: parseDate,idRoom: _mainBloc.idVanPhong,idTime: _mainBloc.idKhungGio,typeCustomer: _mainBloc.loaiKhach,thoiGian: thoiGian,))).then((value){
                  viewDetail = false;
                  _mainBloc.viewDetailTC = false;
                  _bloc.add(GetListGroupAwaitingCustomer(parseDate));
              });
            }
          }
        },
        child: BlocBuilder<WaitingBloc,WaitingState>(
          bloc: _bloc,
          builder: (BuildContext context, WaitingState state) {
            return buildPage(context,state);
          },
        ),
    )
    );
  }

  Stack buildPage(BuildContext context,WaitingState state){
    return Stack(
      children: [
        !Utils.isEmpty(_mainBloc.listOfGroupAwaitingCustomer) ?
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
                      _mainBloc.listOfGroupAwaitingCustomer.length <= 0 ?
                      'Bạn có không có Cuốc chờ nào!!!' : 'Bạn có ${_mainBloc.listOfGroupAwaitingCustomer.length} Cuốc chờ / ${Jiffy(dateTime, "yyyy-MM-dd").format("dd-MM-yyyy")}',
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
              child: RefreshIndicator(
                color: Colors.orange,
                onRefresh: () => Future.delayed(Duration.zero).then(
                        (_) {
                          if(Utils.isEmpty(dateTime)){
                            dateTime = DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
                          }
                          _bloc.add(GetListGroupAwaitingCustomer(dateTime));}),
                child: Scrollbar(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _mainBloc.listOfGroupAwaitingCustomer.length,
                        itemBuilder: (BuildContext context, int index) {

                          return buildListItem(_mainBloc.listOfGroupAwaitingCustomer[index],index);
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
            child: Text('${Jiffy(dateTime, "yyyy-MM-dd").format("dd-MM-yyyy")} \n Chưa có chuyến nào',textAlign: TextAlign.center,),
          ),
        ),
        Visibility(
          visible: state is WaitingLoading,
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
          viewDetail = true;
          tenChuyen = item.tenVanPhong;
          thoiGian = "${item.loaiKhach == 1 ? "${item.thoiGianDi}->${item.thoiGianDen}" : "${item.thoiGianDen}->${item.thoiGianDi}"}";// "${item.thoiGianDi}->${item.thoiGianDen}";
          _mainBloc.trips = "${item.loaiKhach == 1 ? item.thoiGianDi : item.thoiGianDen} - ${item.ngayChay}";
          _mainBloc.idKhungGio = item.idKhungGio!;
          _mainBloc.loaiKhach = item.loaiKhach!;
          _mainBloc.blocked = true;
          _mainBloc.idVanPhong = item.idVanPhong!;
          _mainBloc.ngayTC = item.ngayChay.toString();
          _mainBloc.currentNumberCustomerOfList = item.soKhach!;
          _bloc.add(GetListDetailTripsOfPageWaiting(format.parse(item.ngayChay.toString()),item.idVanPhong!,item.idKhungGio!,item.loaiKhach!));

          // if( _mainBloc.listCustomer.length == 0){
          //   Utils.showDialogAssign(context: context,titleHintText: 'Bạn sẽ đón nhóm Khách này?').then((value){
          //     if(!Utils.isEmpty(value)){
          //       // _mainBloc.trips = item.thoiGianDi + ' - ' + item.ngayChay;
          //       // _bloc.add(GetListDetailTripsOfPageWaiting(format.parse(item.ngayChay),item.idVanPhong,item.idKhungGio,item.loaiKhach));
          //       // _mainBloc.blocked = true;
          //       // _mainBloc.idKhungGio = item.idKhungGio;
          //       // _mainBloc.loaiKhach = item.loaiKhach;
          //       // _mainBloc.idVanPhong = item.idVanPhong;
          //       // _mainBloc.ngayTC = item.ngayChay;
          //       // _mainBloc.currentNumberCustomerOfList = item.soKhach;
          //       Utils.showToast( 'Chạy thôi nào bạn ơi !!!');
          //       // Future.delayed(Duration(seconds: 1), () {
          //       //   _mainBloc.add(NavigateProfile());
          //       // });
          //       /// New EPX
          //     }
          //     else{
          //       print('Click huỷ');
          //     }
          //   });
          // } else{
          //   print('đi đón nốt người đi thằng ngu');
          //   Utils.showToast( 'Bạn vẫn đang trong tuyến hoặc chưa trả khách xong.');
          // }
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
                            Expanded(
                              child: Text(item.tenVanPhong??
                                '',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
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
                                  style: Theme.of(this.context).textTheme.caption?.copyWith(
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
                              style: Theme.of(this.context).textTheme.caption?.copyWith(
                                color: Theme.of(this.context).disabledColor,
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
                                  'Xuất bến:  ${item.loaiKhach == 1 ? item.thoiGianDi??'' : item.thoiGianDen??''}',//${item.thoiGianDi??''}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.black,),
                                ),
                                Icon(Icons.arrow_forward),
                                Text(//${item.thoiGianDen??''}
                                  'Tới bến: Loading',//${item.loaiKhach == 1 ? item.thoiGianDen??'' : item.thoiGianDi??''}
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.black,)
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
                        padding: const EdgeInsets.only(right: 16, left: 16, top: 10, bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Số khách cần xử lý',
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${item.soKhach??''} Khách',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(Jiffy(item.ngayChay, "dd/MM/yyyy").format("yyyy-MM-dd"));
                            //     Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailTripsPage(typeDetail: 1,dateTime: parseDate,idRoom: item.idVanPhong,idTime: item.idKhungGio,typeCustomer: item.loaiKhach,thoiGian: thoiGian,)));///item.idTuyenDuong.toString()
                            //   },
                            //   child: Container(
                            //     padding: EdgeInsets.all(8),
                            //     decoration: BoxDecoration(
                            //       color: (item.idKhungGio == _mainBloc.idKhungGio && item.loaiKhach == _mainBloc.loaiKhach && _mainBloc.blocked == true&& item.idVanPhong == _mainBloc.idVanPhong) ? Colors.purple.withOpacity(0.5): Colors.purple,
                            //       borderRadius: BorderRadius.all(Radius.circular(16))
                            //     ),
                            //     child: Text('Xem thêm',style: TextStyle(color: (item.idKhungGio == _mainBloc.idKhungGio && item.loaiKhach == _mainBloc.loaiKhach && _mainBloc.blocked == true && item.idVanPhong == _mainBloc.idVanPhong) ? Colors.white.withOpacity(0.5) : Colors.white,fontSize: 10),),
                            //   ),
                            // ),
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
                    child: Text( "${item.loaiKhach == 1 ? 'Đang đón' : 'Đang trả'}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
