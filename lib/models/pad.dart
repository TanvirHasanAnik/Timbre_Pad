class Pad{
  final int? id;
  final String? title;
  final String? path;
  static const String COL_ID = "pad_id";
  static const COL_TITLE = "pad_title";
  static const COL_PATH = "pad_path";

  Pad({this.id, this.title, this.path});

  Pad.fromMap(Map<String, dynamic> map)
      : id = map[COL_ID],
        title = map[COL_TITLE],
        path = map[COL_PATH];

  Map<String, dynamic> toMap() {
    return {
      'pad_id': id,
      'pad_title': title,
      'pad_path': path,
    };
  }
}