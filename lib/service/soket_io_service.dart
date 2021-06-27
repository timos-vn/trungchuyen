import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:trungchuyen/utils/const.dart';

class SocketIOService extends GetxService {
  IO.Socket socket;
  SharedPreferences _prefs;
  String _accessToken;
  @override
  void onInit() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      _accessToken = _prefs.getString(Const.ACCESS_TOKEN) ?? "";
    }else{
      _accessToken = _prefs.getString(Const.ACCESS_TOKEN) ?? "";
    }
    initSocket();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  initSocket() {
    try {
      socket = IO.io('https://trungchuyenhn.com:8443/', <String, dynamic>{
        'transports': ['websocket'],
        'query': {'token': '$_accessToken'},
        'autoConnect': false
      },);
    } catch (error) {
      print(error);
    }
    socket.onConnect((_) {
      print('socket connect id:${socket.id}');
    });
    socket.onDisconnect((_) => print('disconnect'));
  }

}
