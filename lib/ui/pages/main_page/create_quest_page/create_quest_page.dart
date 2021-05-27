import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CreateQuestPage extends StatelessWidget {
  final List<String> item = List<String>.generate(10, (i) => 'Samantha Sparcs');

  static const String routeName = "/createQuestPage";

  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 130,
          elevation: 2,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.only(left: 12),
                alignment: Alignment.centerLeft,
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_sharp,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Create quest',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Proposal',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Color(0xFFF7F8FA),
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    ),
                    alignment: Alignment.centerLeft,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        isExpanded: true,
                        items: <String>['One', 'Two', 'Free', 'Four']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          size: 30,
                          color: Colors.blueAccent,
                        ),
                        hint: Text(
                          'Choose',
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsetsDirectional.only(
                      top: 20.0,
                      bottom: 10.0,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Color(0xFFF7F8FA),
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    ),
                    alignment: Alignment.centerLeft,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        isExpanded: true,
                        items: <String>['One', 'Two', 'Free', 'Four']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          size: 30,
                          color: Colors.blueAccent,
                        ),
                        hint: Text(
                          'Choose',
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsetsDirectional.only(
                      top: 20.0,
                      bottom: 10.0,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Address',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFFF7F8FA),
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    ),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      maxLines: 1,
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                            onPressed: null,
                            icon: Icon(
                              Icons.map_outlined,
                              color: Colors.blueAccent,
                              size: 26.0,
                            )),
                        hintText: 'Moscow, Lenina street, 3',
                      ),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsetsDirectional.only(
                      top: 20.0,
                      bottom: 10.0,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Runtime',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFF7F8FA),
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.arrow_left_sharp,
                            size: 30.0,
                            color: Colors.blueAccent,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '1',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.arrow_right_sharp,
                            size: 30.0,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsetsDirectional.only(
                      top: 20.0,
                      bottom: 10.0,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Quest title',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFF7F8FA),
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    ),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Title',
                      ),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsetsDirectional.only(
                      top: 20.0,
                      bottom: 10.0,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'About quest',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    height: 245,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFF7F8FA),
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Quest text',
                      ),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:20.0),
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      strokeCap: StrokeCap.round,
                      radius: Radius.circular(10),
                      dashPattern: [6, 6,],
                      color: Colors.grey,
                      strokeWidth: 1.0,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: GestureDetector(
                          ///Add on tap function
                          onTap: null,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Upload images \n or videos',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),

                              SizedBox(
                                height: 12,
                              ),

                              Icon(Icons.add_to_photos_outlined,color: Colors.blueAccent,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsetsDirectional.only(
                      top: 20.0,
                      bottom: 10.0,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFF7F8FA),
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Price',
                      ),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 50.0,
                margin: const EdgeInsets.symmetric(vertical: 30),
                child: ElevatedButton(
                  onPressed: null,
                  child: Text(
                    'Create a quest',
                    style: TextStyle(color: Colors.white,),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

}
