import 'package:flutter/material.dart';
import 'package:smartrr/components/screens/shop/shop.dart';
import 'package:smartrr/components/screens/user/home.dart';
import 'package:smartrr/components/screens/user/settings.dart';
import 'package:smartrr/components/screens/chatbot/chatbot.dart';
import 'package:smartrr/theme/svg_icons.dart';
import 'package:smartrr/utils/colors.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  List<Widget> pages = [Home(), Shop(), ChatBot(), Settings()];

  int _currentIndex = 0;

  Widget _widgetAt(int index) => pages[index];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: materialWhite,
        items: [
          BottomNavigationBarItem(
              icon:
                  _currentIndex == 0 ? SmartIcons.HomeActive : SmartIcons.Home,
              label: "Home"),
          BottomNavigationBarItem(
              icon:
                  _currentIndex == 1 ? SmartIcons.CartActive : SmartIcons.Cart,
              label: "Shop"),
          BottomNavigationBarItem(
              icon:
                  _currentIndex == 2 ? SmartIcons.Message : SmartIcons.Message,
              label: "Chatbot"),
          BottomNavigationBarItem(
              icon: _currentIndex == 3
                  ? SmartIcons.ProfileActive
                  : SmartIcons.Profile,
              label: "Profile")
        ],
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
