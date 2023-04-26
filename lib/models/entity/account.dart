
import 'package:equatable/equatable.dart';

class AccountInfo extends Equatable {

  final String userName;
  final String pass;

  AccountInfo(
      this.userName,
      this.pass
     );

  AccountInfo.fromDb(Map<String, dynamic> map)
      :
        userName = map['userName'],
        pass = map['pass'];

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['userName'] = userName;
    map['pass'] = pass;
    return map;
  }

  @override
  List<Object> get props => [
    userName,
    pass,
  ];
}
