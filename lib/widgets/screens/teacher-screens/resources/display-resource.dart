import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:SIL_app/models/resource.dart';
import 'package:SIL_app/service/db.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class DisplayResource extends StatefulWidget {
  final ResourceDownload resourceDownload;

  DisplayResource({required this.resourceDownload});

  @override
  _DisplayResourceState createState() => _DisplayResourceState();
}

class _DisplayResourceState extends State<DisplayResource> {
  List<VideoPlayerController> _controllers = [];
  List<bool> _isPlaying = [];
  List<bool> _isInitialized = [];
  final _db = DatabaseService();

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
        widget.resourceDownload.urlMap.length,
        (index) => VideoPlayerController.network(
            widget.resourceDownload.urlMap.values.elementAt(index)));
    _isPlaying =
        List.generate(widget.resourceDownload.urlMap.length, (index) => false);
    _isInitialized =
        List.generate(widget.resourceDownload.urlMap.length, (index) => false);
  }

  @override
  void dispose() {
    super.dispose();
    _controllers.forEach((controller) => controller.dispose());
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (int i = 0; i < widget.resourceDownload.urlMap.length; i++) {
      if (widget.resourceDownload.urlMap.keys.elementAt(i).endsWith('.mp4')) {
        children.add(Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: GestureDetector(
              onTap: () {
                if (!_isInitialized[i]) {
                  _controllers[i]
                    ..initialize().then((_) {
                      setState(() {
                        _isInitialized[i] = true;
                        _isPlaying[i] = true;
                      });
                      _controllers[i].play();
                    });
                } else {
                  setState(() {
                    _isPlaying[i] = !_isPlaying[i];
                  });
                  if (_isPlaying[i]) {
                    _controllers[i].play();
                  } else {
                    _controllers[i].pause();
                  }
                }
              },
              child: AspectRatio(
                aspectRatio: _controllers[i].value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    VideoPlayer(_controllers[i]),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 1000),
                      reverseDuration: Duration(milliseconds: 1000),
                      child: _isPlaying[i]
                          ? SizedBox.shrink()
                          : Container(
                              color: Colors.black26,
                              child: Center(
                                child: Icon(
                                  Icons.play_arrow,
                                  size: 50.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
      } else {
        children.add(ListTile(
          title: Text(widget.resourceDownload.urlMap.keys.elementAt(i)),
          trailing: Icon(Icons.file_download),
          onTap: () async {
            final url = widget.resourceDownload.urlMap.values.elementAt(i);
            final fileName = widget.resourceDownload.urlMap.keys.elementAt(i);
            if (defaultTargetPlatform == TargetPlatform.android) {
              setState(() {
                Permission.storage.request().then((value) {
                  if (value.isGranted) {
                    _db.downloadFile(url, fileName);
                  } else {
                    return null;
                  }
                });
              });
            } else {
              String webUrl;

              webUrl = await _db.downloadFileWeb(url, fileName);

              if (await canLaunchUrl(Uri.parse(webUrl))) {
                await launchUrl(Uri.parse(webUrl));
              } else {
                throw 'Could not launch $url';
              }
            }
          },
        ));
      }
    }
    return Scaffold(
      appBar: AppBar(
          title: Text(
        '${widget.resourceDownload.topic}',
        style: Theme.of(context).appBarTheme.toolbarTextStyle,
      )),
      body: SafeArea(
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
