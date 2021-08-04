import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/create_quest_page/camera_page.dart';
import 'package:app/ui/pages/main_page/create_quest_page/store/create_quest_store.dart';
import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../observer_consumer.dart';

class CreateQuestPage extends StatefulWidget {
  static const String routeName = '/createQuestPage';
  final BaseQuestResponse? questInfo;
  CreateQuestPage({this.questInfo});

  @override
  _CreateQuestPageState createState() => _CreateQuestPageState();
}

class _CreateQuestPageState extends State<CreateQuestPage> {
  late CameraController controller;
  late List<CameraDescription> cameras;
  late int selectedCameraIdx;
  late String imagePath;

  void initState() {
    super.initState();
    if (widget.questInfo != null) {
      final store = context.read<CreateQuestStore>();
      store.priority = store.priorityList[widget.questInfo!.priority];
      store.category = widget.questInfo!.category;
      store.questTitle = widget.questInfo!.title;
      store.description = widget.questInfo!.description;
      store.price = widget.questInfo!.price;
      // store.medi a = widget.questInfo!.medias;
    }
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      controller = CameraController(cameras.first, ResolutionPreset.max);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }).catchError((err) {
      // 3
      print('Error: ${err.code}\nError Message: ${err.message}');
      print("cam$cameras");
      print("can$controller");
    });
  }

  Widget build(context) {
    final store = context.read<CreateQuestStore>();
    print("cam$cameras");
    print("can$controller");

    return Scaffold(
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
                                .map<DropdownMenuItem<String>>((String value) {
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
                      child: TextField(
                        maxLines: 1,
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
                                                  mode: CupertinoDatePickerMode
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
                        initialValue: store.questTitle,
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
                  ),
                  titledField(
                    "About Quest",
                    Container(
                      height: 245,
                      decoration: BoxDecoration(
                        color: Color(0xFFF7F8FA),
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      ),
                      child: TextFormField(
                        initialValue: store.description,
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
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Center(
                            child: Observer(
                          builder: (context) => store.media.isEmpty
                              ? bottomSheet(store, context)
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(child: mediaView(store, context)),
                                    IconButton(
                                      onPressed: () =>
                                          addFile(store),
                                      icon: Icon(
                                        Icons.add_circle,
                                      ),
                                    ),
                                  ],
                                ),
                        )),
                      ),
                    ),
                  ),
                  titledField(
                    "Price",
                    Container(
                      height: 50,
                      child: TextFormField(
                        initialValue: store.price,
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
                  ),
                  Container(
                    height: 50.0,
                    margin: const EdgeInsets.symmetric(vertical: 30),
                    child: ObserverListener <CreateQuestStore>(
                    onSuccess: () {
                      Navigator.pop(context);
                    },
                      child: ElevatedButton(
                        onPressed: () {
                          store.createQuest();
                          print(store.price);
                        },
                        child: Text(
                          '${widget.questInfo == null ? "Create" : "Edit"} a quest',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blueAccent,
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

  // child: ObserverListener<SignInStore>(
  // onSuccess: () {
  // Navigator.pushNamedAndRemoveUntil(
  // context,
  // MainPage.routeName,
  // (_) => false,
  // );
  // },
  // child: Observer(
  // builder: (context) {
  // return ElevatedButton(
  // onPressed: signInStore.canSignIn
  // ? () async {
  // if (_formKey.currentState!.validate()) {
  // await signInStore.signInWithUsername();
  // }
  // }
  //     : null,
  // child: signInStore.isLoading
  // ? PlatformActivityIndicator()
  //     : Text(
  // context.translate(AuthLangKeys.login),
  // ),
  // );
  // },
  // ),
  // ),

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

  ///Displays Chosen Media Files
  Widget mediaView(
    CreateQuestStore store,
    BuildContext context,
  ) {
    return Observer(
      builder: (context) => ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        itemCount: store.media.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(
          width: 10.0,
        ),
        itemBuilder: (context, index) {
          return Container(
            width: 150,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(
                  store.media[index],
                ),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(
                15,
              ),
            ),
            child: IconButton(
              onPressed: () {
                store.removeImage(index);
              },
              icon: Icon(
                Icons.cancel_outlined,
                color: Colors.redAccent,
              ),
            ),
          );
        },
      ),
    );
  }


  Widget bottomSheet(
    CreateQuestStore store,
    BuildContext context,
  ) =>
      Observer(
        builder: (context) => InkWell(
          onTap: () =>addFile(store),
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
      );


  ///Add media Function
  addFile(CreateQuestStore store) => modalBottomSheet(
    Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(
              controller,
              child: IconButton(
                icon: Icon(
                  Icons.camera,
                  size: 30.0,
                ),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TakePictureScreen(
                        cameras: cameras,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: Observer(
            builder: (context) => IconButton(
                icon: Icon(
                  Icons.folder,
                  size: 30.0,
                ),
                onPressed: () {
                  store.choosePictures();
                  Navigator.pop(context);
                }),
          ),
        ),
      ],
    ),
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
