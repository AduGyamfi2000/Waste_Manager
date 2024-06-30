import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'pages/account.dart';
import 'pages/currentlocation.dart';
import 'pages/recycle_items.dart';
import 'pages/recyclingtech.dart';

class MyTabs extends StatefulWidget {
  const MyTabs({super.key});

  @override
  MyTabsState createState() => MyTabsState();
}

class MyTabsState extends State<MyTabs> {
  int _selectedIndex = 0;

  static final List<Widget> _tabs = <Widget>[
    const Recycle(),
    const CurrentLocationPage(),
    const RecycleItemsPage(),
    const AccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("WasteManager",
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Consumer<ThemeModel>(
            builder: (context, themeModel, child) {
              return IconButton(
                icon: Icon(
                    themeModel.isDarkMode ? Icons.dark_mode : Icons.light_mode),
                onPressed: () {
                  themeModel.toggleTheme();
                },
              );
            },
          ),
        ],
      ),
      body: Center(child: _tabs.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.list_outlined), label: "Information"),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_city_outlined), label: "Map"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart_sharp),
              label: "Recycle Items"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box), label: "Account"),
        ],
        currentIndex: _selectedIndex,
        selectedFontSize: 10,
        selectedItemColor: Colors.redAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
