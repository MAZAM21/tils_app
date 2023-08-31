import 'package:flutter/material.dart';
import 'package:SIL_app/models/institutemd.dart';

import 'package:SIL_app/models/student_rank.dart';
import 'package:SIL_app/service/db.dart';
import 'package:provider/provider.dart';
import 'package:SIL_app/widgets/button-styles.dart';

class EditStudSubs extends StatefulWidget {
  static const routeName = '/edit-stud-subs';
  const EditStudSubs(this.stud, this.instData);

  final StudentRank stud;
  final InstituteData? instData;
  @override
  State<EditStudSubs> createState() => _EditStudProfileState();
}

class _EditStudProfileState extends State<EditStudSubs> {
  List _selectedSubs = [];
  List _originalSubs = [];
  String? _section = '';
  String? _year = '';
  Map<String, Map<String, dynamic>> year_subjects = {};
  @override
  void initState() {
    super.initState();
    _year = widget.stud.year;
    _section = widget.stud.section;
    year_subjects = widget.instData!.year_subjects;
    _selectedSubs = widget.stud.subjects!;
    _originalSubs = List.from(widget.stud.subjects!);
  }

  void didChangeDependencies() {
    // widget.stud.subjects!.forEach((sub) {
    //   _selectedSubs.add(sub);
    // });
    _year = widget.stud.year;
    _section = widget.stud.section;
    year_subjects = widget.instData!.year_subjects;
    _selectedSubs = widget.stud.subjects!;
    _originalSubs = List.from(widget.stud.subjects!);

    super.didChangeDependencies();
  }

  void revertChanges() {
    print('revert changes called');
    print('stud subs: ${widget.stud.subjects!}');
    setState(() {
      _selectedSubs.clear();
      _selectedSubs.addAll(List.from(_originalSubs));
    });
    print('exit selectsubs: $_selectedSubs');
  }

  Widget buildYearButton(
    String year,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _section = '';

            _year = year;
          });
          print('in buildyear');
          print('$_year');
          print('$_section');
        },
        child: Text(
          year,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Proxima Nova',
            fontWeight: FontWeight.w600,
            color: _year == year ? Color(0xffffffff) : Color(0xff161616),
          ),
        ),
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(107, 25)),
          fixedSize: MaterialStateProperty.all(Size(110, 32)),
          backgroundColor: _year == year
              ? MaterialStateProperty.all(Color(0xffC54134))
              : MaterialStateProperty.all(Color(0xfff4f6f9)),
        ),
      ),
    );
  }

  List<Widget> buildSubjectGrid(sectionSubs) {
    List<Widget> rows = [];
    print('sectionSubs: $sectionSubs');
    final subLength = sectionSubs!.length;
    print('subLength: $subLength');

    /// The main for loop iterates for every three subjects added
    /// when the value of i exceeds the subjects, it terminates
    if (subLength > 0) {
      for (int i = 0; i < subLength; i += 3) {
        List<Widget> children = [];

        /// the inner for loop condition iterates to three and checks whether
        /// the subject length has been reached by adding the main for loop i with
        /// the inner for loop j and seeing if they are less than subLength

        for (int j = 0; j < 3 && i + j < subLength; j++) {
          print(i + j);
          if (_selectedSubs.isNotEmpty &&
              _selectedSubs.contains(sectionSubs[i + j])) {
            children.add(RedButtonMain(
                child: '${sectionSubs[i + j]}',
                onPressed: () {
                  setState(() {
                    _selectedSubs.remove(sectionSubs[i + j]);
                  });
                  print('in buildsubject red');
                  // print('$_year');
                  // print('$_section');
                  // print(_selectedSub);
                }));
          } else {
            children.add(WhiteButtonMain(
                child: '${sectionSubs[i + j]}',
                onPressed: () {
                  setState(() {
                    _selectedSubs.add(sectionSubs[i + j]);
                  });
                  print('in buildsubject white');
                  print('$_year');
                  print('$_section');
                  print(_selectedSubs[i + j]);
                }));
          }

          //end of inner for loop
        }

        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: children,
        ));

        //end of outer for loop
      }
    }
    return rows;
  }

  Widget buildSectionButton(String section) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _section = section;
          });
          print('in buildSection');
          print('$_year');
          print('$_section');
          //print(_selectedSub);
        },
        child: Text(
          section,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Proxima Nova',
            fontWeight: FontWeight.w600,
            color: _section == section ? Color(0xffffffff) : Color(0xff161616),
          ),
        ),
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(107, 25)),
          fixedSize: MaterialStateProperty.all(Size(110, 32)),
          backgroundColor: _section == section
              ? MaterialStateProperty.all(Color(0xffC54134))
              : MaterialStateProperty.all(Color(0xfff4f6f9)),
        ),
      ),
    );
  }

  // Widget _buildSubButton(String subName) {
  //   return ElevatedButton(
  //     child: Text(
  //       subName == 'Jurisprudence' ? 'Juris' : subName,
  //       style: TextStyle(
  //         fontSize: 12.5,
  //         fontFamily: 'Proxima Nova',
  //         fontWeight: FontWeight.w600,
  //         color: _selectedSubs.contains(subName)
  //             ? Color(0xffffffff)
  //             : Color(0xff161616),
  //       ),
  //     ),
  //     style: ButtonStyle(
  //       backgroundColor: _selectedSubs.contains(subName)
  //           ? MaterialStateProperty.all(Color(0xffc54134))
  //           : MaterialStateProperty.all(Color(0xfff4f6f9)),
  //     ),
  //     onPressed: _selectedSubs.contains(subName)
  //         ? () {
  //             setState(() {
  //               _selectedSubs.remove('$subName');
  //             });
  //           }
  //         : () {
  //             setState(() {
  //               _selectedSubs.add(subName);
  //             });
  //           },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<DatabaseService>(context, listen: false);

    print(year_subjects);
    print(_year);
    print('section: $_section');
    print('selectedSubs: $_selectedSubs');
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: Color(0xffffffff),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            revertChanges(); // Revert changes before navigating back
            Navigator.of(context).pop(); // Navigate back
          },
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          SizedBox(height: 25),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Year',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: year_subjects.keys
                .map((year) => buildYearButton(year))
                .toList(),
          ),
          if (_year!.isNotEmpty)
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Select Section',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          SizedBox(height: 25),
          if (_year!.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: year_subjects[_year]!
                  .keys
                  .map((section) => buildSectionButton(section))
                  .toList(),
            ),
          SizedBox(height: 25),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Registered Subjects',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          if (_year!.isNotEmpty && _section!.isNotEmpty)
            Container(
              height: 280,
              child: Row(
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: buildSubjectGrid(
                              year_subjects[_year]?[_section])),
                    ),
                  ),
                ],
              ),
            ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                db.editStudentSubs(_selectedSubs, widget.stud, _year, _section,
                    widget.instData!.inst_subjects);
                //db.printInstID();
              });
            },
            child: Text(
              'Save Subject Changes',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Proxima Nova',
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23)),
                ),
                minimumSize: MaterialStateProperty.all(Size(107, 25)),
                fixedSize: MaterialStateProperty.all(Size(250, 45)),
                backgroundColor: MaterialStateProperty.all(Color(0xffC54134))),
          ),
          SizedBox(
            height: 20,
          ),
          Divider(),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                db.editStudentYear(_year, widget.stud);
              });
            },
            child: Text(
              'Save Year',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Proxima Nova',
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
              ),
              minimumSize: MaterialStateProperty.all(Size(107, 25)),
              fixedSize: MaterialStateProperty.all(Size(150, 45)),
              backgroundColor: MaterialStateProperty.all(Color(0xffC54134)),
            ),
          ),
        ],
      )),
    );
  }
}
