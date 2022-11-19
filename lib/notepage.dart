import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class notePage extends StatefulWidget {
  String title;
  String category;
  String note;
  notePage({
    Key? key,
    required this.title,
    required this.category,
    required this.note,
  }) : super(key: key);

  @override
  State<notePage> createState() => _notePageState();
}

class _notePageState extends State<notePage> {
  List list = ["Important", "Bookmarked", ];
  ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    String dropDownValue = "Important";
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
      body: Container(
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
                    widget.note,
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
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(30))),
                  width: size.width,
                  height: size.height * 0.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.category,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      DropdownButton(
                          value: dropDownValue,
                          icon: Icon(
                            FluentIcons.list_28_regular,
                            color: Colors.greenAccent,
                          ),
                          dropdownColor: Colors.black,
                          underline: Container(
                            height: 2,
                            width: 10,
                            decoration: BoxDecoration(
                                color: Colors.greenAccent,
                                borderRadius: BorderRadius.circular(0.5)),
                          ),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                          items: [
                            DropdownMenuItem(child: Text("Bookmarked")),
                            DropdownMenuItem(child: Text("Important"))
                          ],
                          onChanged: ((value) {
                            setState(() {
                              dropDownValue = value!;
                            });
                          }))
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}