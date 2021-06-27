import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:trungchuyen/models/database/dbhelper.dart';
import 'package:trungchuyen/models/entity/customer.dart';
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

class WaitingPage extends StatefulWidget {

  WaitingPage({Key key}) : super(key: key);

  @override
  WaitingPageState createState() => WaitingPageState();

}

class WaitingPageState extends State<WaitingPage> {

  WaitingBloc _bloc;
  MainBloc _mainBloc;
  //List<ListOfGroupAwaitingCustomerBody> _listOfGroupAwaitingCustomer = new List();
  DatabaseHelper db = DatabaseHelper();
  List<Customer> langSt = new List<Customer>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = WaitingBloc(context);
    _mainBloc = BlocProvider.of<MainBloc>(context);
    DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
    _bloc.add(GetListGroupAwaitingCustomer(parseDate));
    //_listOfGroupAwaitingCustomer = _mainBloc.listOfGroupAwaitingCustomer;
  }

  @override
  Widget build(BuildContext context) {
    print('check');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Lịch Khách Chờ',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body:BlocListener<WaitingBloc,WaitingState>(
        cubit: _bloc,
        listener:  (context, state){
          if(state is GetListOfWaitingCustomerSuccess){
           _mainBloc.listOfGroupAwaitingCustomer = _bloc.listOfGroupAwaitingCustomer;
            print('Length123');
          }
          else if(state is GetListOfDetailTripsOfWaitingPageSuccess){
            _mainBloc.listOfDetailTrips.clear();
            _mainBloc.listOfDetailTrips = _bloc.listOfDetailTrips;
            /// add sqfliet
            ///

            int _countExitsCustomer = 0;
            _bloc.listOfDetailTrips.forEach((element) {
              db.deleteAll();
              Customer customer = new Customer(
                idTrungChuyen: element.idTrungChuyen,
                  idTaiXeLimousine : element.idTaiXeLimousine,
                  hoTenTaiXeLimousine : element.hoTenTaiXeLimousine,
                  dienThoaiTaiXeLimousine : element.dienThoaiTaiXeLimousine,
                  tenXeLimousine : element.tenXeLimousine,
                  bienSoXeLimousine : element.bienSoXeLimousine,
                  tenKhachHang : element.tenKhachHang,
                  soDienThoaiKhach :element.soDienThoaiKhach,
                  diaChiKhachDi :element.diaChiKhachDi,
                  toaDoDiaChiKhachDi:element.toaDoDiaChiKhachDi,
                  diaChiKhachDen:element.diaChiKhachDen,
                  toaDoDiaChiKhachDen:element.toaDoDiaChiKhachDen,
                  diaChiLimoDi:element.diaChiLimoDi,
                  toaDoLimoDi:element.toaDoLimoDi,
                  diaChiLimoDen:element.diaChiLimoDen,
                  toaDoLimoDen:element.toaDoLimoDen,
                  loaiKhach:element.loaiKhach,
                  trangThaiTC:element.trangThaiTC,
                  soKhach:element.soKhach,
                  statusCustomer: element.loaiKhach == 1 ? 2 : 5
              );

              db.addNew(customer);

              if(Utils.isEmpty(_mainBloc.listTaiXeLimo)){
                _countExitsCustomer++;
                element.soKhach = _countExitsCustomer;
                _mainBloc.listTaiXeLimo.add(element);
              }
              else{
                var contain =  _mainBloc.listTaiXeLimo.where((phone) => phone.dienThoaiTaiXeLimousine == element.dienThoaiTaiXeLimousine);
                if (contain.isEmpty){
                  _mainBloc.listTaiXeLimo.add(element);
                }else{
                  _countExitsCustomer++;
                  final tile = _mainBloc.listTaiXeLimo.firstWhere((item) => item.dienThoaiTaiXeLimousine == element.dienThoaiTaiXeLimousine);
                  if (tile != null) tile.soKhach = _countExitsCustomer;
                }
              }
            });
            getListCustomer();
          }
        },
        child: BlocBuilder<WaitingBloc,WaitingState>(
          cubit: _bloc,
          builder: (BuildContext context, WaitingState state) {
            return buildPage(context,state);
          },
        ),
      //),
    )
    );
  }

  Future<List<Customer>> getListCustomer() async {
    langSt = await getListFromDb();
    if (!Utils.isEmpty(langSt)) {
      print(langSt);
      return langSt;
    }else{
      print('nullll');
      return null;
    }
  }

  Future<List<Customer>> getListFromDb() {
    return db.fetchAll();
  }

  Stack buildPage(BuildContext context,WaitingState state){
    // if(!Utils.isEmpty(_listOfGroupAwaitingCustomer))
    //   _listOfGroupAwaitingCustomer = _bloc.listOfGroupAwaitingCustomer;
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
                      'Bạn có không có Cuốc chờ nào!!!' : 'Bạn có ${_mainBloc.listOfGroupAwaitingCustomer.length} Cuốc chờ',
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
                        (_) => _bloc
                        .add(GetListGroupAwaitingCustomer(DateFormat("yyyy-MM-dd").parse(DateTime.now().toString())))),
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
            child: Padding(
              padding: const EdgeInsets.only(left: 40,right: 40),
              child: InkWell(
                onTap: ()=>_bloc.add(GetListGroupAwaitingCustomer(DateFormat("yyyy-MM-dd").parse(DateTime.now().toString()))),
                child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueAccent,
                    ),
                  child: Center(
                    child: Text(
                      'Làm mới danh sách',
                      style: Theme.of(context).textTheme.button.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
          if(_mainBloc.listOfDetailTrips.length == 0){
            Utils.showDialogAssign(context: context,titleHintText: 'Bạn sẽ đón nhóm Khách này?').then((value){
              if(!Utils.isEmpty(value)){
                _mainBloc.trips = item.tenTuyenDuong + "  /  " + item.thoiGianDi + ' - ' + item.ngayChay;
                DateFormat format = DateFormat("dd/MM/yyyy");
                _bloc.add(GetListDetailTripsOfPageWaiting(format.parse(item.ngayChay),item.idTuyenDuong,item.idKhungGio));
                _mainBloc.blocked = true;
                _mainBloc.indexAwaitingList = index;
                _mainBloc.currentNumberCustomerOfList = item.soKhach;
                Utils.showToast( 'Chạy thôi nào bạn ơi !!!');
              }
              else{
                print('Click huỷ');
              }
            });
          } else{
            print('đi đón nốt người đi thằng ngu');
            Utils.showToast( 'Bạn vẫn đang trong tuyến.');
          }

        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 16, top: 8, bottom: 8),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: (  index == _mainBloc.indexAwaitingList && _mainBloc.blocked == true) ?  Colors.black.withOpacity(0.5) : Theme.of(this.context).scaffoldBackgroundColor,
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
                          Container(
                            height: 45,
                            width: 45,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color:  (  index == _mainBloc.indexAwaitingList && _mainBloc.blocked == true) ? (item.loaiKhach == 1 ? Colors.orange.withOpacity(0.5) : Colors.blue.withOpacity(0.5)) : (item.loaiKhach == 1 ? Colors.orange : Colors.blue),
                                borderRadius: BorderRadius.all(Radius.circular(32))),
                            child: Center(
                              child: Text(
                               '${item.loaiKhach == 1 ? 'Đón' : 'Trả'}',
                                style: Theme.of(this.context).textTheme.caption.copyWith(
                                  color:( index == _mainBloc.indexAwaitingList && _mainBloc.blocked == true) ? Colors.white.withOpacity(0.5) :Colors.white,
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
                          GestureDetector(
                            onTap: () {
                              DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailTripsPage(dateTime: parseDate,idTrips: item.idTuyenDuong.toString(),idTime: item.idKhungGio.toString(),)));
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: (  index == _mainBloc.indexAwaitingList && _mainBloc.blocked == true) ? Colors.purple.withOpacity(0.5): Colors.purple,
                                borderRadius: BorderRadius.all(Radius.circular(16))
                              ),
                              child: Text('Xem thêm',style: TextStyle(color: (  index == _mainBloc.indexAwaitingList && _mainBloc.blocked == true) ? Colors.white.withOpacity(0.5) : Colors.white,fontSize: 10),),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: index == _mainBloc.indexAwaitingList && _mainBloc.blocked == true,
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
