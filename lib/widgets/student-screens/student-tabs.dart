import 'package:flutter/material.dart';
import 'package:tils_app/widgets/student-screens/rankings/student-ranking-display.dart';


import 'package:tils_app/widgets/student-screens/student-drawer.dart';

import './student_home/student_home.dart';

class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar({this.color, this.tabBar});

  final Color color;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Container(
        color: color,
        child: tabBar,
      );
}

class AllStudentTabs extends StatefulWidget {
  @override
  _AllStudentTabsState createState() => _AllStudentTabsState();
}

class _AllStudentTabsState extends State<AllStudentTabs>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        drawer: StudentDrawer(),
        appBar: AppBar(
          title: Text(
            'Blackstone Student\'s Portal',
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.justify,
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(30),
            child: ColoredTabBar(
              color: Theme.of(context).canvasColor,
              tabBar: TabBar(
                  controller: _controller,
                  labelColor: Color.fromARGB(255, 76, 76, 76),
                  indicatorColor: Color.fromARGB(255, 143, 166, 203),
                  isScrollable: false,
                  tabs: <Widget>[
                    Tab(
                      text: 'Home',
                    ),
                    Tab(
                      text: 'Rankings',
                    ),
                  ]),
            ),
          ),
        ),
        body: TabBarView(children: <Widget>[
          StudentHome(),
          StudentRankingDisplay(),
        ]),
      ),
    );
  }
}
