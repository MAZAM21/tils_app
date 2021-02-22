import 'package:flutter/material.dart';
import 'package:tils_app/service/db.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:excel/excel.dart';

class AddStudent extends StatefulWidget {
  static const routeName = '/add-students';
  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _formKey = GlobalKey<FormState>();
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  String _section;
  var _batch = '';
  final db = DatabaseService();
  List<String> years = [
    'First',
    'Second',
    'Third',
  ];
  var _year = '';
  List<String> _selectedSubs = [];
  Widget _buildSubButton(String subname) {
    return ElevatedButton(
      child: Text(
        '$subname',
      ),
      style: ButtonStyle(
        backgroundColor: _selectedSubs.contains(subname)
            ? MaterialStateProperty.all(Colors.red)
            : MaterialStateProperty.all(Colors.blueAccent),
      ),
      onPressed: _selectedSubs.contains(subname)
          ? () {
              setState(() {
                _selectedSubs.remove('$subname');
              });
            }
          : () {
              setState(() {
                _selectedSubs.add(subname);
              });
            },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save_outlined),
            onPressed: () {
              _formKey.currentState.validate();
              if (_formKey.currentState.validate() &&
                  _year != '' &&
                  _section.isNotEmpty) {
                _formKey.currentState.save();
                db.saveStudent(
                  _userEmail,
                  _userPassword,
                  _userName,
                  _selectedSubs,
                  _year,
                  _batch,
                  _section,
                );
                _formKey.currentState.reset();
                setState(() {
                  _selectedSubs.clear();
                });
              } else {
                showDialog(
                  context: context,
                  child: AlertDialog(
                    content: Text('All fields are required'),
                  ),
                );
              }
            },
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  children: <Widget>[
                    Text('Student Name'),
                    TextFormField(
                      key: ValueKey('name'),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                    Divider(),
                    Text('Student Email'),
                    TextFormField(
                      key: ValueKey('email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter email address';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userEmail = value;
                      },
                    ),
                    Divider(),
                    Text('Student Password'),
                    TextFormField(
                      key: ValueKey('pass'),
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userPassword = value;
                      },
                    ),
                    Divider(),
                    Text('Student Batch'),
                    TextFormField(
                      key: ValueKey('batch'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter batch';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _batch = value;
                      },
                    ),
                    Divider(),
                    Text('Year'),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.calendar_today),
                      itemBuilder: (BuildContext context) =>
                          years.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList(),
                      onSelected: (String value) {
                        setState(() {
                          if (value == 'First') {
                            _year = '1';
                          } else if (value == 'Second') {
                            _year = '2';
                          } else if (value == 'Third') {}
                          _year = '3';
                        });
                      },
                    ),
                    Divider(),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            child: Text('A'),
                            onPressed: () {
                              setState(() {
                                _section = 'A';
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: _section == 'A'
                                  ? MaterialStateProperty.all(Colors.redAccent)
                                  : MaterialStateProperty.all(
                                      Colors.greenAccent),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            child: Text('B'),
                            onPressed: () {
                              setState(() {
                                _section = 'B';
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: _section == 'B'
                                  ? MaterialStateProperty.all(Colors.redAccent)
                                  : MaterialStateProperty.all(
                                      Colors.greenAccent),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Text('Registered Subjects'),
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
                                children: <Widget>[
                                  _buildSubButton('Conflict'),
                                  _buildSubButton('Jurisprudence'),
                                  _buildSubButton('Islamic'),
                                  _buildSubButton('Trust'),
                                  _buildSubButton('Company'),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  _buildSubButton('Tort'),
                                  _buildSubButton('Property'),
                                  _buildSubButton('EU'),
                                  _buildSubButton('HR'),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  _buildSubButton('Contract'),
                                  _buildSubButton('Criminal'),
                                  _buildSubButton('Public'),
                                  _buildSubButton('LSM'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(thickness: 10,),

                    ElevatedButton(
                      child: Text('Add students from spreadsheet'),
                      onPressed: () async {
                        FilePickerResult result = await FilePicker.platform
                            .pickFiles(allowMultiple: false);
                        if (result != null) {
                          var file = result.paths.first;
                          var bytes = File(file).readAsBytesSync();
                          var excel = Excel.decodeBytes(bytes);

                          for (var table in excel.tables.keys) {
                            print(table); //sheet Name
                            print(excel.tables[table].maxCols);
                            print(excel.tables[table].maxRows);
                            for (var row in excel.tables[table].rows) {
                              print("$row");
                              print('${row[3]}');
                              if (row[0] != 'Name') {
                                List<String> subs = row[3].split(', ');
                                print(row[1]);
                                db.saveStudent(
                                  '${row[1]}',
                                  '${row[2]}',
                                  '${row[0]}',
                                  subs,
                                  "${row[4]}",
                                  '${row[5]}',
                                  '${row[6]}',
                                );
                              }
                            }
                          }
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
