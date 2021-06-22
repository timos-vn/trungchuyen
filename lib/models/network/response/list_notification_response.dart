import 'dart:convert';

import 'package:trungchuyen/utils/utils.dart';

class ListNotificationData {

  List<NotificationData> notifications;

  ListNotificationData({ this.notifications});

  ListNotificationData.fromJson(Map<String, dynamic> json) {
    if (json['notifications'] != null) {
      notifications = new List<NotificationData>();
      json['notifications'].forEach((v) {
        notifications.add(new NotificationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notifications != null) {
      data['notifications'] =
          this.notifications.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationData {
  // String title;
  // String body;
  DataDetail listDataDetail;
  // List<DataDetail> listDataDetail;

  NotificationData(
      {

        // this.title,
        // this.body,
        this.listDataDetail
      });

  NotificationData.fromJson(Map<String, dynamic> jsons) {

    // title = jsons['title'];
    // body = jsons['body'];
    listDataDetail=jsons['data'];
    // if (!Utils.isEmpty(jsons['data'])) {
    //   final jsonMap = json.decode(jsons['data']);
    //   listDataDetail = new List<DataDetail>();
    //   listDataDetail.add(new DataDetail.fromJson(jsonMap));
    //   print(jsonMap.runtimeType);
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    // data['title'] = this.title;
    // data['body'] = this.body;
    data['data'] = this.listDataDetail;
    // if (this.listDataDetail != null) {
    //   data['data'] =  this.listDataDetail.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class DataDetail{
  String loaiKhach;
  String soKhach;
  String event;
  String idChuyenTruyens;
  String thoiGian;
  String chuyen;

  DataDetail({this.loaiKhach,this.soKhach,this.event,this.idChuyenTruyens,this.thoiGian,this.chuyen});

  DataDetail.fromJson(Map<String, dynamic> json) {
    loaiKhach = json['LoaiKhach'];
    soKhach = json['SoKhach'];
    event = json['EVENT'];
    idChuyenTruyens = json['IdChuyenTruyens'];
    thoiGian = json['ThoiGian'];
    chuyen = json['Chuyen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LoaiKhach'] = this.loaiKhach;
    data['SoKhach'] = this.soKhach;
    data['EVENT'] = this.event;
    data['IdChuyenTruyens'] = this.idChuyenTruyens;
    data['ThoiGian'] = this.thoiGian;
    data['Chuyen'] = this.chuyen;
    return data;
  }
}