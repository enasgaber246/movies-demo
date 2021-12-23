
import 'package:http/http.dart' as http;
class MoviesWebServices {
  Future<String> postData(
      {required String url,
        required int pageNum,
        String lang = 'en',
       }) async {

    var res = await http.post(
        Uri.parse( 'https://api.themoviedb.org/3/movie/$url?api_key=a8b30d1dc4543784205e7b699751fcc7&page=$pageNum'),
    );

    return res.body;
  }
}
