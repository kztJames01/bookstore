import 'package:bookstore/UpdatePage.dart';
import 'package:bookstore/books.dart';
import 'package:bookstore/database_handler.dart';
import 'package:bookstore/results.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import "package:flutter/material.dart";

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
                                          FluentIcons.text_edit_style_24_regular,
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
