import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:horizonuser/localization/localization_constants.dart';
import 'package:horizonuser/pages/category.dart';
import 'package:horizonuser/pages/home.dart';
import 'package:horizonuser/pages/cart.dart';
import 'package:horizonuser/pages/profile.dart';
import 'package:connectivity_widget/connectivity_widget.dart';

import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';


class MyHomePage extends StatefulWidget {
  final internet_status;
  final index;
  const MyHomePage({Key key, this.internet_status,this.index}): super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _page=0;
  bool internet=true;


  @override
  void initState() {

    setState(() {
      internet=widget.internet_status==null?true:widget.internet_status;
    });


    super.initState();
  }
  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    Categories(),
    Cart(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body:  _widgetOptions.elementAt(_page),

      bottomNavigationBar:  BottomNavigationBar(
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(getTranslated(context,"Home")),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text(getTranslated(context,"Products")),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text(getTranslated(context,"Shopping Cart")),
          ),BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text(getTranslated(context,"Profile")),
          ),
        ],
        currentIndex: _page,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor:Colors.grey,
        onTap: changeTab,
      ),




    );
  }
  changeTab(int index) {
    setState(() {
      _page = index;
    });
  }
}