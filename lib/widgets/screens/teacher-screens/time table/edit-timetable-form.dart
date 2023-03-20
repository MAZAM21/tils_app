import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
// import 'package:provider/provider.dart';
import 'package:SIL_app/models/meeting.dart';

import 'package:SIL_app/models/subject-class.dart';
import 'package:SIL_app/service/db.dart';
// import './time_table.dart';

class EditTTForm extends StatefulWidget {
  static const routeName = '/edit-tt-form';

  @override
  _EditTTFormState createState() => _EditTTFormState();
}

class _EditTTFormState extends State<EditTTForm> {
  DateTime _startDate = DateTime.now();
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();
  SubjectName _subName;
  String _topic = '';
  String _section;
  String _duration = '';
  int _customHours = 0;
  int _customMinutes = 0;
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  var _isEdit = false;
  String _editedId;

  final db = DatabaseService();
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final editClass = ModalRoute.of(context).settings.arguments as Meeting;
      if (editClass != null) {
        _section = editClass.section;
        _topic = editClass.topic ?? '';
        _startDate = editClass.from;
        _startTime = editClass.from;
        _endTime = editClass.to;
        _subName = checkSubject(editClass.eventName);
        _isEdit = true;
        _editedId = editClass.docId;
      }
      //if a route argument is passed to this then it copies the passed values to the local variables and executes findMeetingIndex to get the index of the edited element.
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  //sets _subName to SubjectName enum
  void setSubject(String sub) {
    switch (sub) {
      case 'Jurisprudence':
        _subName = SubjectName.Jurisprudence;
        break;
      case 'Trust':
        _subName = SubjectName.Trust;
        break;
      case 'Conflict':
        _subName = SubjectName.Conflict;
        break;
      case 'Islamic':
        _subName = SubjectName.Islamic;
        break;
      case 'Company':
        _subName = SubjectName.Company;
        break;
      case 'Tort':
        _subName = SubjectName.Tort;
        break;
      case 'Property':
        _subName = SubjectName.Property;
        break;
      case 'EU':
        _subName = SubjectName.EU;
        break;
      case 'HR':
        _subName = SubjectName.HR;
        break;
      case 'Contract':
        _subName = SubjectName.Contract;
        break;
      case 'Criminal':
        _subName = SubjectName.Criminal;
        break;
      case 'LSM':
        _subName = SubjectName.LSM;
        break;
      case 'Public':
        _subName = SubjectName.Public;
        break;
      default:
        _subName = SubjectName.Undeclared;
    }
  }

  //returns string from enum
  String enToString(SubjectName name) {
    switch (name) {
      case SubjectName.Jurisprudence:
        return 'Jurisprudence';
        break;
      case SubjectName.Trust:
        return 'Trust';
        break;
      case SubjectName.Conflict:
        return 'Conflict';
        break;
      case SubjectName.Islamic:
        return 'Islamic';
        break;
      case SubjectName.Company:
        return 'Company';
        break;
      case SubjectName.Tort:
        return 'Tort';
        break;
      case SubjectName.Property:
        return 'Property';
        break;
      case SubjectName.EU:
        return 'EU';
        break;
      case SubjectName.HR:
        return 'HR';
        break;
      case SubjectName.Contract:
        return 'Contract';
        break;
      case SubjectName.Criminal:
        return 'Criminal';
        break;
      case SubjectName.LSM:
        return 'LSM';
        break;
      case SubjectName.Public:
        return 'Public';
        break;
      default:
        return 'Undeclared';
    }
  }

//takes string returns subject name
  SubjectName checkSubject(String sub) {
    switch (sub) {
      case 'Jurisprudence':
        return SubjectName.Jurisprudence;
        break;
      case 'Trust':
        return SubjectName.Trust;
        break;
      case 'Conflict':
        return SubjectName.Conflict;
        break;
      case 'Islamic':
        return SubjectName.Islamic;
        break;
      case 'Company':
        return SubjectName.Company;
        break;
      case 'Tort':
        return SubjectName.Tort;
        break;
      case 'Property':
        return SubjectName.Property;
        break;
      case 'EU':
        return SubjectName.EU;
        break;
      case 'HR':
        return SubjectName.HR;
        break;
      case 'Contract':
        return SubjectName.Contract;
        break;
      case 'Criminal':
        return SubjectName.Criminal;
        break;
      case 'LSM':
        return SubjectName.LSM;
        break;
      case 'Public':
        return SubjectName.Public;
        break;
      default:
        return SubjectName.Undeclared;
    }
  }

//subject option buttons,
//set _subName.
  Widget buildSubjectButton(String subName) {
    return ElevatedButton(
      child: Text(
        subName == 'Jurisprudence' ? 'Juris' : subName,
        style: TextStyle(
          fontSize: 12.5,
          fontFamily: 'Proxima Nova',
          fontWeight: FontWeight.w600,
          color: _subName == checkSubject(subName)
              ? Color(0xffffffff)
              : Color(0xff161616),
        ),
      ),
      onPressed: () {
        setState(() {
          setSubject(subName);
        });
        print(_subName);
      },
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        minimumSize: MaterialStateProperty.all(Size(40, 25)),
        fixedSize: MaterialStateProperty.all(Size(107, 38)),
        backgroundColor: _subName == checkSubject(subName)
            ? MaterialStateProperty.all(Color(0xffc54134))
            : MaterialStateProperty.all(Color(0xfff4f6f9)),
      ),
    );
  }

  //date picker
  void pickDate() {
    showDatePicker(
      context: context,
      initialDate: _isEdit ? _startDate : DateTime.now(),
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
          DateFormat('d MMM').format(_startDate),
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
          _isEdit ? TimeOfDay.fromDateTime(_startDate) : TimeOfDay.now(),
    ).then((time) {
      if (time == null) {
        return;
      }
      setState(() {
        _startTime = DateTime(
          _startDate.year,
          _startDate.month,
          _startDate.day,
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
          DateFormat('h:mm a').format(_startTime),
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _saveForm(BuildContext context) {
    if (!_endTime.isBefore(_startTime) &&
        _subName != SubjectName.Undeclared &&
        _subName != null &&
        _duration != '' &&
        _section != null) {
      _form.currentState.save();
      _form.currentState.reset();
      if (!_isEdit) {
        db.addClassToCF(
          _subName,
          _startTime,
          _endTime,
          _section,
          _topic,
        );
        setState(() {
          _subName = null;
          _startTime = DateTime.now();
          _duration = '';
          _endTime = null;
          _customHours = 0;
          _customMinutes = 0;
          _section = null;
        });
      } else {
        db.editClassInCF(
          _editedId,
          enToString(_subName),
          _startTime,
          _endTime,
          _section,
          _topic,
        );
      }
    } else {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => AlertDialog(
          title: Text('Fields Incorrect'),
          content: Text('Please fill all fields correctly'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool startPicked = false;
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

                        /// Section Buttons
                        Container(
                          child: Column(
                            children: <Widget>[
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
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: <Widget>[
                                  Spacer(),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _section = 'A';
                                      });
                                    },
                                    child: Text(
                                      'Section A',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Proxima Nova',
                                        fontWeight: FontWeight.w600,
                                        color: _section == 'A'
                                            ? Color(0xffffffff)
                                            : Color(0xff161616),
                                      ),
                                    ),
                                    style: ButtonStyle(
                                      minimumSize: MaterialStateProperty.all(
                                          Size(107, 25)),
                                      fixedSize: MaterialStateProperty.all(
                                          Size(129, 32)),
                                      backgroundColor: _section == 'A'
                                          ? MaterialStateProperty.all(
                                              Color(0xffC54134))
                                          : MaterialStateProperty.all(
                                              Color(0xfff4f6f9)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _section = 'B';
                                      });
                                    },
                                    child: Text(
                                      'Section B',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Proxima Nova',
                                        fontWeight: FontWeight.w600,
                                        color: _section == 'B'
                                            ? Color(0xffffffff)
                                            : Color(0xff161616),
                                      ),
                                    ),
                                    style: ButtonStyle(
                                      minimumSize: MaterialStateProperty.all(
                                          Size(107, 25)),
                                      fixedSize: MaterialStateProperty.all(
                                          Size(129, 32)),
                                      backgroundColor: _section == 'B'
                                          ? MaterialStateProperty.all(
                                              Color(0xffC54134))
                                          : MaterialStateProperty.all(
                                              Color(0xfff4f6f9)),
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              )
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
                              SingleChildScrollView(
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        buildSubjectButton('Jurisprudence'),
                                        buildSubjectButton('Trust'),
                                        buildSubjectButton('Conflict'),
                                        buildSubjectButton('Islamic'),
                                        buildSubjectButton('Company'),
                                      ],
                                    ),
                                    SizedBox(width: 7),
                                    Column(
                                      children: <Widget>[
                                        buildSubjectButton('Tort'),
                                        buildSubjectButton('Property'),
                                        buildSubjectButton('EU'),
                                        buildSubjectButton('HR'),
                                      ],
                                    ),
                                    SizedBox(width: 7),
                                    Column(
                                      children: <Widget>[
                                        buildSubjectButton('Criminal'),
                                        buildSubjectButton('Contract'),
                                        buildSubjectButton('LSM'),
                                        buildSubjectButton('Public'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
                                          .format(_startDate),
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
                                                .format(_startTime),
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
                                  content: !_endTime.isBefore(_startTime) &&
                                          _subName != SubjectName.Undeclared &&
                                          _subName != null &&
                                          _duration != null &&
                                          _section != null
                                      ? Text(
                                          '${enToString(_subName)} on ${DateFormat('d MMM hh mm a').format(_startTime)} added to Time Table')
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
        _endTime = _startTime.add(Duration(hours: h, minutes: m));
      });
    });
  }
}




//  Row(
//                           children: <Widget>[

//                         Container(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               ElevatedButton(
//                                 child: Text('A'),
//                                 onPressed: () {
//                                   setState(() {
//                                     _section = 'A';
//                                   });
//                                 },
//                                 style: ButtonStyle(
//                                   backgroundColor: _section == 'A'
//                                       ? MaterialStateProperty.all(
//                                           Colors.redAccent)
//                                       : MaterialStateProperty.all(
//                                           Colors.greenAccent),
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 20,
//                               ),
//                               ElevatedButton(
//                                 child: Text('B'),
//                                 onPressed: () {
//                                   setState(() {
//                                     _section = 'B';
//                                   });
//                                 },
//                                 style: ButtonStyle(
//                                   backgroundColor: _section == 'B'
//                                       ? MaterialStateProperty.all(
//                                           Colors.redAccent)
//                                       : MaterialStateProperty.all(
//                                           Colors.greenAccent),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Divider(),
//                         //Subject Buttons
//                         Container(
//                           height: 280,
//                           child: Row(
//                             children: <Widget>[
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.stretch,
//                                   children: <Widget>[
//                                     buildSubjectButton('Jurisprudence'),
//                                     buildSubjectButton('Trust'),
//                                     buildSubjectButton('Conflict'),
//                                     buildSubjectButton('Islamic'),
//                                     buildSubjectButton('Company'),
//                                   ],
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.stretch,
//                                   children: <Widget>[
//                                     buildSubjectButton('Tort'),
//                                     buildSubjectButton('Property'),
//                                     buildSubjectButton('EU'),
//                                     buildSubjectButton('HR'),
//                                   ],
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.stretch,
//                                   children: <Widget>[
//                                     buildSubjectButton('Criminal'),
//                                     buildSubjectButton('Contract'),
//                                     buildSubjectButton('LSM'),
//                                     buildSubjectButton('Public'),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Divider(),
//                         //Date Display and Picker
//                         Container(
//                           width: 250,
//                           height: 100,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: <Widget>[
//                               buildDatepicker(),
//                               buildDateDisplay(),
//                             ],
//                           ),
//                         ),
//                         Divider(),
//                         //Time Display and Picker
//                         Container(
//                           width: 250,
//                           height: 50,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: <Widget>[
//                               buildTimePicker(),
//                               buildTimeDisplay(),
//                             ],
//                           ),
//                         ),
//                         Divider(),
//                         //Topic input field
//                         Text(
//                           'Topic',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 16,
//                             fontFamily: 'Lato',
//                           ),
//                         ),
//                         Container(
//                           width: 300,
//                           child: TextFormField(
//                             initialValue: _topic,
//                             keyboardType: TextInputType.text,
//                             onSaved: (value) {
//                               _topic = value;
//                             },
//                             decoration: InputDecoration(
//                               labelText: 'Topic',
//                               border: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color: Theme.of(context).primaryColor),
//                               ),
//                             ),
//                           ),
//                         ),

//                         Divider(),
//                         //Duration presets
//                         Container(
//                           margin: EdgeInsets.symmetric(vertical: 10),
//                           width: 400,
//                           height: 50,
//                           child: Column(
//                             children: <Widget>[
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.center,
//                                 crossAxisAlignment:
//                                     CrossAxisAlignment.stretch,
//                                 children: <Widget>[
//                                   buildDurationOption('1', 1, 0),
//                                   buildDurationOption('1.5', 1, 30),
//                                   buildDurationOption('2', 2, 0),
//                                   buildDurationOption('2.5', 2, 30),
//                                   buildDurationOption('3', 3, 0),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         Divider(),
//                         //Custom duration
//                         Container(
//                           height: 70,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               Text(
//                                 'Custom Duration',
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 16,
//                                   fontFamily: 'Lato',
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//                                   SizedBox(
//                                     height: 35,
//                                     width: 35,
//                                     child: ElevatedButton(
//                                       child: Text(
//                                         'H',
//                                         textAlign: TextAlign.center,
//                                       ),
//                                       onPressed: () {
//                                         showDialog(
//                                             context: context,
//                                             builder:
//                                                 (BuildContext context) {
//                                               return NumberPicker(
//                                                 value: 0,
//                                                 minValue: 0,
//                                                 maxValue: 12,
//                                                 onChanged: (v) {
//                                                   setState(() {
//                                                     _customMinutes = v;
//                                                     setDuration(
//                                                         _customHours,
//                                                         _customMinutes,
//                                                         '');
//                                                   });
//                                                 },
//                                               );
//                                             });
//                                       },
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 40,
//                                     height: 40,
//                                     child: Card(
//                                       color: Colors.white,
//                                       child: Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical: 8, horizontal: 11),
//                                         child: Text(
//                                           _customHours.toString(),
//                                           style: TextStyle(
//                                               fontSize: 16,
//                                               color: Colors.blueGrey[900]),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 35,
//                                     height: 35,
//                                     child: ElevatedButton(
//                                       child: Text(
//                                         'M',
//                                         textAlign: TextAlign.center,
//                                       ),
//                                       onPressed: () {
//                                         showDialog(
//                                           context: context,
//                                           builder: (BuildContext context) {
//                                             return NumberPicker(
//                                               value: 0,
//                                               minValue: 0,
//                                               maxValue: 60,
//                                               onChanged: (v) {
//                                                 setState(() {
//                                                   _customMinutes = v;
//                                                   setDuration(_customHours,
//                                                       _customMinutes, '');
//                                                 });
//                                               },
//                                             );
//                                           },
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 50,
//                                     height: 40,
//                                     child: Card(
//                                       color: Colors.white,
//                                       child: Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical: 8, horizontal: 11),
//                                         child: Text(
//                                           _customMinutes.toString(),
//                                           style: TextStyle(
//                                               fontSize: 16,
//                                               color: Colors.blueGrey[900]),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         Divider(),
//                         // Save button
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             ElevatedButton(
//                               child: Text('Add to Time Table'),
//                               onPressed: () {
//                                 Scaffold.of(context).hideCurrentSnackBar();
//                                 Scaffold.of(context).showSnackBar(SnackBar(
//                                   content: _subName !=
//                                               SubjectName.Undeclared &&
//                                           _duration != null &&
//                                           _section.isNotEmpty
//                                       ? Text(
//                                           '${enToString(_subName)} on ${DateFormat('d MMM hh mm a').format(_startTime)} added to Time Table')
//                                       : Text('Class not added'),
//                                 ));
//                                 setState(() {
//                                   _saveForm(context);
//                                 });
//                                 if (_isEdit) {
//                                   Navigator.pop(context);
//                                 }
//                               },
//                             )
//                           ],
//                         ),
//                         SizedBox(
//                           height: 25,
//                         )
