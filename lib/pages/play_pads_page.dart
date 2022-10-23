import 'package:flutter/material.dart';
import 'package:flutter_projects/pages/edit_pads_page.dart';

class PlayPadsPage extends StatefulWidget {
  const PlayPadsPage({Key? key}) : super(key: key);

  @override
  State<PlayPadsPage> createState() => _PlayPadsPageState();
}

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
    );
  }
}
