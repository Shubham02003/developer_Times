import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DeatailsNews extends StatefulWidget {
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;
  DeatailsNews(
      {super.key, this.description,
      this.content,
      this.title,
      this.urlToImage,
      this.publishedAt,
      this.url,
      this.author});

  @override
  State<DeatailsNews> createState() => _DeatailsNewsState();
}

class _DeatailsNewsState extends State<DeatailsNews> {
  @override
  Widget build(BuildContext context) {
    if (widget.url != 'null') {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title!),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  child: Image(
                    fit: BoxFit.fill,
                    width: 380,
                    height: 300,
                    image: NetworkImage(widget.urlToImage!),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(widget.publishedAt!),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    widget.title!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(widget.description!),
                const SizedBox(
                  height: 10,
                ),
                Text(widget.content!),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () async {
                    if (!await launchUrl(Uri.parse(widget.url!),)) {
                      throw Exception('Could not launch ${widget.url}');
                    }
                  },
                  style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.red.shade300,
                  ),
                  child: const Text(
                    'Read More',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
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
