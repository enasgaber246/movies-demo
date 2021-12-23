import 'package:flutter/material.dart';
import 'package:movies/constants/colors.dart';
import 'package:movies/data/models/movies_response.dart';

class movieDetailsScreen extends StatelessWidget {
  static String routeName = "/details_screen";
   MovieModel? movie;


  Widget buildSliverAppBar() {

    return SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      stretch: true,
      backgroundColor:MyColors.White,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          movie!.title,
          style: TextStyle(color: MyColors.White, fontFamily: "meduim",),
        ),
        background: Hero(
          tag: movie!.id,
          child: Image.network(
            'https://image.tmdb.org/t/p/w500/${movie!.posterPath}',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget movieInfo(String title, String value) {
    return RichText(
      //overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
              fontFamily: "meduim",
              color: MyColors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontFamily: "meduim",
              color: MyColors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDivider(double endIndent) {
    return Divider(
      height: 30,
      endIndent: endIndent,
      color: MyColors.Yellow,
      thickness: 2,
    );
  }



  Widget showProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: MyColors.Yellow,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    final arguments = ModalRoute.of(context)!.settings.arguments as Map;

    if (arguments != null) {
      this.movie=arguments['movie'];
    }

    return Scaffold(
      backgroundColor: MyColors.White,
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: EdgeInsets.fromLTRB(14, 14, 14, 0),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      movieInfo('Language : ', movie!.originalLanguage),
                      buildDivider(0.15),
                      movieInfo(
                          'Over View : ', movie!.overview),
                      buildDivider(0.15),

                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}