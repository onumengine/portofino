import 'dart:async';

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:port/bloc/home/bloc.dart';
import 'package:port/bloc/submit/bloc.dart';
import 'package:port/bloc/submit/event.dart';
import 'package:port/bloc/submit/state.dart';
import 'package:port/components/molecules/error.dart';
import 'package:port/components/organisms/timestamp_card.dart';
import 'package:port/screens/home.dart';
import 'package:port/utility/colors.dart';
import 'package:port/utility/colors_main.dart';

class SubmitScreen extends StatefulWidget {
  @override
  _SubmitScreenState createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  TextEditingController _summaryNoteController;
  bool _showLoadingIndicator = false;
  SubmitBloc _submitBloc;

  @override
  void initState() {
    super.initState();
    _summaryNoteController = TextEditingController();
    _submitBloc = BlocProvider.of<SubmitBloc>(context)
      ..add(FetchPreferencesDataEvent())
      ..add(PurposesFetchEvent());
  }

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
          "Summary",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocConsumer<SubmitBloc, SubmitScreenState>(
        listener: (context, state) {
          if (state is SuccessfulSubmissionState) {
            _submitBloc.add(ClearSubmissionDataEvent());
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider<HomeBloc>(
                  create: (context) => HomeBloc(),
                  child: MyHomePage(),
                ),
              ),
              (route) => false,
            );
          } else if (state is SubmissionErrorState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ErrorComponent(errorMessage: state.errorMessage),
              ),
            );
            return Timer(Duration(milliseconds: 500), () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                ),
              );
            });
          }
        },
        builder: (context, state) {
          if (state is DefaultState) {
            return ListView(
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
                          "Bank of America",
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
                TimestampCard(
                  selectedDate: state.date,
                  selectedTime: state.time,
                  selectedDuration: state.duration,
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
                      padding: EdgeInsets.only(
                        top: 16,
                        bottom: 30,
                        left: 16,
                        right: 16,
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: inputBackgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButton(
                              isExpanded: true,
                              value: state.selectedPurpose,
                              icon: Icon(CupertinoIcons.chevron_down),
                              iconEnabledColor: opPrimaryColor,
                              underline: SizedBox(),
                              onChanged: (selectedPurpose) {
                                _submitBloc.add(
                                  PurposeSelectionEvent(
                                      selectedPurpose: selectedPurpose),
                                );
                              },
                              hint: Text("Choose reason for appointment"),
                              disabledHint: Text("Disabled"),
                              items: <DropdownMenuItem>[
                                DropdownMenuItem(
                                  child: Container(
                                    child: Center(
                                      child: Text("${state.purposes[0]}"),
                                    ),
                                  ),
                                  value: state.purposes[0],
                                ),
                                DropdownMenuItem(
                                  child: Container(
                                    child: Center(
                                      child: Text("${state.purposes[1]}"),
                                    ),
                                  ),
                                  value: state.purposes[1],
                                ),
                                DropdownMenuItem(
                                  child: Container(
                                    child: Center(
                                      child: Text("${state.purposes[2]}"),
                                    ),
                                  ),
                                  value: state.purposes[2],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 27),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Text(
                                "Add a note",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                  color: opPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 188,
                            width: double.infinity,
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: inputBackgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              expands: true,
                              maxLines: null,
                              minLines: null,
                              controller: _summaryNoteController,
                              decoration:
                                  InputDecoration.collapsed(hintText: ""),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                InkWell(
                  onTap: () {
                    print("Tapped Edit button\nAdding SubmissionEvent");
                    _submitBloc.add(SubmissionEvent(
                      note: _summaryNoteController.text,
                    ));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    height: 54,
                    decoration: BoxDecoration(
                      color: opPrimaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: _showLoadingIndicator
                          ? CircularProgressIndicator()
                          : Text(
                              "Submit",
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
            );
          } else if (state is SubmissionErrorState) {
            return ListView(
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
                          "Bank of America",
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
                TimestampCard(
                  selectedDate: state.date,
                  selectedTime: state.time,
                  selectedDuration: state.duration,
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
                      padding: EdgeInsets.only(
                        top: 16,
                        bottom: 30,
                        left: 16,
                        right: 16,
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: inputBackgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButton(
                              isExpanded: true,
                              value: state.selectedPurpose,
                              icon: Icon(CupertinoIcons.chevron_down),
                              iconEnabledColor: opPrimaryColor,
                              underline: SizedBox(),
                              onChanged: (selectedPurpose) {
                                _submitBloc.add(
                                  PurposeSelectionEvent(
                                      selectedPurpose: selectedPurpose),
                                );
                              },
                              hint: Text("Choose reason for appointment"),
                              disabledHint: Text("Disabled"),
                              items: <DropdownMenuItem>[
                                DropdownMenuItem(
                                  child: Container(
                                    child: Center(
                                      child: Text("${state.purposes[0]}"),
                                    ),
                                  ),
                                  value: state.purposes[0],
                                ),
                                DropdownMenuItem(
                                  child: Container(
                                    child: Center(
                                      child: Text("${state.purposes[1]}"),
                                    ),
                                  ),
                                  value: state.purposes[1],
                                ),
                                DropdownMenuItem(
                                  child: Container(
                                    child: Center(
                                      child: Text("${state.purposes[2]}"),
                                    ),
                                  ),
                                  value: state.purposes[2],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 27),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Text(
                                "Add a note",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                  color: opPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 188,
                            width: double.infinity,
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: inputBackgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              expands: true,
                              maxLines: null,
                              minLines: null,
                              controller: _summaryNoteController,
                              decoration:
                                  InputDecoration.collapsed(hintText: ""),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                InkWell(
                  onTap: () {
                    print("Tapped Edit button\nAdding SubmissionEvent");
                    _submitBloc.add(SubmissionEvent(
                      note: _summaryNoteController.text,
                    ));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    height: 54,
                    decoration: BoxDecoration(
                      color: opPrimaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: _showLoadingIndicator
                          ? CircularProgressIndicator()
                          : Text(
                              "Submit",
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
            );
          } else if (state is InitialSubmitScreenState) {
            return Container();
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  double _getHorizontalPadding(double screenWidth) {
    if (screenWidth <= 592)
      return 8;
    else if (screenWidth <= 1000)
      return 40;
    else if (screenWidth > 1000) return 3;
  }
}
