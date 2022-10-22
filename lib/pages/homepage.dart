import 'package:flutter/material.dart';
import 'package:flutter_projects/models/pad.dart';
import 'package:flutter_projects/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
var db = DatabaseHelper();
bool isTrackRunning = false;
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                      onTap: () async {},
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
