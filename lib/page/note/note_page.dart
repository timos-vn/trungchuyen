import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trungchuyen/utils/utils.dart';

class NotePage extends StatefulWidget {
  final bool typeView;
  final String reasonOld;

  const NotePage({Key key, this.typeView,this.reasonOld}) : super(key: key);
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  bool _isChecked = true;
  bool _isChecked2 = true;

  List<String> text = ["Đã đón", "Đã thu tiền"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
              height: 350,
              width: double.infinity,
              child: Material(
                  animationDuration: Duration(seconds: 3),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  child: Column(
                    children: [
                      Expanded(
                          flex: 5,
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16))),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Xác nhận đón khách',
                                        style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Divider(),
                                  SizedBox(height: 10,),
                                  CheckboxListTile(
                                    title: Text('Đón khách thành công'),
                                    value: _isChecked,
                                  ),
                                  Visibility(
                                    visible: widget.typeView == true,
                                    child: CheckboxListTile(
                                      title: Text('Đã thu tiền'),
                                      value: _isChecked2,
                                      onChanged: (val) {
                                        setState(() {
                                          _isChecked2 = val;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(right: 20, left: 20),
                            decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.only(bottomRight: Radius.circular(16), bottomLeft: Radius.circular(16))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        'Huỷ',
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: TextButton(
                                      onPressed: (){
                                        String content = '${Utils.isEmpty(widget.reasonOld) ? '' : widget.reasonOld + '/'} [TX]Đón khách thành công';
                                        if(widget.typeView == true){
                                          content = content + ', ' + '[TX]Đã thu tiền';
                                        }
                                       Navigator.pop(context,content);
                                      },
                                      child: Text(
                                        'Đồng ý',
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  )),
            ),
          ),
        ));
  }
}



