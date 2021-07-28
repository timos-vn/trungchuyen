import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trungchuyen/page/account/account_bloc.dart';
import 'package:trungchuyen/page/account/account_event.dart';
import 'package:trungchuyen/page/account/account_state.dart';
import 'package:trungchuyen/themes/colors.dart';
import 'package:trungchuyen/widget/ink_well_custom.dart';
import 'package:trungchuyen/widget/inputDropdown.dart';
import 'package:trungchuyen/widget/pending_action.dart';

const double _kPickerSheetHeight = 216.0;

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> listGender = [{"id": '0',"name" : 'Male',},{"id": '1',"name" : 'Female',}];
  TextEditingController fullName = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  String selectedGender;
  String lastSelectedValue;
  DateTime date = DateTime.now();
  var _image;

  AccountBloc _accountBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _accountBloc = AccountBloc(context);
  }

  Future getImageLibrary() async {
    var gallery = await ImagePicker.pickImage(source: ImageSource.gallery,maxWidth: 700);
    setState(() {
      _image = gallery;
    });
  }

  Future cameraImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera,maxWidth: 700);
    setState(() {
      _image = image;
    });
  }


  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String value) {
      if (value != null) {
        setState(() { lastSelectedValue = value; });
      }
    });
  }

  selectCamera () {
    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
          title: const Text('Select Camera'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text('Camera'),
              onPressed: () {
                Navigator.pop(context, 'Camera');
                cameraImage();
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Photo Library'),
              onPressed: () {
                Navigator.pop(context, 'Photo Library');
                getImageLibrary();
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('Cancel'),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
          )
      ),
    );
  }

  submit(){
    final FormState form = formKey.currentState;
    form.save();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return BlocListener<AccountBloc,AccountState>(
        bloc: _accountBloc,
        listener: (context,state){

        },
        child: BlocBuilder<AccountBloc,AccountState>(
          bloc: _accountBloc,
          builder: (BuildContext context, AccountState state){
            return buildPage(context,state);
          },
    ),
    );
  }

  Widget buildPage(BuildContext context, AccountState state){
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: white,
        title: Text(
          'My profile',
          style: TextStyle(color: black),
        ),
      ),
      body: Stack(
        children: [
          Scrollbar(
            child: SingleChildScrollView(
              child: InkWellCustom(
                  onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
                  child: Form(
                    key: formKey,
                    child: Container(
                      color: Color(0xffeeeeee),
                      child: Column(
                        children: <Widget>[
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsets.only(bottom: 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Material(
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: new ClipRRect(
                                      borderRadius: new BorderRadius.circular(100.0),
                                      child:_image == null
                                          ?new GestureDetector(
                                          onTap: (){selectCamera();},
                                          child: new Material(
                                            elevation: 10.0,
                                            color: Colors.white,
                                            shape: CircleBorder(),
                                            child: Padding(
                                              padding: EdgeInsets.all(2.0),
                                              child: SizedBox(
                                                height: 80,
                                                width: 80,
                                                child: CircleAvatar(
                                                    radius: 30,
                                                    backgroundColor: Colors.transparent,
                                                    backgroundImage: CachedNetworkImageProvider(
                                                      "https://source.unsplash.com/1600x900/?portrait",
                                                    )
                                                ),
                                              ),
                                            ),
                                          ),
                                      ): new GestureDetector(
                                          onTap: () {selectCamera();},
                                          child: new Container(
                                            height: 80.0,
                                            width: 80.0,
                                            child: Image.file(_image,fit: BoxFit.cover, height: 800.0,width: 80.0,),
                                          )
                                      )
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 20.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          TextField(
                                            style: TextStyle(
                                              color: const Color(0XFF000000),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                labelStyle: TextStyle(
                                                  color: const Color(0XFF000000),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                hintStyle: TextStyle(color: Colors.white),
                                                counterStyle: TextStyle(
                                                  color: const Color(0XFF000000),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                hintText: "Họ tên",

                                                border: UnderlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.white))),
                                            controller: fullName,
                                            onChanged: (String _firstName) {

                                            },
                                          ),
                                          TextField(
                                            style: TextStyle(
                                              color: const Color(0XFF000000),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                labelStyle: TextStyle(
                                                  color: const Color(0XFF000000),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                hintStyle: TextStyle(color: Colors.white),
                                                counterStyle: TextStyle(
                                                  color: const Color(0XFF000000),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                hintText: "Số điện thoại",
                                                border: UnderlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.white))),
                                            controller: phone,
                                            onChanged: (String _lastName) {

                                            },
                                          ),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsets.only(top: 10.0),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          padding: EdgeInsets.only(right: 10.0),
                                          child: Text(
                                            "Email",
                                            style: TextStyle(
                                              color: const Color(0XFF000000),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: TextField(
                                          keyboardType: TextInputType.emailAddress,
                                          style: TextStyle(
                                            color: const Color(0XFF000000),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              labelStyle: TextStyle(
                                                color: const Color(0XFF000000),
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              hintStyle:
                                              TextStyle(color: Colors.white),
                                              counterStyle: TextStyle(
                                                color: const Color(0XFF000000),
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white))
                                          ),
                                          controller: email,
                                          onChanged: (String _email) {

                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          padding: EdgeInsets.only(right: 10.0),
                                          child: Text(
                                            "Gender",
                                            style: TextStyle(
                                              color: const Color(0XFF000000),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: new DropdownButtonHideUnderline(
                                            child: Container(
                                              // padding: EdgeInsets.only(bottom: 12.0),
                                              child: new InputDecorator(
                                                decoration: const InputDecoration(
                                                ),
                                                isEmpty: selectedGender == null,
                                                child: new DropdownButton<String>(
                                                  hint: new Text("Gender",style: TextStyle(
                                                    color: const Color(0XFF000000),
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.normal,
                                                  ),),
                                                  value: selectedGender,
                                                  isDense: true,
                                                  onChanged: (String newValue) {
                                                    setState(() {
                                                      selectedGender = newValue;
                                                      print(selectedGender);
                                                    });
                                                  },
                                                  items: listGender.map((value) {
                                                    return new DropdownMenuItem<String>(
                                                      value: value['id'],
                                                      child: new Text(value['name'],style: TextStyle(
                                                        color: const Color(0XFF000000),
                                                        fontSize: 14.0,
                                                        fontWeight: FontWeight.normal,
                                                      ),),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            )
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          padding: EdgeInsets.only(right: 10.0),
                                          child: Text(
                                            "Birthday",
                                            style: TextStyle(
                                              color: const Color(0XFF000000),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child:  GestureDetector(
                                            onTap: () {
                                              showCupertinoModalPopup<void>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return _buildBottomPicker(
                                                    CupertinoDatePicker(
                                                      mode: CupertinoDatePickerMode.date,
                                                      initialDateTime: date,
                                                      onDateTimeChanged: (DateTime newDateTime) {
                                                        setState(() {
                                                          date = newDateTime;
                                                        });
                                                      },
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: new InputDropdown(
                                              valueText: DateFormat.yMMMMd().format(date),
                                              valueStyle: TextStyle(color: Colors.black),
                                            )
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: new ButtonTheme(
                                    height: 45.0,
                                    minWidth: MediaQuery.of(context).size.width-50,
                                    child: RaisedButton.icon(
                                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                                      elevation: 0.0,
                                      color: primaryColor,
                                      icon: new Text(''),
                                      label: new Text('Lưu', style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                      onPressed: (){
                                       // _accountBloc.add(UpdateInfo(phone, email, fullName, companyId, role));
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ),
            ),
          ),
          Visibility(
            visible: state is AccountLoading,
            child: PendingAction(),
          ),
        ],
      ),
    );
  }
}
