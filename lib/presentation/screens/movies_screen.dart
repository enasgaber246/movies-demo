import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:movies/business_logic/movies_bloc.dart';
import 'package:movies/constants/colors.dart';
import 'package:movies/data/models/movies_response.dart';
import 'package:movies/presentation/widgets/movie_item.dart';

class moviesScreen extends StatefulWidget {
  static String routeName = "/movies_screen";

  late MoviesBloc bloc = MoviesBloc();

  // late LoadMediaMoviesEvent event = LoadMediaMoviesEvent(0,1);

  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<moviesScreen> {
  late List<MovieModel> items;
  late MoviesResponse modelrespose;
  int current_index = 0;
  int current_page = 1;

  @override
  Widget build(BuildContext context) {
    return screenWidget();
  }

  Future<Null> _refreshScreen() async {
    widget.bloc.add(LoadMediaMoviesEvent(current_page, 1));
  }

  Widget screenWidget() => Scaffold(
        body: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: MyColors.Yellow,
              title: Text(
                "Movies",
                style: TextStyle(
                    color: Colors.black87,
                    fontFamily: "meduim",
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              bottom: TabBar(
                indicatorColor: MyColors.White,
                tabs: [
                  Tab(
                    icon: Text(
                      'Top movies',
                      style: TextStyle(
                        color: MyColors.White,
                        fontFamily: "meduim",
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Tab(
                    icon: Text(
                      'Popular',
                      style: TextStyle(
                        color: MyColors.White,
                        fontFamily: "meduim",
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Tab(
                    icon: Text(
                      'Playing now',
                      style: TextStyle(
                        color: MyColors.White,
                        fontFamily: "meduim",
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              centerTitle: true,
            ),
            body: TabBarView(
              physics: BouncingScrollPhysics(),
              children: [
                currentScreen(0),
                currentScreen(1),
                currentScreen(2),
              ],
            ),
          ),
        ),
      );

  Widget currentScreen(int index) {
    this.current_index = index;
    // current_page = 1;
    String title = 'Top Movies';

    switch (index) {
      case 0:
        title = 'Top Movies';
        break;
      case 1:
        title = 'Popular';
        break;
      case 2:
        title = 'Top Movies';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshScreen,
            child: screenBuilder(index, title),
          ),
        ),
      ],
    );
  }

  BlocProvider screenBuilder(int index, String title) {
    return BlocProvider<MoviesBloc>(
        create: (context) {
          widget.bloc.add(LoadMediaMoviesEvent(current_page, 1));
          return widget.bloc;
        },
        child: Scaffold(
          body: OfflineBuilder(
            connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
            ) {
              final bool connected = connectivity != ConnectivityResult.none;

              if (connected) {
                return buildBlocWidget();
              } else {
                return buildNoInternetWidget();
              }
            },
            child: showLoadingIndicator(),
          ),
        ));
  }

  Widget showLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: MyColors.Yellow,
      ),
    );
  }

  Widget buildNoInternetWidget() {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Can\'t connect .. check internet',
              style: TextStyle(
                fontSize: 22,
                color: MyColors.Grey,
              ),
            ),
            Image.asset('assets/images/no_internet.png')
          ],
        ),
      ),
    );
  }

  Widget buildBlocWidget() {
    return BlocBuilder<MoviesBloc, MoviesState>(
        // ignore: missing_return
        builder: (context, state) {
      if (state is LoadingMoviesState) {
        return Center(
            child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(MyColors.Yellow),
        ));
      } else if (state is LoadedMoviesState) {
        items = state.items;
        modelrespose = state.modelrespose;
        return buildLoadedListWidgets();
      } else if (state is LoadedMoviesEmptyState) {
        return Container(
            child: Center(child: Text("There is no movies here yet.")));
      } else if (state is FailedMoviesState) {
        return Container(
            child: Center(
                child:
                    Text("Some thing went wrong, please try  again later.")));
      } else {
        return Container(
            child:
                Center(child: Text("Error : Please try to restart the app")));
      }
    });
  }

  Widget buildLoadedListWidgets() {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildCharactersList(),
        ],
      ),
    );
  }

  currentPage(int index) {
    // this.current_page = index + 1;
    setState(() {
      this.current_page = index + 1;
    });
  }

  Widget buildCharactersList() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 1,
      ),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: items.length,
      itemBuilder: (ctx, index) {
        return movieItem(
          movie: items[index],
        );
      },
    );
  }
}
