import 'package:flutter/cupertino.dart';
import 'package:movies/presentation/screens/movies_screen.dart';

import 'presentation/screens/movie_datails.dart';

final Map<String,WidgetBuilder> routes={
  moviesScreen.routeName:(context)=>moviesScreen(),
  movieDetailsScreen.routeName:(context)=>movieDetailsScreen(),
};