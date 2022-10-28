import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_projects/models/pad.dart';

class AudioPlayerServices extends ChangeNotifier {
  AudioPlayer player = AudioPlayer();

  String getAudioStatus(AudioPlayer player) {
    return player.state.name;
  }

  void oneshot(Pad pad) {
    try {
      player.setReleaseMode(ReleaseMode.stop);
      player.stop();
      player.play(
        DeviceFileSource(pad.path ?? ''),
        mode: PlayerMode.lowLatency,
      );
      notifyListeners();
    } on Exception catch (_, e) {
      print(e);
    }
  }

  void loopback(Pad pad) async {
    if (player.state == PlayerState.playing) {
      player.stop();
      notifyListeners();
    } else {
      await player.setReleaseMode(ReleaseMode.loop);
      player.play(
        DeviceFileSource(pad.path ?? ''),
        mode: PlayerMode.lowLatency,
      );
      notifyListeners();
    }
  }

  void loopStart(Pad pad) async {
    await player.setReleaseMode(ReleaseMode.loop);
    player.play(
      DeviceFileSource(pad.path ?? ''),
      mode: PlayerMode.lowLatency,
    );
    notifyListeners();
  }

  void loopEnd(Pad pad) {
    player.stop();
    notifyListeners();
  }
}
