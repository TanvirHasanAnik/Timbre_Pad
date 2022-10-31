import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_projects/models/pad.dart';

class AudioPlayerService extends ChangeNotifier {
  Timer? stopperTimer;
  late AudioPlayer player;
  late StreamSubscription playerStateListener;

  AudioPlayerService(int id) {
    player = AudioPlayer(playerId: id.toString());
    player.stop();
    playerStateListener = player.onPlayerStateChanged.listen((event) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    player.dispose();
    playerStateListener.cancel();
    super.dispose();
  }

  PlayerState getAudioStatus() => player.state;

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
