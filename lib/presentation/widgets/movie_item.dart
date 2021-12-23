import 'package:flutter/material.dart';
import 'package:movies/constants/colors.dart';
import 'package:movies/data/models/movies_response.dart';
import 'package:movies/presentation/screens/movie_datails.dart';

class movieItem extends StatelessWidget{
  final MovieModel movie;

  const movieItem({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
      padding: EdgeInsetsDirectional.all(4),
      decoration: BoxDecoration(
        color: MyColors.White,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, movieDetailsScreen.routeName , arguments: {'movie': movie}),
        child: GridTile(
          child: Hero(
            tag: movie.id,
            child: Container(
              color: MyColors.Grey,
              child: movie.posterPath.isNotEmpty
                  ? FadeInImage.assetNetwork(
                width: double.infinity,
                height: double.infinity,
                placeholder: 'assets/images/loading.jpg',
                image:'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                fit: BoxFit.cover,
              )
                  : Image.asset('assets/images/placeholder.jpg'),
            ),
          ),
          footer: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: Colors.black54,
            alignment: Alignment.bottomCenter,
            child: Text(
              '${movie.title}',
              style: TextStyle(
                height: 1.3,
                fontSize: 16,
                fontFamily: "meduim",
                color: MyColors.White,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}