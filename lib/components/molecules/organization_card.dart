import "package:flutter/material.dart";
import 'package:port/utility/colors.dart';
import 'package:port/utility/colors_main.dart';

class OrganizationCard extends StatelessWidget {
  String organizationSymbol;
  String organizationName;
  double distanceFromUser;
  VoidCallback onTap;

  OrganizationCard({
    @required this.organizationSymbol,
    @required this.organizationName,
    @required this.distanceFromUser,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: GestureDetector(
        onTap: this.onTap,
        child: PhysicalModel(
          color: colorAppBackground,
          shadowColor: colorCardShadow,
          borderRadius: BorderRadius.circular(8),
          elevation: 8,
          child: Container(
            height: 94,
            child: Center(
              child: ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: paleCircleAvatarBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "B",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  this.organizationName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: primaryTextColor,
                  ),
                ),
                subtitle: Row(
                  children: [
                    Icon(
                      Icons.watch_later,
                      color: paleTextColor,
                      size: 14,
                    ),
                    Text(
                      "${distanceFromUser.toInt()}km away",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: paleTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
