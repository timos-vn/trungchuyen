import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:trungchuyen/models/database/dbhelper.dart';
import 'package:trungchuyen/models/entity/customer.dart';
import 'package:trungchuyen/models/entity/notification_trung_chuyen.dart';
import 'package:trungchuyen/models/network/response/detail_trips_repose.dart';
import 'package:trungchuyen/page/account/account_bloc.dart';
import 'package:trungchuyen/page/account/account_event.dart';
// import 'package:trungchuyen/page/account/account_page.dart';
import 'package:trungchuyen/page/detail_trips/detail_trips_bloc.dart';
import 'package:trungchuyen/page/detail_trips/detail_trips_event.dart';
import 'package:trungchuyen/page/detail_trips/detail_trips_page.dart';
import 'package:trungchuyen/page/history/list_history_limo_bloc.dart';
import 'package:trungchuyen/page/history/list_history_limo_page.dart';
import 'package:trungchuyen/page/history_tc/list_history_tc_bloc.dart';
import 'package:trungchuyen/page/history_tc/list_history_tc_page.dart';
import 'package:trungchuyen/page/limo_confirm/limo_confirm_bloc.dart';
import 'package:trungchuyen/page/limo_confirm/limo_confirm_event.dart';
import 'package:trungchuyen/page/limo_confirm/limo_confirm_page.dart';
import 'package:trungchuyen/page/list_customer_limo/list_customer_limo_bloc.dart';
import 'package:trungchuyen/page/list_customer_limo/list_customer_limo_page.dart';
import 'package:trungchuyen/page/map/map_bloc.dart';
import 'package:trungchuyen/page/map/map_event.dart';
import 'package:trungchuyen/page/map/map_page.dart';
import 'package:trungchuyen/page/map_limo/map_limo_bloc.dart';
import 'package:trungchuyen/page/map_limo/map_limo_event.dart';
import 'package:trungchuyen/page/map_limo/map_limo_page.dart';
import 'package:trungchuyen/page/notification_api.dart';
import 'package:trungchuyen/page/report/report_bloc.dart';
import 'package:trungchuyen/page/report/report_page.dart';
import 'package:trungchuyen/page/report_limo/report_limo_bloc.dart';
import 'package:trungchuyen/page/report_limo/report_limo_page.dart';
import 'package:trungchuyen/page/waiting/waiting_bloc.dart';
import 'package:trungchuyen/page/waiting/waiting_event.dart';
import 'package:trungchuyen/page/waiting/waiting_page.dart';
import 'package:trungchuyen/service/lifecycle_event_handler.dart';
import 'package:trungchuyen/service/soket_io_service.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/themes/images.dart';
import 'package:trungchuyen/utils/const.dart';
import 'package:trungchuyen/utils/utils.dart';
import 'package:trungchuyen/widget/custom_tab_bar.dart';
import 'package:trungchuyen/widget/custom_tab_scaffold.dart';
import 'package:trungchuyen/widget/custom_tab_view.dart';
import 'package:trungchuyen/widget/pending_action.dart';
import '../account/account_screen.dart';
import 'main_bloc.dart';
import 'main_event.dart';
import 'main_state.dart';

class MainPage extends StatefulWidget {
  final bool? roleTC;
  final int? roleAccount;
  final String? tokenFCM;
  const MainPage({Key? key,this.roleTC,this.roleAccount,this.tokenFCM}) : super(key: key);


  @override
  State<StatefulWidget> createState() => _MainPageState();
}

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

class _MainPageState extends State<MainPage> with WidgetsBindingObserver{
  late MainBloc _mainBloc;
  // MapBloc _mapBloc;
  late WaitingBloc _waitingBloc;
  late ListHistoryLimoBloc _listHistoryLimoBloc;
  late ListHistoryTCBloc _listHistoryTCBloc;
  late AccountBloc _accountBloc;
  late ListCustomerLimoBloc _listCustomerLimoBloc;
  // late MapLimoBloc _mapLimoBloc;
  late LimoConfirmBloc _limoConfirmBloc;
  late DetailTripsBloc _detailTripsBloc;
  DateFormat format = DateFormat("dd/MM/yyyy");
  int testcase = 0;
  int _lastIndexToShop = 0;
  int _currentIndex = 0;

  DatabaseHelper db = DatabaseHelper();
  late GlobalKey<NavigatorState> _currentTabKey;
  List<BottomNavigationBarItem> listBottomItems = [];

  final GlobalKey<NavigatorState> firstTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> secondTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> thirdTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> fourthTabNavKey = GlobalKey<NavigatorState>();


  // final GlobalKey<MapPageState> _mapPageKey = GlobalKey();
  final GlobalKey<DetailTripsPageState> _detailListCustomerPageKey = GlobalKey();
  // final GlobalKey<MapLimoPageState> _mapLimoPageKey = GlobalKey();
  final GlobalKey<WaitingPageState> _waitingPageKey = GlobalKey();
  final GlobalKey<ListCustomerLimoPageState> _listCustomerLimoKey = GlobalKey();
  final GlobalKey<LimoConfirmPageState> _limoConfirmKey = GlobalKey();

  final GlobalKey<AccountScreenState> _accountPageKey = GlobalKey();

  Future<List<Customer>?> getListCustomer() async {
    _mainBloc.listInfo = await getListFromDb();
    if (!Utils.isEmpty(_mainBloc.listInfo)) {
      _mainBloc.idKhungGio = _mainBloc.listInfo[0].idKhungGio!;
      _mainBloc.idVanPhong = _mainBloc.listInfo[0].idVanPhong!;
      _mainBloc.loaiKhach = _mainBloc.listInfo[0].loaiKhach!;
      _mainBloc.ngayTC = _mainBloc.listInfo[0].ngayTC!;
      _mainBloc.trips = _mainBloc.listInfo[0].chuyen!;
      _mainBloc.blocked = true;
      if(!Utils.isEmpty(_mainBloc.idKhungGio) && !Utils.isEmpty(_mainBloc.ngayTC) && !Utils.isEmpty(_mainBloc.idVanPhong) && !Utils.isEmpty(_mainBloc.idKhungGio) && !Utils.isEmpty(_mainBloc.loaiKhach)){
        _mainBloc.add(GetListDetailTripsTC(format.parse(_mainBloc.ngayTC),_mainBloc.idVanPhong,_mainBloc.idKhungGio,_mainBloc.loaiKhach));
      }
      print('LENGHT: ${_mainBloc.soKhachDaDonDuoc}');
      return _mainBloc.listInfo ;
    }else{
      print('nullll');
      // _mainBloc.db.deleteAll();
      // _mainBloc.add(GetListTaiXeLimo());
      return null;
    }
  }

  Future<List<Customer>?> getListTaiXeLimo() async {
    _mainBloc.listTaiXeLimo = await getListDriverLimoFromDb();
    if (!Utils.isEmpty(_mainBloc.listTaiXeLimo)) {
      return _mainBloc.listTaiXeLimo ;
    }else{
      print('nullll listTaiXeLimo');
      return null;
    }
  }

  Future<List<Customer>> getListDriverLimoFromDb() {
    return db.fetchAllDriverLimo();
  }

  Future<List<Customer>> getListFromDb() {
    return db.fetchAll();
  }

  late PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  @override
  void initState() {
    Get.put(SocketIOService());
    WidgetsBinding.instance.addObserver(this);
    NotificationApi.init();
    listenNotification();
    tz.initializeTimeZones();
    _mainBloc = MainBloc(context);
    _mainBloc.add(GetPrefsMain());
    _mainBloc.role = widget.roleAccount!;
    // _mapBloc = MapBloc(context);
    _listHistoryLimoBloc = ListHistoryLimoBloc(context);
    _listHistoryTCBloc = ListHistoryTCBloc(context);
    _waitingBloc = WaitingBloc(context);
    _accountBloc = AccountBloc(context);
    _listCustomerLimoBloc = ListCustomerLimoBloc(context);
    // _mapLimoBloc = MapLimoBloc(context);
    _limoConfirmBloc = LimoConfirmBloc(context);
    _detailTripsBloc =DetailTripsBloc(context);
    _currentTabKey = firstTabNavKey;

    WidgetsBinding.instance.addObserver(
        LifecycleEventHandler()
    );

    super.initState();
  }

  void listenNotification()=> NotificationApi.onNotification.stream.listen(listenOnClickNotification);

  void listenOnClickNotification (String payload)=> Utils.showToast(payload);

  @override
  void dispose() {
    // _mainBloc.close();
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.resumed){
      // Utils.showToast('Bạn đã Online');
      //add(GetListTripsLimo(parseDate));
      if(widget.roleAccount == 3){
        if(!Utils.isEmpty(_mainBloc.idKhungGio) && !Utils.isEmpty(_mainBloc.ngayTC) && !Utils.isEmpty(_mainBloc.idVanPhong) && !Utils.isEmpty(_mainBloc.idKhungGio) && !Utils.isEmpty(_mainBloc.loaiKhach)){
         _mainBloc.add(GetListDetailTripsTC(format.parse(_mainBloc.ngayTC),_mainBloc.idVanPhong,_mainBloc.idKhungGio,_mainBloc.loaiKhach));
        }
      }else if(widget.roleAccount == 7){
        _mainBloc.add(GetListTripsLimo(_mainBloc.parseDate));
      }
      if(_mainBloc.socketIOService.socket.disconnected)
      {
        _mainBloc.socketIOService.socket.connect();
        if(widget.roleAccount == 3){
        }else if(widget.roleAccount == 7){
          _mainBloc.add(GetListNotificationOfLimo());
        }
      }
    }else if(state == AppLifecycleState.inactive || state == AppLifecycleState.paused){
      Utils.showToast('Bạn đã offline. Vui lòng quay lại app.');
      if(_mainBloc.socketIOService.socket.connected)
      {
        _mainBloc.socketIOService.socket.disconnect();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
          bool isSuccess = await _currentTabKey.currentState!.maybePop();
          if (!isSuccess && _currentIndex != Const.WAITING) {
            // _lastIndexToShop = Const.MAP;
            _mainBloc.add(NavigateBottomNavigation(Const.WAITING));
            _currentIndex = _lastIndexToShop;
            _currentTabKey = firstTabNavKey;
          }
          if (!isSuccess) _exitApp(context);
          return false;
      },
      child: Scaffold(
        body:
          MultiBlocProvider(
              providers: [
                BlocProvider<MainBloc>(
                  create: (context) {
                    if (_mainBloc == null) _mainBloc = MainBloc(context);
                    return _mainBloc;
                  },
                ),
                BlocProvider<WaitingBloc>(
                  create: (context) {
                    if (_waitingBloc == null) _waitingBloc = WaitingBloc(context);
                    return _waitingBloc;
                  },
                ),
                // BlocProvider<MapBloc>(
                //   create: (context) {
                //     if (_mapBloc == null) _mapBloc = MapBloc(context);
                //     return _mapBloc;
                //   },
                // ),
                BlocProvider<ListHistoryLimoBloc>(
                  create: (context) {
                    if (_listHistoryLimoBloc == null) _listHistoryLimoBloc = ListHistoryLimoBloc(context);
                    return _listHistoryLimoBloc;
                  },
                ),
                BlocProvider<ListHistoryTCBloc>(
                  create: (context) {
                    if (_listHistoryTCBloc == null) _listHistoryTCBloc = ListHistoryTCBloc(context);
                    return _listHistoryTCBloc;
                  },
                ),
                BlocProvider<LimoConfirmBloc>(
                  create: (context) {
                    if (_limoConfirmBloc == null) _limoConfirmBloc = LimoConfirmBloc(context);
                    return _limoConfirmBloc;
                  },
                ),
                BlocProvider<AccountBloc>(
                  create: (context) {
                    if (_accountBloc == null) _accountBloc = AccountBloc(context);
                    return _accountBloc;
                  },
                ),
                BlocProvider<ListCustomerLimoBloc>(
                  create: (context) {
                    if (_listCustomerLimoBloc == null) _listCustomerLimoBloc = ListCustomerLimoBloc(context);
                    return _listCustomerLimoBloc;
                  },
                ),
                // BlocProvider<MapLimoBloc>(
                //   create: (context) {
                //     if (_mapLimoBloc == null) _mapLimoBloc = MapLimoBloc(context);
                //     return _mapLimoBloc;
                //   },
                // ),
              ],
              child: BlocListener<MainBloc, MainState>(
                bloc: _mainBloc,
                // bloc: _mainBloc,
                listener: (context, state) {
                  if(state is GetPrefsSuccess){
                    if(widget.roleAccount == 3){
                      getListCustomer();
                      getListTaiXeLimo();
                    }
                    else if(widget.roleAccount == 7){
                      _mainBloc.add(GetListNotificationOfLimo());
                    }
                  }
                  if (state is LogoutFailure) {
                    Utils.showToast(state.error.toString());
                  }
                  else if(state is  UpdateStatusCustomerSuccess){
                    DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
                    _waitingBloc.add(GetListGroupAwaitingCustomer(parseDate));
                  }
                  else if (state is LogoutSuccess) {
                    _lastIndexToShop = Const.WAITING;
                    _currentIndex = _lastIndexToShop;
                    _currentTabKey = firstTabNavKey;
                  }else if (state is RefreshMainState){
                    refreshChildPage();
                  }
                  else if(state is GetListOfGroupCustomerSuccess){
                    _waitingPageKey.currentState?.setState(() {
                      _mainBloc.listOfGroupAwaitingCustomer = _mainBloc.listOfGroupAwaitingCustomer;

                    });
                  }
                  else if(state is GetListCustomerConfirmLimo){
                    _limoConfirmKey.currentState?.setState(() {
                      _mainBloc.listCustomerConfirmLimo = _mainBloc.listCustomerConfirmLimo;
                    });
                  }
                  else if(state is GetListCustomerLimoSuccess){
                    _listCustomerLimoKey.currentState?.setState(() {
                      _mainBloc.listCustomerLimo = _mainBloc.listCustomerLimo;
                    });
                  }else if(state is GetListOfDetailTripsTCSuccess){
                    // _mapPageKey?.currentState?.setState(() {
                    //   _mainBloc.listCustomer = _mainBloc.listCustomer;
                    // });
                    print('O hay 1');
                    //_detailTripsBloc.add(GetListDetailTrips(state.ngayChay,state.idRoom,state.idTime,state.typeCustomer));
                    _detailListCustomerPageKey.currentState?.setState(() {
                      _mainBloc.listCustomer = _mainBloc.listCustomer;
                    });
                  }else if(state is CountNotificationSuccess){
                    _accountPageKey.currentState?.setState(() {
                      _mainBloc.countNotifyUnRead = _mainBloc.countNotifyUnRead;
                    });
                  }
                  else if (state is NavigateToNotificationState) {}
                  else if(state is GetLocationSuccess){
                  }
                },
                child: BlocBuilder<MainBloc, MainState>(
                  bloc: _mainBloc,
                  builder: (context, state) {
                    if (state is MainPageState) {
                      _currentIndex = state.position;
                      // if (_currentIndex == Const.MAP) {
                      //   if(widget.roleAccount == 3){ /// LX TC
                      //    // _mapBloc.add(GetListCustomer(_mainBloc.listOfDetailTrips));
                      //   }
                      // }
                      if (_currentIndex == Const.WAITING) {
                        if(widget.roleAccount == 3){
                          DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
                          _mainBloc.add(GetListGroupCustomer(parseDate));
                        }else if(widget.roleAccount == 7){
                          DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
                          _mainBloc.add(GetListTripsLimo(parseDate));
                        }
                      }
                      if (_currentIndex == Const.CONFIRM) {
                        if(widget.roleAccount == 7 ){
                          _mainBloc.add(GetListCustomerConfirm());
                        }
                      }
                      if (_currentIndex == Const.ACCOUNT) {
                        _mainBloc.add(GetCountNotificationUnRead());
                      }
                    }
                    if (state is MainProfile) {
                      // _mapPageKey?.currentState?.setState(() {
                      //   _mainBloc.listCustomer = _mainBloc.listCustomer;
                      // });
                      //_currentIndex = Const.MAP;
                      _currentTabKey = secondTabNavKey;
                    }
                    _mainBloc.init(context);
                    return Stack(children: <Widget>[
                      PersistentTabView(
                        context,
                        controller: _controller,
                        screens: _buildScreens(),
                        items: _navBarsItems(),
                        confineInSafeArea: true,
                        handleAndroidBackButtonPress: true,
                        resizeToAvoidBottomInset: true,
                        stateManagement: true,
                        navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
                            ? 0.0
                            : kBottomNavigationBarHeight,
                        hideNavigationBarWhenKeyboardShows: true,
                        margin: EdgeInsets.all(0.0),
                        popActionScreens: PopActionScreensType.all,
                        bottomScreenMargin: 0.0,
                        onWillPop: (context) async {
                          await showDialog(
                            context: context!,
                            useSafeArea: true,
                            builder: (context) => Container(
                              height: 50.0,
                              width: 50.0,
                              color: Colors.white,
                              child: ElevatedButton(
                                child: Text("Close"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                          return false;
                        },
                        selectedTabScreenContext: (context) {
                          //testContext = context;
                          print('AccountHEHE');
                          print(_controller.index);
                          if (_controller.index == Const.WAITING) {
                            if(widget.roleAccount == 3){
                              DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
                              _mainBloc.add(GetListGroupCustomer(parseDate));
                            }else if(widget.roleAccount == 7){
                              DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
                              _mainBloc.add(GetListTripsLimo(parseDate));
                            }
                          }
                          if (_controller.index == Const.CONFIRM) {
                            if(widget.roleAccount == 7 ){
                              _mainBloc.add(GetListCustomerConfirm());
                            }
                          }
                          if (_controller.index == Const.ACCOUNT) {
                            _mainBloc.add(GetCountNotificationUnRead());
                          }
                        },
                        hideNavigationBar: false,
                        backgroundColor: Colors.white,
                        decoration: NavBarDecoration(
                          //border: Border.all(),
                            boxShadow: [
                              BoxShadow(color: Colors.grey, spreadRadius: 0.1),
                            ],
                            //colorBehindNavBar: Colors.indigo,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            )),
                        popAllScreensOnTapOfSelectedTab: true,
                        itemAnimationProperties: ItemAnimationProperties(
                          duration: Duration(milliseconds: 400),
                          curve: Curves.ease,
                        ),
                        navBarStyle: NavBarStyle.style15, // Choose the nav bar style with this property
                      ),
                      Visibility(
                        visible: state is MainLoading,
                        child: PendingAction(),
                      )
                    ]);
                  },
                ),
              ))
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      widget.roleAccount == 3 ? WaitingPage(key: _waitingPageKey,) : ListCustomerLimoPage(key: _listCustomerLimoKey,),
      LimoConfirmPage(key: _limoConfirmKey,roleTC: widget.roleAccount == 3 ? true : widget.roleTC,),
      AccountScreen(key: _accountPageKey,)
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.avTimer),
        title: "Chuyến",

        activeColorPrimary: Colors.purple,
        inactiveColorPrimary: Colors.grey,
        inactiveColorSecondary: Colors.purple,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Xác nhận"),
        activeColorPrimary: Colors.deepPurple,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.grey,
        // onPressed: (context) {
        //   pushDynamicScreen(context,
        //       screen: SampleModalScreen(), withNavBar: true);
        // }
      ),
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.accountCircle),
        title: ("Tài khoản"),
        activeColorPrimary: Colors.deepOrange,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  List<BottomNavigationBarItem> listBottomBar() {
    return [
      BottomNavigationBarItem(
        icon: _currentIndex == Const.WAITING ?  Icon(
          MdiIcons.carWash,
          color:   orange,
        ) : Icon(
          MdiIcons.carWash,
          color:   grey,
        ),
        label: 'Chuyến'.tr,
        activeIcon: Text(
          'Chuyến'.tr,
          style: TextStyle(color: _currentIndex == Const.WAITING ? orange : grey, fontSize: 10),
        ),
      ),
      // BottomNavigationBarItem(
      //   icon: Icon(
      //     MdiIcons.map,
      //     color: _currentIndex == Const.MAP ? orange : grey,
      //   ),
      //   title: Text(
      //     "Map".tr,
      //     style: TextStyle(color: _currentIndex == Const.MAP ? orange : grey, fontSize: 10),
      //   ),
      // ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.stream,
          color: _currentIndex == Const.CONFIRM ? orange : grey,
        ),
        label: 'Xác nhận'.tr,
        // icon: Text(
        //   'Xác nhận'.tr,
        //   style: TextStyle(color: _currentIndex == Const.CONFIRM ? orange : grey, fontSize: 10),
        // ),
      ),
      BottomNavigationBarItem(
        icon: Icon(
          MdiIcons.orderBoolDescendingVariant,
          color: _currentIndex == Const.ACCOUNT ? orange : grey,
        ),
        label: "Account".tr,
        // title: Text(
        //   "Account".tr,
        //   style: TextStyle(color: _currentIndex == Const.ACCOUNT ? orange : grey, fontSize: 10),
        // ),
      ),

    ];
  }

  void refreshChildPage() {
    // _homeBloc.add(RefreshHomeEvent());
    // _reportBloc.add(RefreshReportEvent());
    // _approvalBloc.add(RefreshApprovalEvent());
    // _orderBloc.add(RefreshOrderEvent());
    // _settingBloc.add(RefreshSettingEvent());
    // _workBloc.add(RefreshWorkEvent());
  }

  void _exitApp(BuildContext context) {
    List<Widget> actions = [
      ElevatedButton(
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        child: Text('No'.tr,
            style: TextStyle(
              color: Colors.orange,
              fontSize: 14,
            )),
      ),
      ElevatedButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        },
        child: Text(
          'Yes'.tr,
          style: TextStyle(
            color: Colors.orange,
            fontSize: 14,
          ),
        ),
      )
    ];

    Utils.showDialogTwoButton(
        context: context,
        title: 'Notice'.tr,
        contentWidget: Text(
          'ExitApp'.tr,
          style: TextStyle(fontSize: 16.0),
        ),
        actions: actions);
  }
}
