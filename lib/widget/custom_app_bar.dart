import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trungchuyen/page/main/main_bloc.dart';
import 'package:trungchuyen/page/main/main_event.dart';
import 'package:trungchuyen/utils/const.dart';
import 'package:trungchuyen/utils/log.dart';
//
// appBar(context){
//   MainBloc _mainBloc;
//   String token;
//   SharedPreferences pref;
//   bool value = false;
//   try {
//     _mainBloc = BlocProvider.of<MainBloc>(context);
//     pref = _mainBloc.pref;
//     token = pref?.getString(Const.ACCESS_TOKEN);
//   } catch (e) {
//     logger.e(e);
//   }
//   return AppBar(
//     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//     automaticallyImplyLeading: false,
//     title: !_mainBloc.isOnline ?  GestureDetector(
//       onTap: (){
//         _mainBloc.add(UpdateStatusDriverEvent(0));
//       },
//       child: Text(
//         'OffLine',
//         style: Theme.of(context).textTheme.title.copyWith(
//           fontWeight: FontWeight.bold,
//           color: Theme.of(context).textTheme.title.color,
//         ),
//         textAlign: TextAlign.center,
//       ),
//     )
//         :
//     GestureDetector(
//       onTap: () async{
//         // _mainBloc.add(UpdateStatusCustomerEvent());
//       },
//       child: Text(
//         'Online',
//         style: Theme.of(context).textTheme.title.copyWith(
//           fontWeight: FontWeight.bold,
//           color: Theme.of(context).textTheme.title.color,
//         ),
//         textAlign: TextAlign.center,
//       ),
//     ),
//     centerTitle: true,
//     actions: [
//       Container(
//         padding: EdgeInsets.only(right: 10),
//         alignment: Alignment.centerRight,
//         child: Switch(
//           activeColor: Colors.orange,
//           hoverColor: Colors.orange,
//           value: value,
//           onChanged: (bool val) {
//             // value = val;
//             if(value == true){
//               value = false;
//               //_mainBloc.add(UpdateStatusDriverEvent(1));
//             }else{
//               value = true;
//             }
//             //_mainBloc.isOnline = value;
//             // _mainBloc.isInProcessPickup = true;
//             print(value);
//             //print(_mainBloc.isOnline);
//             // changeOnline();
//           },
//         ),
//       ),
//     ],
//   );
// }

// class CustomAppBar extends StatefulWidget {
//   @override
//   _CustomAppBarState createState() => _CustomAppBarState();
// }
//
// class _CustomAppBarState extends State<CustomAppBar> {
//   bool value = false;
//     MainBloc _mainBloc;
//   String token;
//   SharedPreferences pref;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     try {
//       _mainBloc = BlocProvider.of<MainBloc>(context);
//       pref = _mainBloc.pref;
//       token = pref?.getString(Const.ACCESS_TOKEN);
//     } catch (e) {
//       logger.e(e);
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 70,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Icon(Icons.menu),
//       Switch(
//           activeColor: Colors.orange,
//           hoverColor: Colors.orange,
//           value: _mainBloc.isOnline,
//           onChanged: (bool val) {
//            setState(() {
//              // value = val;
//              //_mainBloc.add(UpdateStatusDriverEvent(1));
//              _mainBloc.isOnline = val;
//              // _mainBloc.isInProcessPickup = true;
//
//              print(_mainBloc.isOnline);
//              // changeOnline();
//            });
//           },
//         ),
//         ],
//       ),
//     );
//   }
// }
