import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:port/components/atoms/appointment_status_tile.dart';
import 'package:port/components/organisms/editable_timestamp_card.dart';
import 'package:port/utility/colors.dart';
import 'package:port/utility/colors_main.dart';

class DetailsScreen extends StatefulWidget {
  Map<String, dynamic> appointment;

  DetailsScreen({this.appointment});

  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  double _getHorizontalPadding(double screenWidth) {
    if (screenWidth < 592)
      return 8;
    else if (screenWidth > 592 && screenWidth < 1000)
      return 40;
    else if (screenWidth > 1000) return 3;
  }

  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _getHorizontalPadding(screenSize.width),
              ),
              child: Container(
                width: 212,
                height: 50,
                decoration: BoxDecoration(
                  color: colorOrangeChip,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    widget.appointment["org_name"],
                    style: TextStyle(
                      color: Color(0xFFFD9453),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          EditableTimestampCard(
            selectedDate: widget.appointment["date"],
            selectedTime: widget.appointment["time"],
            selectedDuration: widget.appointment["duration"],
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(screenSize.width),
            ),
            child: PhysicalModel(
              color: colorAppBackground,
              shadowColor: colorCardShadow,
              elevation: 16,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Purpose",
                        style: TextStyle(
                          color: paleTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 41,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 17),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.appointment["purpose"],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: inputBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Description",
                          style: TextStyle(
                            color: paleTextColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 17, vertical: 17),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                        widget.appointment["note"],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: inputBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(screenSize.width),
            ),
            child: PhysicalModel(
              color: colorAppBackground,
              shadowColor: colorCardShadow,
              elevation: 16,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding:
                    EdgeInsets.only(top: 17, left: 20, right: 20, bottom: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    AppointmentStatusTile(
                      iconPath: "lib/vectors/request_sent_icon.svg",
                      semanticLabel: "Request sent icon",
                      appointmentStatus: "Request sent",
                      timeStamp: "4 Jan 2020, 10:59 AM",
                    ),
                    AppointmentStatusTile(
                      iconPath: "lib/vectors/eye_icon.svg",
                      semanticLabel: "Review icon",
                      appointmentStatus: "Under Review",
                      timeStamp: "22 Jan 2020, 10:59 AM",
                    ),
                    AppointmentStatusTile(
                      iconPath: "lib/vectors/smiley_icon.svg",
                      semanticLabel: "Approved icon",
                      appointmentStatus: "Approved",
                      timeStamp: "10:59 AM",
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
          InkWell(
            onTap: () {
              print("Tapped Edit button");
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 54,
              decoration: BoxDecoration(
                color: opPrimaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "Edit",
                  style: TextStyle(
                    color: opBackgroundColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
