import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/assignment-marks.dart';
import 'package:tils_app/models/student_rank.dart';
import 'package:tils_app/models/teacher-user-data.dart';
import 'package:tils_app/service/teachers-service.dart';
import 'package:tils_app/widgets/screens/teacher-screens/assignments/mark-student-assignments.dart';

///This page will show a text box for entering title
///and buttons to select subject.

class AddAssignment extends StatefulWidget {
  const AddAssignment({Key key}) : super(key: key);

  static const routeName = '/add-assignment';
  @override
  _AddAssignmentState createState() => _AddAssignmentState();
}

class _AddAssignmentState extends State<AddAssignment> {
  final ts = TeacherService();
  final _formKey = GlobalKey<FormState>();
  final titleCont = TextEditingController();
  final marksCont = TextEditingController();
  void initState() {
    Provider.of<AssignmentMarks>(context, listen: false).studentList = [];
    Provider.of<AssignmentMarks>(context, listen: false).marks = {};
    super.initState();
  }

  void dispose() {
    titleCont.dispose();
    marksCont.dispose();
    super.dispose();
  }

  String subject;

  Widget _buttonBuilder(
    String sub,
    Color col,
    BuildContext context,
  ) {
    return Flexible(
      fit: FlexFit.loose,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              subject = sub;
            });
          },
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(Size.fromHeight(50)),
            backgroundColor: subject == sub
                ? MaterialStateProperty.all(Colors.red)
                : MaterialStateProperty.all(col),
            textStyle: MaterialStateProperty.all(
                Theme.of(context).textTheme.headline6),
          ),
          child: Text(sub),
        ),
      ),
    );
  }

  /// The AssignmentMarks object is a change notifier.
  /// The title, subject, and total marks are added on this page
  /// then the object is passed to mark student assignments
  /// there, the individual marks are assigned
  /// and then it is saved to db

  @override
  Widget build(BuildContext context) {
    final assignmentMarks = Provider.of<AssignmentMarks>(context);
    final td = Provider.of<TeacherUser>(context);
    final students = Provider.of<List<StudentRank>>(context);

    ///List of students who are registered for the selected subject
    List<StudentRank> regStuds = [];
    if (students != null && subject != null) {
      regStuds = ts.getStudentsOfSub(students, subject);
    }

    final subs = td.subjects;
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 20),

                    Text(
                      'Assignment Title',
                      style: TextStyle(
                        fontFamily: 'Proxima Nova',
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 76, 76, 76),
                      ),
                    ),

                    /// Input assignment title
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        key: ValueKey('assignment-title'),
                        controller: titleCont,
                        validator: (value) {
                          if (value.isEmpty || value == '') {
                            return 'Please enter an assessment title';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          assignmentMarks.title = titleCont.text;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Assignment Title',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        minLines: 1,
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Divider(
                      thickness: 4,
                    ),

                    //total marks input
                    // its a button that opens a dialogue box with a number picker
                    SizedBox(
                      height: 15,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ClipRRect(
                            child: Container(
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Total Marks',
                                style: TextStyle(
                                  fontFamily: 'Proxima Nova',
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 76, 76, 76),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              NumberPicker(
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
                                maxValue: 100,
                                value: assignmentMarks.totalMarks,
                                onChanged: (int val) {
                                  setState(() {
                                    assignmentMarks.totalMarks = val;
                                  });
                                },
                              ),
                            ],
                          ),
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Divider(
                      thickness: 4,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Select Subject',
                      style: TextStyle(
                        fontFamily: 'Proxima Nova',
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 76, 76, 76),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),

                    /// for loop used to display all of the teachers subjects as buttons
                    for (var x = 0; x < subs.length; x++)
                      _buttonBuilder(
                        subs[x],
                        ts.getColor(subs[x]),
                        context,
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      thickness: 4,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        /// Validation occurs here
                        _formKey.currentState.save();
                        if (subject != null &&
                            regStuds != null &&
                            assignmentMarks.title.isNotEmpty &&
                            assignmentMarks.totalMarks != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ChangeNotifierProvider.value(
                                value: td,
                                child: MarkStudentAssignments(
                                  students: regStuds,
                                  subject: subject,
                                  title: assignmentMarks.title,
                                ),
                              ),
                            ),
                          );
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Please fill all fields'),
                                );
                              });
                        }
                      },
                      //Start Marking button which displays number of students registered for
                      //that subject
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          color: Color(0xffa8dadc),
                          height: 80,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: subject == null
                              ? Center(
                                  child: Text(
                                    'Select Subject',
                                    style: TextStyle(
                                      fontFamily: 'Proxima Nova',
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xffe63946),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    'Start Marking (${regStuds.length} students)',
                                    style: TextStyle(
                                      fontFamily: 'Proxima Nova',
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff1d3557),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
