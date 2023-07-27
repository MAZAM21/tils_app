import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/student-user-data.dart';
import 'package:tils_app/service/student-db.dart';

class EditStudentProfile extends StatefulWidget {
  static const routeName = '/edit-student-profile';

  @override
  _EditStudentProfileState createState() => _EditStudentProfileState();
}

class _EditStudentProfileState extends State<EditStudentProfile> {
  final _picker = ImagePicker();
  final ref = FirebaseStorage.instance.ref().child('student_profile_pictures');
  File? _pickedImageFile;
  final studentDB = StudentDB();

  void _pickImage(String uid) async {
    final pickedImage = await (_picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 120) as Future<XFile>);
    final File fImage = File(pickedImage.path);
    setState(() {
      _pickedImageFile = fImage;
    });
    if (fImage != null) {
      await ref.child(uid + '.jpg').putFile(fImage);
    }

    final url = await ref.child(uid + '.jpg').getDownloadURL();
    if (url != null) {
      await studentDB.addProfileURL(url, uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<User>(context).uid;
    final studentUser = Provider.of<StudentUser>(context);
    print('url=' + '${studentUser.imageURL}');
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: (_pickedImageFile != null
                        ? FileImage(_pickedImageFile!)
                        : studentUser.imageURL != null
                            ? NetworkImage(studentUser.imageURL!)
                            : null) as ImageProvider<Object>?,
                  ),
                  TextButton(
                    onPressed: () {
                      _pickImage(uid);
                    },
                    child: Text('Edit Profile Picture'),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
