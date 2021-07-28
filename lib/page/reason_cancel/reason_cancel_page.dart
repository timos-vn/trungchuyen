import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trungchuyen/utils/utils.dart';

class ReasonCancelPage extends StatefulWidget {
  @override
  _ReasonCancelPageState createState() => _ReasonCancelPageState();
}

class _ReasonCancelPageState extends State<ReasonCancelPage> {
  TextEditingController contentController = TextEditingController();
  int groupValue = 0;
  FocusNode focusNodeContent = FocusNode();
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
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Lý do',
                                        style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
                                      )),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: InkWell(
                                          onTap: (){
                                            setState(() {
                                              groupValue = 0;
                                            });
                                          },
                                          child: Text(
                                            'Khách không liên lạc được',
                                            style: TextStyle(color: Colors.black, fontSize: 15),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Radio(
                                              value: 0,
                                              groupValue: groupValue,
                                              onChanged: (val) {
                                                setState(() {
                                                  groupValue = val;
                                                  print(val);
                                                });
                                              },
                                            ),),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: InkWell(
                                          onTap: (){
                                            setState(() {
                                              groupValue = 1;
                                            });
                                          },
                                          child: Text(
                                            'Khách yêu cầu huỷ',
                                            style: TextStyle(color: Colors.black, fontSize: 15),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Radio(
                                              value: 1,
                                              groupValue: groupValue,
                                              onChanged: (val) {
                                                setState(() {
                                                  groupValue = val;
                                                  print(val);
                                                });
                                              },
                                            ),),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: InkWell(
                                          onTap: (){
                                            setState(() {
                                              groupValue = 2;
                                            });
                                          },
                                          child: Text(
                                            'Lý do khác',
                                            style: TextStyle(color: Colors.black, fontSize: 15),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Radio(
                                            value: 2,
                                            groupValue: groupValue,
                                            onChanged: (val) {
                                              setState(() {
                                                groupValue = val;
                                                print(val);
                                              });
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () => FocusScope.of(context).requestFocus(focusNodeContent),
                                    child: Container(
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                      ),
                                      child: TextField(
                                        maxLines: 3,
                                        // obscureText: true,
                                        controller: contentController,
                                        decoration: new InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.all(8),
                                          hintText: 'Vui lòng nhập lý do',
                                          hintStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                                        ),
                                        // focusNode: focusNodeContent,
                                        keyboardType: TextInputType.text,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 14),
                                        //textInputAction: TextInputAction.none,
                                      ),
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
                                        if(groupValue == 0){
                                          Navigator.pop(context,'Khách không liên lạc được');
                                        }else if(groupValue == 1){
                                          Navigator.pop(context,'Khách yêu cầu huỷ');
                                        }else if(groupValue == 2){
                                          Navigator.pop(context, !Utils.isEmpty(contentController.text) ? contentController.text : 'Lý do khác');
                                        }
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



