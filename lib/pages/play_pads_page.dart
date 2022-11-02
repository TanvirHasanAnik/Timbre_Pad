import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/database_helper.dart';
import 'package:flutter_projects/models/pad.dart';
import 'package:flutter_projects/pages/edit_pads_page.dart';
import 'package:flutter_projects/play_pads_cubit.dart';
import 'package:google_fonts/google_fonts.dart';

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
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0xff2193b0),
                  Color(0xff6dd5ed),
                ]),
          ),
          child: Column(
            children: [
              customAppbar(),
              Expanded(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget customAppbar() {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 60,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(3, 3), // changes position of shadow
          ),
        ],
        gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xff02aab0),
              Color(0xff00cdac),
            ]),
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  child: Image.asset('lib/assets/icon/icon.png', fit: BoxFit.cover),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Play",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),
          Row(
            children: [
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
          )
        ],
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
          final PlayPadsCubit playPadsCubit = PlayPadsCubit(pad.id ?? -1);
          return BlocProvider(
            key: UniqueKey(),
            create: (_) => playPadsCubit,
            child: GestureDetector(
              onLongPressDown: (event) {
                if (pad.soundMode == SoundMode.loop.name) {
                  playPadsCubit.loopStart(pad);
                }
              },
              onTapUp: (event) {
                if (pad.soundMode == SoundMode.loop.name) {
                  playPadsCubit.loopEnd(pad);
                }
              },
              onLongPressEnd: (event) {
                if (pad.soundMode == SoundMode.loop.name) {
                  playPadsCubit.loopEnd(pad);
                }
              },
              onTap: () {
                try {
                  if (pad.soundMode == SoundMode.oneshot.name) {
                    playPadsCubit.oneshot(pad);
                  } else if (pad.soundMode == SoundMode.loopback.name) {
                    playPadsCubit.loopback(pad);
                  }
                } on Exception catch (_, e) {}
              },
              child: playPadItemWidget(pad),
            ),
          );
        });
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

  Widget playPadItemWidget(Pad pad) {
    return BlocBuilder<PlayPadsCubit, PlayerState>(builder: (context, playerState) {
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
              gradient: RadialGradient(radius: 0.9, colors: <Color>[
                playerState == PlayerState.stopped || pad.path == null
                    ? const Color(0xff43cea2)
                    : const Color(0xffff4d4d),
                const Color(0xff185a9d),
              ]),
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [padTitleWidget(pad), padSoundModeWidget(pad)],
          ));
    });
  }

  Widget padTitleWidget(Pad pad) => Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Text(
              "${pad.title}",
              style: GoogleFonts.cabin(color: Color(0xffd9e6f2), fontWeight: FontWeight.w600),
            ),
          ),
        ),
      );

  Widget padSoundModeWidget(Pad pad) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Text(
            pad.soundMode!.toUpperCase(),
            style: const TextStyle(
                color: Color(0xffddddbb), fontWeight: FontWeight.bold, fontSize: 11),
          ),
        ),
      );
}
