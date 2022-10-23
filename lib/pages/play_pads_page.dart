import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/database_helper.dart';
import 'package:flutter_projects/models/pad.dart';
import 'package:flutter_projects/pages/edit_pads_page.dart';

class PlayPadsPage extends StatefulWidget {
  const PlayPadsPage({Key? key}) : super(key: key);

  @override
  State<PlayPadsPage> createState() => _PlayPadsPageState();
}

var db = DatabaseHelper();

class _PlayPadsPageState extends State<PlayPadsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.lightBlueAccent,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditPadsPage()));
            },
          ),
        ],
        title: Text("Play"),
        backgroundColor: Colors.amber,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: FutureBuilder(
              future: db.getPad(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Pad>> snapshot) {
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      Pad? pad = snapshot.data?[index];
                      return GestureDetector(
                        onTap: () async {
                          AudioPlayer().play(
                            DeviceFileSource(pad?.path ?? ''),
                            mode: PlayerMode.lowLatency,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text("${pad?.title}"),
                        ),
                      );
                    });
              }),
        ),
      ),
    );
  }
}
