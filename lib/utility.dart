import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_projects/database_helper.dart';
import 'package:path/path.dart';

import 'models/pad.dart';

DatabaseHelper db = new DatabaseHelper();

class Utility {
  static Future pickAudio(int? padId, BuildContext context) async {
    var result = await FilesystemPicker.open(
      allowedExtensions: [".mp3", ".aac"],
      context: context,
      rootDirectory: Directory("storage/emulated/0"),
    );
    if (result != null) {
      File file = File(result);
      await db.updatePad(padId, basename(file.path), file.path);
    }
  }

  static void loopback(Pad pad, AudioPlayer player) async {
    if (player.state == PlayerState.playing) {
      player.stop();
    } else {
      await player.setReleaseMode(ReleaseMode.loop);
      player.play(
        DeviceFileSource(pad.path ?? ''),
        mode: PlayerMode.lowLatency,
      );
    }
  }

  static void oneshot(Pad pad) {
    AudioPlayer().play(
      DeviceFileSource(pad.path ?? ''),
      mode: PlayerMode.lowLatency,
    );
  }

  static void loop(Pad pad, AudioPlayer player) async {
    if (player.state == PlayerState.playing) {
      player.stop();
    } else {
      await player.play(
        DeviceFileSource(pad.path ?? ''),
        mode: PlayerMode.lowLatency,
      );
      player.setReleaseMode(ReleaseMode.release);
    }
  }
}
