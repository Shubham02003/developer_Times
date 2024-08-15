import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/screens/homepage.dart';
import 'package:url_launcher/url_launcher.dart';

class ReadArticle extends StatefulWidget {
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;
  const ReadArticle({
    super.key,
    required this.description,
    required this.content,
    required this.title,
    required this.urlToImage,
    required this.publishedAt,
    required this.url,
    required this.author,
  });

  @override
  State<ReadArticle> createState() => _ReadArticleState();
}

class _ReadArticleState extends State<ReadArticle> {
  @override
  Widget build(BuildContext context) {
    if (widget.url != 'null') {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusDirectional.circular(10),
                  child: Image(
                    fit: BoxFit.fill,
                    width: 380,
                    height: 300,
                    image: NetworkImage(widget.urlToImage),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(widget.publishedAt),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(widget.description),
                const SizedBox(
                  height: 10,
                ),
                Text(widget.content),
                const SizedBox(
                  height: 10,
                ),
                ReadMoreButton(
                  onPressed: () async {
                    if (await launchUrl(
                      Uri.parse(widget.url),
                    )) {
                      throw Exception('Could not launch ${widget.url}');
                    }
                  },
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return const CircularProgressIndicator();
    }
  }
}
