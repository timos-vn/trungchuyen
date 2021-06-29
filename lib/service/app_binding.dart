import 'package:get/get.dart';
import 'package:trungchuyen/service/soket_io_service.dart';
import 'location_service.dart';

class AppBinding extends Bindings {

  @override
  void dependencies() {
    injectService();
  }

  void injectService() {
    // Get.put(SocketIOService());
    // Get.put(LocationService());
    // Get.put(FireBaseService());
  }
}