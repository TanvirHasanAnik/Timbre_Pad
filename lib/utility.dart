import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_projects/database_helper.dart';
import 'package:path/path.dart';

import 'models/pad.dart';

DatabaseHelper db = new DatabaseHelper();

class Utility {
  Future pickAudio(int? padId, BuildContext context) async {
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

  void loopback(Pad? pad, AudioPlayer? _player) async {
    if (await _player!.state == PlayerState.playing) {
      _player.stop();
    } else {
      await _player.play(
        DeviceFileSource(pad?.path ?? ''),
        mode: PlayerMode.lowLatency,
      );
      _player.setReleaseMode(ReleaseMode.loop);
    }
  }

  void oneshot(Pad? pad, AudioPlayer? _player) async {
    if (await _player!.state == PlayerState.playing) {
      _player.stop();
    } else {
      await _player.play(
        DeviceFileSource(pad?.path ?? ''),
        mode: PlayerMode.lowLatency,
      );
    }
  }

  void loop(Pad? pad, AudioPlayer? _player) async {
    if (await _player!.state == PlayerState.playing) {
      _player.stop();
    } else {
      await _player.play(
        DeviceFileSource(pad?.path ?? ''),
        mode: PlayerMode.lowLatency,
      );
      _player.setReleaseMode(ReleaseMode.release);
    }
  }
}
