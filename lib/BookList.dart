import 'package:bookstore/UpdatePage.dart';
import 'package:bookstore/books.dart';
import 'package:bookstore/cubit/drop_down_cubit.dart';
import 'package:bookstore/database_handler.dart';
import 'package:bookstore/notepage.dart';
import 'package:bookstore/results.dart';
import 'package:bookstore/searchList.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class BookList extends StatefulWidget {
  const BookList({
    Key? key,
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
  bool search = false;
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
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return "Enter search value";
                    }
                    return null;
                  }),
                  decoration: pressed
                      ? InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 10, top: 20),
                          isCollapsed: false,
                          suffixIcon: IconButton(
                            padding: EdgeInsets.all(0),
                            iconSize: 24,
                            icon: Icon(
                              Icons.search_outlined,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              search = true;
                              BlocProvider.of<searchCubit2>(context)
                                  .change(true);
                            },
                          ),
                          labelText: 'Search',
                          labelStyle: TextStyle(
                              color: Colors.black38,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          hintText: 'Enter note category',
                          hintStyle: TextStyle(
                            color: Colors.black26,
                            fontStyle: FontStyle.italic,
                            fontSize: 14,
                          ))
                      : InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 10, top: 20),
                          isCollapsed: false,
                          suffixIcon: Icon(
                            Icons.search_outlined,
                            color: Colors.black,
                            size: 16,
                          ),
                          hintText: 'Enter note category',
                          hintStyle: TextStyle(
                              color: Colors.black26,
                              fontSize: 14,
                              fontStyle: FontStyle.italic)),
                  controller: hello,
                  keyboardType: TextInputType.text,
                  onTap: () {
                    setState(() {
                      pressed = true;
                    });
                  },
                  onFieldSubmitted: (value) {
                    hello.text;
                  },
                ),
              ),
            ),
            BlocBuilder<searchCubit2, searchResult>(
              builder: (context, state) {
                return Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  width: size.width,
                  height: size.height,
                  child: search == state.search
                      ? Search(
                          category: hello.text,
                          pressed: search,
                        )
                      : FutureBuilder<List<Book>>(
                          future: databaseHandler.selectAllbooks(),
                          builder: (context, hello) => hello.connectionState !=
                                  ConnectionState.done
                              ? Center(
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text("Loading",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ))
                              : hello.data!.isEmpty
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              "lib/photos/error.jpg"),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text("You have no notes",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                            ))
                                      ],
                                    )
                                  : ListView.builder(
                                      itemCount: hello.data!.length,
                                      itemBuilder:
                                          (BuildContext context, int value) {
                                        return Dismissible(
                                          key: ValueKey<int>(
                                              hello.data![value].id),
                                          onDismissed: (direction) {
                                            Alert(
                                                context: context,
                                                style: AlertStyle(
                                                    descStyle: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.greenAccent),
                                                    titleStyle: TextStyle(
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.greenAccent),
                                                    backgroundColor:
                                                        Colors.black,
                                                    alertAlignment:
                                                        Alignment.center),
                                                title: "Alert",
                                                desc:
                                                    "Are you sure to delete this?",
                                                buttons: [
                                                  DialogButton(
                                                      color: Colors.black,
                                                      child: Text(
                                                        "Dismiss",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .greenAccent,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {});
                                                        Navigator.of(context)
                                                            .pop();
                                                      }),
                                                  DialogButton(
                                                      color: Colors.black,
                                                      child: Text(
                                                        "Confirm",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .greenAccent,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      onPressed: () {
                                                        databaseHandler
                                                            .deleteData(hello
                                                                .data![value]
                                                                .id);

                                                        setState(() {});
                                                        Navigator.of(context)
                                                            .pop();
                                                      })
                                                ]).show();
                                          },
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          notePage(
                                                            title: hello
                                                                .data![value]
                                                                
                                                          )));
                                            },
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  20))),
                                              color: Colors.black,
                                              child: ListTile(
                                                title: Text(
                                                  hello.data![value].noteTitle,
                                                  style: TextStyle(
                                                      color: Colors.greenAccent,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                subtitle: Text(
                                                  hello.data![value].category,
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
                                                    await Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    SecondPage(
                                                                      book: hello
                                                                              .data![
                                                                          value],
                                                                    )));
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      })),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
