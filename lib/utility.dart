import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_projects/database_helper.dart';
import 'package:path/path.dart';

DatabaseHelper db = DatabaseHelper();

class Utility {
  static Future pickAudio(int? padId, BuildContext context) async {
    var result = await FilesystemPicker.open(
      allowedExtensions: [".mp3", ".aac", ".flac", ".wav", ".m4a"],
      context: context,
      rootDirectory: Directory("storage/emulated/0"),
    );
    if (result != null) {
      File file = File(result);
      AudioPlayer player = AudioPlayer();
      await player.setSourceUrl(file.path ?? '');
      Duration tempDuration =
          await player.getDuration() ?? const Duration(milliseconds: 1000);
      int duration = tempDuration.inMilliseconds;
      await db.updatePad(padId, basename(file.path), file.path, duration);
    }
  }
}
