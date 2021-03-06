import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:port/bloc/users/event.dart';
import 'package:port/bloc/users/state.dart';
import 'package:port/repository/api_client.dart';
import 'package:port/utility/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersBloc extends Bloc<UsersScreenEvent, UsersScreenState> {
  ApiClient _apiClient = ApiClient();
  Map<String, dynamic> response;
  List listOfUsers;
  String userOrganizationName;
  String selectedUserId = "";
  SharedPreferences _preferences;

  @override
  UsersScreenState get initialState => PopulatedUsersState();

  @override
  Stream<UsersScreenState> mapEventToState(UsersScreenEvent event) async* {
    if (event is UsersFetchEvent) {
      yield FetchingUsersState();
      try {
        await _fetchUsers(event.usersOrganizationId);
        listOfUsers = response["data"];
        userOrganizationName = event.usersOrganizationName;
        yield PopulatedUsersState(
          users: listOfUsers,
          userOrganizationName: userOrganizationName,
        );
      } catch (error) {
        yield FetchingErrorState(errorMessage: error.toString());
      }
    } else if (event is UserSubmitEvent) {
      selectedUserId = event.selectedUserId;
      try {
        _preferences = await SharedPreferences.getInstance();
        print("YOUR PREFERENCES BEFORE ASSIGNMENT ARE: ${_preferences.getKeys()}");
        _preferences.setString("repId", selectedUserId);
        print("YOUR PREFERENCE KEYS ARE NOW: ${_preferences.getKeys()}");
      } catch (e) {
        print("SHARED_PREFERENCES ASSIGNMENT FAILED WITH AN EXCEPTION: $e");
      }
    }
  }

  Future<void> _fetchUsers(String usersOrganizationId) async {
    response = jsonDecode(
        await _apiClient.get(USERS_FETCH_PATH + usersOrganizationId));
  }
}
