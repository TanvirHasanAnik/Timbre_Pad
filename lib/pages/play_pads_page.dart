import 'package:flutter/material.dart';
import 'package:flutter_projects/audioplayerServices.dart';
import 'package:flutter_projects/database_helper.dart';
import 'package:flutter_projects/models/pad.dart';
import 'package:flutter_projects/pages/edit_pads_page.dart';
import 'package:provider/provider.dart';

class PlayPadsPage extends StatefulWidget {
  const PlayPadsPage({Key? key}) : super(key: key);

  @override
  State<PlayPadsPage> createState() => _PlayPadsPageState();
}

var db = DatabaseHelper();

class _PlayPadsPageState extends State<PlayPadsPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
              setState(() {});
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditPadsPage()))
                  .then((value) {
                setState(() {});
              });
            },
          ),
        ],
        title: Text("Play"),
        backgroundColor: const Color(0xff50A7C2),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0xff50A7C2),
                  Color(0xffB7F8DB),
                ]),
          ),
          padding: EdgeInsets.all(10),
          child: FutureBuilder(
              future: db.getPad(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Pad>> snapshot) {
                return GridViewWidget(snapshot);
              }),
        ),
      ),
    );
  }

  GridView GridViewWidget(AsyncSnapshot<List<Pad>> snapshot) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: snapshot.data?.length ?? 0,
        itemBuilder: (context, index) {
          Pad pad = snapshot.data![index];
          final AudioPlayerServices playerService = AudioPlayerServices(pad.id);
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
                } else if (pad.soundMode == SoundMode.loopback.name) {
                  playerService.loopback(pad);
                }
              } on Exception catch (_, e) {
                print(e);
              }
            },
            child: playPadItemWidget(pad, playerService),
          );
        });
  }

  Widget playPadItemWidget(Pad pad, AudioPlayerServices playerService) {
    return ChangeNotifierProvider<AudioPlayerServices>(
        create: (BuildContext context) => playerService,
        child: Consumer<AudioPlayerServices>(
          builder: (context, notifyPlayerService, child) {
            return Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset:
                            const Offset(3, 3), // changes position of shadow
                      ),
                    ],
                    gradient: RadialGradient(radius: 1, colors: <Color>[
                      notifyPlayerService
                                  .getAudioStatus(playerService.player) ==
                              "stopped"
                          ? const Color(0xff4956d0)
                          : const Color(0xffC33764),
                      const Color(0xff1D2671),
                    ]),
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [padTitleWidget(pad), padSoundModeWidget(pad)],
                ));
          },
        ));
  }

  Widget padSoundModeWidget(Pad pad) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Text(
            "${pad.soundMode}",
            style: const TextStyle(
                color: Color(0xff00FFFF), fontWeight: FontWeight.bold),
          ),
        ),
      );

  Widget padTitleWidget(Pad pad) => Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Text(
              "${pad.title}",
              style: const TextStyle(color: Color(0xffFFFF00)),
            ),
          ),
        ),
      );
}
