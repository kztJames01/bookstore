import 'package:azlistview/azlistview.dart';
import 'package:bookstore/books.dart';
import 'package:bookstore/database_handler.dart';
import 'package:bookstore/notepage.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class _AZitem extends ISuspensionBean {
  String title;
  String tag;
  String category;
  _AZitem({required this.tag, required this.title, required this.category});

  @override
  String getSuspensionTag() => tag;
}

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<_AZitem> dataItems = [];
  DatabaseHandler _handler = DatabaseHandler();
  Future<List<Book>> futureListToList() async {
    var list = await _handler.selectAllbooks();

    return list;
  }

  @override
  void initState() {
    callMethod();
    // TODO: implement initState
    super.initState();
  }

  void callMethod() async {
    _initList(await futureListToList());
  }

  _initList(List<Book> items) async {
    dataItems = await items
        .map((item) => _AZitem(
            category: item.category,
            tag: item.noteTitle[0].toUpperCase(),
            title: item.noteTitle))
        .toList();
    SuspensionUtil.sortListBySuspensionTag(dataItems);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget content(String noteTitle, String category,Book book) {
      return ListTileTheme(
        contentPadding: EdgeInsets.all(10),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context)=> notePage(title: book)));
              },
              child: ListTile(
                title: Text(
                  noteTitle,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  category,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              FluentIcons.arrow_left_28_filled,
              color: Colors.black,
            ),
          )),
      body: Container(
        color: Colors.white,
        width: size.width,
        height: size.height,
        padding: EdgeInsets.all(20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Title Lists",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 24,
              ),
              FutureBuilder(
                  future: _handler.selectAllbooks(),
                  builder: ((context, snapshot) {
                    return Container(
                      width: size.width * 0.9,
                      height: size.height * 0.75,
                      child: AzListView(
                        indexBarOptions: IndexBarOptions(
                            selectTextStyle: TextStyle(
                                color: Colors.greenAccent, fontSize: 12),
                            downTextStyle:
                                TextStyle(color: Colors.black, fontSize: 12),
                            color: Colors.white),
                        indexBarWidth: 10,
                        padding: EdgeInsets.all(10),
                        data: dataItems,
                        itemCount: dataItems.length,
                        itemBuilder: (context, index) {
                          return content(dataItems[index].title,
                              dataItems[index].category,snapshot.data![index]);
                        },
                      ),
                    );
                  }))
            ]),
      ),
    );
  }
}
