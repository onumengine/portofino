import 'package:flutter/material.dart';
import 'package:port/components/molecules/appointment_card.dart';
import 'package:port/screens/details.dart';

class AppointmentsComponent extends StatefulWidget {
  final List todaysAppointments, otherAppointments;

  AppointmentsComponent({
    @required this.todaysAppointments,
    @required this.otherAppointments,
  });

  @override
  _AppointmentsComponentState createState() =>
      _AppointmentsComponentState();
}

class _AppointmentsComponentState extends State<AppointmentsComponent> {
  double _getHorizontalPadding(double screenWidth) {
    if (screenWidth < 592)
      return 12;
    else if (screenWidth > 592 && screenWidth < 1000)
      return 40;
    else if (screenWidth > 1000) return 3;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.only(left: 19),
              child: Text(
                "Today",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 19),
          ]),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
                child: AppointmentCard(
                  organizationName: widget.todaysAppointments.elementAt(index)["org_name"],
                  startTime: widget.todaysAppointments.elementAt(index)["time"],
                  duration: widget.todaysAppointments.elementAt(index)["duration"],
                  approvalStatus: widget.todaysAppointments
                      .elementAt(index)["status"]
                      .toString(),
                ),
              );
            },
            childCount: widget.todaysAppointments.length,
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.only(left: 19),
              child: Text(
                "Others",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 19),
          ]),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
                child: AppointmentCard(
                  organizationName:
                      widget.otherAppointments.elementAt(index)["org_name"],
                  startTime:
                      widget.otherAppointments.elementAt(index)["time"],
                  duration: widget.otherAppointments.elementAt(index)["duration"],
                  approvalStatus: widget.otherAppointments
                      .elementAt(index)["status"]
                      .toString(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(
                          appointment: widget.otherAppointments.elementAt(index),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            childCount: widget.otherAppointments.length,
          ),
        )
      ],
    );
  }
}
