import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'basic_overlay_widget.dart';

class VideoPlayerWidget extends StatelessWidget {
  final VideoPlayerController? controller;

  const VideoPlayerWidget({
    Key? key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      controller != null && controller!.value.isInitialized
          ? ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: buildVideo())
          : Container(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );

  Widget buildVideo() => Stack(
        children: <Widget>[
          buildVideoPlayer(),
          // Positioned.fill(child: BasicOverlayWidget(controller: controller!)),
        ],
      );

  Widget buildVideoPlayer() => VideoPlayer(controller!);
  // AspectRatio(
  //       aspectRatio: controller!.value.aspectRatio,
  //       child:
  //        VideoPlayer(controller!),
  //     );
}
