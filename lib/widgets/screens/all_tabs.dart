import 'package:flutter/material.dart';

import 'package:tils_app/widgets/drawer.dart';

import 'package:tils_app/widgets/screens/teacher-screens/attendance/attendance_page.dart';
import 'package:tils_app/widgets/screens/teacher-screens/home/teacher-home.dart';
import 'package:tils_app/widgets/screens/teacher-screens/teacher-rankings/teacher-ranking-display.dart';


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

class AllTabs extends StatefulWidget {
  @override
  _AllTabsState createState() => _AllTabsState();
}

class _AllTabsState extends State<AllTabs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text(
            'Blackstone Teacher\'s Portal',
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.justify,
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(30),
            child: ColoredTabBar(
              color: Theme.of(context).canvasColor,
              tabBar: TabBar(
                  labelColor: Color.fromARGB(255, 76, 76, 76),
                  indicatorColor: Color.fromARGB(255, 143, 166, 203),
                  isScrollable: false,
                  tabs: <Widget>[
                    Tab(
                      text: 'Rankings',
                    ),
                    Tab(
                      text: 'Home',
                    ),
                    Tab(text: 'Attendance'),
                  ]),
            ),
          ),
        ),
        body: TabBarView(children: <Widget>[
          TeacherRankingDisplay(),
          HomePage(),
          AttendancePage(),
        ]),
      ),
    );
  }
}
