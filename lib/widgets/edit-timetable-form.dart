import 'package:flutter/material.dart';

class EditTTForm extends StatefulWidget {
  @override
  _EditTTFormState createState() => _EditTTFormState();
}

class _EditTTFormState extends State<EditTTForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  ElevatedButton(
                    child: Text('Jurisprudence'),
                    onPressed: () {},
                  ),
                  ElevatedButton(
                    child: Text('Jurisprudence'),
                    onPressed: () {},
                  ),
                  ElevatedButton(
                    child: Text('Jurisprudence'),
                    onPressed: () {},
                  ),
                  ElevatedButton(
                    child: Text('Jurisprudence'),
                    onPressed: () {},
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
