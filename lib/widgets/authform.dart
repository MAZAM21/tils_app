import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  //constructer gets a submit form function and a is Loading bool
  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;
  //submit form function defined
  final void Function(
    String email,
    String password,
    String userName,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String? _userEmail = '';
  var _userName = '';
  String? _userPassword = '';

  void _trySubmit() {
    //IsValid stores bool on whether the text inputs are validated
    final isValid = _formKey.currentState!.validate();
    //removes focus from the fields
    FocusScope.of(context).unfocus();
    //if IsValid is true then save form state and execute submitfn on inputs
    //.trim removes whitespace
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(_userEmail!.trim(), _userPassword!.trim(), _userName.trim(),
          _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android
        ? Center(
            child: Container(
              margin: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image(
                          image: AssetImage('lib/assets/LCI_icon.png'),
                          height: 150,
                        ),
                        SizedBox(
                          height: 70,
                        ),
                        Row(
                          children: [
                            Text(
                              'Email Address',
                              style: TextStyle(
                                color: Colors.indigo[900],
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Proxima Nova',
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Colors.grey[200],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                cursorColor: Colors.white,
                                key: ValueKey('email'),
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    return 'Please enter a valid email address.';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.emailAddress,
                                onSaved: (value) {
                                  _userEmail = value;
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text(
                              'Password',
                              style: TextStyle(
                                color: Colors.indigo[900],
                                fontFamily: 'Proxima Nova',
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Colors.grey[200],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                cursorColor: Colors.white,
                                key: ValueKey('password'),
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 6) {
                                    return 'Password must be at least 6 characters long.';
                                  }
                                  return null;
                                },
                                obscureText: true,
                                onSaved: (value) {
                                  _userPassword = value;
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        if (widget.isLoading) CircularProgressIndicator(),
                        if (!widget.isLoading)
                          ElevatedButton(
                            style: ButtonStyle(
                              fixedSize:
                                  MaterialStateProperty.all(Size(200, 40)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.indigo[900]),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Proxima Nova',
                                  color: Colors.white),
                            ),
                            onPressed: _trySubmit,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )

          //Web

        : Center(
            child: Container(
              margin: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image(
                          image: AssetImage('lib/assets/SIL_innerlogo.png'),
                          height: 230,
                        ),
                        SizedBox(
                          height: 70,
                        ),
                        Container(
                          width: 500,
                          child: Row(
                            children: [
                              Text(
                                'Email Address',
                                style: TextStyle(
                                  color:Colors.indigo[900],
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Proxima Nova',
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 500,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Colors.grey[200],
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  cursorColor: Colors.white,
                                  key: ValueKey('email'),
                                  validator: (value) {
                                    if (value!.isEmpty || !value.contains('@')) {
                                      return 'Please enter a valid email address.';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  onSaved: (value) {
                                    _userEmail = value;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: 500,
                          child: Row(
                            children: [
                              Text(
                                'Password',
                                style: TextStyle(
                                  color:Colors.indigo[900],
                                  fontFamily: 'Proxima Nova',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 500,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Colors.grey[200],
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  cursorColor: Colors.white,
                                  key: ValueKey('password'),
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 6) {
                                      return 'Password must be at least 6 characters long.';
                                    }
                                    return null;
                                  },
                                  obscureText: true,
                                  onSaved: (value) {
                                    _userPassword = value;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        if (widget.isLoading) CircularProgressIndicator(),
                        if (!widget.isLoading)
                          ElevatedButton(
                            style: ButtonStyle(
                              fixedSize:
                                  MaterialStateProperty.all(Size(200, 40)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.indigo[900]),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Proxima Nova',
                                  color: Colors.white),
                            ),
                            onPressed: _trySubmit,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
