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
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height * 0.9,
          child: Stack(children: [
            Positioned(
                top: 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(30))),
                  width: size.width,
                  height: size.height * 0.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 24,
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
                        onChanged: ((value) {}),
                        dropdownColor: Colors.white,
                        items: [
                          DropdownMenuItem(
                              child: Text(
                            "To Do",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )),
                          DropdownMenuItem(
                              child: Text(
                            "Done",
                            style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ))
                        ],
                      )
                    ],
                  ),
                )),
            Positioned(
              bottom: 0,
              child: Container(
                width: size.width,
                height: size.height * 0.6,
                color: Colors.white,
                padding: EdgeInsets.all(15),
                child: Text(
                  widget.note,
                  maxLines: 20,
                  strutStyle: StrutStyle(height: 1.5),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w300),
                ),
                
              ),
            )
          ], alignment: AlignmentDirectional.centerStart),
          
        ),
      ),
    );
  }
}
