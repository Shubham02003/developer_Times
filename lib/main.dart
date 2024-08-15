import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/controllers/news_controller.dart';
import 'package:news_app/models/articles_model.dart';
import 'package:news_app/navbar.dart';
import 'package:news_app/repositories/news_repo.dart';
import 'package:provider/provider.dart';
import './models/articles_model.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ArticleModelAdapter());
  Hive.registerAdapter(ArticlesAdapter());
  Hive.registerAdapter(SourceAdapter());

  await Hive.openBox<ArticleModel>('bookmarks');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NewsController(
            NewsRepository(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: const BottomNavBar(),
      ),
    );
  }
}
