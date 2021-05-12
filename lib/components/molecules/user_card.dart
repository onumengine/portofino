import "package:flutter/material.dart";
import 'package:flutter_svg/svg.dart';
import 'package:port/utility/colors_main.dart';
import 'package:port/utility/colors.dart';

class UserCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
          ),
          child: SvgPicture.asset(
            "lib/vectors/gyms_icon.svg",
            semanticsLabel: "ICONN",
          ),
        ),
      ),
    );
  }
}
