import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_projects/database_helper.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

DatabaseHelper db = DatabaseHelper();

class Utility {
  static Future pickAudio(int? padId, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lastPath = "storage/emulated/0";
    var lastPathSubDirectoryList = prefs.getString("lastLocation")?.split("/");
    if (lastPathSubDirectoryList != null) {
      lastPath = removeFileNameFromPath(lastPathSubDirectoryList);
    }
    var result = await FilesystemPicker.open(
      allowedExtensions: [".mp3", ".aac", ".flac", ".wav", ".m4a"],
      context: context,
      directory: Directory(lastPath),
      rootDirectory: Directory("storage/emulated/0"),
    );
    if (result != null) {
      File file = File(result);
      prefs.setString('lastLocation', file.path);
      AudioPlayer player = AudioPlayer();
      await player.setSourceUrl(file.path ?? '');
      Duration tempDuration =
          await player.getDuration() ?? const Duration(milliseconds: 1000);
      int duration = tempDuration.inMilliseconds;
      await db.updatePad(
          padId, basenameWithoutExtension(file.path), file.path, duration);
    }
  }

  static String removeFileNameFromPath(List<String> lastPathSubDirectoryList) {
    String lastPath = "";
    for (int i = 0; i < lastPathSubDirectoryList.length - 1; i++) {
      lastPath += "${lastPathSubDirectoryList[i]}/";
    }
    return lastPath;
  }
}
