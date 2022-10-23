import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_projects/database_helper.dart';
import 'package:path/path.dart';

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
}
