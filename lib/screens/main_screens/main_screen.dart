import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/screens/main_screens/add_book_screen.dart';
import 'package:graduation_project/screens/main_screens/bookmarks_screen.dart';
import 'package:graduation_project/screens/main_screens/user_chats_screen.dart';

import 'home_screen.dart';
import 'notifications_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final List<Widget> _screens = [
    const HomeScreen(),
    const UserChatsScreen(),
    const AddBookScreen(),
    const NotificationsScreens(),
    const BookMarksScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 60.0,
        items: const <CurvedNavigationBarItem>[
          CurvedNavigationBarItem(
            child: Icon(
              Icons.home,
              size: 35,
              color: Color.fromARGB(255, 0, 23, 43),
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.chat,
              size: 35,
              color: Color.fromARGB(255, 0, 23, 43),
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.add,
              size: 50,
              color: Color.fromARGB(255, 0, 23, 43),
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.notifications_active,
              size: 35,
              color: Color.fromARGB(255, 0, 23, 43),
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.bookmark,
              size: 35,
              color: Color.fromARGB(255, 0, 23, 43),
            ),
          ),
        ],
        color: const Color(0xFFB78682),
        buttonBackgroundColor: const Color(0xFFFFD2C8),
        backgroundColor: Colors.blueGrey,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: _screens[_selectedIndex],
    );
  }
}
