// import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/themes/font.dart';
import 'package:trungchuyen/utils/utils.dart';
import '../../utils/const.dart';
import 'options_input_bloc.dart';
import 'options_input_event.dart';
import 'options_input_state.dart';


class OptionsInputPage extends StatefulWidget {
  const OptionsInputPage({Key? key}) : super(key: key);
  @override
  _OptionsInputPageState createState() => _OptionsInputPageState();
}

class _OptionsInputPageState extends State<OptionsInputPage> {

  late OptionsInputBloc _bloc;
  String? timeName;
  String? timeId = "";
  int status = 0;
  String toDate ="";
  String fromDate="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = OptionsInputBloc(context);
    _bloc.add(GetPrefs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
        body: BlocListener<OptionsInputBloc,OptionsInputState>(
          bloc: _bloc,
            listener: (context, state){
              if (state is WrongDate) {
                Utils.showToast('Ngày sau phải lớn hơn ngày trước');
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
                          '${_bloc.getStringFromDate(_bloc.dateFrom!)}',
                          style: TextStyle(fontSize: 13),
                        ),
                      )),
                ),
                SizedBox(
                  width: 20,
                ),
                // SizedBox(
                //   // height: 40,
                //   width: 50,
                //   child: DateTimePicker(
                //     type: DateTimePickerType.date,
                //     // dateMask: 'd MMM, yyyy',
                //     initialValue: DateTime.now().toString(),
                //     firstDate: DateTime(2000),
                //     lastDate: DateTime(2100),
                //     decoration:const InputDecoration(
                //       suffixIcon: Icon(Icons.event,color: Colors.orange,size: 22,),
                //       contentPadding: EdgeInsets.only(left: 12),
                //       border: InputBorder.none,
                //     ),
                //     style:const TextStyle(fontSize: 13),
                //     locale: const Locale("vi", "VN"),
                //     // icon: Icon(Icons.event),
                //     selectableDayPredicate: (date) {
                //       return true;
                //     },
                //     onChanged: (result){
                //       DateTime? dateOrder = result as DateTime?;
                //       DateTime dateTime = Utils.parseStringToDate(dateOrder.toString(), Const.DATE_SV_FORMAT_2);
                //       _bloc.add(DateFrom(dateTime));
                //     },
                //     validator: (result) {
                //
                //       return null;
                //     },
                //     onSaved: (val){
                //       print('asd$val');
                //     },
                //   ),
                // ),
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
                          "${_bloc.getStringFromDate(_bloc.dateTo!)}",
                          style: TextStyle(fontSize: 13),
                        ),
                      )),
                ),
                SizedBox(
                  width: 20,
                ),
                // SizedBox(
                //   // height: 40,
                //   width: 50,
                //   child: DateTimePicker(
                //     type: DateTimePickerType.date,
                //     // dateMask: 'd MMM, yyyy',
                //     initialValue: DateTime.now().toString(),
                //     firstDate: DateTime(2000),
                //     lastDate: DateTime(2100),
                //     decoration:const InputDecoration(
                //       suffixIcon: Icon(Icons.event,color: Colors.orange,size: 22,),
                //       contentPadding: EdgeInsets.only(left: 12),
                //       border: InputBorder.none,
                //     ),
                //     style:const TextStyle(fontSize: 13),
                //     locale: const Locale("vi", "VN"),
                //     // icon: Icon(Icons.event),
                //     selectableDayPredicate: (date) {
                //       return true;
                //     },
                //     onChanged: (result){
                //       DateTime? dateOrder = result as DateTime?;
                //       DateTime dateTime = Utils.parseStringToDate(dateOrder.toString(), Const.DATE_SV_FORMAT_2);
                //       _bloc.add(DateTo(dateTime));
                //     },
                //     validator: (result) {
                //
                //       return null;
                //     },
                //     onSaved: (val){
                //       print('asd$val');
                //     },
                //   ),
                // ),
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
                      if(!Utils.isEmpty(_bloc.dateFrom!) && !Utils.isEmpty(_bloc.dateTo!)){
                        Navigator.pop(context,[_bloc.getStringFromDateYMD(_bloc.dateFrom!),_bloc.getStringFromDateYMD(_bloc.dateTo!),]);
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
                          Text(listName[index].toString(),style: TextStyle(color: blue.withOpacity(0.5)),),
                          Text(listID[index].toString(),style: TextStyle(color: blue.withOpacity(0.5)),),
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
}
