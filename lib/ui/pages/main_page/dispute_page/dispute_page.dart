import 'package:app/ui/pages/main_page/dispute_page/store/dispute_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";

class DisputePage extends StatefulWidget {
  static const String routeName = '/disputePage';

  const DisputePage();

  @override
  _DisputePageState createState() => _DisputePageState();
}

class _DisputePageState extends State<DisputePage> {
  final _descriptionController = TextEditingController();

  @override
  Widget build(context) {
    final store = context.read<DisputeStore>();
    return Scaffold(
      appBar: CupertinoNavigationBar(
        automaticallyImplyLeading: true,
        middle: Text("Begin Dispute"),
      ),
      body: CustomScrollView(
        slivers: [
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
                    "Dispute Theme",
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
                                itemCount: store.disputeCategoriesList.length,
                                itemBuilder: (context, index) => SizedBox(
                                  height: 45.0,
                                  width: double.maxFinite,
                                  child: InkWell(
                                    onTap: () {
                                      store.changeTheme(
                                          store.disputeCategoriesList[index]);
                                      print("${store.theme}");
                                      Navigator.pop(context);
                                    },
                                    child: Center(
                                      child: new Text(
                                        store.disputeCategoriesList[index],
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
                                  store.theme,
                                  maxLines: 2,
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
                    "Description",
                    Container(
                      height: 200,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Color(0xFFF7F8FA),
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Observer(
                        builder: (_) => TextField(
                          onChanged: (text) => store.setDescription(text),
                          controller: _descriptionController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          textAlignVertical: TextAlignVertical.top,
                          expands: true,
                          decoration: InputDecoration(
                            hintText: "Description",
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
