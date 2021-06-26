import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:trungchuyen/utils/const.dart';

class SocketIOService extends GetxService {
  IO.Socket socket;
  //final getStorage = GetStorage();
  SharedPreferences _prefs;
  String _accessToken;
  //User user;
  @override
  void onInit() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      _accessToken = _prefs.getString(Const.ACCESS_TOKEN) ?? "";
    }else{
      _accessToken = _prefs.getString(Const.ACCESS_TOKEN) ?? "";
    }
    print('ACCC: ${_accessToken.toString()}');
    // user = User.fromJson(getStorage.read(GetStorageKey.user));
    initSocket();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  initSocket() {
    try {
      //String token = getStorage.read(GetStorageKey.accessToken);
      socket = IO.io('https://trungchuyenhn.com:8443/', <String, dynamic>{

        'transports': ['websocket'],
        'query': {'token': '$_accessToken'}
      });
    } catch (error) {
      print(error);
    }

    socket.onConnect((_) {
      print('socket connect id:${socket.id}');
    });
    socket.on('event2', (data) => print('data2: ${data}'));
    // socket.on('new_customer_pickup', (data) {
    //   try {
    //     // final driverTransshipmentMapController = Get.find<DriverTransshipmentMapController>();
    //     // driverTransshipmentMapController.addCustomerPickup(data);
    //   } catch (e) {}
    // });
    socket.onDisconnect((_) => print('disconnect'));
  }

}
