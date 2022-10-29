import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_projects/models/pad.dart';

class AudioPlayerServices extends ChangeNotifier {
  AudioPlayer player = AudioPlayer();

  @override
  void dispose() {
    // TODO: implement dispose
    player.dispose();
    super.dispose();
  }

  String getAudioStatus(AudioPlayer player) {
    String state = player.state.name;
    player.onPlayerStateChanged.listen((event) {
      state = event.name;
      notifyListeners();
    });
    return state;
  }

  void oneshot(Pad pad) async {
    try {
      player.setReleaseMode(ReleaseMode.stop);
      player.stop();
      await player
          .play(
            DeviceFileSource(pad.path ?? ''),
            mode: PlayerMode.lowLatency,
          )
          .then((value) => {
                Future.delayed(const Duration(milliseconds: 300), () {
                  player.state = PlayerState.stopped;
                })
              });
    } on Exception catch (_, e) {
      print(e);
    }
  }

  void loopback(Pad pad) async {
    if (player.state == PlayerState.playing) {
      await player.stop();
    } else {
      await player.setReleaseMode(ReleaseMode.loop);
      await player.play(
        DeviceFileSource(pad.path ?? ''),
        mode: PlayerMode.lowLatency,
      );
    }
  }

  void loopStart(Pad pad) async {
    await player.setReleaseMode(ReleaseMode.loop);
    await player.play(
      DeviceFileSource(pad.path ?? ''),
      mode: PlayerMode.lowLatency,
    );
  }

  void loopEnd(Pad pad) async {
    await player.stop();
  }
}
