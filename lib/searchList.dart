import 'package:bookstore/cubit/drop_down_cubit.dart';
import 'package:bookstore/database_handler.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'UpdatePage.dart';
import 'notepage.dart';

class Search extends StatefulWidget {
  String category;
  bool pressed;
  Search({super.key, required this.category, required this.pressed});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DatabaseHandler _handler = DatabaseHandler();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: _handler.selectSpecific(widget.category),
        builder: ((context, snapshot) {
          return snapshot.connectionState != ConnectionState.done
              ? Center(
                  child: Column(children: [
                    CircularProgressIndicator(
                      color: Colors.greenAccent,
                      backgroundColor: Colors.black,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Loading...",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  ]),
                )
              : snapshot.data!.isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image(
                          image: AssetImage("lib/photos/error.jpg"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text("There is no category like that.",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ))
                      ],
                    )
                  : Container(
                      width: size.width,
                      height: size.height * 0.8,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    BlocProvider.of<searchCubit2>(context)
                                        .change(false);
                                  },
                                  icon: Icon(
                                      FluentIcons.arrow_circle_left_24_regular,
                                      color: Colors.greenAccent)),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Search Results",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int value) {
                                return Dismissible(
                                  key: ValueKey<int>(snapshot.data![value].id),
                                  onDismissed: (direction) {
                                    Alert(
                                        context: context,
                                        style: AlertStyle(
                                            descStyle: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.greenAccent),
                                            titleStyle: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.greenAccent),
                                            backgroundColor: Colors.black,
                                            alertAlignment: Alignment.center),
                                        title: "Alert",
                                        desc: "Are you sure to delete this?",
                                        buttons: [
                                          DialogButton(
                                              color: Colors.black,
                                              child: Text(
                                                "Dismiss",
                                                style: TextStyle(
                                                    color: Colors.greenAccent,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              onPressed: () {
                                                setState(() {});
                                                Navigator.of(context).pop();
                                              }),
                                          DialogButton(
                                              color: Colors.black,
                                              child: Text(
                                                "Confirm",
                                                style: TextStyle(
                                                    color: Colors.greenAccent,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              onPressed: () {
                                                _handler.deleteData(
                                                    snapshot.data![value].id);

                                                setState(() {});
                                                Navigator.of(context).pop();
                                              })
                                        ]).show();
                                  },
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => notePage(
                                                    title: snapshot
                                                        .data![value].noteTitle,
                                                  )));
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              bottomRight:
                                                  Radius.circular(20))),
                                      color: Colors.black,
                                      child: ListTile(
                                        title: Text(
                                          snapshot.data![value].noteTitle,
                                          style: TextStyle(
                                              color: Colors.greenAccent,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          snapshot.data![value].category,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        trailing: IconButton(
                                          icon: Icon(
                                            FluentIcons
                                                .text_edit_style_24_regular,
                                            color: Colors.white,
                                          ),
                                          onPressed: () async {
                                            await Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SecondPage(
                                                          book: snapshot
                                                              .data![value],
                                                        )));
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ),
                    );
        }));
  }
}
