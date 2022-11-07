import 'package:bookstore/books.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/database_handler.dart';
import 'package:bookstore/results.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

void main() => runApp(Home());

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Hello());
  }
}

class Hello extends StatelessWidget {
  const Hello({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello'),
      ),
      body: Center(child: BookList()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SecondPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class BookList extends StatefulWidget {
  const BookList({
    Key key,
  }) : super(key: key);

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  TextEditingController hello = TextEditingController();
  DatabaseHandler databaseHandler = DatabaseHandler();
  @override
  void initState() {
    hello = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: TextField(
              decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              controller: hello,
              keyboardType: TextInputType.text,
              onSubmitted: (value) {
                databaseHandler.search(value);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Results(searchValue: value)));
              },
            ),
          ),
          Positioned(
            top: 70,
            left: 0,
            right: 0,
            bottom: 0,
            child: FutureBuilder<List<Book>>(
                future: databaseHandler.selectAllbooks(),
                builder: (context, hello) => hello.connectionState !=
                        ConnectionState.done
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : hello.data.length == 0
                        ? Center(
                            child: Text('NO DATA LEFT'),
                          )
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
                                  child: ListTile(
                                    title: Text(hello.data[value].book_name),
                                    subtitle: Text(hello.data[value].author),
                                    trailing: IconButton(
                                      icon: Icon(Icons.edit),
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
