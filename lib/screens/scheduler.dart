import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import 'package:port/components/organisms/date_picker.dart';
import 'package:port/screens/submit.dart';
import 'package:port/utility/colors.dart';
import 'package:port/utility/colors_main.dart';

class SchedulerScreen extends StatefulWidget {
  @override
  _SchedulerScreenState createState() => _SchedulerScreenState();
}

class _SchedulerScreenState extends State<SchedulerScreen> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Pick day and time",
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  DatePicker(),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    height: 50,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorOrangeChip,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Paris (GMT+2)",
                      style: TextStyle(
                        color: orangeChipTextColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Choose time",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 26,
                crossAxisSpacing: 26,
                childAspectRatio: 2 / 1,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                    height: 62,
                    width: screenSize.width / 14,
                    decoration: BoxDecoration(
                      color: paleChipBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "Time text",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: chipTextColorDisabled,
                        ),
                      ),
                    ),
                  );
                },
                childCount: 6,
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Choose duration",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 26,
                crossAxisSpacing: 26,
                childAspectRatio: 1.6774,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                    height: 62,
                    width: screenSize.width / 14,
                    decoration: BoxDecoration(
                      color: paleChipBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "Time text",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: chipTextColorDisabled,
                        ),
                      ),
                    ),
                  );
                },
                childCount: 3,
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: 110),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: opPrimaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      child: Text(
                        "Proceed",
                        style: TextStyle(
                          color: white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubmitScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}