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

  void LoopAudio(Pad? pad, AudioPlayer? _player) async {
    // Duration? duration  = await _player!.getDuration();
    // print("-------------------------------------------------------- $duration");
    if (await _player!.state == PlayerState.playing) {
      print("STOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOP");
      _player.stop();
    } else {
      print("PLAyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");
      await _player.play(
        DeviceFileSource(pad?.path ?? ''),
        mode: PlayerMode.lowLatency,
      );
      _player.setReleaseMode(ReleaseMode.loop);
    }
  }
}
