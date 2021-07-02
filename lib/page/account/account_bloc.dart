import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trungchuyen/models/network/service/network_factory.dart';
import 'package:trungchuyen/page/account/account_event.dart';

import 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent,AccountState> {

  BuildContext context;
  NetWorkFactory _networkFactory;
  AccountBloc(this.context){
    _networkFactory = NetWorkFactory(context);
  }

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }

  @override
  // TODO: implement initialState
  AccountState get initialState => AccountInitial();

}