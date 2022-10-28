import 'package:flutter/material.dart';
import 'package:flutter_projects/audioplayerServices.dart';
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
            icon: const Icon(
              Icons.sync,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditPadsPage()));
            },
          ),
        ],
        title: Text("Play"),
        backgroundColor: Colors.greenAccent,
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
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      Pad pad = snapshot.data![index];
                      final AudioPlayerServices playerService =
                          AudioPlayerServices();
                      return GestureDetector(
                        onLongPressStart: (longPressEndDetails) {
                          if (pad.soundMode == SoundMode.loop.name) {
                            playerService.loopStart(pad);
                          }
                        },
                        onLongPressEnd: (longPressEndDetails) {
                          if (pad.soundMode == SoundMode.loop.name) {
                            playerService.loopEnd(pad);
                          }
                        },
                        onTap: () {
                          try {
                            if (pad.soundMode == SoundMode.oneshot.name) {
                              playerService.oneshot(pad);
                            } else if (pad.soundMode ==
                                SoundMode.loopback.name) {
                              playerService.loopback(pad);
                            }
                          } on Exception catch (_, e) {
                            print(e);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text("${pad.title}"),
                        ),
                      );
                    });
              }),
        ),
      ),
    );
  }
}
