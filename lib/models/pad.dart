enum SoundMode { oneshot, loopback, loop }

class Pad {
  final int? id;
  final String? title;
  final String? path;
  final String? soundMode;
  final int? duration;
  static const String COL_ID = "pad_id";
  static const COL_TITLE = "pad_title";
  static const COL_PATH = "pad_path";
  static const COL_SOUNDMODE = "pad_soundmode";
  static const COL_DURATION = "pad_duration";

  Pad({this.id, this.title, this.path, this.soundMode, this.duration});

  Pad.fromMap(Map<String, dynamic> map)
      : id = map[COL_ID],
        title = map[COL_TITLE],
        path = map[COL_PATH],
        soundMode = map[COL_SOUNDMODE],
        duration = map[COL_DURATION];

  Map<String, dynamic> toMap() {
    return {
      'pad_id': id,
      'pad_title': title,
      'pad_path': path,
      'pad_soundmode': soundMode,
      'pad_duration': duration,
    };
  }
}
