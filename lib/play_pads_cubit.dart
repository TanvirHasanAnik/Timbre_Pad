import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/models/pad.dart';

class PlayPadsCubit extends Cubit<PlayerState> {
  Timer? stopperTimer;
  late AudioPlayer player;
  late StreamSubscription playerStateListener;
  bool isLoopStarting = false;

  PlayPadsCubit(int id) : super(PlayerState.stopped) {
    player = AudioPlayer(playerId: id.toString());
    player.stop();
    playerStateListener = player.onPlayerStateChanged.listen((playerState) {
      emit(playerState);
    });
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
    isLoopStarting = true;
    await player.setReleaseMode(ReleaseMode.loop);
    await player.play(
      DeviceFileSource(pad.path ?? ''),
      mode: PlayerMode.lowLatency,
    );
    isLoopStarting = false;
  }

  void loopEnd(Pad pad) async {
    if (isLoopStarting) {
      Future.delayed(const Duration(milliseconds: 100), () => player.stop());
    } else {
      player.stop();
    }
  }
}
