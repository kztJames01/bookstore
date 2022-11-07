import 'package:flutter/material.dart';

import 'database_handler.dart';

class Results extends StatefulWidget {
  final searchValue;
  Results({Key key, this.searchValue}) : super(key: key);

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  DatabaseHandler databaseHandler;
  @override
  void initState() {
    databaseHandler = DatabaseHandler();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: FutureBuilder(
              initialData: [databaseHandler.selectAllbooks()],
              future: databaseHandler.selectAllbooks(),
              builder: (context, snapshot) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          child: Container(
                        child: Column(
                          children: [
                            Text(snapshot.data[index].id.toString()),
                            Text(snapshot.data[index].book_name),
                            Text(snapshot.data[index].author),
                            Text(snapshot.data[index].price.toString())
                          ],
                        ),
                      ));
                    });
              })),
    );
  }
}
