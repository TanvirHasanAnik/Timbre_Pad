import 'package:flutter/material.dart';
import 'package:flutter_projects/database_helper.dart';
import 'package:flutter_projects/models/pad.dart';
import 'package:flutter_projects/utility.dart';
import 'package:permission_handler/permission_handler.dart';

enum Menu { oneshot, loopback, loop }

class EditPadsPage extends StatefulWidget {
  const EditPadsPage({Key? key}) : super(key: key);

  @override
  State<EditPadsPage> createState() => _EditPadsPageState();
}

var db = DatabaseHelper();
const List<String> list = <String>['Play mode', 'Edit mode'];
String dropdownValue = list.first;
bool isTrackRunning = false;

class _EditPadsPageState extends State<EditPadsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Edit"),
        backgroundColor: const Color(0xffA1C4FD),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_box_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              db.insertPad(
                Pad(
                    title: "Empty Pad",
                    soundMode: SoundMode.oneshot.name,
                    duration: 0),
              );
              setState(() {});
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.topCenter,
                colors: <Color>[
                  Color(0xffC2E9FB),
                  Color(0xffA1C4FD),
                ]),
          ),
          child: FutureBuilder(
            future: db.getPad(),
            builder: (BuildContext context, AsyncSnapshot<List<Pad>> snapshot) {
              return gridViewWidget(snapshot);
            },
          ),
        ),
      ),
    );
  }

  GridView gridViewWidget(AsyncSnapshot<List<Pad>> snapshot) {
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
          return editPadItemWidget(pad);
        });
  }

  Widget editPadItemWidget(Pad pad) {
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
          gradient: const RadialGradient(radius: 1, colors: <Color>[
            Color(0xff00CDAC),
            Color(0xff02AABD),
          ]),
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12)),
      child: Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            padTitleWidget(pad),
            buttonsRowWidget(pad),
          ],
        ),
        Positioned(
          top: 5,
          right: 5,
          child: deleteButton(pad),
        ),
      ]),
    );
  }

  Widget deleteButton(Pad pad) {
    return GestureDetector(
      onTap: () async {
        // set up the buttons
        Widget cancelButton = TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        );
        Widget continueButton = TextButton(
          child: const Text("Delete"),
          onPressed: () async {
            await db.deletePad(pad);
            setState(() {});
            Navigator.pop(context);
          },
        );

        // set up the AlertDialog
        AlertDialog alert = AlertDialog(
          title: const Text("Delete?"),
          content: const Text("Would you like to delete this pad?"),
          actions: [
            cancelButton,
            continueButton,
          ],
        );

        // show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      },
      child: const Icon(
        Icons.remove_circle,
        color: Colors.red,
      ),
    );
  }

  Widget buttonsRowWidget(Pad pad) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          fileSelectorButton(pad),
          const SizedBox(width: 8),
          soundModeButton(pad),
        ],
      ),
    );
  }

  Widget soundModeButton(Pad pad) {
    return PopupMenuButton(
        onSelected: (Menu item) {
          setState(() {
            db.updatePadSoundMode(pad.id, item.name);
          });
        },
        child: const Icon(
          Icons.category,
          color: Colors.white,
        ),
        itemBuilder: (context) => [
              const PopupMenuItem(
                value: Menu.oneshot,
                child: Text('oneshot'),
              ),
              const PopupMenuItem(
                value: Menu.loopback,
                child: Text('loopback'),
              ),
              const PopupMenuItem(
                value: Menu.loop,
                child: Text('loop'),
              )
            ]);
  }

  GestureDetector fileSelectorButton(Pad pad) {
    return GestureDetector(
      onTap: () async {
        if (await Permission.storage.request().isGranted) {
          await Utility.pickAudio(pad.id, context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Permission not granted!'),
            ),
          );
        }
        setState(() {});
      },
      child: const Icon(
        Icons.audio_file_rounded,
        color: Colors.white,
      ),
    );
  }

  Widget padTitleWidget(Pad pad) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Text(style: TextStyle(color: Colors.white), "${pad.title}"),
        ),
      ),
    );
  }
}
