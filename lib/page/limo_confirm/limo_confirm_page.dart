import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as libGetX;
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:trungchuyen/models/network/response/list_customer_confirm_response.dart';
import 'package:trungchuyen/page/limo_confirm/limo_confirm_bloc.dart';
import 'package:trungchuyen/page/limo_confirm/limo_confirm_state.dart';
import 'package:trungchuyen/page/main/main_bloc.dart';
import 'package:trungchuyen/themes/images.dart';
import 'package:trungchuyen/widget/pending_action.dart';
import 'dart:io' show Platform, exit;

import 'limo_confirm_event.dart';


class LimoConfirmPage extends StatefulWidget {
  const LimoConfirmPage({Key key,}) : super(key: key);
  @override
  _LimoConfirmPageState createState() => _LimoConfirmPageState();
}

class _LimoConfirmPageState extends State<LimoConfirmPage>  {

  LimoConfirmBloc _limoConfirmBloc;
  MainBloc _mainBloc;
  @override
  void initState() {
    // TODO: implement initState
    _mainBloc = BlocProvider.of<MainBloc>(context);
    _limoConfirmBloc = LimoConfirmBloc(context);
    _limoConfirmBloc.add(GetListCustomerConfirmEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Khách chờ xác nhận'),
      ),
        body: BlocListener<LimoConfirmBloc,LimoConfirmState>(
          bloc: _limoConfirmBloc,
            listener: (context, state){
              if(state is UpdateStatusCustomerConfirmSuccess){
                _limoConfirmBloc.add(GetListCustomerConfirmEvent());
              }
            },
            child: BlocBuilder<LimoConfirmBloc,LimoConfirmState>(
              bloc: _limoConfirmBloc,
              builder: (BuildContext context, LimoConfirmState state){
                return buildPage(context,state);
              },
            )
        ));
  }

  Widget buildPage(BuildContext context,LimoConfirmState state){
    return Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          child: LiquidPullToRefresh(
            showChildOpacityTransition: false,
            onRefresh: () => Future.delayed(Duration.zero).then(
                    (_) => _limoConfirmBloc
                    .add(GetListCustomerConfirmEvent())),
            child: Scrollbar(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _limoConfirmBloc.listCustomerConfirmLimo.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildListItem(_limoConfirmBloc.listCustomerConfirmLimo[index],index);
                    })
            ),
          ),
        ),
        Visibility(
          visible: state is LimoConfirmLoading,
          child: PendingAction(),
        ),
      ],
    );
  }

  Widget buildListItem(CustomerLimoConfirmBody item,int index) {
    return GestureDetector(
        onTap: () {
          _limoConfirmBloc.add(UpdateStatusCustomerConfirmMapEvent(status: 2,idTrungChuyen:item.idTrungChuyen));
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 16, top: 8, bottom: 8),
          child:  Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color:  Theme.of(this.context).scaffoldBackgroundColor,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: [
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
                        ],
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.all(Radius.circular(32))
                        ),
                        child: Center(
                          child: Text(
                            index % item.loaiKhach == 1 ? 'Trả' : 'Đón',
                            style:TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 12
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
                        '${item.hoTenTaiXe??''}' + " / " + '${item.dienThoaiTaiXe??''}',
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
                              'Số điện thoại khách',
                              style: Theme.of(this.context).textTheme.caption.copyWith(
                                color: Theme.of(this.context).disabledColor,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${item.soDienThoaiKhach??''}',
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
                      Visibility(
                        visible: _limoConfirmBloc.role == '7',
                        child: GestureDetector(
                        onTap: () {

                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color:  Colors.purple,
                              borderRadius: BorderRadius.all(Radius.circular(16))
                          ),
                          child: Text('Xác nhận khách',style: TextStyle(color: Colors.white,fontSize: 10),),
                        ),
                      ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
