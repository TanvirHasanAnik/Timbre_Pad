import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_projects/models/pad.dart';

class AudioPlayerServices {
  AudioPlayer player = AudioPlayer();

  void oneshot(Pad pad) {
    try {
      player.setReleaseMode(ReleaseMode.stop);
      player.stop();
      player.play(
        DeviceFileSource(pad.path ?? ''),
        mode: PlayerMode.lowLatency,
      );
    } on Exception catch (_, e) {
      print(e);
    }
  }
}
