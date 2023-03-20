import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:tils_app/models/resource.dart';
import 'package:tils_app/service/db.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

class DisplayResource extends StatefulWidget {
  final ResourceDownload resourceDownload;

  DisplayResource({@required this.resourceDownload});

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
        children.add(GestureDetector(
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
        ));
      } else {
        children.add(ListTile(
          title: Text(widget.resourceDownload.urlMap.keys.elementAt(i)),
          trailing: Icon(Icons.file_download),
          onTap: () async {
            final url = widget.resourceDownload.urlMap.values.elementAt(i);
            final fileName = widget.resourceDownload.urlMap.keys.elementAt(i);
            final webUrl = await _db.downloadWithUrl(url);
            
              FileDownloader.downloadFile(url: webUrl);
           
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
