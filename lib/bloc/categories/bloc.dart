import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:port/bloc/categories/event.dart';
import 'package:port/bloc/categories/state.dart';
import 'package:port/repository/api_client.dart';
import 'package:port/utility/constants.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  ApiClient _apiClient = ApiClient();
  Map<String, dynamic> response;
  var errorMessage, listOfCategories;

  @override
  CategoriesState get initialState => CategoriesInitialState();

  @override
  Stream<CategoriesState> mapEventToState(CategoriesEvent event) async* {
    if (event is CategoriesFetchEvent) {
      yield CategoriesFetchingState();
      try {
        await fetchCategories();
        listOfCategories = response["data"];
        yield CategoriesFetchedState(categories: listOfCategories);
      } catch (e) {
        errorMessage = e.toString();
        yield CategoriesErrorState(errorMessage: errorMessage);
      }
    }
  }

  Future<void> fetchCategories() async {
    response = jsonDecode(await _apiClient.get(CATEGORIES_FETCH_PATH));
  }
}
