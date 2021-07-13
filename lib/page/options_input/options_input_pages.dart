import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:trungchuyen/extension/bottom_sheet.dart';
import 'package:trungchuyen/extension/popup_picker.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/themes/font.dart';
import 'package:trungchuyen/utils/utils.dart';
import 'options_input_bloc.dart';
import 'options_input_event.dart';
import 'options_input_state.dart';


class OptionsInputPage extends StatefulWidget {
  const OptionsInputPage({Key key}) : super(key: key);
  @override
  _OptionsInputPageState createState() => _OptionsInputPageState();
}

class _OptionsInputPageState extends State<OptionsInputPage> {

  OptionsInputBloc _bloc;
  String timeName;
  String timeId = "";
  int status;
  String toDate ="";
  String fromDate="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = OptionsInputBloc();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
        body: BlocListener<OptionsInputBloc,OptionsInputState>(
          bloc: _bloc,
            listener: (context, state){
              if (state is WrongDate) {
                Utils.showToast('from_date_before_to_date'.tr);
              }
            },
            child: BlocBuilder<OptionsInputBloc,OptionsInputState>(
              bloc: _bloc,
              builder: (BuildContext context, OptionsInputState state){
                return buildPage(context,state);
              },
            )
        )
    );
  }

  Widget buildPage(BuildContext context,OptionsInputState state){
    return Padding(
      padding: const EdgeInsets.only(top: 35,bottom: 35),
      child: AlertDialog(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                height: 40,
                child: Row(
                  children: [
                    Container(
                      // width: 50,
                      child: Text(
                        "Tìm kiếm".tr,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(width: 5,)
                  ],
                )
            ),
            ///or
            Row(
              children: [
                Expanded(
                  child: Divider(
                    height: 1,
                    color: Colors.blue.withOpacity(0.8),
                  ),
                ),
                Expanded(
                  child: Divider(
                    height: 1,
                    color: Colors.blue.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            ///FromDate
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  //width: 50,
                  child: Text(
                    'FromDate'.tr +' ',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: ()async {
                      final DateTime result = await showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return DateRangePicker(
                              _bloc.dateFrom ?? DateTime.now(),
                              null,
                              minDate: DateTime.now().subtract(const Duration(days: 10000)),
                              maxDate:
                              DateTime.now().add(const Duration(days: 10000)),
                              displayDate: _bloc.dateFrom ?? DateTime.now(),
                            );
                          });
                      if (result != null) {
                        print(result);
                        _bloc.add(DateFrom(result));
                      }
                    },
                    child: Container(
                        height: 30,
                        padding:
                        EdgeInsets.fromLTRB(5, 0, 0, 0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: blackBlur,
                                width: 1)),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _bloc.getStringFromDate(_bloc.dateFrom) ?? '',
                            style: TextStyle(fontSize: 13),
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                    child: Icon(
                      MdiIcons.calendar,
                      color: primaryColor,
                    ),
                  onTap: ()async {
                    final DateTime result = await showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return DateRangePicker(
                            _bloc.dateFrom ?? DateTime.now(),
                            null,
                            minDate: DateTime.now().subtract(const Duration(days: 10000)),
                            maxDate:
                            DateTime.now().add(const Duration(days: 10000)),
                            displayDate: _bloc.dateFrom ?? DateTime.now(),
                          );
                        });
                    if (result != null) {
                      print(result);
                      _bloc.add(DateFrom(result));
                    }
                  },),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ///ToDate
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  //width: 50,
                  child: Text(
                    "ToDate".tr,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                      onTap: ()async {
                        final DateTime result = await showDialog<dynamic>(
                            context: context,
                            builder: (BuildContext context) {
                              return DateRangePicker(
                                _bloc.dateTo ?? DateTime.now(),
                                null,
                                minDate: DateTime.now()
                                    .subtract(const Duration(days: 10000)),
                                maxDate:
                                DateTime.now().add(const Duration(days: 10000)),
                                displayDate: _bloc.dateTo ?? DateTime.now(),
                              );
                            });
                        if (result != null) {
                          print(result);
                          _bloc.add(DateTo(result));
                        }},
                      child: Container(
                          height: 30,
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: blackBlur,
                                  width: 1)),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _bloc.getStringFromDate(_bloc.dateTo) ?? "",
                              style: TextStyle(fontSize: 13),
                            ),
                          ))),
                ),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                    child: Icon(
                      MdiIcons.calendar,
                      color: primaryColor,
                    ),
                    onTap: ()async {
                      final DateTime result = await showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return DateRangePicker(
                              _bloc.dateTo ?? DateTime.now(),
                              null,
                              minDate: DateTime.now().subtract(const Duration(days: 10000)),
                              maxDate:
                              DateTime.now().add(const Duration(days: 10000)),
                              displayDate: _bloc.dateTo ?? DateTime.now(),
                            );
                          });
                      if (result != null) {
                        print(result);
                        _bloc.add(DateTo(result));
                      }}),
              ],
            ),

            SizedBox(height: 25,),
            ///Button
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 90.0,
                      height: 35.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.0), color: grey),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cancel,size: 18,color: Colors.white,),
                          SizedBox(width: 6,),
                          Text(
                            'Cancel'.tr,
                            style: TextStyle(
                              fontFamily: fontSub,
                              fontSize: 12,
                              color: white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if(!Utils.isEmpty(_bloc.dateFrom) && !Utils.isEmpty(_bloc.dateTo)){
                        Navigator.pop(context,[_bloc.getStringFromDateYMD(_bloc.dateFrom),_bloc.getStringFromDateYMD(_bloc.dateTo),]);
                      }else{
                        Utils.showToast('Vui lòng nhập đủ dữ liệu.');
                      }
                    },
                    child: Container(
                      width: 90.0,
                      height: 35.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.0), color: orange),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle,size: 18,color: Colors.white,),
                          SizedBox(width: 4,),
                          Text(
                            'Continues'.tr,
                            style: TextStyle(
                              fontFamily: fontSub,
                              fontSize: 12,
                              color: white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSettings(BuildContext context,List<String> listName, List<String> listID) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
          return ListView.separated(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              separatorBuilder: (BuildContext context, int index)=>Padding(
                padding: const EdgeInsets.only(left: 16,right: 16,),
                child: Divider(),
              ),

              itemBuilder: (BuildContext context, int index){
                return InkWell(
                  onTap: ()=> Navigator.pop(context,[index,listName[index].toString(),listID[index].toString()]),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16,right: 16),
                    child: Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(listName[index]?.toString()??'',style: TextStyle(color: blue.withOpacity(0.5)),),
                          Text(listID[index]?.toString()??'',style: TextStyle(color: blue.withOpacity(0.5)),),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: listName.length
          );
        });
  }

  void showBottomSheetSettingsPanel(BuildContext context,String title ,Widget propertyWidget) {
    showRoundedModalBottomSheet<dynamic>(
        context: context,
        color:Colors.white,
        builder: (BuildContext context) => Container(
          padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
          child: Stack(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(title?.toString()??'Title'.tr,
                    style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 0.34,
                        fontWeight: FontWeight.w500)),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    // color: _model.textColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 50, 0, 0),
                child: propertyWidget)
          ]),
        )).then((value) {
      if(!Utils.isEmpty(value)){
        print(value[2]);
        setState(() {
          setState((){
            timeName = value[1];
            timeId = value[2];
          });
        });
      }
    });
  }
}
