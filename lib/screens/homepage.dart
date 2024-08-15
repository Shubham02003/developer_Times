import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:news_app/controllers/news_controller.dart';
import 'package:news_app/models/articles_model.dart';
import 'details_page.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String location = "everything";
  bool isConnection = false;
  late StreamSubscription<ConnectivityResult> subscription;
  List<Articles> bookmarkedArticles = [];

  GestureDetector customTile(String topic) {
    return GestureDetector(
      onTap: () {
        // checkInterNetConnection();
        if (isConnection) {
          setState(() {
            location = topic;
            Provider.of<NewsController>(context, listen: false)
                .fetchNews(context, location);
          });
        }
        Navigator.pop(context);
      },
      child: Container(
        color: Colors.black,
        child: ListTile(
          leading: const Icon(
            Icons.add_alert,
            color: Colors.white,
          ),
          title: Text(
            topic,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loadBookmarkedArticles() async {
    final controller = Provider.of<NewsController>(context, listen: false);
    bookmarkedArticles = await controller.getBookmarkedArticles();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadBookmarkedArticles();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        setState(() {
          isConnection = true;
          Provider.of<NewsController>(context, listen: false)
              .fetchNews(context, location);
        });
      } else {
        isConnection = false;
      }
    });
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              customTile('India'),
              customTile('business'),
              customTile('general'),
              customTile('health'),
              customTile('Corona'),
              customTile('Share Market'),
              customTile('Maharashtra'),
              customTile('Bollywood'),
              customTile('Politics'),
              customTile('Sports'),
              customTile('Tech'),
              customTile('BJP'),
              customTile('us'),
              customTile('Hackathon'),
            ],
          ),
        ),
      ),
      body: isConnection
          ? Consumer<NewsController>(
              builder: (context, controller, child) {
                if (controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.articleModel != null &&
                    controller.articleModel!.articles != null) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.articleModel!.articles!.length,
                    itemBuilder: (context, index) {
                      final article = controller.articleModel!.articles![index];
                      bool isBookMarked = bookmarkedArticles.contains(article);
                      if (article.urlToImage != null) {
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 3),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(
                                  10,
                                  10,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(17),
                                    topRight: Radius.circular(17)),
                                child: Image.network(
                                  article.urlToImage ?? "",
                                  fit: BoxFit.fill,
                                  height: 200,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                width: double.infinity,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.s,
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        child: Text(
                                          article.title ?? "",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                         Provider.of<NewsController>(context,
                                                listen: false)
                                            .toggleBookmark(article);
                                         loadBookmarkedArticles();
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: Icon(
                                          isBookMarked ? Icons.bookmark_added_rounded : Icons.bookmark_border,
                                          color: isBookMarked ? Colors.greenAccent : Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 10,
                                  right: 5,
                                ),
                                child: Text(
                                  article.description ?? "",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ReadMoreButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReadArticle(
                                        author: article.author ?? "Unknown",
                                        title: article.title ?? "",
                                        description: article.description ?? "",
                                        url: article.url ?? "",
                                        urlToImage: article.urlToImage ?? "",
                                        publishedAt: article.publishedAt ?? "",
                                        content: article.content ?? "",
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        );
                      } else {
                        return const SizedBox(
                          height: 200,
                          child: Image(
                            image: NetworkImage(
                                "https://miro.medium.com/max/880/0*H3jZONKqRuAAeHnG.jpg"),
                          ),
                        );
                      }
                    },
                  );
                } else {
                  return const Center(
                    child: Text('No articles found'),
                  );
                }
              },
            )
          : const Center(
              child: Text('Please check Internet Connection....'),
            ),
    );
  }
}

class ReadMoreButton extends StatelessWidget {
  const ReadMoreButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.redAccent,
            gradient: const LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [Colors.black12, Colors.grey, Colors.black26],
            ),
            borderRadius: BorderRadiusDirectional.circular(25),
          ),
          child: const Text(
            "Read More ...",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          )),
    );
  }
}
