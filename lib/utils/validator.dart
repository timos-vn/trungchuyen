import 'package:flutter/cupertino.dart';
import 'package:trungchuyen/utils/utils.dart';

class Validators{
  static final RegExp _phoneRegex = RegExp(r'(\+84|0)\d{9}$');
  static final RegExp _emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  String? checkHotId(BuildContext context, String username) {
    if (Utils.isEmpty(username)) {
      return 'HotIdIsNotEmpty';
    }  else {
      return null;
    }
  }

  String? checkUsername(BuildContext context, String username) {
    if (Utils.isEmpty(username)) {
      return 'Vui lòng nhập số điện thoại';
    } else if (username.length < 10) {
      return 'Số điện thoại không đúng định dạn';
    } else if (!Utils.isEmpty(username) && username.substring(0,1) != '0') {
      return 'Số điện thoại không đúng định dạn';
    } else {
      return null;
    }
  }

  String? checkPass(BuildContext context, String password) {
    if (Utils.isEmpty(password)) {
      return 'Vui lòng nhập mật khẩu';
    } else if (password.length < 6) {
      return 'Mật khẩu phải nhiều hơn 6 ký tự';
    } else {
      return null;
    }
  }

  String? checkPassAgain(BuildContext context, String currentPassword, String newPassword) {
    if (Utils.isEmpty(newPassword)) {
      return 'Vui lòng nhập mật khẩu';
    } else if (newPassword.length < 6) {
      return 'Mật khẩu không đúng định dạng';
    }else if (currentPassword != newPassword){
      return 'Các mật khẩu đã nhập không khớp. Hãy thử lại.';
    }
    else {
      return null;
    }
  }

  String? checkPhoneNumber2(BuildContext context, String phoneNumber) {
    if (Utils.isEmpty(phoneNumber)) return null;
    if (!_phoneRegex.hasMatch(phoneNumber)) {
      return 'Số điện thoại không đúng định dạng';
    } else {
      return null;
    }
  }
}