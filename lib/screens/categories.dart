import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:port/bloc/categories/bloc.dart';
import 'package:port/bloc/categories/event.dart';
import 'package:port/bloc/categories/state.dart';
import 'package:port/bloc/organizations/bloc.dart';
//import 'package:port/components/atoms/searchbar.dart';
import 'package:port/components/molecules/category_card.dart';
import 'package:port/components/molecules/network_error.dart';
import 'package:port/screens/organizations.dart';
import 'package:port/utility/colors.dart';
import 'package:port/utility/constants.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  CategoriesBloc _categoriesBloc;

  @override
  void initState() {
    super.initState();
    _categoriesBloc = BlocProvider.of<CategoriesBloc>(context);
    _categoriesBloc.add(CategoriesFetchEvent());
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
          "Choose Category",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        height: screenSize.height,
        width: screenSize.width,
        child: BlocBuilder<CategoriesBloc, CategoriesState>(
          builder: (context, state) {
            if (state is CategoriesFetchedState) {
              return Container(
                height: screenSize.height,
                width: screenSize.width,
                child: CustomScrollView(
                  slivers: [
                    /*
                    SliverAppBar(
                      elevation: 0,
                      expandedHeight: 100,
                      automaticallyImplyLeading: false,
                      flexibleSpace: Padding(
                        padding: EdgeInsets.only(
                          top: 20,
                          bottom: 40,
                          left: _getHorizontalPadding(screenSize.width),
                          right: _getHorizontalPadding(screenSize.width),
                        ),
                        child: SearchBar(),
                      ),
                      floating: true,
                    ), */
                    SliverList(
                      delegate: SliverChildListDelegate([
                        SizedBox(height: 40),
                      ]),
                    ),
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 4 / 5,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (_isAnOddNumber(index)) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: CategoryCard(
                                iconPath: (ICON_FETCH_PATH +
                                    state.categories.elementAt(index)["icon"]),
                                semanticLabel:
                                    state.categories.elementAt(index)["name"],
                                categoryName:
                                    state.categories.elementAt(index)["name"],
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BlocProvider<OrganizationsBloc>(
                                        create: (context) =>
                                            OrganizationsBloc(),
                                        child: OrganizationsScreen(
                                          categoryId:
                                              '/${state.categories.elementAt(index)["id"]}',
                                          organizationType: state.categories.elementAt(index)["name"],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: CategoryCard(
                                iconPath: (ICON_FETCH_PATH +
                                    state.categories.elementAt(index)["icon"]),
                                semanticLabel:
                                    state.categories.elementAt(index)["name"],
                                categoryName:
                                    state.categories.elementAt(index)["name"],
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BlocProvider<OrganizationsBloc>(
                                        create: (context) =>
                                            OrganizationsBloc(),
                                        child: OrganizationsScreen(
                                          categoryId:
                                              '/${state.categories.elementAt(index)["id"]}',
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        },
                        childCount: state.categories.length,
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        <Widget>[
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is CategoriesFetchingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is CategoriesErrorState) {
              return NetworkErrorComp(onTap: () {
                _categoriesBloc.add(CategoriesFetchEvent());
              });
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.assistant,
                          size: 50, color: paleTextColor)),
                  Text("Unable to load."),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  double _getHorizontalPadding(double screenWidth) {
    if (screenWidth < 592) {
      return 20;
    } else if (screenWidth > 592 && screenWidth < 1000) {
      return 40;
    } else if (screenWidth > 1000) {
      return 3;
    }
  }

  bool _isAnOddNumber(int index) {
    return (index % 2) != 0;
  }
}
