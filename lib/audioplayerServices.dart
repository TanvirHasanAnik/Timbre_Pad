import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_projects/models/pad.dart';

class AudioPlayerServices extends ChangeNotifier {
  int? id = null;
  Timer? stopperTimer;

  AudioPlayerServices(this.id) {
    if (player.playerId == "$id") {
      player.stop();
    }
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

  void oneshot(Pad pad) async {
    try {
      await player.setReleaseMode(ReleaseMode.stop);
      await player.stop();
      stopperTimer?.cancel();
      await player.play(
        DeviceFileSource(pad.path ?? ''),
        mode: PlayerMode.lowLatency,
      );
      stopperTimer = Timer(Duration(milliseconds: pad.duration ?? 1000), () {
        player.stop();
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
