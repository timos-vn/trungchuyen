import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/utils/utils.dart';

class ModalInsideModal extends StatelessWidget {
  final bool? reverse;
  final String? title;
  final List<String>? listName;
  final List<String>? listId;

  const ModalInsideModal({required Key key, this.reverse = false,this.title,this.listName,this.listId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
              leading: Container(),
              middle: Text(title.toString())),
          child: SafeArea(
            bottom: false,
            child: ListView.separated(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            separatorBuilder: (BuildContext context, int index)=>Padding(
              padding: const EdgeInsets.only(left: 16,right: 16,),
              child: Divider(),
            ),

            itemBuilder: (BuildContext context, int index){
              return InkWell(
                onTap: ()=> Navigator.pop(context,[index,listName![index].toString(),listId![index]]),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16,right: 16),
                  child: Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(listName![index].toString(),style: TextStyle(color: blue.withOpacity(0.5)),),
                        Text(!Utils.isEmpty(listId!) ? listId![index].toString() : '',style: TextStyle(color: blue.withOpacity(0.5)),),
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: listName!.length
          )
      ),
    ));
  }
}
