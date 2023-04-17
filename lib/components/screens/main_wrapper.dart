import 'package:flutter/material.dart';
import 'package:smartrr/components/screens/shop/shop.dart';
import 'package:smartrr/components/screens/user/home.dart';
import 'package:smartrr/components/screens/user/profile.dart';
import 'package:smartrr/components/screens/chatbot/chatbot.dart';
import 'package:smartrr/components/widgets/custom_drawer.dart';
import 'package:smartrr/theme/svg_icons.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  List<Widget> pages = [Home(), Shop(), ChatBot(), Profile()];

  int _currentIndex = 0;

  Widget _widgetAt(int index) => pages[index];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SmartIcons.Home,
            activeIcon: SmartIcons.HomeActive,
            label: "Home",
            tooltip: "Home",
          ),
          BottomNavigationBarItem(
            icon: SmartIcons.Cart,
            activeIcon: SmartIcons.CartActive,
            label: "Shop",
            tooltip: "Shop",
          ),
          BottomNavigationBarItem(
            icon: SmartIcons.Message,
            activeIcon: SmartIcons.MessageActive,
            label: "Chatbot",
            tooltip: "Chatbot",
          ),
          BottomNavigationBarItem(
            icon: SmartIcons.Profile,
            activeIcon: SmartIcons.ProfileActive,
            label: "Profile",
            tooltip: "Profile",
          )
        ],
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
