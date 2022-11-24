import 'package:bookstore/books.dart';
import 'package:bookstore/cubit/drop_down_cubit.dart';
import 'package:bookstore/database_handler.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class notePage extends StatefulWidget {
  final Book title;

  notePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<notePage> createState() => _notePageState();
}

class _notePageState extends State<notePage> {
  late TextEditingController _controller;
  DatabaseHandler handler = DatabaseHandler();
  ScrollController controller = ScrollController();
  int index = 0;
  bool isEditable = false;
  late String initialText;
  static GlobalKey<FormState> key = new GlobalKey<FormState>();
  @override
  void initState() {
    initialText = widget.title.note;
    _controller = TextEditingController.fromValue(
        TextEditingValue(text: widget.title.note));
    // TODO: implement initState
    super.initState();
  }

  Widget _editText(bool isEditable, String note) {
    return isEditable
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 0))),
                key: key,
                onFieldSubmitted: (value) {
                  _controller.text;
                },
                controller: _controller,
                keyboardType: TextInputType.multiline,
                maxLines: 20,
                maxLength: 2000,
                style: TextStyle(
                    letterSpacing: 1.15,
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.black,
                minWidth: 300,
                height: 50,
                onPressed: () async {
                  await handler.updateData(Book.withId(
                      widget.title.id,
                      widget.title.noteTitle,
                      widget.title.category,
                      _controller.text));
                  setState(() {
                    
                  });
                  BlocProvider.of<edit>(context).change(false);
                },
                child: Text(
                  "Update",
                  style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          )
        : Text(
            note,
            style: TextStyle(
                letterSpacing: 1.15,
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 32,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  BlocProvider.of<edit>(context).change(true);
                },
                icon: Icon(
                  FluentIcons.edit_24_filled,
                  color: Colors.white,
                ))
          ],
        ),
        body: FutureBuilder<List<Book>>(
            future: handler.search(widget.title.noteTitle),
            builder: (context, snapshot) {
              return Container(
                      width: size.width,
                      height: size.height * 0.9,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned(
                            bottom: 0,
                            child: BlocBuilder<edit, textEdit>(
                              builder: (context, state) {
                                return SingleChildScrollView(
                                  controller: controller,
                                  child: Container(
                                
                                      width: size.width,
                                      height: size.height * 0.75,
                                      padding: EdgeInsets.only(
                                          top: size.height * 0.1,
                                          left: 10,
                                          right: 10),
                                      child: _editText(
                                          state.edit,
                                          snapshot.hasData
                                              ? snapshot.data![index].note
                                              : widget.title.note)),
                                );
                              },
                            ),
                          ),
                          Positioned(
                              top: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 0),
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
                                      "Title: ${widget.title.noteTitle}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.greenAccent,
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Category: ${widget.title.category}",
                                      overflow: TextOverflow.ellipsis,
                                       style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    );
            }));
  }
}
