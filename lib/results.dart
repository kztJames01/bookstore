import 'package:bookstore/books.dart';
import 'package:flutter/material.dart';

import 'database_handler.dart';

class Results extends StatefulWidget {
  final searchValue;
  Results({Key? key, this.searchValue}) : super(key: key);

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  late DatabaseHandler databaseHandler;
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
          child: FutureBuilder<List<Book>>(
              future: databaseHandler.selectSpecific(widget.searchValue),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int value) {
                          return Card(
                              child: Container(
                            child: Column(
                              children: [
                                Text(snapshot.data![value].id.toString()),
                                Text(snapshot.data![value].noteTitle),
                                Text(snapshot.data![value].category),
                                Text(snapshot.data![value].note),
                              ],
                            ),
                          ));
                        })
                    : Center(
                        child: Text(
                        "No Data",
                        style: TextStyle(color: Colors.black),
                      ));
              })),
    );
  }
}
