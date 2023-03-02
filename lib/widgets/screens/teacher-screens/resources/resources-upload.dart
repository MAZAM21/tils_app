import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/models/resource.dart';
import 'package:tils_app/models/teacher-user-data.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:tils_app/widgets/button-style.dart';

class ResourcesUpload extends StatefulWidget {
  const ResourcesUpload({Key key}) : super(key: key);

  @override
  State<ResourcesUpload> createState() => _ResourcesUploadState();
}

class _ResourcesUploadState extends State<ResourcesUpload> {
  final topicController = TextEditingController();
  ResourceUploadObj resUp;

  @override
  void initState() {
    resUp = ResourceUploadObj(
      date: DateTime.now(),
      resourceFiles: [],
      subject: '',
      topic: '',
      uploadTeacher: '',
    );
    super.initState();
  }

  void pickFiles() async {
    FilePickerResult results;

    try {
      results = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'mp4', 'mp3'],
      );
    } catch (e) {
      // User canceled the picker
    }

    if (results != null) {
      setState(() {
        resUp.resourceFiles = results.files;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final teacherData = Provider.of<TeacherUser>(context);
   
    final subLength = teacherData.subjects.length;

    // This list will have a row of button widgets
    List<Widget> rows = [];

    /// The main for loop iterates for every three subjects added
    /// when the value of i exceeds the subjects, it terminates
    for (int i = 0; i < subLength; i += 3) {
      List<Widget> children = [];

      /// the inner for loop condition iterates to three and checks whether
      /// the subject length has been reached by adding the main for loop i with 
      /// the inner for loop j and seeing if they are less than subLength
     
      for (int j = 0; j < 3 && i + j < subLength; j++) {
        
        if (resUp.subject != null &&
            '${teacherData.subjects[i + j]}' == resUp.subject) {
          children.add(RedButtonMobile(
              child: '${teacherData.subjects[i + j]}',
              onPressed: () {
                setState(() {
                  resUp.subject = '${teacherData.subjects[i + j]}';
                });
              }));
        } else {
          children.add(WhiteButtonMobile(
              child: '${teacherData.subjects[i + j]}',
              onPressed: () {
                setState(() {
                  resUp.subject = '${teacherData.subjects[i + j]}';
                });
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

    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        Center(
          child: InkWell(
            onTap: () {
              setState(() {
                pickFiles();
              });
            },
            child: DottedBorder(
              radius: Radius.circular(12),
              dashPattern: [10, 8],
              strokeWidth: 1,
              padding: EdgeInsets.all(6),
              borderPadding: EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                child: Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud),
                        Text('Upload file'),
                      ],
                    ),
                  ),
                  height: 100,
                  width: 300,
                  color: Color(0xffBFCAD0),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextFormField(
            controller: topicController,
            key: ValueKey('res-topic'),
            onSaved: (value) {
              resUp.topic = value;
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Column(
          children: rows,
        ),
        SizedBox(
          height: 20,
        ),
        if (resUp.resourceFiles.isNotEmpty)
          Container(
            height: 300,
            child: ListView.builder(
              itemBuilder: (ctx, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.5),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    tileColor: Colors.white,
                    title: Text(
                      '${resUp.resourceFiles[i].name}',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    // subtitle: Text(
                    //   '${topThree[i].subject}',
                    //   style: TextStyle(
                    //     fontSize: 12,
                    //     fontFamily: 'Proxima Nova',
                    //     color: Color(0xff5F686F),
                    //   ),
                    // ),
                  ),
                );
              },
              itemCount: resUp.resourceFiles.length,
            ),
          )
      ]),
    );
  }
}
