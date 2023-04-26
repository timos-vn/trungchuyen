// import 'package:animator/animator.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:trungchuyen/themes/colors.dart';
// import 'dummy_material.dart';
//
// class DummyBackgroundContent extends StatelessWidget {
//   final accent = Color(0xff8ba38d);
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           height: double.infinity,
//           width: double.infinity,
//           child: SingleChildScrollView(
//             child: Container(
//               color: Colors.grey[400],
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 25,right: 25,bottom: 25,top: 55),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     IntrinsicHeight(
//                       child: Row(
//                         mainAxisSize: MainAxisSize.max,
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           Expanded(
//                             child: IntrinsicHeight(
//                               child: SquareMaterial(),
//                             ),
//                           ),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.stretch,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 TextMaterial(width: 54),
//                                 SquareMaterial(
//                                   color: accent,
//                                 ),
//                                 TextMaterial(width: 104),
//                                 SquareMaterial(),
//                                 TextMaterial(width: 64),
//                                 SquareMaterial(
//                                   color: accent,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SquareMaterial(height:180),
//                     TextMaterial(width: double.infinity),
//                     TextMaterial(width: 140.0),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         offLineMode(),
//       ],
//     );
//   }
//
//   Widget offLineMode() {
//     return Column(
//       children: [
//         Animator(
//           duration: Duration(milliseconds: 500),
//           cycles: 1,
//           builder: (anim) => SizeTransition(
//             sizeFactor: anim,
//             axis: Axis.vertical,
//             child: Container(
//               height: AppBar().preferredSize.height,
//               color: Colors.orange,
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 14, left: 14),
//                 child: Row(
//                   children: <Widget>[
//                     DottedBorder(
//                       color: white,
//                       borderType: BorderType.Circle,
//                       strokeWidth: 2,
//                       child: Padding(
//                         padding: const EdgeInsets.all(4),
//                         child: Icon(
//                           FontAwesomeIcons.cloudMoon,
//                           color:white,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 16,
//                     ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           'You are offline !',
//                           style: Theme.of(Get.context).textTheme.title.copyWith(
//                             fontWeight: FontWeight.bold,
//                             color: white,
//                           ),
//                         ),
//                         Text(
//                           'Go online to strat accepting jobs.',
//                           style: Theme.of(Get.context).textTheme.subtitle1.copyWith(
//                             color: white,
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
