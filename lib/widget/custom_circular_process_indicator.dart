import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:trungchuyen/themes/colors.dart';
class CustomCircularProcessIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircularProgressIndicator(
          backgroundColor: primaryColor.withOpacity(0.2),
          valueColor: new AlwaysStoppedAnimation<Color>(
              // Colors.pinkAccent
              blue),
          strokeWidth: 3,
        ),
        Positioned(
          top: 5,
          left: 5,
          right: 5,
          bottom: 5,
          child: CircleAvatar(
            radius: 14.0,
            //backgroundImage: AssetImage(icLogo),
            // NetworkImage( "https://i.pinimg.com/originals/d5/8f/19/d58f191c768aa2c0938298ca5232aed8.png"),
            backgroundColor: Colors.transparent,
            child: Center(
              child: Icon(
                MdiIcons.bat,
                color: orange,
              ),
            ),
          ),
        )
      ],
    );
  }
}
