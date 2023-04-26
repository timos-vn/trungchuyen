import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../themes/colors.dart';

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget(
      {required this.controller,
        this.textInputAction: TextInputAction.next,
        this.isEnable = true,
        this.onChanged,
        this.isPassword: false,
        this.inputFormatters,
        this.errorText,
        this.labelText,
        this.hintText,
        this.keyboardType: TextInputType.text,
        this.focusNode,
        this.onSubmitted,
        this.prefixIcon,
        this.suffix,
        required this.readOnly,
        this.color});

  final TextEditingController controller;
  final bool isEnable;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction textInputAction;
  final FormFieldSetter<String>? onChanged;
  final bool isPassword;
  final String? errorText;
  final String? labelText;
  final String? hintText;
  final TextInputType keyboardType;
  final FocusNode? focusNode;
  final FormFieldSetter<String>? onSubmitted;
  final dynamic prefixIcon;
  final dynamic suffix;
  final bool readOnly;
  final Color? color;

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late bool _obscureText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(

      readOnly: widget.readOnly,
      enabled: widget.isEnable,
      focusNode: widget.focusNode,
      controller: widget.controller,
      obscureText: _obscureText,
      textInputAction: widget.textInputAction,
      textAlignVertical: TextAlignVertical.center,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(

          border: const UnderlineInputBorder(borderSide: BorderSide(color: grey, width: 1),),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: grey, width: 1),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: grey, width: 1),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: grey, width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 7),
          isDense: true,
          focusColor: primaryColor,
          hintText: widget.hintText,

          labelText: widget.labelText,
          // suffix: widget.suffix == null
          //     ? null
          //     : Icon(widget.suffix,color: grey,size: 20,)
          // ,
          errorText: widget.errorText,
          prefixIcon: widget.prefixIcon == null
              ? null
              : (widget.prefixIcon is String
              ? Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              widget.prefixIcon,
              width: 35,
              height: 35,
              fit: BoxFit.fitHeight,
            ),
          )
              : Icon(
            widget.prefixIcon,
            color: accent,
            size: 20,
          )),
          suffixIcon: !widget.isPassword
              ? widget.suffix == null ? null : Icon(widget.suffix,color: grey,size: 20,)
              : GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(
              _obscureText ? MdiIcons.eye : MdiIcons.eyeOff,
              semanticLabel:
              _obscureText ? 'show password' : 'hide password',
              color: blue,
            ),
          ),
          labelStyle:
          TextStyle(color: widget.isEnable ? grey : widget.color == null ? widget.color : grey, fontSize: 13),
          hintStyle: const TextStyle(
            fontSize: 13,
            color: grey,
          ),
          errorStyle: const TextStyle(
            fontSize: 10,
            color: red,
          )),
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      style: TextStyle(
        fontSize: 13,
        color: widget.isEnable ? black : grey,
      ),
    );
  }
}
