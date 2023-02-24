import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/teacher-user-data.dart';

class ResourcesUpload extends StatefulWidget {
  const ResourcesUpload({Key key}) : super(key: key);

  @override
  State<ResourcesUpload> createState() => _ResourcesUploadState();
}

class _ResourcesUploadState extends State<ResourcesUpload> {
  @override
  Widget build(BuildContext context) {
    final teacherData = Provider.of<TeacherUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Resources'),
      ),
      body: Column(children: [
        
        Center(
          child: InkWell(
            onTap: (){
              FilePicker.platform.pickFiles();
            },
            child: Container(
              child: Text('Upload file'),
              height: 100,
              width: 300,
              color: Colors.grey,
            ),
          ),
        ),
        TextFormField(),
        
      ]),
    );
  }
}
