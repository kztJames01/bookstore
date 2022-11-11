import 'package:bookstore/BookList.dart';
import 'package:bookstore/books.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/database_handler.dart';
import 'package:bookstore/results.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

void main() => runApp(Hi());

class Hi extends StatefulWidget {
  const Hi({
    Key? key,
  }) : super(key: key);

  @override
  State<Hi> createState() => _HiState();
}

class _HiState extends State<Hi> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Notes",
      debugShowCheckedModeBanner: false,
      home: Hello(
        book: Book(),
      ),
    );
  }
}

class Hello extends StatefulWidget {
  final Book book;
  const Hello({Key? key, required this.book}) : super(key: key);

  @override
  State<Hello> createState() => _HelloState();
}

class _HelloState extends State<Hello> with TickerProviderStateMixin {
  late AdvancedDrawerController drawercontroller;

  TextEditingController controller = TextEditingController();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  var key = GlobalKey<FormState>();
  bool pressed = false;
  late DatabaseHandler databasehandler;
  @override
  void initState() {
    drawercontroller = AdvancedDrawerController();
    super.initState();
    controller = TextEditingController();
    controller1 = TextEditingController();
    controller2 = TextEditingController();
    controller3 = TextEditingController();
    databasehandler = DatabaseHandler();
    if (widget.book != null) {
      controller.text = widget.book.id.toString();
      controller1.text = widget.book.noteTitle;
      controller2.text = widget.book.category;
      controller3.text = widget.book.note;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: AdvancedDrawer(
            childDecoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20)),
            controller: drawercontroller,
            backdropColor: Colors.black,
            child: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                      onPressed: () => drawercontroller.showDrawer(),
                      icon: ValueListenableBuilder<AdvancedDrawerValue>(
                        valueListenable: drawercontroller,
                        builder: ((context, value, child) {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              value.visible
                                  ? Icons.clear
                                  : Icons.library_books_outlined,
                              color: Colors.black,
                              key: ValueKey<bool>(value.visible),
                            ),
                          );
                        }),
                      )),
                  title: Text(
                    'Notes',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.white,
                  elevation: 0,
                ),
                body: Container(
                  child: BookList(),
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.black,
                  onPressed: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        elevation: 10,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        context: context,
                        builder: (context) => SizedBox(
                              width: size.width,
                              height: size.height * 0.9,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Form(
                                    key: key,
                                    child: Container(
                                      width: size.width,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            onTap: () {
                                              setState(() {
                                                pressed = true;
                                              });
                                            },
                                            validator: ((value) {
                                              if (value!.isEmpty) {
                                                return 'Enter ID';
                                              }
                                              return null;
                                            }),
                                            onFieldSubmitted: ((value) =>
                                                controller.text),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            decoration: pressed == true
                                                ? InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    labelText: "ID",
                                                    labelStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    hintText: "Enter ID number",
                                                    hintStyle: const TextStyle(
                                                        color: Colors.black12,
                                                        fontSize: 16,
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  )
                                                : const InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    hintText: "Enter ID number",
                                                    hintStyle: TextStyle(
                                                        color: Colors.black12,
                                                        fontSize: 16,
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  ),
                                            controller: controller,
                                            keyboardType: TextInputType.text,
                                          ),
                                          TextFormField(
                                            onTap: () {
                                              setState(() {
                                                pressed = true;
                                              });
                                            },
                                            validator: ((value) {
                                              if (value!.isEmpty) {
                                                return 'Enter Title';
                                              }
                                              return null;
                                            }),
                                            onFieldSubmitted: ((value) =>
                                                controller1.text),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            decoration: pressed == true
                                                ? InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    labelText: "Title",
                                                    labelStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    hintText: "Enter the title",
                                                    hintStyle: const TextStyle(
                                                        color: Colors.black12,
                                                        fontSize: 16,
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  )
                                                : const InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    hintText: "Enter the title",
                                                    hintStyle: TextStyle(
                                                        color: Colors.black12,
                                                        fontSize: 16,
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  ),
                                            controller: controller1,
                                            keyboardType: TextInputType.text,
                                          ),
                                          TextFormField(
                                            onTap: () {
                                              setState(() {
                                                pressed = true;
                                              });
                                            },
                                            validator: ((value) {
                                              if (value!.isEmpty) {
                                                return 'Enter Category';
                                              }
                                              return null;
                                            }),
                                            onFieldSubmitted: ((value) =>
                                                controller2.text),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            decoration: pressed == true
                                                ? InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    labelText: "Category",
                                                    labelStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    hintText:
                                                        "Enter the category",
                                                    hintStyle: const TextStyle(
                                                        color: Colors.black12,
                                                        fontSize: 16,
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  )
                                                : const InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    hintText:
                                                        "Enter the category",
                                                    hintStyle: TextStyle(
                                                        color: Colors.black12,
                                                        fontSize: 16,
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  ),
                                            controller: controller2,
                                            keyboardType: TextInputType.text,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          TextFormField(
                                            onTap: () {
                                              pressed = true;
                                            },
                                            validator: ((value) {
                                              if (value!.isEmpty) {
                                                return 'Enter Note';
                                              }
                                              return null;
                                            }),
                                            controller: controller3,
                                            onFieldSubmitted: ((value) =>
                                                controller3.text),
                                            decoration: pressed == false
                                                ? InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black12),
                                                        borderRadius: BorderRadius.circular(
                                                            10)),
                                                    fillColor: Colors.white,
                                                    labelText: 'Note',
                                                    labelStyle: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black))
                                                : InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black12),
                                                        borderRadius: BorderRadius.circular(
                                                            10)),
                                                    hintText: "Enter Notes",
                                                    hintStyle: TextStyle(
                                                        color: Colors.black12,
                                                        fontSize: 16,
                                                        fontStyle: FontStyle.italic),
                                                    fillColor: Colors.white,
                                                    labelText: 'Notes',
                                                    labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: 17,
                                            maxLength: 1500,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  MaterialButton(
                                    height: 50,
                                    minWidth: 300,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    color: Colors.black,
                                    onPressed: () async {
                                      if (!key.currentState!.validate()) {
                                        return;
                                      }

                                      Book book = Book.withId(
                                          int.parse(controller.text),
                                          controller1.text,
                                          controller2.text,
                                          controller3.text);
                                      int success = await databasehandler
                                          .insertData(book);
                                      if (success == 1) {
                                        SnackBar(
                                        
                                          backgroundColor: Colors.black,
                                          duration: Duration(seconds: 3),
                                          margin: EdgeInsets.all(10),
                                          padding: EdgeInsets.all(10),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          content: Text(
                                            'Success',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        );
                                      }
                                      setState(() {});
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Confirm",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                            ));
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.greenAccent,
                  ),
                )),
            drawer: Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              child: ListTileTheme(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                style: ListTileStyle.drawer,
                iconColor: Colors.greenAccent,
                textColor: Colors.white,
                contentPadding:
                    const EdgeInsets.only(top: 20, bottom: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).primaryColorLight),
                          image: const DecorationImage(
                              image: AssetImage("lib/photos/error.jpg")),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "Kaung Zaw Thant\n",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      const TextSpan(
                          text: "Level 1",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold))
                    ])),
                    ListTile(
                      onTap: () {},
                      leading:
                          const Icon(FluentIcons.person_accounts_24_regular),
                      title: const Text("My Account"),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: const Icon(FluentIcons.history_24_regular),
                      title: const Text("Pomodoro List"),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: const Icon(FluentIcons.settings_24_regular),
                      title: const Text("Settings"),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: const Icon(FluentIcons.contact_card_24_regular),
                      title: const Text("Contact Us"),
                    ),
                  ],
                ),
              ),
            )));
  }
}
