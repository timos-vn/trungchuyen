import 'package:flutter/material.dart';
import 'package:trungchuyen/models/network/response/list_customer_confirm_response.dart';
import 'package:trungchuyen/themes/images.dart';
import 'package:trungchuyen/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailListConfirm extends StatefulWidget {
  final String nameTrip;
  final List<CustomerLimoConfirmBody> list;
  final String dateStart;
  final String idDriver;
  final String timeStart;
  final int role;
  final int totalCustomer;
  final int typeCustomer;

  const DetailListConfirm({Key key, this.nameTrip,this.list,this.dateStart,this.idDriver,this.timeStart,this.role,this.totalCustomer,this.typeCustomer}) : super(key: key);

  @override
  _DetailListConfirmState createState() => _DetailListConfirmState();
}

class _DetailListConfirmState extends State<DetailListConfirm> {

  List<CustomerLimoConfirmBody> _list = new List<CustomerLimoConfirmBody>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _list.clear();
    widget.list.forEach((element) {
      if(widget.idDriver == element.idTaiXe && widget.dateStart == element.ngayChay && widget.timeStart == element.thoiGianDi && widget.nameTrip == element.tenTuyenDuong){

        var contain =  _list.where((phone) => phone.soDienThoaiKhach == element.soDienThoaiKhach);
        if (contain.isEmpty){
          _list.add(element);
        }else{
          final _customerNews = _list.firstWhere((item) => item.soDienThoaiKhach == element.soDienThoaiKhach);
          if (_customerNews != null){
            _customerNews.soKhach = _customerNews.soKhach + 1;
            String listIdTC = _customerNews.idTrungChuyen + ',' + element.idTrungChuyen;
            _customerNews.idTrungChuyen = listIdTC;
          }
          _list.removeWhere((rm) => rm.soDienThoaiKhach == _customerNews.soDienThoaiKhach);
          _list.add(_customerNews);
        }
      }
    });
    print(_list.length);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: new AppBar(
          title: InkWell(
              onTap: ()=>print(widget.list.length),
              child: Text('Danh sách Khách')),
          centerTitle: true,
        ),
        body: Utils.isEmpty(_list) ?
              Center(child: Text('Có lỗi xảy ra'),) :
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Table(
                border: TableBorder.all(color: Colors.grey),
                columnWidths: {
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(),
                  2: FlexColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 30,right: 30),
                        height: 35,
                        child: Center(child: Text('Thông tin chuyến',style: TextStyle(fontStyle: FontStyle.italic),)),
                      ),
                      Container(
                        height: 35,
                        child: Center(child: Text(widget.nameTrip?.toString()??'')),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Container(
                        height: 35,
                        child: Center(child: Text('Tổng số khách',style: TextStyle(fontStyle: FontStyle.italic),)),
                      ),
                      Container(
                        height: 35,
                        child: Center(child: Text(widget.totalCustomer?.toString()??'')),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Container(
                        height: 35,
                        child: Center(child: Text('Loại khách',style: TextStyle(fontStyle: FontStyle.italic),)),
                      ),
                      Container(
                        height: 35,
                        child: Center(child: Text(!Utils.isEmpty(_list) ? (_list[0].loaiKhach == 1 ? 'Đón' : _list[0].loaiKhach == 2 ? 'Trả' : '') : '')),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Container(
                        height: 35,
                        child: Center(child: Text('Thời gian',style: TextStyle(fontStyle: FontStyle.italic),)),
                      ),
                      Container(
                        height: 35,
                        child: Center(child: Text('${widget.timeStart} - ${widget.dateStart}')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return buildListItem(_list[index],index);
                  }),
            ),
          ],
        )
        ,
      ),
    );
  }

  Widget buildListItem(CustomerLimoConfirmBody item,int index) {
    return Padding(
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${item.tenKhachHang??''}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 5,),
                              Text(
                                '(${item.soDienThoaiKhach??''})',
                                style: TextStyle(fontWeight: FontWeight.normal,color: Colors.grey,fontSize: 11),
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text(
                                'Số khách:',
                                style: TextStyle(color:Colors.red,fontSize: 12,fontStyle: FontStyle.italic),
                              ),
                              SizedBox(width: 4,),
                              Text(
                                '${item.soKhach??''}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(this.context).textTheme.subtitle.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.red,fontSize: 12,fontStyle: FontStyle.italic
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => launch("tel://${item.soDienThoaiKhach}"),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.all(Radius.circular(24))
                        ),
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.phone_callback_outlined,size: 18,color: Colors.white,)),
                  )
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
                  Text( widget.role == 7 ?
                  'Thông tin lái xe Trung chuyển' : 'Thông tin lái xe Limos',
                    style: Theme.of(this.context).textTheme.caption.copyWith(
                      color: Theme.of(this.context).disabledColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${item.hoTenTaiXe??''}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(this.context).textTheme.subtitle.copyWith(
                              fontWeight: FontWeight.normal,
                              color: Theme.of(this.context).textTheme.title.color,
                            ),
                          ),
                          Text(
                            ' / ${item.dienThoaiTaiXe??''}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(this.context).textTheme.subtitle.copyWith(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => launch("tel://${item.dienThoaiTaiXe}"),
                        child: Container(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.phone_callback_outlined)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
