import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/quest_page/create_quest_page/store/create_quest_store.dart';
import 'package:app/ui/widgets/media_upload_widget.dart';
import 'package:app/ui/widgets/platform_activity_indicator.dart';
import 'package:app/utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:provider/provider.dart";
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../../observer_consumer.dart';

class CreateQuestPage extends StatefulWidget {
  static const String routeName = '/createQuestPage';
  final BaseQuestResponse? questInfo;

  CreateQuestPage({this.questInfo});

  @override
  _CreateQuestPageState createState() => _CreateQuestPageState();
}

class _CreateQuestPageState extends State<CreateQuestPage> {

  void initState() {
    super.initState();
    if (widget.questInfo != null) {
      final store = context.read<CreateQuestStore>();
      store.priority = store.priorityList[widget.questInfo!.priority];
      store.category = widget.questInfo!.category;
      store.questTitle = widget.questInfo!.title;
      store.description = widget.questInfo!.description;
      store.price = widget.questInfo!.price;
    }
  }

  Widget build(context) {
    final store = context.read<CreateQuestStore>();

    return Form(
      //key: _formKey,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: Text(
                "${widget.questInfo == null ? "Create" : "Edit"} Quest",
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
                    titledField(
                      "Priority",
                      Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
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
                    ),
                    titledField(
                      "Category",
                      Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Color(0xFFF7F8FA),
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Observer(
                          builder: (_) => InkWell(
                            onTap: () => modalBottomSheet(
                              DraggableScrollableSheet(
                                initialChildSize: 1.0,
                                expand: false,
                                builder: (context, scrollController) =>
                                    ListView.separated(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 15.0,
                                  ),
                                  separatorBuilder: (context, index) =>
                                      const Divider(
                                    color: Colors.black12,
                                    endIndent: 50.0,
                                    indent: 50.0,
                                  ),
                                  controller: scrollController,
                                  shrinkWrap: true,
                                  itemCount: store.questCategoriesList.length,
                                  itemBuilder: (context, index) => SizedBox(
                                    height: 40.0,
                                    width: double.maxFinite,
                                    child: InkWell(
                                      onTap: () {
                                        store.changedCategory(
                                            store.questCategoriesList[index]);
                                        print("${store.category}");
                                        Navigator.pop(context);
                                      },
                                      child: Center(
                                        child: new Text(
                                          store.questCategoriesList[index],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    store.category,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 30,
                                  color: Colors.blueAccent,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    titledField(
                      "Address",
                      Container(
                        height: 50,
                        child: TextFormField(
                          maxLines: 1,
                          validator: Validators.emptyValidator,
                          decoration: InputDecoration(
                            prefixIcon: IconButton(
                              onPressed: null,
                              icon: Icon(
                                Icons.map_outlined,
                                color: Colors.blueAccent,
                                size: 26.0,
                              ),
                            ),
                            hintText: 'Moscow, Lenina street, 3',
                          ),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Observer(
                        builder: (context) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Text("Add Runtime"),
                                    Checkbox(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      value: store.hasRuntime,
                                      onChanged: store.setRuntime,
                                    ),
                                  ],
                                ),
                                if (store.hasRuntime)
                                  titledField(
                                    "Runtime",
                                    Container(
                                      height: 50,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF7F8FA),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6.0)),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            store.dateString,
                                          ),
                                          Spacer(),
                                          IconButton(
                                            alignment:
                                                AlignmentDirectional.centerEnd,
                                            onPressed: () {
                                              modalBottomSheet(
                                                SizedBox(
                                                  height: 250,
                                                  child: CupertinoDatePicker(
                                                    mode:
                                                        CupertinoDatePickerMode
                                                            .date,
                                                    minimumDate: DateTime.now(),
                                                    onDateTimeChanged:
                                                        store.setDateTime,
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.calendar_today,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            )),
                    titledField(
                      "Quest Title",
                      Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        child: TextFormField(
                          onChanged: store.setQuestTitle,
                          validator: Validators.emptyValidator,
                          initialValue: store.questTitle,
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: 'Title',
                          ),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    titledField(
                      "About Quest",
                      TextFormField(
                        initialValue: store.description,
                        onChanged: store.setAboutQuest,
                        keyboardType: TextInputType.multiline,
                        maxLines: 12,
                        decoration: InputDecoration(
                          hintText: 'Quest text',
                        ),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ///Upload media
                    Padding(
                        padding: const EdgeInsets.only(
                          top: 20.0,
                        ),
                        child: MediaUpload(
                          media: store.media,
                        )),
                    titledField(
                      "Price",
                      Container(
                        height: 50,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          onChanged: store.setPrice,
                          initialValue: store.price,
                          validator: Validators.emptyValidator,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          decoration: InputDecoration(
                            hintText: 'Price',
                          ),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50.0,
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      child: ObserverListener<CreateQuestStore>(
                        onSuccess: () {
                          Navigator.pop(context);
                        },
                        child: Observer(
                          builder: (context) => ElevatedButton(
                            onPressed: store.canCreateQuest
                                ? () {
                                    store.createQuest();
                                    // if (_formKey.currentState!.validate()) {
                                    //   store.createQuest();
                                    // }
                                  }
                                : null,
                            child: store.isLoading
                                ? PlatformActivityIndicator()
                                : Text(
                                    'Create a quest',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget titledField(
    String title,
    Widget child,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          child,
        ],
      );

  ///Show Modal Sheet Function
  modalBottomSheet(Widget child) => showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(
            20.0,
          ),
        ),
      ),
      context: context,
      builder: (context) {
        return child;
      });
}
