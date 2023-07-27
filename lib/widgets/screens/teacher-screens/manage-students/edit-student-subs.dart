import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:tils_app/models/student_rank.dart';
import 'package:tils_app/service/db.dart';

class EditStudSubs extends StatefulWidget {
  static const routeName = '/edit-stud-subs';
  const EditStudSubs(
    this.stud,
  );

  final StudentRank stud;

  @override
  State<EditStudSubs> createState() => _EditStudProfileState();
}

class _EditStudProfileState extends State<EditStudSubs> {
  List<String> _selectedSubs = [];
  final db = DatabaseService();
  String? _yearVal;

  @override
  void didChangeDependencies() {
    widget.stud.subjects!.forEach((sub) {
      _selectedSubs.add(sub);
    });
    _yearVal = widget.stud.year;

    super.didChangeDependencies();
  }

  ElevatedButton _buildYearButton(String yearDisplay) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: _yearVal == yearDisplay
              ? MaterialStateProperty.all(Color(0xffC54134))
              : MaterialStateProperty.all(Color(0xffDEE4ED)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
          )),
      child: Text(
        yearDisplay,
        style: TextStyle(
          fontFamily: 'Proxima Nova',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _yearVal == yearDisplay ? Colors.white : Colors.black,
        ),
      ),
      onPressed: () {
        setState(() {
          _yearVal = yearDisplay;
        });
      },
    );
  }

  Widget _buildSubButton(String subName) {
    return ElevatedButton(
      child: Text(
        subName == 'Jurisprudence' ? 'Juris' : subName,
        style: TextStyle(
          fontSize: 12.5,
          fontFamily: 'Proxima Nova',
          fontWeight: FontWeight.w600,
          color: _selectedSubs.contains(subName)
              ? Color(0xffffffff)
              : Color(0xff161616),
        ),
      ),
      style: ButtonStyle(
        backgroundColor: _selectedSubs.contains(subName)
            ? MaterialStateProperty.all(Color(0xffc54134))
            : MaterialStateProperty.all(Color(0xfff4f6f9)),
      ),
      onPressed: _selectedSubs.contains(subName)
          ? () {
              setState(() {
                _selectedSubs.remove('$subName');
              });
            }
          : () {
              setState(() {
                _selectedSubs.add(subName);
              });
            },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: Color(0xffffffff),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Text(
            'Registered Subjects',
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(
            height: 20,
          ),
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
          ElevatedButton(
            onPressed: () {
              setState(() {
                db.editStudentSubs(_selectedSubs, widget.stud);
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
          Text(
            'Year',
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildYearButton('1'),
              _buildYearButton('2'),
              _buildYearButton('3'),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                db.editStudentYear(_yearVal, widget.stud);
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
