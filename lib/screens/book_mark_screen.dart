import 'package:flutter/material.dart';
import 'package:news_app/controllers/news_controller.dart';
import 'package:news_app/models/articles_model.dart';
import 'package:news_app/screens/details_page.dart';
import 'package:news_app/screens/homepage.dart';
import 'package:provider/provider.dart';

class BookMarkScreen extends StatefulWidget {
  const BookMarkScreen({Key? key}) : super(key: key);

  @override
  State<BookMarkScreen> createState() => _BookMarkScreenState();
}

class _BookMarkScreenState extends State<BookMarkScreen> {
  List<Articles> bookMarkArticle = [];

  Future<void> loadBookmarkedArticles() async {
    final controller = Provider.of<NewsController>(context, listen: false);
    bookMarkArticle = await controller.getBookmarkedArticles();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadBookmarkedArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BookMark"),
      ),
      body: bookMarkArticle.isNotEmpty
          ? ListView.builder(
              itemCount: bookMarkArticle.length,
              itemBuilder: (context, index) {
                Articles article = bookMarkArticle[index];
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
                              child:Container(
                                margin:
                                const EdgeInsets.only(right: 10),
                                child: const Icon(
                                   Icons.bookmark_added_rounded ,
                                  color:Colors.greenAccent ,
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
              })
          : const Center(
              child: Text(
                "No Article Found",
                style: TextStyle(color: Colors.white),
              ),
            ),
    );
  }
}
