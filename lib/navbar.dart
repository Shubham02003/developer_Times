import 'package:flutter/material.dart';
import 'package:news_app/screens/book_mark_screen.dart';
import 'package:news_app/screens/homepage.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int index =0;
  List<Widget> screens = [
    const HomeScreen()  ,
    const BookMarkScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens.elementAt(index) ,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (ind){
          setState(() {
            index = ind;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_added_rounded),
            label: "BookMark",
          )
        ],
      ),
    );
  }
}
