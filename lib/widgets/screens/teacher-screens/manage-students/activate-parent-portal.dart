import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tils_app/models/student_rank.dart';
import 'package:tils_app/service/db.dart';

class ActivateParentPortal extends StatefulWidget {
  const ActivateParentPortal(this.stud);
  final StudentRank stud;

  @override
  State<ActivateParentPortal> createState() => _ActivateParentPortalState();
}

class _ActivateParentPortalState extends State<ActivateParentPortal> {
  final _formKey = GlobalKey<FormState>();
  final db = DatabaseService();

  String email;
  String password;

  String errorMessage;

  void saveParentToDb(email, password) {
    setState(() {
      _formKey.currentState.validate();

      db.saveParent(email, password, widget.stud);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Activate Parent\'s Portal for ${widget.stud.name}',
          style: TextStyle(
            color: Color(0xff21353f),
            fontSize: 16,
          ),
        ),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              
              children: <Widget>[
                SizedBox(height: 50,),
                Text(
                  'Enter Email',
                  style: Theme.of(context).textTheme.headline6,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          key: ValueKey('email'),
                          onSaved: (newEmail) {
                            email = newEmail;
                          },
                          validator: (value) {
                            if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              errorMessage = 'Invalid email';
                              return errorMessage;
                            }
                            errorMessage = null;
                            return null;
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Text('Enter Password',
                    style: Theme.of(context).textTheme.headline6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    color: Colors.white,
                    child: TextFormField(
                      key: ValueKey('password'),
                      onSaved: (newPass) {
                        password = newPass;
                      },
                      validator: (value) {
                        if (value.length < 6 || value.isEmpty) {
                          return 'Password should have 6 characters at least';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () {
                    _formKey.currentState.save();
                    saveParentToDb(email, password);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Activate Parent\'s Portal',
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
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xffC54134)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
