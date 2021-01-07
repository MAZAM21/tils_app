import 'package:flutter/material.dart';
import 'package:tils_app/widgets/drawer.dart';
import 'package:tils_app/widgets/time_table_builder.dart';

import './attendance_page.dart';
import './choose_records_screen.dart';
import './edit-timetable-form.dart';
import './home.dart';
import './time_table.dart';

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
          title: Text('TAPP'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(30),
            child: ColoredTabBar(
              
              color: Colors.black,
              tabBar: TabBar(
                labelColor: Theme.of(context).primaryColor,
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
                  Tab(
                    text: 'Attendance'
                  ),
                  Tab(
                    text: 'Records',
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            EditTTForm(),
            TimeTableBuilder(),
            HomePage(),
            AttendancePage(),
            RecordsPage(),
          ],
        ),
      ),
    );
  }
}
