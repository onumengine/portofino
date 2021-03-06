import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:port/bloc/categories/bloc.dart';
import 'package:port/bloc/date_picker/bloc.dart';
import 'package:port/bloc/home/bloc.dart';
import 'package:port/bloc/home/event.dart';
import 'package:port/bloc/home/state.dart';
import 'package:port/bloc/notifications/bloc.dart';
import 'package:port/bloc/scheduler/bloc.dart';
import 'package:port/components/molecules/network_error.dart';
import 'package:port/components/organisms/appointments.dart';
import 'package:port/components/organisms/empty_appointments.dart';
import 'package:port/components/organisms/more.dart';
import 'package:port/screens/categories.dart';
import 'package:port/screens/notifications.dart';
import 'package:port/screens/scheduler.dart';
import 'package:port/utility/colors.dart';
import 'package:port/utility/colors_main.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _navbarIndex = 0;
  String title;
  HomeBloc _homeBloc;
  List _tabs;

  @override
  void initState() {
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    super.initState();
    _homeBloc.add(SchedulesFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    _tabs = [
      BlocBuilder<HomeBloc, AppointmentState>(
        builder: (context, state) {
          if (state is EmptyAppoinmentsState) {
            return EmptyAppointmentsComponent(
              onTap: () {
                _homeBloc.add(SchedulesFetchEvent());
              },
            );
          } else if (state is BookedState) {
            return AppointmentsComponent(
              todaysAppointments: state.todaysSchedules,
              otherAppointments: state.otherSchedules,
            );
          } else if (state is FetchingErrorState) {
            return NetworkErrorComp(onTap: () {
              _homeBloc.add(SchedulesFetchEvent());
            });
          } else if (state is AppointmentsFetchingState) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center();
          }
        },
      ),
      MoreComponent(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PORT",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        automaticallyImplyLeading: false,
        elevation: Theme.of(context).appBarTheme.elevation,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<NotificationsBloc>(
                    create: (context) => NotificationsBloc(),
                    child: NotificationsScreen(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _tabs[_navbarIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: opPrimaryColor,
        foregroundColor: white,
        child: Icon(Icons.add),
        onPressed: () {
          /*
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider<CategoriesBloc>(
                create: (context) => CategoriesBloc(),
                child: CategoriesScreen(),
              ),
            ),
          );
          */
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<SchedulerBloc>(
                    create: (context) => SchedulerBloc(),
                  ),
                  BlocProvider<DatePickerBloc>(
                    create: (context) => DatePickerBloc(),
                  )
                ],
                child: SchedulerScreen(),
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navbarIndex,
        onTap: (int selectedIndex) {
          setState(() {
            _navbarIndex = selectedIndex;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "lib/vectors/home_icon.svg",
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "lib/vectors/options_icon.svg",
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}
