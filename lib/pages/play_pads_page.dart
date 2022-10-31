import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/audioplayerServices.dart';
import 'package:flutter_projects/database_helper.dart';
import 'package:flutter_projects/models/pad.dart';
import 'package:flutter_projects/pages/edit_pads_page.dart';
import 'package:google_fonts/google_fonts.dart';
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
                MaterialPageRoute(builder: (context) => const EditPadsPage()),
              ).then((value) {
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
          alignment: Alignment.center,
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0xff50A7C2),
                  Color(0xffB7F8DB),
                ]),
          ),
          child: FutureBuilder(
              future: db.getPad(),
              builder: (BuildContext context, AsyncSnapshot<List<Pad>> snapshot) {
                if (snapshot.data == null) {
                  return addNewPadAdviceWidget();
                }
                return snapshot.data!.isNotEmpty
                    ? GridViewWidget(snapshot)
                    : addNewPadAdviceWidget();
              }),
        ),
      ),
    );
  }

  Container addNewPadAdviceWidget() {
    return Container(
      child: const Text(
        "Add new pads in edit section",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
        softWrap: true,
      ),
    );
  }

  Widget GridViewWidget(AsyncSnapshot<List<Pad>> snapshot) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        padding: const EdgeInsets.all(10),
        itemCount: snapshot.data?.length ?? 0,
        itemBuilder: (context, index) {
          Pad pad = snapshot.data![index];
          final AudioPlayerService playerService = AudioPlayerService(pad.id ?? -1);
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

  Widget playPadItemWidget(Pad pad, AudioPlayerService playerService) {
    return ChangeNotifierProvider<AudioPlayerService>(
        create: (BuildContext context) => playerService,
        child: Consumer<AudioPlayerService>(
          builder: (context, audioPlayerService, child) {
            return Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(3, 3), // changes position of shadow
                      ),
                    ],
                    gradient: RadialGradient(radius: 1, colors: <Color>[
                      audioPlayerService.getAudioStatus() == PlayerState.stopped || pad.path == null
                          ? const Color(0xffc2e59c)
                          : const Color(0xffff4d4d),
                      const Color(0xff64b3f4),
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
        pad.soundMode!.toUpperCase(),
        style: const TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold),
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
          style: GoogleFonts.cabin(color: Color(0xff1a0033), fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );
}
