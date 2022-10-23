import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class Utility{
  Future pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false
    );
  }
}