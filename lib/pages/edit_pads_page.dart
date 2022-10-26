import 'package:flutter/material.dart';
import 'package:flutter_projects/database_helper.dart';
import 'package:flutter_projects/models/pad.dart';
import 'package:flutter_projects/utility.dart';

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
        title: Text("Edit"),
        backgroundColor: Colors.amber,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
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
        itemCount: snapshot.data?.length,
        itemBuilder: (context, index) {
          Pad pad = snapshot.data![index];
          return editPadItemWidget(pad);
        });
  }

  Widget editPadItemWidget(Pad pad) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.amber, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          padTitleWidget(pad),
          buttonsRowWidget(pad),
        ],
      ),
    );
  }

  Widget buttonsRowWidget(Pad pad) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          fileSelectorButton(pad),
          const SizedBox(width: 8),
          soundModeButton(),
        ],
      ),
    );
  }

  GestureDetector soundModeButton() {
    return GestureDetector(
      onTap: () async {
        print("object");
      },
      child: const Icon(Icons.category_outlined),
    );
  }

  GestureDetector fileSelectorButton(Pad pad) {
    return GestureDetector(
      onTap: () async {
        Utility utility = Utility();
        await utility.pickAudio(pad.id, context);
        setState(() {});
      },
      child: const Icon(Icons.audio_file_outlined),
    );
  }

  Widget padTitleWidget(Pad pad) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("${pad.title}"),
      ),
    );
  }
}
