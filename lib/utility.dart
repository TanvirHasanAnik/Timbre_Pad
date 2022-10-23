import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_projects/database_helper.dart';
import 'package:path_provider/path_provider.dart';

DatabaseHelper db = new DatabaseHelper();

class Utility {
  Future pickAudio(int? padId) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
      withData: true,
    );
    if (result == null) return;
    final file = result.files.first;
    final newFile = await saveFilePermanently(file);

    print('From path:  ${file.path}');
    print('To path:  ${newFile.path}');

    await db.updatePad(padId, file.name, newFile.path);
  }

  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');
    return File(file.path!).copy(newFile.path);
  }
}