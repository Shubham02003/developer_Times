import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/articles_model.dart';
import 'package:fpdart/fpdart.dart';
import '../common/failure.dart';

class NewsRepository{


  Future<Either<ArticleModel?,Failure>> getNews(String query) async {
    try{
      await dotenv.load();
      String apiKey = dotenv.get('API_KEY');
      final response = await http.get(Uri.parse(
          'https://newsapi.org/v2/everything?q=$query&apiKey=$apiKey'));
      var jsondata = jsonDecode(response.body);
      ArticleModel? articleModel;
      if (response.statusCode == 200) {
        articleModel = ArticleModel.fromJson(jsondata);
      }
      return left(articleModel);
    }catch(e){
        throw Failure(message: e.toString());
    }
  }


}