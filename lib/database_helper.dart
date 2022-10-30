import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/pad.dart';

class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    final dbpath = await getDatabasesPath();

    const dbname = 'pad.db';

    final path = join(dbpath, dbname);

    _database = await openDatabase(path, version: 1, onCreate: _createDB);

    return _database!;
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''CREATE TABLE pad(
        ${Pad.COL_ID} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Pad.COL_TITLE} TEXT,
        ${Pad.COL_PATH} TEXT,
        ${Pad.COL_SOUNDMODE} TEXT,
        ${Pad.COL_DURATION} INTEGER
      )''');
  }

  Future<void> insertPad(Pad pad) async {
    final db = await database;
    await db.insert(
      'pad',
      pad.toMap(),
    );
  }

  Future<void> deletePad(Pad pad) async {
    final db = await database;
    await db.delete('pad', where: '${Pad.COL_ID} = ?', whereArgs: [pad.id]);
  }

  Future<void> updatePad(
      int? id, String newTitle, String path, int? duration) async {
    final db = await database;
    await db.rawUpdate('''
      UPDATE pad SET ${Pad.COL_TITLE} = ?, ${Pad.COL_PATH} = ?, ${Pad.COL_DURATION} = ?
      WHERE ${Pad.COL_ID} = ?
    ''', [newTitle, path, duration, id]);
  }

  Future<void> updatePadSoundMode(int? id, String newSoundMode) async {
    final db = await database;
    await db.rawUpdate('''
      UPDATE pad SET ${Pad.COL_SOUNDMODE} = ?
      WHERE ${Pad.COL_ID} = ?
    ''', [newSoundMode, id]);
  }

  Future<List<Pad>> getPad() async {
    final db = await database;

    List<Map<String, dynamic>> items = await db.query(
      'pad',
      orderBy: Pad.COL_ID,
    );

    return List.generate(
        items.length,
        (index) => Pad(
          id: items[index][Pad.COL_ID],
              title: items[index][Pad.COL_TITLE],
              path: items[index][Pad.COL_PATH],
              soundMode: items[index][Pad.COL_SOUNDMODE],
              duration: items[index][Pad.COL_DURATION],
            ));
  }

  Future<bool> padTableExists() async {
    final db = await database;
    var queryResult = await db.rawQuery('SELECT * FROM pad');
    return queryResult.isNotEmpty ? true : false;
  }
}