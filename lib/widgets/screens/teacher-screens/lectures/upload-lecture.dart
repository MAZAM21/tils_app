import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VideoUploadScreen extends StatefulWidget {
  @override
  _VideoUploadScreenState createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  File _videoFile;
  String _uploadedFileURL;
  final _picker = ImagePicker();

  Future<void> pickVideo() async {
    var video = await _picker.pickVideo(source: ImageSource.gallery);
    final File _videoSelected = File(video.path);

    setState(() {
      _videoFile = _videoSelected;
    });
  }

  Future<void> uploadFile() async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('videos/${DateTime.now().millisecondsSinceEpoch}.mp4');
    Task uploadTask = storageReference.putFile(_videoFile);
    await uploadTask.whenComplete(() => print('File Uploaded'));

    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Video'),
      ),
      body: Center(
        child: _videoFile == null
            ? Text('No video selected.')
            : Column(
                children: <Widget>[
                  Container(
                    height: 200,
                    child: Image.file(_videoFile),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _uploadedFileURL != null
                      ? Text(
                          'Uploaded video URL: $_uploadedFileURL',
                        )
                      : Container(),
                ],
              ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: pickVideo,
            tooltip: 'Pick Video',
            child: Icon(Icons.video_library),
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: uploadFile,
            tooltip: 'Upload Video',
            child: Icon(Icons.cloud_upload),
          ),
        ],
      ),
    );
  }
}
