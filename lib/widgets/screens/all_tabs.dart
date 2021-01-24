


import 'package:flutter/material.dart';

import 'package:tils_app/widgets/drawer.dart';
import 'package:tils_app/widgets/screens/attendance/attendance_page.dart';

import './records/choose_records_screen.dart';
import './time table/edit-timetable-form.dart';
import './home/home.dart';
import './time table/time_table.dart';

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
      length: 5,
      initialIndex: 2,
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text(
            'TILS Teacher\'s Portal',
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.justify,
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(30),
            child: ColoredTabBar(
              color: Color.fromARGB(255, 0, 109, 119),
              tabBar: TabBar(
                  labelColor: Color.fromARGB(255, 237, 246, 249),
                  isScrollable: true,
                  tabs: <Widget>[
                    Tab(
                      text: 'Edit Time Table',
                    ),
                    Tab(
                      text: 'Time Table',
                    ),
                    Tab(
                      text: 'Home',
                    ),
                    Tab(text: 'Attendance'),
                    Tab(
                      text: 'Records',
                    ),
                  ]),
            ),
          ),
        ),
        body: TabBarView(children: <Widget>[
          EditTTForm(),
          CalendarApp(),
          HomePage(),
          AttendancePage(),
          RecordsPage(),
        ]),
      ),
    );
  }
}
