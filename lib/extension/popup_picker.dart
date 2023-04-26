// ///Package import
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// ///Date picker imports
// import 'package:syncfusion_flutter_datepicker/datepicker.dart' as _picker;
//
// /// Core import
// import 'package:syncfusion_flutter_core/core.dart';
// import 'package:syncfusion_flutter_core/localizations.dart';
// import 'package:trungchuyen/extension/sample_model.dart';
// import 'package:trungchuyen/extension/sample_view.dart';
//
// ///Local import
//
// /// Renders datepicker with popup menu
// class PopUpDatePicker extends SampleView {
//   /// Creates datepicker with popup menu
//   const PopUpDatePicker(Key key) : super(key: key);
//
//   @override
//   _PopUpDatePickerState createState() => _PopUpDatePickerState();
// }
//
// class _PopUpDatePickerState extends SampleViewState
//     with SingleTickerProviderStateMixin {
//   _PopUpDatePickerState();
//
//   DateTime _startDate;
//   DateTime _endDate;
//   int _value;
//
//   @override
//   void initState() {
//     _startDate = DateTime.now();
//     _endDate = DateTime.now().add(const Duration(days: 1));
//     _value = 1;
//     super.initState();
//   }
//
//   /// Update the selected date for the date range picker based on the date selected,
//   /// when the trip mode set one way.
//   void _onSelectedDateChanged(DateTime date) {
//     if (date == null || date == _startDate) {
//       return;
//     }
//
//     setState(() {
//       final Duration difference = _endDate.difference(_startDate);
//       _startDate = DateTime(date.year, date.month, date.day);
//       _endDate = _startDate.add(difference);
//     });
//   }
//
//   /// Update the selected range based on the range selected in the pop up editor,
//   /// when the trip mode set as round trip.
//   void _onSelectedRangeChanged(_picker.PickerDateRange dateRange) {
//     final DateTime startDateValue = dateRange.startDate;
//     DateTime endDateValue = dateRange.endDate;
//     endDateValue ??= startDateValue;
//     setState(() {
//       if (startDateValue.isAfter(endDateValue)) {
//         _startDate = endDateValue;
//         _endDate = startDateValue;
//       } else {
//         _startDate = startDateValue;
//         _endDate = endDateValue;
//       }
//     });
//   }
//
//   Widget _getBooking() {
//     return Card(
//         elevation: 10,
//         margin: model.isWeb
//             ? const EdgeInsets.fromLTRB(30, 20, 30, 5)
//             : const EdgeInsets.all(30),
//         child: Container(
//             color: model.cardThemeColor,
//             child: ListView(
//                 padding: model.isWeb
//                     ? const EdgeInsets.fromLTRB(30, 10, 10, 5)
//                     : const EdgeInsets.fromLTRB(30, 20, 10, 10),
//                 children: <Widget>[
//                   Container(
//                     padding: const EdgeInsets.symmetric(vertical: 5),
//                     child: Text(
//                       'Book a Flight',
//                       style: TextStyle(
//                           color: model.textColor,
//                           backgroundColor: Colors.transparent,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 20),
//                     ),
//                   ),
//                   Container(
//                       padding: const EdgeInsets.all(0),
//                       child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: <Widget>[
//                             Expanded(
//                               flex: 5,
//                               child: RawMaterialButton(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(5, 5, 10, 5),
//                                   onPressed: () {
//                                     setState(() {
//                                       _value = 0;
//                                     });
//                                   },
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Icon(
//                                         _value == 0
//                                             ? Icons.radio_button_checked
//                                             : Icons.radio_button_unchecked,
//                                         color: model.backgroundColor,
//                                         size: 22,
//                                       ),
//                                       SizedBox(
//                                         width: 8,
//                                       ),
//                                       Text(
//                                         'One-way',
//                                         style: TextStyle(
//                                             fontSize: 16.0,
//                                             fontWeight: _value == 0
//                                                 ? FontWeight.w600
//                                                 : FontWeight.w400),
//                                       ),
//                                     ],
//                                   )),
//                             ),
//                             Expanded(
//                                 flex: 5,
//                                 child: RawMaterialButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       _value = 1;
//                                     });
//                                   },
//                                   padding:
//                                       const EdgeInsets.fromLTRB(5, 5, 10, 5),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Icon(
//                                         _value == 1
//                                             ? Icons.radio_button_checked
//                                             : Icons.radio_button_unchecked,
//                                         color: model.backgroundColor,
//                                         size: 22,
//                                       ),
//                                       SizedBox(
//                                         width: 8,
//                                       ),
//                                       Text(
//                                         'Round-Trip',
//                                         style: TextStyle(
//                                             fontSize: 16.0,
//                                             fontWeight: _value == 1
//                                                 ? FontWeight.w600
//                                                 : FontWeight.w400),
//                                       ),
//                                     ],
//                                   ),
//                                 )),
//                           ])),
//                   Container(
//                       child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: <Widget>[
//                         Expanded(
//                             flex: 5,
//                             child: Container(
//                                 padding: EdgeInsets.all(5),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: const <Widget>[
//                                     Text(
//                                       'From',
//                                       style: TextStyle(
//                                           color: Colors.grey, fontSize: 10),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
//                                       child: Text('Cleveland (CLE)',
//                                           style: TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.w500)),
//                                     ),
//                                   ],
//                                 ))),
//                         Expanded(
//                             flex: 5,
//                             child: Container(
//                                 padding: EdgeInsets.all(5),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: const <Widget>[
//                                     Text(
//                                       'Destination',
//                                       style: TextStyle(
//                                           color: Colors.grey, fontSize: 10),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
//                                       child: Text('Chicago (CHI)',
//                                           style: TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.w500)),
//                                     ),
//                                   ],
//                                 )))
//                       ])),
//                   const Padding(
//                       padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
//                       child: Divider(
//                         color: Colors.black26,
//                         height: 1.0,
//                         thickness: 1,
//                       )),
//                   Container(
//                       child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: <Widget>[
//                         Expanded(
//                             flex: 5,
//                             child: RawMaterialButton(
//                                 padding: EdgeInsets.all(5),
//                                 onPressed: () async {
//                                   if (_value == 0) {
//                                     final DateTime date =
//                                         await showDialog<dynamic>(
//                                             context: context,
//                                             builder: (BuildContext context) {
//                                               return DateRangePicker(
//                                                   _startDate, null,
//                                                   displayDate: _startDate,
//                                                   minDate: DateTime.now(),
//                                                  );
//                                             });
//                                     if (date != null) {
//                                       _onSelectedDateChanged(date);
//                                     }
//                                   } else {
//                                     final _picker.PickerDateRange range =
//                                         await showDialog<dynamic>(
//                                             context: context,
//                                             builder: (BuildContext context) {
//                                               return DateRangePicker(
//                                                 null,
//                                                 _picker.PickerDateRange(
//                                                   _startDate,
//                                                   _endDate,
//                                                 ),
//                                                 displayDate: _startDate,
//                                                 minDate: DateTime.now(),
//
//                                               );
//                                             });
//
//                                     if (range != null) {
//                                       _onSelectedRangeChanged(range);
//                                     }
//                                   }
//                                 },
//                                 child: Container(
//                                     alignment: Alignment.centerLeft,
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: <Widget>[
//                                         Text('Departure Date',
//                                             style: TextStyle(
//                                                 color: Colors.grey,
//                                                 fontSize: 10)),
//                                         Padding(
//                                           padding:
//                                               EdgeInsets.fromLTRB(0, 5, 5, 0),
//                                           child: Text(
//                                               DateFormat('dd MMM yyyy')
//                                                   .format(_startDate),
//                                               style: const TextStyle(
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.w500)),
//                                         ),
//                                       ],
//                                     )))),
//                         Expanded(
//                             flex: 5,
//                             child: RawMaterialButton(
//                                 padding: EdgeInsets.all(5),
//                                 onPressed: _value == 0
//                                     ? null
//                                     : () async {
//                                         final _picker.PickerDateRange range =
//                                             await showDialog<dynamic>(
//                                                 context: context,
//                                                 builder:
//                                                     (BuildContext context) {
//                                                   return DateRangePicker(
//                                                     null,
//                                                     _picker.PickerDateRange(
//                                                         _startDate, _endDate),
//                                                     displayDate: _endDate,
//                                                     minDate: DateTime.now(),
//
//                                                   );
//                                                 });
//
//                                         if (range != null) {
//                                           _onSelectedRangeChanged(range);
//                                         }
//                                       },
//                                 child: Container(
//                                     padding: EdgeInsets.all(0),
//                                     alignment: Alignment.centerLeft,
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: _value == 0
//                                           ? <Widget>[
//                                               Text('Return Date',
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       color: Colors.grey,
//                                                       fontWeight:
//                                                           FontWeight.w500))
//                                             ]
//                                           : <Widget>[
//                                               Text('Return Date',
//                                                   style: TextStyle(
//                                                       color: Colors.grey,
//                                                       fontSize: 10)),
//                                               Padding(
//                                                 padding: EdgeInsets.fromLTRB(
//                                                     0, 5, 5, 0),
//                                                 child: Text(
//                                                     DateFormat('dd MMM yyyy')
//                                                         .format(_endDate),
//                                                     style: const TextStyle(
//                                                         fontSize: 16,
//                                                         fontWeight:
//                                                             FontWeight.w500)),
//                                               ),
//                                             ],
//                                     ))))
//                       ])),
//                   const Padding(
//                       padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
//                       child: Divider(
//                         color: Colors.black26,
//                         height: 1.0,
//                         thickness: 1,
//                       )),
//                   Container(
//                       child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: <Widget>[
//                         Expanded(
//                             flex: 5,
//                             child: Container(
//                                 padding: EdgeInsets.all(5),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: const <Widget>[
//                                     Text(
//                                       'Travellers',
//                                       style: TextStyle(
//                                           color: Colors.grey, fontSize: 10),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
//                                       child: Text('1 Adult',
//                                           style: TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.w500)),
//                                     ),
//                                   ],
//                                 ))),
//                         Expanded(
//                             flex: 5,
//                             child: Container(
//                                 padding: EdgeInsets.all(5),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: const <Widget>[
//                                     Text(
//                                       'Class',
//                                       style: TextStyle(
//                                           color: Colors.grey, fontSize: 10),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
//                                       child: Text('Economy',
//                                           style: TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.w500)),
//                                     ),
//                                   ],
//                                 )))
//                       ])),
//                   Container(
//                       margin: EdgeInsets.only(top: 30),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           RawMaterialButton(
//                             fillColor: model.backgroundColor,
//                             splashColor: Colors.grey.withOpacity(0.12),
//                             hoverColor: Colors.grey.withOpacity(0.04),
//                             onPressed: () {
//                               Scaffold.of(context).showSnackBar(const SnackBar(
//                                 content: Text(
//                                   'Searching...',
//                                 ),
//                                 duration: Duration(milliseconds: 200),
//                               ));
//                             },
//                             child: const Text(
//                               'SEARCH',
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   backgroundColor: Colors.transparent,
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 18),
//                             ),
//                           ),
//                         ],
//                       )),
//                 ])));
//   }
//
//   @override
//   Widget build([BuildContext context]) {
//     return Scaffold(
//       backgroundColor: model.themeData == null ||
//               model.themeData.brightness == Brightness.light
//           ? null
//           : const Color(0x171A21),
//       body: model.isWeb
//           ? Center(
//               child: Container(width: 400, height: 380, child: _getBooking()))
//           : Container(
//               height: 450,
//               child: _getBooking(),
//             ),
//     );
//   }
// }
//
// /// Get date range picker
// _picker.SfDateRangePicker getPopUpDatePicker() {
//   return _picker.SfDateRangePicker();
// }
//
// /// Builds the date range picker inside a pop-up based on the properties passed,
// /// and return the selected date or range based on the tripe mode selected.
// class DateRangePicker extends StatefulWidget {
//   /// Creates Date range picker
//   const DateRangePicker(this.date, this.range,
//       {this.minDate, this.maxDate, this.displayDate});
//
//   /// Holds date value
//   final dynamic date;
//
//   /// Holds date range value
//   final dynamic range;
//
//   /// Holds minimum date value
//   final dynamic minDate;
//
//   /// Holds maximum date value
//   final dynamic maxDate;
//
//   /// Holds showable date value
//   final dynamic displayDate;
//
//
//   @override
//   State<StatefulWidget> createState() {
//     return _DateRangePickerState();
//   }
// }
//
// class _DateRangePickerState extends State<DateRangePicker> {
//   dynamic _date;
//   dynamic _controller;
//   dynamic _range;
//   bool? _isWeb, _isHijri;
//   SfLocalizations? _localizations;
//   SampleModel? model;
//
//   @override
//   void initState() {
//     model = new SampleModel();
//     _isHijri = widget.date is HijriDateTime;
//     _date = widget.date;
//     _range = widget.range;
//     if (_isHijri) {
//       _controller = _picker.HijriDatePickerController();
//     } else {
//       _controller = _picker.DateRangePickerController();
//     }
//     _isWeb = false;
//     super.initState();
//   }
//
//   @override
//   void didChangeDependencies() {
//     //// Extra small devices (phones, 600px and down)
// //// @media only screen and (max-width: 600px) {...}
// ////
// //// Small devices (portrait tablets and large phones, 600px and up)
// //// @media only screen and (min-width: 600px) {...}
// ////
// //// Medium devices (landscape tablets, 768px and up)
// //// media only screen and (min-width: 768px) {...}
// ////
// //// Large devices (laptops/desktops, 992px and up)
// //// media only screen and (min-width: 992px) {...}
// ////
// //// Extra large devices (large laptops and desktops, 1200px and up)
// //// media only screen and (min-width: 1200px) {...}
// //// Default width to render the mobile UI in web, if the device width exceeds
// //// the given width agenda view will render the web UI.
//     _isWeb = MediaQuery.of(context).size.width > 767;
//     _localizations = SfLocalizations.of(context);
//     super.didChangeDependencies();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final Widget footerWidget = ButtonBarTheme(
//       data: ButtonBarTheme.of(context),
//       child: ButtonBar(
//         children: <Widget>[
//           FlatButton(
//             splashColor: model.backgroundColor
//                 .withOpacity(model.backgroundColor.opacity * 0.2),
//             child: Text(
//               'Cancel',
//               style: TextStyle(color: model.backgroundColor),
//             ),
//             onPressed: () => Navigator.pop(context, null),
//           ),
//           FlatButton(
//             splashColor: model.backgroundColor
//                 .withOpacity(model.backgroundColor.opacity * 0.2),
//             child: Text(
//               'OK',
//               style: TextStyle(color: model.backgroundColor),
//             ),
//             onPressed: () {
//               (_range != null)
//                   ? Navigator.pop(context, _range)
//                   : Navigator.pop(context, _date);
//             },
//           ),
//         ],
//       ),
//     );
//
//     final Widget selectedDateWidget = Container(
//         color: Colors.transparent,
//         padding: const EdgeInsets.symmetric(vertical: 16.0),
//         child: Container(
//             height: 30,
//             padding: const EdgeInsets.symmetric(horizontal: 4.0),
//             child: _range == null ||
//                     _range.startDate == null ||
//                     _range.endDate == null ||
//                     _range.startDate == _range.endDate
//                 ? Text(
//                     _isHijri
//                         ? getFormattedHijriString(
//                             _range == null
//                                 ? _date
//                                 : (_range.startDate ?? _range.endDate),
//                             _localizations,
//                             'MMM')
//                         : DateFormat('dd MMM, yyyy').format(_range == null
//                             ? _date
//                             : (_range.startDate ?? _range.endDate)),
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: model.textColor),
//                   )
//                 : Row(
//                     children: <Widget>[
//                       Expanded(
//                         flex: 5,
//                         child: Text(
//                           _isHijri
//                               ? getFormattedHijriString(
//                                   _range.startDate.isAfter(_range.endDate)
//                                       ? _range.endDate
//                                       : _range.startDate,
//                                   _localizations,
//                                   'MMM')
//                               : DateFormat('dd MMM, yyyy').format(
//                                   _range.startDate.isAfter(_range.endDate)
//                                       ? _range.endDate
//                                       : _range.startDate),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                               color: model.textColor),
//                         ),
//                       ),
//                       Container(
//                           child: const VerticalDivider(
//                         thickness: 1,
//                       )),
//                       Expanded(
//                         flex: 5,
//                         child: Text(
//                           _isHijri
//                               ? getFormattedHijriString(
//                                   _range.startDate.isAfter(_range.endDate)
//                                       ? _range.startDate
//                                       : _range.endDate,
//                                   _localizations,
//                                   'MMM')
//                               : DateFormat('dd MMM, yyyy').format(
//                                   _range.startDate.isAfter(_range.endDate)
//                                       ? _range.startDate
//                                       : _range.endDate),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                               color: model.textColor),
//                         ),
//                       ),
//                     ],
//                   )));
//
//     _controller.selectedDate = _date;
//     _controller.selectedRange = _range;
//     Widget pickerWidget;
//     if (_isHijri) {
//       pickerWidget = _picker.SfHijriDateRangePicker(
//         controller: _controller,
//         initialDisplayDate: widget.displayDate,
//         showNavigationArrow: true,
//         enableMultiView: _range != null && _isWeb,
//         selectionMode: _range == null
//             ? _picker.DateRangePickerSelectionMode.single
//             : _picker.DateRangePickerSelectionMode.range,
//         minDate: widget.minDate,
//         maxDate: widget.maxDate,
//         todayHighlightColor: Colors.transparent,
//         headerStyle: _picker.DateRangePickerHeaderStyle(
//             textAlign: TextAlign.center,
//             textStyle:
//                 TextStyle(color: model.backgroundColor, fontSize: 15)),
//         onSelectionChanged:
//             (_picker.DateRangePickerSelectionChangedArgs details) {
//           setState(() {
//             if (_range == null) {
//               _date = details.value;
//             } else {
//               _range = details.value;
//             }
//           });
//         },
//       );
//     } else {
//       pickerWidget = _picker.SfDateRangePicker(
//         controller: _controller,
//         initialDisplayDate: widget.displayDate,
//         showNavigationArrow: true,
//         enableMultiView: _range != null && _isWeb,
//         selectionMode: _range == null
//             ? _picker.DateRangePickerSelectionMode.single
//             : _picker.DateRangePickerSelectionMode.range,
//         minDate: widget.minDate,
//         maxDate: widget.maxDate,
//         todayHighlightColor: Colors.transparent,
//         headerStyle: _picker.DateRangePickerHeaderStyle(
//             textAlign: TextAlign.center,
//             textStyle:
//                 TextStyle(color: model.backgroundColor, fontSize: 15)),
//         onSelectionChanged:
//             (_picker.DateRangePickerSelectionChangedArgs details) {
//           setState(() {
//             if (_range == null) {
//               _date = details.value;
//             } else {
//               _range = details.value;
//             }
//           });
//         },
//       );
//     }
//
//     return Dialog(
//         backgroundColor: model.cardThemeColor,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//         child: Container(
//             height: 400,
//             width: _range != null && _isWeb ? 500 : 300,
//             color: model.cardThemeColor,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: <Widget>[
//                 selectedDateWidget,
//                 Flexible(
//                     child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 0, horizontal: 5),
//                         child: pickerWidget)),
//                 footerWidget,
//               ],
//             )));
//   }
//
//   String getFormattedHijriString(
//       HijriDateTime date, SfLocalizations localizations, String monthFormat) {
//     return date.day.toString() +
//         ' ' +
//         getHijriMonthText(date, localizations, monthFormat) +
//         ' ' +
//         date.year.toString();
//   }
//
//   String getHijriMonthText(
//       dynamic date, SfLocalizations localizations, String format) {
//     if (date.month == 1) {
//       if (format == 'M' || format == 'MM') {
//         return date.month.toString();
//       } else if (format == 'MMM') {
//         return localizations.shortMuharramLabel;
//       }
//       return localizations.muharramLabel;
//     } else if (date.month == 2) {
//       if (format == 'M' || format == 'MM') {
//         return date.month.toString();
//       } else if (format == 'MMM') {
//         return localizations.shortSafarLabel;
//       }
//       return localizations.safarLabel;
//     } else if (date.month == 3) {
//       if (format == 'M' || format == 'MM') {
//         return date.month.toString();
//       } else if (format == 'MMM') {
//         return localizations.shortRabi1Label;
//       }
//       return localizations.rabi1Label;
//     } else if (date.month == 4) {
//       if (format == 'M' || format == 'MM') {
//         return date.month.toString();
//       } else if (format == 'MMM') {
//         return localizations.shortRabi2Label;
//       }
//       return localizations.rabi2Label;
//     } else if (date.month == 5) {
//       if (format == 'M' || format == 'MM') {
//         return date.month.toString();
//       } else if (format == 'MMM') {
//         return localizations.shortJumada1Label;
//       }
//       return localizations.jumada1Label;
//     } else if (date.month == 6) {
//       if (format == 'M' || format == 'MM') {
//         return date.month.toString();
//       } else if (format == 'MMM') {
//         return localizations.shortJumada2Label;
//       }
//       return localizations.jumada2Label;
//     } else if (date.month == 7) {
//       if (format == 'M' || format == 'MM') {
//         return date.month.toString();
//       } else if (format == 'MMM') {
//         return localizations.shortRajabLabel;
//       }
//       return localizations.rajabLabel;
//     } else if (date.month == 8) {
//       if (format == 'M' || format == 'MM') {
//         return date.month.toString();
//       } else if (format == 'MMM') {
//         return localizations.shortShaabanLabel;
//       }
//
//       return localizations.shaabanLabel;
//     } else if (date.month == 9) {
//       if (format == 'M' || format == 'MM') {
//         return date.month.toString();
//       } else if (format == 'MMM') {
//         return localizations.shortRamadanLabel;
//       }
//
//       return localizations.ramadanLabel;
//     } else if (date.month == 10) {
//       if (format == 'M' || format == 'MM') {
//         return date.month.toString();
//       } else if (format == 'MMM') {
//         return localizations.shortShawwalLabel;
//       }
//       return localizations.shawwalLabel;
//     } else if (date.month == 11) {
//       if (format == 'M' || format == 'MM') {
//         return date.month.toString();
//       } else if (format == 'MMM') {
//         return localizations.shortDhualqiLabel;
//       }
//       return localizations.dhualqiLabel;
//     } else {
//       if (format == 'M' || format == 'MM') {
//         return date.month.toString();
//       } else if (format == 'MMM') {
//         return localizations.shortDhualhiLabel;
//       }
//       return localizations.dhualhiLabel;
//     }
//   }
// }
