import 'package:bookstore/books.dart';
import 'package:flutter/material.dart';

import 'database_handler.dart';

class SecondPage extends StatefulWidget {
  final Book book;
  SecondPage({Key key, this.book}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  var key = GlobalKey<FormState>();
  bool pressed = false;
  DatabaseHandler databasehandler;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller1 = TextEditingController();
    controller2 = TextEditingController();
    controller3 = TextEditingController();
    databasehandler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: key,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              Text(
                "Update your notes",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter New Note';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                controller: controller1,
                onTap: () {
                  pressed = true;
                },
                onFieldSubmitted: (value) => controller1.text,
                decoration: pressed
                    ? InputDecoration(
                        fillColor: Colors.white,
                        labelText: 'New Title',
                        labelStyle: TextStyle(color: Colors.black))
                    : InputDecoration(
                        hintText: "Enter New Title",
                        fillColor: Colors.white,
                        labelText: 'New Title',
                        labelStyle: TextStyle(color: Colors.black)),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Category';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                controller: controller2,
                onTap: () {
                  pressed = true;
                },
                onFieldSubmitted: (value) => controller2.text,
                decoration: pressed
                    ? InputDecoration(
                        fillColor: Colors.white,
                        labelText: 'New Category',
                        labelStyle: TextStyle(color: Colors.black))
                    : InputDecoration(
                        hintText: "Enter New Category",
                        fillColor: Colors.white,
                        labelText: 'New Category',
                        labelStyle: TextStyle(color: Colors.black)),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                onTap: () {
                  pressed = true;
                },
                decoration: pressed
                    ? InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10)),
                        fillColor: Colors.white,
                        labelText: 'New Note',
                        labelStyle: TextStyle(color: Colors.black))
                    : InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10)),
                        hintText: "Enter New Note",
                        fillColor: Colors.white,
                        labelText: 'New Note',
                        labelStyle: TextStyle(color: Colors.black)),
                keyboardType: TextInputType.multiline,
                maxLines: 17,
                maxLength: 1500,
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  height: 50,
                  color: Colors.black,
                  onPressed: () async {
                    if (!key.currentState.validate()) {
                      return;
                    }
                    if (widget.book != null) {
                      await databasehandler.updateData(Book.withId(
                          widget.book.id,
                          controller1.text,
                          controller2.text,
                          controller3.text));
                      Navigator.pop(context);

                      return;
                    }

                    
                    setState(() {});
                  },
                  child: Text(
                    widget.book != null ? 'Update' : 'Save',
                    style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
