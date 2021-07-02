import 'package:equatable/equatable.dart';

class NotificationOfLimo extends Equatable {
  final String idTrungChuyen;
  final String nameTC;
  final String phoneTC;
  final String numberCustomer;
  final String listIdTAIXELIMO;
  final String idDriverTC;


  NotificationOfLimo(
      {this.idTrungChuyen,
        this.nameTC,
        this.phoneTC,
        this.numberCustomer,
        this.listIdTAIXELIMO,
        this.idDriverTC
      });

  NotificationOfLimo.fromDb(Map<String, dynamic> map)
      :
        idTrungChuyen = map['idTrungChuyen'],
        nameTC = map['nameTC'],
        phoneTC = map['phoneTC'],
        numberCustomer = map['numberCustomer'],
        listIdTAIXELIMO = map['listIdTAIXELIMO'],
        idDriverTC = map['idDriverTC'];

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['idTrungChuyen'] = idTrungChuyen;
    map['nameTC'] = nameTC;
    map['phoneTC'] = phoneTC;
    map['numberCustomer'] = numberCustomer;
    map['listIdTAIXELIMO'] = listIdTAIXELIMO;
    map['idDriverTC'] = idDriverTC;
    return map;
  }

  @override
  List<Object> get props => [
    idTrungChuyen,
    nameTC,
    phoneTC,
    numberCustomer,
    listIdTAIXELIMO,
    idDriverTC,
  ];
}
