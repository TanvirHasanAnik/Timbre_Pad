class Pad{
  final int? id;
  final String? title;
  static const String COL_ID = "pad_id";
  static const COL_TITLE = "pad_title";

  Pad({this.id, this.title});

  Pad.fromMap(Map<String, dynamic> map)
    : id = map[COL_ID],
      title = map[COL_TITLE];

  Map<String, dynamic> toMap(){
    return {
      'pad_id':id,
      'pad_title': title,
    };
  }
}