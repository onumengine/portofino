import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:port/bloc/date_picker/event.dart';
import 'package:port/bloc/date_picker/state.dart';
import 'package:shared_preferences/shared_preferences.dart';

///  ## HOW THIS DATE_PICKER POPULATES ITS DAYS
///
///  1. Switch to a new month.
///  2. Update the [selectedMonth] variable.
///  3. Check the first weekday of the month.
///  4. Update the [firstWeekdayOfSelectedMonth] variable.
///  5. Calculate the grid index to start rendering bubbles from.
///  6. Store this value in a variable [indexToRenderFrom].
///  7. GridBuilder will render empty containers from index 0 to index [indexToRenderFrom] - 1.
///  8. GridBuilder will render [CalendarBubble]s from index [indexToRenderFrom] to
///     the [numberOfDaysInSelectedMonth].
///  9. Find a way to get the number of days in a month.
/// 10. Make number of [CalendarBubble]s rendered by GridBuilder equal to the number
///     of days in a month

class DatePickerBloc extends Bloc<DatePickerEvent, DatePickerState> {
  int selectedYear;
  int selectedMonth;
  int selectedDay;
  int firstWeekdayOfSelectedMonth;
  int numberOfDaysInSelectedMonth;
  int numberOfGridItemsToRender;
  int indexToRenderFrom;
  String finalDate;
  SharedPreferences _preferences;

  Map<int, String> _numberToDayMap = <int, String>{
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Saturday",
    7: "Sunday",
  };

  DatePickerBloc() {
    selectedYear = DateTime.now().year;
    selectedMonth = DateTime.now().month;
    selectedDay = DateTime.now().day;
    firstWeekdayOfSelectedMonth = DateTime.now().weekday;
    numberOfDaysInSelectedMonth =
        DateTime(DateTime.now().year, (DateTime.now().month + 1), 0).day;
    numberOfGridItemsToRender = DateTime.now().weekday +
        DateTime(DateTime.now().year, (DateTime.now().month + 1), 0).day -
        1;
  }

  @override
  DatePickerState get initialState => DatePickerState(
        selectedYear: DateTime.now().year,
        selectedMonth: DateTime.now().month,
        selectedDay: DateTime.now().day,
        weekdayToRenderFrom: DateTime.now().weekday - 1,
        numberOfDaysInSelectedMonth:
            DateTime(DateTime.now().year, (DateTime.now().month + 1), 0).day,
        itemCount: DateTime.now().weekday +
            DateTime(DateTime.now().year, (DateTime.now().month + 1), 0).day -
            1,
      );

  @override
  Stream<DatePickerState> mapEventToState(DatePickerEvent event) async* {
    if (event is YearIncrementEvent) {
      _incrementSelectedYear();
      firstWeekdayOfSelectedMonth =
          DateTime(selectedYear, selectedMonth, 1).weekday;
      numberOfDaysInSelectedMonth =
          DateTime(selectedYear, (selectedMonth + 1), 0).day;
      numberOfGridItemsToRender =
          firstWeekdayOfSelectedMonth + numberOfDaysInSelectedMonth;
      indexToRenderFrom = (DateTime(selectedYear, selectedMonth, 1).weekday);
      yield DatePickerState(
        selectedYear: selectedYear,
        selectedMonth: selectedMonth,
        selectedDay: selectedDay,
        weekdayToRenderFrom: indexToRenderFrom,
        numberOfDaysInSelectedMonth: numberOfDaysInSelectedMonth,
        itemCount: numberOfGridItemsToRender,
      );
    } else if (event is YearDecrementEvent) {
      _decrementSelectedYear();
      firstWeekdayOfSelectedMonth =
          DateTime(selectedYear, selectedMonth, 1).weekday;
      numberOfDaysInSelectedMonth =
          DateTime(selectedYear, (selectedMonth + 1), 0).day;
      numberOfGridItemsToRender =
          firstWeekdayOfSelectedMonth + numberOfDaysInSelectedMonth;
      indexToRenderFrom = (DateTime(selectedYear, selectedMonth, 1).weekday);
      yield DatePickerState(
        selectedYear: selectedYear,
        selectedMonth: selectedMonth,
        selectedDay: selectedDay,
        weekdayToRenderFrom: indexToRenderFrom,
        numberOfDaysInSelectedMonth: numberOfDaysInSelectedMonth,
        itemCount: numberOfGridItemsToRender,
      );
    } else if (event is MonthIncrementEvent) {
      _incrementSelectedMonth();
      firstWeekdayOfSelectedMonth =
          DateTime(selectedYear, selectedMonth, 1).weekday;
      numberOfDaysInSelectedMonth =
          DateTime(selectedYear, (selectedMonth + 1), 0).day;
      numberOfGridItemsToRender =
          firstWeekdayOfSelectedMonth + numberOfDaysInSelectedMonth;
      indexToRenderFrom = (DateTime(selectedYear, selectedMonth, 1).weekday);
      yield DatePickerState(
        selectedYear: selectedYear,
        selectedMonth: selectedMonth,
        selectedDay: selectedDay,
        weekdayToRenderFrom: indexToRenderFrom,
        numberOfDaysInSelectedMonth: numberOfDaysInSelectedMonth,
        itemCount: numberOfGridItemsToRender,
      );
    } else if (event is MonthDecrementEvent) {
      _decrementSelectedMonth();
      firstWeekdayOfSelectedMonth =
          DateTime(selectedYear, selectedMonth, 1).weekday;
      numberOfDaysInSelectedMonth =
          DateTime(selectedYear, (selectedMonth + 1), 0).day;
      numberOfGridItemsToRender =
          firstWeekdayOfSelectedMonth + numberOfDaysInSelectedMonth;
      indexToRenderFrom = (DateTime(selectedYear, selectedMonth, 1).weekday);
      yield DatePickerState(
        selectedYear: selectedYear,
        selectedMonth: selectedMonth,
        selectedDay: selectedDay,
        weekdayToRenderFrom: indexToRenderFrom,
        numberOfDaysInSelectedMonth: numberOfDaysInSelectedMonth,
        itemCount: numberOfGridItemsToRender,
      );
    } else if (event is DaySelectionEvent) {
      _setSelectedDay(event.day);
      firstWeekdayOfSelectedMonth =
          DateTime(selectedYear, selectedMonth, 1).weekday;
      numberOfDaysInSelectedMonth =
          DateTime(selectedYear, (selectedMonth + 1), 0).day;
      numberOfGridItemsToRender =
          firstWeekdayOfSelectedMonth + numberOfDaysInSelectedMonth;
      indexToRenderFrom = (DateTime(selectedYear, selectedMonth, 1).weekday);
      _setFinalDate();
      await _saveDateToSharedPreferences();
      yield DatePickerState(
        selectedYear: selectedYear,
        selectedMonth: selectedMonth,
        selectedDay: selectedDay,
        weekdayToRenderFrom: indexToRenderFrom,
        numberOfDaysInSelectedMonth: numberOfDaysInSelectedMonth,
        itemCount: numberOfGridItemsToRender,
      );
    }
  }

  _incrementSelectedYear() {
    selectedYear++;
  }

  _decrementSelectedYear() {
    selectedYear--;
  }

  _incrementSelectedMonth() {
    selectedMonth++;
  }

  _decrementSelectedMonth() {
    selectedMonth--;
  }

  _setSelectedDay(int day) {
    selectedDay = day;
  }

  _setFinalDate() {
    this.finalDate = "$selectedYear-$selectedMonth-$selectedDay";
    print("THE FINAL DATE IN THE BLOC IS $finalDate");
  }

  Future<void> _saveDateToSharedPreferences() async {
    try {
      _preferences = await SharedPreferences.getInstance();
      print(
          "YOUR PREFERENCES BEFORE ASSIGNMENT ARE: ${_preferences.getKeys()}");
      _preferences.setString("date", "$selectedYear-$selectedMonth-$selectedDay");
      print("YOUR PREFERENCE KEYS ARE NOW: ${_preferences.getKeys()}");
    } catch (e) {
      print("SHARED_PREFERENCES ASSIGNMENT FAILED WITH AN EXCEPTION: $e");
    }
  }
}
