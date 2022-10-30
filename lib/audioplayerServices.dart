import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_projects/models/pad.dart';

class AudioPlayerServices extends ChangeNotifier {
  int? id = null;

  AudioPlayerServices(int? id) {
    this.id = id;
  }

  late AudioPlayer player = AudioPlayer(playerId: id.toString());

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

  bool stopPlayer() {
    player.stop();
    return true;
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
          .then((value) async {
        await Future.delayed(Duration(milliseconds: pad.duration ?? 1000), () {
          player.stop();
        });
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
