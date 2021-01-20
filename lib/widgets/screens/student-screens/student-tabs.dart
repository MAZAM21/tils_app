import 'package:flutter/material.dart';
import 'package:tils_app/models/role.dart';
import 'package:tils_app/widgets/drawer.dart';
import 'package:tils_app/widgets/screens/attendance/attendance_page.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/widgets/screens/loading-screen.dart';
import 'package:tils_app/widgets/screens/student-screens/student_home.dart';

import '../records/choose_records_screen.dart';
import '../time table/edit-timetable-form.dart';
import '../home/home.dart';
import '../time table/time_table.dart';

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

class _AllStudentTabsState extends State<AllStudentTabs> with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    // TODO: implement initState
    _controller = TabController(vsync: this, length: 5);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   
    bool isActive = false;

    return !isActive
        ? LoadingScreen()
        : DefaultTabController(
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
                        controller: _controller,
                        labelColor: Theme.of(context).primaryColor,
                        isScrollable: true,
                        tabs: <Widget>[
                         
                        ]),
                  ),
                ),
              ),
              body: TabBarView(children: <Widget>[
               
              ]),
            ),
          );
  }
}
