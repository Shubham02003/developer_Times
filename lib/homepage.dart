import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news_app/Networking/load_data.dart';
import 'details_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  GetArticle getArticle = GetArticle();
  String location = "everything";
  bool isConnection = false;
  GestureDetector customTile(String topic) {
    return GestureDetector(
      onTap: () {
        checkInterNetConnection();
        if (isConnection) {
          setState(() {
            location = topic;
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

  Future<bool> checkInterNetConnection() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        isConnection = true;
      });
      return true;
    } else {
      setState(() {
        isConnection = false;
      });
      return false;
    }
  }

  @override
  void initState() {
    checkInterNetConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'News',
        ),
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
          ? FutureBuilder(
              future: getArticle.getNews(location),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        if (snapshot.data!.articles![index].urlToImage
                                .toString() !=
                            'null') {
                          return Container(
                            margin: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DeatailsNews(
                                                author: snapshot.data!
                                                    .articles![index].author
                                                    .toString(),
                                                title: snapshot.data!
                                                    .articles![index].title
                                                    .toString(),
                                                description: snapshot
                                                    .data!
                                                    .articles![index]
                                                    .description
                                                    .toString(),
                                                url: snapshot
                                                    .data!.articles![index].url
                                                    .toString(),
                                                urlToImage: snapshot.data!
                                                    .articles![index].urlToImage
                                                    .toString(),
                                                publishedAt: snapshot
                                                    .data!
                                                    .articles![index]
                                                    .publishedAt
                                                    .toString(),
                                                content: snapshot.data!
                                                    .articles![index].content
                                                    .toString(),
                                              )),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image(
                                      fit: BoxFit.fill,
                                      width: 380,
                                      height: 200,
                                      image: NetworkImage(snapshot
                                          .data!.articles![index].urlToImage
                                          .toString()),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    snapshot.data!.articles![index].title
                                        .toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,

                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data!.articles![index].description
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade600),
                                ),
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
                      });
                } else {
                  return const CircularProgressIndicator();
                }
              },
            )
          : const Center(
              child: Text('Please check Internet Connection....'),
            ),
    );
  }
}
