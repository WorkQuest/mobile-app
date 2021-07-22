import 'package:app/ui/pages/main_page/create_quest_page/store/create_quest_store.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class CreateQuestPage extends StatelessWidget {
  static const String routeName = '/createQuestPage';

  const CreateQuestPage();

  Widget build(context) {
    final store = context.read<CreateQuestStore>();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(
              "Create Quest",
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              16.0,
              16.0,
              16.0,
              0.0,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Priority',
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
                        child: Observer(
                          builder: (_) => DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              value: store.priority,
                              onChanged: (String? value) {
                                store.changedPriority(value!);
                              },
                              items: store.priorityList
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                size: 30,
                                color: Colors.blueAccent,
                              ),
                              hint: Text(
                                'Choose',
                                maxLines: 1,
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
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
                        child: Observer(
                          builder: (_) => DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              value: store.category,
                              onChanged: (String? value) {
                                store.changedCategory(value!);
                              },
                              items: store.questCategoriesList
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                size: 30,
                                color: Colors.blueAccent,
                              ),
                              hint: Text(
                                'Choose',
                                maxLines: 1,
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
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
                          'Address',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        child: TextField(
                          maxLines: 1,
                          decoration: InputDecoration(
                            prefixIcon: IconButton(
                                onPressed: null,
                                icon: Icon(
                                  Icons.map_outlined,
                                  color: Colors.blueAccent,
                                  size: 26.0,
                                ),),
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
                        alignment: Alignment.centerLeft,
                        child: TextField(
                          onChanged: store.setQuestTitle,
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
                        decoration: BoxDecoration(
                          color: Color(0xFFF7F8FA),
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        ),
                        child: TextField(
                          onChanged: store.setAboutQuest,
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
                        padding: const EdgeInsets.only(top: 20.0),
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          strokeCap: StrokeCap.round,
                          radius: Radius.circular(10),
                          dashPattern: [
                            6,
                            6,
                          ],
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
                                  Icon(
                                    Icons.add_to_photos_outlined,
                                    color: Colors.blueAccent,
                                  ),
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
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          onChanged: store.setPrice,
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
                      onPressed: () {
                        store.createQuest();
                        print(store.price);
                      },
                      child: Text(
                        'Create a quest',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blueAccent),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
