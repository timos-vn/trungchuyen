import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:get/get.dart' as libGetX;
import 'package:trungchuyen/models/network/response/notification_response.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/themes/font.dart';
import 'package:trungchuyen/themes/images.dart';
import 'package:trungchuyen/utils/const.dart';
import 'package:trungchuyen/utils/utils.dart';
import 'package:trungchuyen/widget/pending_action.dart';
import 'package:trungchuyen/widget/slidable_widget.dart';

import 'notification_bloc.dart';
import 'notification_event.dart';
import 'notification_sate.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  NotificationBloc _bloc;
  ScrollController _scrollController;
  final _scrollThreshold = 200.0;
  bool _hasReachedMax = true;
  List<NotificationDataResponse> _list = new List<NotificationDataResponse>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = NotificationBloc(context);
    _bloc.add(GetListNotification());
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScroll - currentScroll <= _scrollThreshold && !_hasReachedMax && _bloc.isScroll == true) {
        _bloc.add(GetListNotification(isLoadMore: true));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationBloc,NotificationState>(
      bloc: _bloc,
      listener: (context,state){
        if(state is GetListNotificationFailure){
          Utils.showToast(state.error.toString());
        }
        if(state is UpdateNotificationFailure){
          Utils.showToast(state.error.toString());
        }
        if(state is GetListNotificationSuccess){
          _list = _bloc.listNotification;
        }
        if(state is UpdateNotificationSuccess){
          Utils.showToast('Successful'.tr);
        }
      },
      child: BlocBuilder<NotificationBloc,NotificationState>(
        bloc: _bloc,
        builder: (BuildContext context, NotificationState state){
          return Scaffold(
            appBar: new AppBar(
              centerTitle: true,
              backgroundColor: Colors.white,
              title: Text(
                'Notification'.tr,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: fontApp, color: Colors.black),
              ),
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: IconButton(
                      icon: Icon(Icons.delete_forever,color: Colors.black,),
                    onPressed: () async {
                      //_bloc.add(UpdateAllNotificationEvent(ite));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                      icon: Icon(Icons.mark_chat_read,color: Colors.black,),
                    onPressed: () => _bloc.add(UpdateAllNotificationEvent()),
                  ),
                )
              ],
            ),
            body: buildPage(context,state),
          );
        },
      ),
    );
  }

  Widget buildPage(BuildContext context, NotificationState state) {

    int length = _list?.length ?? 0;
    if (state is GetListNotificationSuccess) {
      _hasReachedMax = length < _bloc.currentPage * 20;
    }
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                LiquidPullToRefresh(
                  showChildOpacityTransition: false,
                  onRefresh: () => Future.delayed(Duration.zero).then((_) => _bloc.add(GetListNotification(isRefresh: true))),
                  child: ListView.separated(
                    controller: _scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: 5),
                    separatorBuilder: (context, index) => Container(),
                    shrinkWrap: true,
                    itemCount: length == 0 ? length : _hasReachedMax ? length : length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      return index >= length ?
                      Container(
                        height: 100.0,
                        color: white,
                        child: PendingAction(),
                      )
                          :
                      Card(
                        child: SlidableWidget(
                          child: buildListTile(_list[index]),
                          onDismissed: (action) => dismissSlidableItem(context, index, action,_list[index]),
                        ),
                      );
                    },
                  ),
                ),
                Visibility(
                  visible: state is EmptyDataState,
                  child: Center(
                    child: Text('NoData'.tr),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: state is NotificationLoading,
            child: PendingAction(),
          ),
        ],
      ),
    );
  }

  Widget buildListTile(NotificationDataResponse item) => Container(
    color: item.daDoc == true ? white : grey_100,
    child: ListTile(
      onTap: ()=>_bloc.add(UpdateNotificationEvent(item.id)),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: AssetImage(notify),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.tieuDe,
            style: TextStyle(color: black,
                fontWeight:
                item.daDoc == true ? FontWeight.normal : FontWeight.bold),
            overflow: TextOverflow.fade,
          ),
          const SizedBox(height: 4),
          Text(item.noiDung)
        ],
      ),
      trailing:Text(
        Utils.parseStringDateToString(
            item?.ngayTao,
            Const.DATE_SV,
            Const.DATE_FORMAT_1) ??
            "",
        style: TextStyle(
            fontSize: 12.0,
            color: grey,
            fontWeight: FontWeight.normal),
      ),
    ),
  );

  void dismissSlidableItem(BuildContext context, int index, SlidableAction action,NotificationDataResponse item) {
    switch (action) {
      case SlidableAction.more:
        print('Selected more');
        break;
      case SlidableAction.delete:
        showDialog( item,index);
        break;
    }
  }

  void showDialog(NotificationDataResponse item,int index) async{
    _bloc.add(DeleteNotificationEvent(item.id));
    setState(() {
      _list.removeAt(index);
    });
  }
}
