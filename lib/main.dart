import 'package:flutter/material.dart';
import 'package:flutter_projects/database_helper.dart';
import 'package:flutter_projects/models/pad.dart';
import 'package:flutter_projects/pages/play_pads_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var db = DatabaseHelper();
  if(await db.padTableExists() == false){
    for(int i = 1; i <= 9; i++){
      await db.insertPad(Pad(title: "$i", soundMode: SoundMode.oneshot.name));
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PlayPadsPage(),
    );
  }
}
