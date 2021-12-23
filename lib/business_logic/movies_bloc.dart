import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/data/models/movies_response.dart';
import 'package:movies/data/web_services/movies_web_services.dart';

class MoviesBloc extends Bloc<MediaMoviesEvent, MoviesState> {
  MoviesBloc() : super(LoadingMoviesState());

  @override
  Stream<MoviesState> mapEventToState(MediaMoviesEvent event) async* {
    if (event is LoadMediaMoviesEvent) {
      yield LoadingMoviesState();

      String response =
      await MoviesWebServices().postData(url: checkEndPoint(event.type),pageNum: event.pageNum);

      try {
        print("Response : ${response.toString()}");

        final data = jsonDecode(response) as Map<String, dynamic>;
        MoviesResponse result = MoviesResponse.fromJson(data);

        if ((result.results ?? []).isNotEmpty) {
          yield LoadedMoviesState(items: result.results ?? [],modelrespose: result);
        } else {
          yield LoadedMoviesEmptyState();
        }
      } catch (e) {
        print("Error : ");
        print(e.toString());
        yield FailedMoviesState(error: e);
      }
    }
  }

  String checkEndPoint(int type){
    String endPoint = 'top_rated';
    switch (type) {
      case 0:
        endPoint = 'top_rated';
        break;
      case 1:
        endPoint = 'popular';
        break;
      case 2:
        endPoint = 'now_playing';
        break;
    }

    return endPoint;
  }
}

// Event
abstract class MediaMoviesEvent {}

class LoadMediaMoviesEvent extends MediaMoviesEvent {
  int type = 0;
  int pageNum=1;
  LoadMediaMoviesEvent(this.type,this.pageNum);
}
abstract class MoviesState {}

class LoadingMoviesState extends MoviesState {}

class LoadedMoviesEmptyState extends MoviesState {}

class LoadedMoviesState extends MoviesState {
  List<MovieModel> items;
  MoviesResponse modelrespose;
  LoadedMoviesState({required this.items,required this.modelrespose});
}

class FailedMoviesState extends MoviesState {
  Object error;

  FailedMoviesState({required this.error});
}
