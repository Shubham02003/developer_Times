import 'dart:convert';
import 'package:http/http.dart' as http;
import 'articles_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GetArticle {
  ArticleModel articleModel=ArticleModel();
    Future<ArticleModel> getNews(String query) async {
      await dotenv.load();
    String apiKey = dotenv.get('API_KEY');
    http.Response response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?q=$query&apiKey=$apiKey'));
    var jsondata = jsonDecode(response.body);

    if (response.statusCode == 200) {
      articleModel = ArticleModel.fromJson(jsondata);
    }
    return articleModel;
  }
}
