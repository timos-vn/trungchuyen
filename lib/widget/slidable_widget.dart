// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
//
// enum SlidableAction { archive, share, more, delete }
//
// class SlidableWidget<T> extends StatelessWidget {
//   final Widget child;
//   final Function(SlidableAction action) onDismissed;
//
//   const SlidableWidget({
//     required this.child,
//     required this.onDismissed,
//     required Key key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) => Slidable(
//         key: const ValueKey(1),
//         endActionPane: ActionPane(
//           motion: ScrollMotion(),
//           dismissible: DismissiblePane(onDismissed: ()=>print('12333')),
//           children: [
//             SlidableAction(
//               onPressed: onDismissed(),
//               backgroundColor: Color(0xFF7BC043),
//               foregroundColor: Colors.white,
//               icon: Icons.archive,
//               label: 'Xoá',
//             ),
//           ],
//         ),
//         // actionPane: SlidableDrawerActionPane(),
//         child: child,
//         /// right side
//       //   secondaryActions: <Widget>[
//       //     IconSlideAction(
//       //       caption: 'More',
//       //       color: Colors.black45,
//       //       icon: Icons.more_horiz,
//       //       onTap: () => onDismissed(SlidableAction.more),
//       //     ),
//       //     IconSlideAction(
//       //       caption: 'Delete',
//       //       color: Colors.red,
//       //       icon: Icons.delete,
//       //       onTap: () => onDismissed(SlidableAction.delete),
//       //     ),
//       //   ],
//       );
// }
