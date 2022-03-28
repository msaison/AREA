// ignore_for_file: camel_case_types, diagnostic_describe_all_properties

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DisplayVideo extends StatefulWidget {
  final String path;

  const DisplayVideo( this.path,
    {Key key}) : super(key: key);

  @override
  __DisplayVideoState createState() => __DisplayVideoState();
}

class __DisplayVideoState extends State<DisplayVideo> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.path)
      ..initialize().then((_) {
        _controller.setLooping(true);
        setState(() {
          _controller.play();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
