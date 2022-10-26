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
          buttonsRowWidget(),
        ],
      ),
    );
  }

  Row buttonsRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        fileSelectorButton(),
        soundModeButton(),
      ],
    );
  }

  GestureDetector soundModeButton() {
    return GestureDetector(
      onTap: () async {
        print("object");
      },
      child: Icon(Icons.ac_unit),
    );
  }

  GestureDetector fileSelectorButton() {
    return GestureDetector(
      onTap: () async {
        print("object");
      },
      child: Icon(Icons.folder_copy),
    );
  }

  Widget padTitleWidget(Pad pad) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () async {
            Utility utility = Utility();
            await utility.pickAudio(pad.id, context);
            setState(() {});
          },
          child: Container(
            child: Text("${pad!.title}"),
          ),
        ),
      ),
    );
  }
}
