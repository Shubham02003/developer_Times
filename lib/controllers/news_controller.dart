import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:news_app/models/articles_model.dart';
import 'package:news_app/common/failure.dart';
import 'package:news_app/repositories/news_repo.dart';

class NewsController extends ChangeNotifier {
  final NewsRepository _newsRepository;
  ArticleModel? _articleModel;
  bool _isLoading = false;

  ArticleModel? get articleModel => _articleModel;
  bool get isLoading => _isLoading;

  NewsController(this._newsRepository);

  Future<void> fetchNews(BuildContext context, String query) async {
    if( _articleModel==null || _articleModel!.articles==null || _articleModel!.articles!.isEmpty || query!= "everything"){
      _setLoading(true);
       final result = await _newsRepository.getNews(query);
       result.match(
             (article) {
           _articleModel = article;
           _setLoading(false);
           notifyListeners();
         },
             (failure) {
           _setLoading(false);
           _showErrorSnackBar(context, failure.message);
         },
       );
    }else{

      print("list have data");
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
