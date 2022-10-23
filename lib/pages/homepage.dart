import 'package:flutter/material.dart';
import 'package:flutter_projects/custom_widgets.dart';
import 'package:flutter_projects/models/pad.dart';
import 'package:flutter_projects/database_helper.dart';
import 'package:flutter_projects/utility.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
var db = DatabaseHelper();
const List<String> list = <String>['Play mode', 'Edit mode'];
String dropdownValue = list.first;
bool isTrackRunning = false;
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
            DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_drop_down,color: Colors.black54),
            style: const TextStyle(color: Colors.black54,fontWeight: FontWeight.bold),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                dropdownValue = value!;
              });
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )
        ],
        title: Text("Pads"),
        backgroundColor: Colors.amber,
      ),


      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: FutureBuilder(
            future: db.getPad(),
            builder: (BuildContext context, AsyncSnapshot<List<Pad>> snapshot){
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context,index){
                    Pad? pad = snapshot.data?[index];
                    return GestureDetector(
                      onTap: () async {
                        Utility utility = Utility();
                        utility.pickAudio();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text("${pad?.title}"),
                      ),
                    );
                  }
              );
            }
          ),
        ),
      ),
    );
  }
}
