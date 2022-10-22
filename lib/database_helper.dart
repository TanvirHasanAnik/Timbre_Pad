import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'models/pad.dart';
class DatabaseHelper{
  Database? _database;

  Future<Database> get database async{
    final dbpath = await getDatabasesPath();

    const dbname = 'pad.db';

    final path = join(dbpath, dbname);

    _database = await openDatabase(path, version: 1, onCreate: _createDB);

    return _database!;
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''CREATE TABLE pad(
        ${Pad.COL_ID} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Pad.COL_TITLE} TEXT
      )''');
  }

  Future<void> insertPad(Pad pad) async {
    final db = await database;
    await db.insert(
      'pad',
      pad.toMap(),
    );
  }

  Future<List<Pad>> getPad() async {
    final db = await database;

    List<Map<String, dynamic>> items = await db.query('pad',
      orderBy: Pad.COL_ID,
    );

    return List.generate(items.length, (index) => Pad(
      id: items[index][Pad.COL_ID],
      title: items[index][Pad.COL_TITLE],
    ));
  }

  Future<bool> padTableExists() async {
    final db = await database;
    var queryResult = await db.rawQuery('SELECT * FROM pad');
    return queryResult.isNotEmpty ? true : false;
  }
}