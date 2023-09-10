import 'package:SIL_app/models/institutemd.dart';
import 'package:SIL_app/models/student-user-data.dart';
import 'package:SIL_app/widgets/screens/loading-screen.dart';
import 'package:flutter/material.dart';
import 'package:SIL_app/widgets/student-screens/rankings/student-ranking-display.dart';

import 'package:SIL_app/widgets/student-screens/student-drawer.dart';
import 'package:SIL_app/widgets/student-screens/student-newsfeed/student-newsfeed.dart';
import 'package:provider/provider.dart';
import './student_home/student_home.dart';

class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar({this.color, this.tabBar});

  final Color? color;
  final TabBar? tabBar;

  @override
  Size get preferredSize => tabBar!.preferredSize;

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
  TabController? _controller;

  @override
  Widget build(BuildContext context) {
    final instData = Provider.of<InstituteData?>(context);
    final studData = Provider.of<StudentUser?>(context);
    bool isActive = false;
    if (studData != null) {
      isActive = true;
    }
    return !isActive
        ? LoadingScreen()
        : Row(
            children: [
              StudentDrawer(studData!),
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  initialIndex: 1,
                  child: Scaffold(
                    drawer: StudentDrawer(studData!),
                    appBar: AppBar(
                      title: Text(
                        '${instData!.name} Student\'s Portal',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.justify,
                      ),
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(30),
                        child: ColoredTabBar(
                          color: Theme.of(context).canvasColor,
                          tabBar: TabBar(
                              controller: _controller,
                              labelColor: Color.fromARGB(255, 76, 76, 76),
                              indicatorColor:
                                  Color.fromARGB(255, 143, 166, 203),
                              isScrollable: false,
                              tabs: <Widget>[
                                Tab(
                                  text: 'NewsFeed',
                                ),
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
                      StudentNewsFeed(),
                      StudentHome(),
                      StudentRankingDisplay(),
                    ]),
                  ),
                ),
              ),
            ],
          );
  }
}
