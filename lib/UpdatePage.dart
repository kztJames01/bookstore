import 'package:bookstore/books.dart';
import 'package:bookstore/cubit/drop_down_cubit.dart';
import 'package:bookstore/main.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'database_handler.dart';

String _dropDownValue = "All";

class SecondPage extends StatefulWidget {
  final Book book;
  SecondPage({Key? key, required this.book}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

List<String> list = <String>[
  "All",
  "Important",
  "Lectures",
  "Transportation",
  "Health",
  "Politics",
  "Addresses",
  "Passwords",
  "Random"
];

class _SecondPageState extends State<SecondPage> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  var key = GlobalKey<FormState>();
  bool pressed = false;
  late DatabaseHandler databasehandler;
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
    var size = MediaQuery.of(context).size;
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
                  if (value!.isEmpty) {
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
                        labelText: 'New Title',
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        hintText: "Enter New Title",
                        hintStyle: TextStyle(
                          color: Colors.black38,
                          fontSize: 16,
                        ))
                    : InputDecoration(
                        hintText: "Enter New Title",
                        hintStyle: TextStyle(
                          color: Colors.black38,
                          fontSize: 16,
                        )),
              ),
              SizedBox(
                height: 20,
              ),
              BlocBuilder<DropDownCubit1, DropDownInitial1>(
                builder: (context, state) {
                  return Container(
                    width: size.width * 0.8,
                    height: size.height * 0.05,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20)),
                    child: DropdownButton<String>(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        value: state.textValue,
                        elevation: 16,
                        icon: Icon(
                          FluentIcons.arrow_circle_down_24_regular,
                        ),
                        dropdownColor: Colors.black,
                        iconDisabledColor: Colors.white,
                        iconEnabledColor: Colors.greenAccent,
                        isExpanded: true,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                        items:
                            list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                              ));
                        }).toList(),
                        onChanged: (value) {
                          BlocProvider.of<DropDownCubit1>(context)
                              .change1(value);
                          _dropDownValue = value!;
                        }),
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                onTap: () {
                  pressed = true;
                },
                controller: controller3,
                onFieldSubmitted: (value) {
                  controller3.text;
                },
                decoration: pressed
                    ? InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "New Note",
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 20),
                        hintText: 'Enter New Note',
                        hintStyle:
                            TextStyle(color: Colors.black38, fontSize: 20))
                    : InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10)),
                        hintText: "Enter New Note",
                        hintStyle:
                            TextStyle(color: Colors.black38, fontSize: 20)),
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
                    if (!key.currentState!.validate()) {
                      return;
                    }
                    if (widget.book != null) {
                      await databasehandler.updateData(Book.withId(
                        widget.book.id,
                          controller1.text, _dropDownValue, controller3.text));
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
