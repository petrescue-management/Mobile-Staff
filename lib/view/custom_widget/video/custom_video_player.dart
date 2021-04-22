import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:prs_staff/view/custom_widget/custom_dialog.dart';
import 'basic_overlay_widget.dart';

// ignore: must_be_immutable
class VideoThumbnailFromUrl extends StatefulWidget {
  String videoUrl;

  VideoThumbnailFromUrl({this.videoUrl});

  @override
  _VideoThumbnailFromUrlState createState() => _VideoThumbnailFromUrlState();
}

class _VideoThumbnailFromUrlState extends State<VideoThumbnailFromUrl> {
  VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    // initializing the video
    controller = VideoPlayerController.network(widget.videoUrl)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) => controller.pause());
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: controller != null && controller.value.initialized
            ? Stack(
                children: [
                  // video view
                  VideoPlayer(controller),
                  // volume button
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Icon(
                      Icons.volume_off,
                      color: Colors.white,
                    ),
                  ),
                  // video overlays
                  Positioned.fill(
                    child: BasicOverlayWidget(
                      controller: controller,
                    ),
                  ),
                ],
              )
            : loading(context),
      ),
    );
  }
}
