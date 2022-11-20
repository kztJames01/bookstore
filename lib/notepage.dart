import 'package:bookstore/books.dart';
import 'package:bookstore/database_handler.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class notePage extends StatefulWidget {
  String title;

  notePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<notePage> createState() => _notePageState();
}

class _notePageState extends State<notePage> {
  DatabaseHandler handler = DatabaseHandler();
  ScrollController controller = ScrollController();
  int index = 0;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              FluentIcons.arrow_circle_left_32_regular,
              color: Colors.greenAccent,
              size: 32,
            ),
          )),
      body: FutureBuilder<List<Book>>(
          future: handler.search(widget.title),
          builder: (context, snapshot) {
            return snapshot.connectionState != ConnectionState.done
                ? Container(
                    width: size.width,
                    height: size.height * 0.9,
                    color: Colors.black,
                    child: Column(children: [
                      CircularProgressIndicator(
                        color: Colors.white,
                        backgroundColor: Colors.greenAccent,
                        strokeWidth: 4,
                      ),
                      Text("Loading",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold))
                    ]),
                  )
                : Container(
                    width: size.width,
                    height: size.height * 0.9,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Positioned(
                          bottom: 0,
                          child: SingleChildScrollView(
                            controller: controller,
                            child: Container(
                              width: size.width,
                              height: size.height * 0.75,
                              padding: EdgeInsets.only(
                                  top: size.height * 0.1, left: 10, right: 10),
                              child: Text(
                                snapshot.data![index].note,
                                maxLines: 15,
                                style: TextStyle(
                                    letterSpacing: 1.15,
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            top: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(30))),
                              width: size.width,
                              height: size.height * 0.2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Title: ${widget.title}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.greenAccent,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Category: ${snapshot.data![index].category}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  );
          }),
    );
  }
}
