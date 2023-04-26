// import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart' as libGetX;
import 'package:trungchuyen/models/network/response/notification_response.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/themes/font.dart';
import 'package:trungchuyen/utils/const.dart';
import 'package:trungchuyen/utils/utils.dart';
import 'package:trungchuyen/widget/pending_action.dart';

import '../../widget/custom_question.dart';
import 'notification_bloc.dart';
import 'notification_event.dart';
import 'notification_sate.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  late NotificationBloc _bloc;
  ScrollController _scrollController  = ScrollController();
  final _scrollThreshold = 200.0;
  bool _hasReachedMax = true;
  List<NotificationDataResponse> _list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = NotificationBloc(context);

    _bloc.add(GetPrefs());


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
        if(state is GetPrefsSuccess){
          _bloc.add(GetListNotification());
        }
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
          //Utils.showToast('Successful'.tr);
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
                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: fontApp, color: Colors.black),
              ),
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () async {
                  Navigator.of(context).pop(['Reload UnNotification']);
                },
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: IconButton(
                    icon: Icon(Icons.delete_forever,color: Colors.black,),
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return WillPopScope(
                              onWillPop: () async => false,
                              child: const CustomQuestionComponent(
                                showTwoButton: true,
                                iconData: Icons.delete_forever_outlined,
                                title: 'Bạn chuẩn bị xoá thông báo',
                                content: 'Hãy chắc chắn bạn muốn điều này xảy ra?',
                              ),
                            );
                          }).then((value){
                        if(value != null){
                          if(!Utils.isEmpty(value) && value == 'Yeah'){
                            _bloc.add(DeleteAllNotificationEvent());
                                _list.clear();
                          }
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    icon: Icon(Icons.mark_chat_read,color: Colors.black,),
                    onPressed: () {
                      _bloc.add(UpdateAllNotificationEvent());
                      _bloc.add(GetListNotification());
                    },
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

    int length = _list.length;
    if (state is GetListNotificationSuccess) {
      _hasReachedMax = length < _bloc.currentPage! * 20;
    }
    return Scaffold(
      backgroundColor: dark_text.withOpacity(0.1),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                RefreshIndicator(
                  color: Colors.orange,
                  onRefresh: () => Future.delayed(Duration.zero).then((_) => _bloc.add(GetListNotification(isRefresh: true))),
                  child: ListView.separated(
                    controller: _scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: 5,bottom: MediaQuery.of(context).size.height * 0.1),
                    separatorBuilder: (context, index) => Container(height: 10,),
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
                      Slidable(
                        key: const ValueKey(1),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dragDismissible: false,
                          children: [
                            SlidableAction(
                              onPressed:(_) {
                                _bloc.add(DeleteNotificationEvent(_list[index].id.toString()));
                                setState(() {
                                  _list.removeAt(index);
                                });
                              },
                              backgroundColor: const Color(0xFFC90000),
                              foregroundColor: Colors.white,
                              icon: Icons.delete_forever,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 6,right: 6),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(25))
                            ),
                            child: Card(
                              borderOnForeground: true,
                              elevation: 5,
                              child: buildListTile(_list[index]),
                            ),
                          ),
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
    color: item.daDoc == true ? white : Colors.grey.withOpacity(0.3),
    child: ListTile(
      onTap: (){
        _bloc.add(UpdateNotificationEvent(item.id.toString()));
        _bloc.add(GetListNotification());
      },
      contentPadding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6,
      ),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.red,
        child: Icon(Icons.email_rounded,color: white,),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.tieuDe?.toString()??'',
            style: TextStyle(color: black,fontSize: 14,
                fontWeight:
                item.daDoc == true ? FontWeight.normal : FontWeight.bold),
            overflow: TextOverflow.fade,
          ),
          const SizedBox(height: 4),
          Text(item.noiDung.toString(),style: TextStyle(fontSize: 12,),)
        ],
      ),
      trailing:Text(
        Utils.parseDateTToString(
          item.ngayTao.toString(),
          Const.DATE_SV,).split('T')[0].toString() + '\n' + '  '+ Utils.parseDateTToString(
          item.ngayTao.toString(),
          Const.DATE_SV,).split('T')[1].toString(),
        style: TextStyle(
            fontSize: 11.0,
            color: Colors.black,
            fontWeight: FontWeight.normal),
      ),
    ),
  );
}
