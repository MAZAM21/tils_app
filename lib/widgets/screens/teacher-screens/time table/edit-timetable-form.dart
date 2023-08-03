import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/instititutemd.dart';
import 'package:tils_app/models/meeting.dart';
import 'package:tils_app/widgets/button-style.dart';
import 'package:tils_app/models/subject-class.dart';
import 'package:tils_app/service/db.dart';
// import './time_table.dart';

class EditTTForm extends StatefulWidget {
  static const routeName = '/edit-tt-form';
  final InstituteData? instData;
  final Meeting? editClass;
  EditTTForm(this.instData, [this.editClass]);

  @override
  _EditTTFormState createState() => _EditTTFormState();
}

class _EditTTFormState extends State<EditTTForm> {
  DateTime? _startDate = DateTime.now();
  DateTime? _startTime = DateTime.now();
  DateTime? _endTime = DateTime.now();

  String? _topic = '';
  String? _section = '';
  String? _year = '';
  String _duration = '';
  int _customHours = 0;
  int _customMinutes = 0;
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  var _isEdit = false;
  String _selectedSub = '';
  String? _editedId;
  Map<String, Map<String, dynamic>> year_subjects = {};
  bool isExam = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final editClass = widget.editClass;
      final instData = widget.instData;

      print('in edit tt ${instData!.year_subjects}');
      if (editClass != null) {
        year_subjects = instData!.year_subjects;
        _section = editClass.section;
        _topic = editClass.topic ?? '';
        _startDate = editClass.from;
        _startTime = editClass.from;
        _endTime = editClass.to;
        _selectedSub = editClass.eventName;
        _isEdit = true;
        _editedId = editClass.docId;

        _year = editClass.year;
      }
      //if a route argument is passed to this then it copies the passed values to the local variables and executes findMeetingIndex to get the index of the edited element.
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  //sets _subName to SubjectName enum

  //returns string from enum

//takes string returns subject name

//subject option buttons,
//set _subName.

  List<Widget> buildSubjectGrid(sectionSubs) {
    List<Widget> rows = [];
    final subLength = sectionSubs!.length;

    /// The main for loop iterates for every three subjects added
    /// when the value of i exceeds the subjects, it terminates
    for (int i = 0; i < subLength; i += 3) {
      List<Widget> children = [];

      /// the inner for loop condition iterates to three and checks whether
      /// the subject length has been reached by adding the main for loop i with
      /// the inner for loop j and seeing if they are less than subLength

      for (int j = 0; j < 3 && i + j < subLength; j++) {
        if (_selectedSub == sectionSubs[i + j]) {
          children.add(RedSubjectButtonMobile(
              child: '${sectionSubs[i + j]}',
              onPressed: () {
                setState(() {
                  _selectedSub = sectionSubs[i + j];
                });
                print('in buildsubject red');
                print('$_year');
                print('$_section');
                print(_selectedSub);
              }));
        } else {
          children.add(WhiteSubjectButtonMobile(
              child: '${sectionSubs[i + j]}',
              onPressed: () {
                setState(() {
                  _selectedSub = sectionSubs[i + j];
                });
                print('in buildsubject white');
                print('$_year');
                print('$_section');
                print(_selectedSub);
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
    return rows;
  }

  Widget buildYearButton(String year) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _section = '';
            _selectedSub = '';
            _year = year;
          });
          print('in buildyear');
          print('$_year');
          print('$_section');
          print(_selectedSub);
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
          print(_selectedSub);
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

  //date picker
  void pickDate() {
    showDatePicker(
      context: context,
      initialDate: _isEdit ? _startDate! : DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _startDate = pickedDate;
        _startTime = pickedDate;
      });
    });
  }

  //the date selection button
  Widget buildDatepicker() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        child: Text('Date'),
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).primaryColor),
          textStyle:
              MaterialStateProperty.all(Theme.of(context).textTheme.headline6),
        ),
        onPressed: () {
          pickDate();
          print(_startDate);
        },
      ),
    );
  }

  //Displays date
  Widget buildDateDisplay() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          DateFormat('d MMM').format(_startDate!),
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void pickTimeStart() {
    showTimePicker(
      context: context,
      initialTime:
          _isEdit ? TimeOfDay.fromDateTime(_startDate!) : TimeOfDay.now(),
    ).then((time) {
      if (time == null) {
        return;
      }
      setState(() {
        _startTime = DateTime(
          _startDate!.year,
          _startDate!.month,
          _startDate!.day,
          time.hour,
          time.minute,
        );
      });
    });
  }

  Widget buildTimePicker() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: () {
          pickTimeStart();
        },
        child: Text('Start Time'),
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size.fromHeight(35)),
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).primaryColor),
          textStyle:
              MaterialStateProperty.all(Theme.of(context).textTheme.headline6),
        ),
      ),
    );
  }

  Widget buildTimeDisplay() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          DateFormat('h:mm a').format(_startTime!),
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _saveForm(BuildContext context) {
    final db = Provider.of<DatabaseService>(context, listen: false);
    if (!_endTime!.isBefore(_startTime!) &&
        _selectedSub.isNotEmpty &&
        _duration != '' &&
        _section != null) {
      _form.currentState!.save();
      _form.currentState!.reset();
      if (!_isEdit) {
        db.addClassToCF(
          _selectedSub,
          _startTime!,
          _endTime!,
          _section,
          _year,
          _topic,
          isExam,
        );
        setState(() {
          _selectedSub = '';
          _startTime = DateTime.now();
          _duration = '';
          _endTime = null;
          _customHours = 0;
          _customMinutes = 0;
          _section = '';
          _year = '';
        });
      } else {
        db.editClassInCF(
          _editedId,
          _selectedSub,
          _startTime!,
          _endTime!,
          _section,
          _year,
          _topic,
        );
      }
    } else {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => AlertDialog(
          title: Text('Fields Incorrect, or internet not connected'),
          content: Text('Please fill all fields correctly'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    year_subjects = widget.instData!.year_subjects;

    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: Color(0xffffffff),
      ),
      body: SafeArea(
        child: Builder(builder: (BuildContext context) {
          return Form(
            key: _form,
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.915,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (isExam)
                          Row(
                            children: <Widget>[
                              Text(
                                'Add Exam',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'Proxima Nova',
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff2A353F),
                                ),
                              ),
                            ],
                          ),
                        if (!isExam)
                          Row(
                            children: <Widget>[
                              Text(
                                'Add Class',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'Proxima Nova',
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff2A353F),
                                ),
                              ),
                            ],
                          ),
                        SizedBox(
                          height: 25,
                        ),

                        Container(
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Exam',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Proxima Nova',
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff2A353F),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Switch(
                                  activeColor: Color(0xffC54134),
                                  value: isExam,
                                  onChanged: (val) {
                                    setState(() {
                                      isExam = val;
                                    });
                                    print(isExam);
                                  },
                                ),
                              ],
                            )
                          ]),
                        ),

                        /// Section Buttons
                        Container(
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Select Year',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Proxima Nova',
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff2A353F),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: year_subjects.keys
                                    .map((year) => buildYearButton(year))
                                    .toList(),
                              ),
                              if (_year!.isNotEmpty)
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Select Section',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Proxima Nova',
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff2A353F),
                                      ),
                                    ),
                                  ],
                                ),
                              if (_year!.isNotEmpty)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: year_subjects[_year]!
                                      .keys
                                      .map((section) =>
                                          buildSectionButton(section))
                                      .toList(),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),

                        ///Subject Buttons Subject Buttons Subject Buttons Subject Buttons
                        ///Subject Buttons Subject Buttons Subject Buttons Subject Buttons
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: <Widget>[
                              if (_section!.isNotEmpty)
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Select Subject',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Proxima Nova',
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff2A353F),
                                      ),
                                    ),
                                  ],
                                ),
                              SizedBox(
                                height: 12,
                              ),
                              if (_section!.isNotEmpty)
                                Column(
                                  children: buildSubjectGrid(
                                      year_subjects[_year]?[_section]),
                                )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 36,
                        ),

                        ///Date Picker Date Picker Date Picker Date Picker Date Picker Date Picker Date Picker Date Picker
                        ///Date Picker Date Picker Date Picker Date Picker Date Picker Date Picker
                        Container(
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Select Time',
                                    style: TextStyle(
                                      color: Color(0xff2a353f),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Proxima Nova',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              GestureDetector(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Date',
                                      style: TextStyle(
                                        fontFamily: 'Proxima Nova',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff161616),
                                      ),
                                    ),
                                    Text(
                                      DateFormat('d MMMM, y')
                                          .format(_startDate!),
                                      style: TextStyle(
                                          color: Color(0xffC54134),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Proxima Nova'),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  _duration = 'Not Set';
                                  pickDate();
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Start Time',
                                      style: TextStyle(
                                        fontFamily: 'Proxima Nova',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff161616),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Container(
                                        color: Color(0xfff4f6f9),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          child: Text(
                                            DateFormat('h:mm a')
                                                .format(_startTime!),
                                            style: TextStyle(
                                                color: Color(0xff161616),
                                                fontSize: 24,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Proxima Nova'),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  pickTimeStart();
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Class Duration',
                                      style: TextStyle(
                                        fontFamily: 'Proxima Nova',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff161616),
                                      ),
                                    ),
                                    Text(
                                      _duration == ''
                                          ? 'Not set'
                                          : '$_duration',
                                      style: TextStyle(
                                          color: Color(0xffC54134),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Proxima Nova'),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  durationMBS(context);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 27,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Topic',
                              style: TextStyle(
                                color: Color(0xff2a353f),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Proxima Nova',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Container(
                          width: double.infinity,
                          child: TextFormField(
                            maxLines: 10,
                            minLines: 4,
                            initialValue: _topic,
                            keyboardType: TextInputType.text,
                            onSaved: (value) {
                              _topic = value;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffc54134)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              child: Text(
                                'Save to Time Table',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Proxima Nova',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: !_endTime!.isBefore(_startTime!) &&
                                          _selectedSub.isNotEmpty &&
                                          _duration != null &&
                                          _section != null
                                      ? Text(
                                          '$_selectedSub on ${DateFormat('d MMM hh mm a').format(_startTime!)} added to Time Table')
                                      : Text('Class not added'),
                                ));
                                setState(() {
                                  _saveForm(context);
                                });
                                if (_isEdit) {
                                  Navigator.pop(context);
                                }
                              },
                              style: ButtonStyle(
                                  minimumSize:
                                      MaterialStateProperty.all(Size(107, 25)),
                                  fixedSize:
                                      MaterialStateProperty.all(Size(200, 45)),
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xffC54134))),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),

                        /// Main col
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<dynamic> durationMBS(BuildContext context) {
    bool isCustom = false;
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(34),
            topLeft: Radius.circular(34),
          ),
        ),
        context: context,
        builder: (BuildContext ctx) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStateModal) {
            return Container(
              // color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 0,
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Class Duration',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Proxima Nova',
                              color: Color(0xff161616)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        buildDurationOption('1', 1, 0, setStateModal, ctx),
                        buildDurationOption('1.5', 1, 30, setStateModal, ctx),
                        buildDurationOption('2', 2, 0, setStateModal, ctx),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        buildDurationOption('2.5', 2, 30, setStateModal, ctx),
                        buildDurationOption('3', 3, 0, setStateModal, ctx),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Text(
                          'Custom Duration',
                          style: TextStyle(
                            color: Color(0xff2A353F),
                            fontFamily: 'Proxima Nova',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 120,
                        color: Color(0xffDEE4ED),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: NumberPicker(
                                itemHeight: 30,
                                textStyle: TextStyle(
                                    color: Color(0xff161616),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Proxima Nova'),
                                selectedTextStyle: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xffC54134),
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'Proxima Nova'),
                                minValue: 0,
                                maxValue: 12,
                                value: _customHours,
                                onChanged: (int hval) {
                                  isCustom = true;
                                  setState(() {
                                    setStateModal(() {
                                      _customHours = hval;
                                      print(_customHours);
                                    });
                                  });
                                },
                              ),
                            ),
                            Text(
                              'Hours',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff161616),
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Proxima Nova'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: NumberPicker(
                                itemHeight: 30,
                                textStyle: TextStyle(
                                    color: Color(0xff161616),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Proxima Nova'),
                                selectedTextStyle: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xffC54134),
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'Proxima Nova'),
                                minValue: 0,
                                maxValue: 60,
                                value: _customMinutes,
                                onChanged: (int mval) {
                                  isCustom = true;
                                  setState(() {
                                    setStateModal(() {
                                      _customMinutes = mval;
                                    });
                                  });
                                },
                              ),
                            ),
                            Text(
                              'Minutes',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff161616),
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Proxima Nova'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setDuration(_customHours, _customMinutes,
                              '$_customHours : $_customMinutes', setStateModal);
                          Navigator.pop(ctx);
                        },
                        child: Text('Set Duration'))
                  ],
                ),
              ),
            );
          });
        });
  }

  Widget buildDurationOption(String duration, int h, int m,
      StateSetter setStateModal, BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          minimumSize: MaterialStateProperty.all(Size(100, 32)),
          fixedSize: MaterialStateProperty.all(Size(104, 32)),
          backgroundColor: _duration == duration
              ? MaterialStateProperty.all(Color(0xffc54134))
              : MaterialStateProperty.all(Color(0xffDEE4ED)),
        ),
        child: Text(
          '$duration hours',
          style: TextStyle(
              color:
                  _duration == duration ? Color(0xffffffff) : Color(0xff161616),
              fontFamily: 'Proxima Nova',
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        onPressed: () {
          Navigator.pop(ctx);
          setState(() {
            setStateModal(() {
              setDuration(h, m, duration, setStateModal);
              _customMinutes = 0;
              _customHours = 0;
            });
          });

          // print(duration);
        },
      ),
    );
  }

  void setDuration(int h, int m, String d, StateSetter setStateModal) {
    setState(() {
      setStateModal(() {
        _duration = d;
        _endTime = _startTime!.add(Duration(hours: h, minutes: m));
      });
    });
  }
}
