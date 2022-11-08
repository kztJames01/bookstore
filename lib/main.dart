import 'package:bookstore/books.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/database_handler.dart';
import 'package:bookstore/results.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

void main() => runApp(Hello());

class Hello extends StatefulWidget {
  const Hello({Key key}) : super(key: key);

  @override
  State<Hello> createState() => _HelloState();
}

class _HelloState extends State<Hello> with TickerProviderStateMixin {
  AdvancedDrawerController controller;
  @override
  void initState() {
    controller = AdvancedDrawerController();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AdvancedDrawer(
            childDecoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20)),
            controller: controller,
            backdropColor: Colors.black,
            child: Scaffold(
         
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () => controller.showDrawer(),
                    icon: ValueListenableBuilder<AdvancedDrawerValue>(
                    valueListenable: controller,
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
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SecondPage()));
                },
                child: Icon(
                  Icons.add,
                  color: Colors.greenAccent,
                ),
              ),
            ),
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
                          text: "Kaung Zaw Thant\n\n",
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

class BookList extends StatefulWidget {
  const BookList({
    Key key,
  }) : super(key: key);

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> with TickerProviderStateMixin {
  TextEditingController hello = TextEditingController();
  DatabaseHandler databaseHandler = DatabaseHandler();

  @override
  void initState() {
    hello = TextEditingController();

    super.initState();
  }

  bool pressed = false;
  var key1 = GlobalKey<FormState>();
  @override
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: key1,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextFormField(
                  validator: ((String value) {
                    if (value.isEmpty) {
                      return 'Enter search value';
                    }
                    return null;
                  }),
                  enabled: pressed,
                  decoration: pressed
                      ? InputDecoration(
                          isCollapsed: false,
                          suffixIcon: Icon(
                            Icons.search_outlined,
                            color: Colors.black,
                            size: 20,
                          ),
                          labelText: 'Search',
                          hintText: 'Enter book title',
                          hintStyle: TextStyle(
                            color: Colors.black26,
                            fontSize: 14,
                          ))
                      : InputDecoration(
                          isCollapsed: false,
                          suffixIcon: Icon(
                            Icons.search_outlined,
                            color: Colors.black,
                            size: 16,
                          ),
                          hintText: 'Enter book title',
                          hintStyle: TextStyle(
                            color: Colors.black26,
                            fontSize: 14,
                          )),
                  controller: hello,
                  keyboardType: TextInputType.text,
                  onTap: () {
                    setState(() {
                      pressed = true;
                    });
                  },
                  onFieldSubmitted: (value) {
                    databaseHandler.search(value);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Results(searchValue: value)));
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              width: size.width,
              height: size.height,
              child: FutureBuilder<List<Book>>(
                  initialData: [],
                  future: databaseHandler.selectAllbooks(),
                  builder: (context, hello) => hello.connectionState !=
                          ConnectionState.done
                      ? Center(
                          child: Column(
                          children: [
                            CircularProgressIndicator(
                              color: Colors.black,
                            ),
                            Text("Loading",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold))
                          ],
                        ))
                      : hello.data.length == 0
                          ? Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  image: AssetImage("lib/photos/error.jpg"),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("No Data",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                    ))
                              ],
                            ))
                          : ListView.builder(
                              itemCount: hello.data.length,
                              itemBuilder: (BuildContext context, int value) {
                                return Dismissible(
                                  key: Key(value.toString()),
                                  onDismissed: (direction) {
                                    databaseHandler
                                        .deleteData(hello.data[value].id);
                                    hello.data.removeAt(value);
                                    setState(() {});
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20))),
                                    color: Colors.black,
                                    child: ListTile(
                                      title: Text(
                                        hello.data[value].book_name,
                                        style: TextStyle(
                                            color: Colors.greenAccent,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        hello.data[value].author,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                        onPressed: () async {
                                          await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SecondPage(
                                                        book: hello.data[value],
                                                      )));
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              })),
            ),
          ],
        ),
      ),
    );
  }
}

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
  DatabaseHandler databasehandler;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller1 = TextEditingController();
    controller2 = TextEditingController();
    controller3 = TextEditingController();
    databasehandler = DatabaseHandler();
    if (widget.book != null) {
      controller.text = widget.book.id.toString();
      controller1.text = widget.book.book_name;
      controller2.text = widget.book.author;
      controller3.text = widget.book.price.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Add data',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: key,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter ID';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                controller: controller,
                onFieldSubmitted: (value) => controller.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    fillColor: Colors.white,
                    labelText: 'ID',
                    labelStyle: TextStyle(color: Colors.black)),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter book name';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                onFieldSubmitted: (value) => controller1.text,
                controller: controller1,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    fillColor: Colors.white,
                    labelText: 'Book Name',
                    labelStyle: TextStyle(color: Colors.black)),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter author name';
                  }
                  return null;
                },
                controller: controller2,
                onFieldSubmitted: (value) => controller2.text,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10)),
                    fillColor: Colors.white,
                    labelText: 'Author',
                    labelStyle: TextStyle(color: Colors.black)),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter price';
                  }
                  return null;
                },
                controller: controller3,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (value) => controller3.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10)),
                    fillColor: Colors.white,
                    labelText: 'Price',
                    labelStyle: TextStyle(color: Colors.black)),
              ),
              MaterialButton(
                  color: Colors.blue,
                  onPressed: () async {
                    if (!key.currentState.validate()) {
                      return;
                    }
                    if (widget.book != null) {
                      await databasehandler.updateData(Book.withId(
                          widget.book.id,
                          controller1.text,
                          controller2.text,
                          int.parse(controller3.text)));
                      Navigator.pop(context);

                      return;
                    }

                    Book book = Book.withId(
                        int.parse(controller.text),
                        controller1.text,
                        controller2.text,
                        int.parse(controller3.text));
                    int success = await databasehandler.insertData(book);
                    if (success == 0) {
                      print('not successful');
                    }
                    setState(() {});
                  },
                  child: Text(
                    widget.book != null ? 'Update' : 'Save',
                    style: TextStyle(color: Colors.black),
                  )),
              MaterialButton(
                onPressed: () {
                  CustomPicker();
                },
                child: Icon(Icons.timer),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime currentTime, LocaleType locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex())
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex());
  }
}
