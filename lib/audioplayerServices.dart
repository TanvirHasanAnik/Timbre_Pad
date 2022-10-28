import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_projects/models/pad.dart';

class AudioPlayerServices extends ChangeNotifier {
  AudioPlayer player = AudioPlayer();

  String getAudioStatus(AudioPlayer player) {
    return player.state.name;
  }

  void oneshot(Pad pad) async {
    try {
      player.setReleaseMode(ReleaseMode.stop);
      player.stop();
      await player.play(
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
      await player.stop();
      notifyListeners();
    } else {
      await player.setReleaseMode(ReleaseMode.loop);
      await player.play(
        DeviceFileSource(pad.path ?? ''),
        mode: PlayerMode.lowLatency,
      );
      notifyListeners();
    }
  }

  void loopStart(Pad pad) async {
    await player.setReleaseMode(ReleaseMode.loop);
    await player.play(
      DeviceFileSource(pad.path ?? ''),
      mode: PlayerMode.lowLatency,
    );
    notifyListeners();
  }

  void loopEnd(Pad pad) async {
    await player.stop();
    notifyListeners();
  }
}
