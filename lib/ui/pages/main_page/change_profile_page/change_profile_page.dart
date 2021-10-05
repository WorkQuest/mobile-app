import 'dart:io';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/change_profile_page/store/change_profile_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/knowledge_work_selection/knowledge_work_selection.dart';
import 'package:app/ui/widgets/skill_specialization_selection/skill_specialization_selection.dart';
import 'package:app/ui/widgets/success_alert_dialog.dart';
import 'package:drishya_picker/drishya_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';
import '../../../../enums.dart';

class ChangeProfilePage extends StatefulWidget {
  static const String routeName = "/ChangeProfilePage";

  @override
  _ChangeProfilePageState createState() => _ChangeProfilePageState();
}

class _ChangeProfilePageState extends State<ChangeProfilePage> {
  ProfileMeStore? profile;
  late ChangeProfileStore pageStore;

  SkillSpecializationController? _controller;
  KnowledgeWorkSelectionController? _controllerKnowledge;

  KnowledgeWorkSelectionController? _controllerWork;

  late final GalleryController gallController;

  @override
  void initState() {
    _controller = SkillSpecializationController();
    _controllerKnowledge = KnowledgeWorkSelectionController();
    _controllerWork = KnowledgeWorkSelectionController();

    profile = context.read<ProfileMeStore>();
    pageStore = ChangeProfileStore(
      ProfileMeResponse.clone(profile!.userData!),
    );
    gallController = GalleryController(
      gallerySetting: const GallerySetting(
        maximum: 1,
        albumSubtitle: 'All',
        requestType: RequestType.image,
      ),
      panelSetting: PanelSetting(
        //topMargin: 100.0,
        headerMaxHeight: 100.0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (profile!.isLoading) return;
            if (!pageStore.areThereAnyChanges(profile!.userData))
              Navigator.pop(context);
            else
              showDialog();
          },
        ),
        title: Text(
          "settings.changeProfile".tr(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: onSave,
            child: Text(
              "settings.save".tr(),
            ),
          ),
        ],
      ),
      body: ObserverListener<ProfileMeStore>(
        onSuccess: () => Navigator.pop(context),
        child: Observer(
          builder: (_) => profile!.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : getBody(),
        ),
      ),
    );
  }

  Widget getBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        children: [
          changeImage(),
          inputBody(
            title: "labels.firstName".tr(),
            initialValue: pageStore.userData.firstName,
            onChanged: (text) => pageStore.userData.firstName = text,
          ),
          inputBody(
            title: "labels.lastName".tr(),
            initialValue: pageStore.userData.lastName ?? "",
            onChanged: (text) => pageStore.userData.lastName = text,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "quests.address".tr(),
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Observer(
                builder: (_) => GestureDetector(
                  onTap: () {
                    pageStore.getPrediction(context);
                  },
                  child: Container(
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFFF7F8FA),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(6.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Flexible(
                            child: pageStore.address.isNotEmpty
                                ? Text(
                                    pageStore.address,
                                    overflow: TextOverflow.fade,
                                  )
                                : Text(
                                    pageStore
                                            .userData.additionalInfo!.address ??
                                        "",
                                    overflow: TextOverflow.fade,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          inputBody(
            title: "modals.phoneNumber".tr(),
            initialValue:
                pageStore.userData.additionalInfo?.secondMobileNumber ?? "",
            onChanged: (text) =>
                pageStore.userData.additionalInfo?.secondMobileNumber = text,
          ),
          inputBody(
            title: "signUp.email".tr(),
            initialValue: pageStore.userData.email ?? "",
            onChanged: (text) => pageStore.userData.email,
          ),
          inputBody(
              title: "modals.title".tr(),
              initialValue:
                  pageStore.userData.additionalInfo!.description ?? "",
              onChanged: (text) =>
                  pageStore.userData.additionalInfo!.description = text,
              maxLines: null),
          if (pageStore.userData.role == UserRole.Worker) fieldForWorker(),
          inputBody(
            title: "settings.twitterUsername".tr(),
            initialValue:
                pageStore.userData.additionalInfo!.socialNetwork?.twitter ?? "",
            onChanged: (text) => pageStore
                .userData.additionalInfo!.socialNetwork?.twitter = text,
          ),
          inputBody(
            title: "settings.facebookUsername".tr(),
            initialValue:
                pageStore.userData.additionalInfo!.socialNetwork?.facebook ??
                    "",
            onChanged: (text) => pageStore
                .userData.additionalInfo!.socialNetwork?.facebook = text,
          ),
          inputBody(
            title: "settings.linkedInUsername".tr(),
            initialValue:
                pageStore.userData.additionalInfo!.socialNetwork?.linkedin ??
                    "",
            onChanged: (text) => pageStore
                .userData.additionalInfo!.socialNetwork?.linkedin = text,
          ),
          inputBody(
            title: "settings.instagramUsername".tr(),
            initialValue:
                pageStore.userData.additionalInfo!.socialNetwork?.instagram ??
                    "",
            onChanged: (text) => pageStore
                .userData.additionalInfo!.socialNetwork?.instagram = text,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget changeImage() {
    return Center(
      child: Observer(
        builder: (_) => Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(65),
              child: pageStore.media == null
                  ? Image.network(
                      profile!.userData!.avatar!.url,
                      height: 130,
                      width: 130,
                      fit: BoxFit.cover,
                    )
                  : Image.memory(
                      pageStore.media!.thumbBytes,
                      height: 130,
                      width: 130,
                      fit: BoxFit.cover,
                    ),
            ),
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                showGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget fieldForWorker() {
    return Column(
      children: <Widget>[
        SkillSpecializationSelection(controller: _controller),
        dropDownMenu(
          title: "settings.priority".tr(),
          value: profile!.priority,
          list: profile!.priorityList,
          onChanged: (text) => profile!.changePriority(text!),
        ),
        inputBody(
          title: "settings.costPerHour".tr(),
          initialValue: "",
          onChanged: (text) => text,
        ),
        dropDownMenu(
          title: "settings.distantWork".tr(),
          value: profile!.distantWork,
          list: profile!.distantWorkList,
          onChanged: (text) => profile!.changeDistantWork(text!),
        ),
        KnowledgeWorkSelection(
          title: "Knowledge",
          hintText: "settings.education.educationalInstitution".tr(),
          controller: _controllerKnowledge,
          // onChanged: pageStore.addKnowledge,
        ),
        KnowledgeWorkSelection(
          title: "Work experience",
          hintText: "Work place",
          controller: _controllerWork,
          // onChanged: pageStore.addWorkExperience,
        ),
      ],
    );
  }

  Widget inputBody({
    required String title,
    required String initialValue,
    required void Function(String)? onChanged,
    int? maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 5),
        TextFormField(
          initialValue: initialValue,
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(
                color: Color(0xFFf7f8fa),
                width: 2.0,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget dropDownMenu({
    required String title,
    required String value,
    required List<String> list,
    required void Function(String?)? onChanged,
  }) {
    return Column(
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
        Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          decoration: BoxDecoration(
            color: Color(0xFFF7F8FA),
            borderRadius: BorderRadius.all(
              Radius.circular(6.0),
            ),
          ),
          alignment: Alignment.centerLeft,
          child: Observer(
            builder: (_) => DropdownButtonHideUnderline(
              child: DropdownButton(
                isExpanded: true,
                value: value,
                onChanged: onChanged,
                items: list.map<DropdownMenuItem<String>>((String value) {
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
                  title.tr(),
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Future showGallery() async {
    final picked = await gallController.pick(
      context,
    );
    if (picked.isNotEmpty) pageStore.media = picked.first;
  }

  onBack() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  onSave() async {
    pageStore.userData.additionalInfo?.educations.clear();
    (_controllerKnowledge?.getAllKnowledge() ?? []).forEach((element) {
      Map<String, String> item = {};
      item["from"] = element.dateFrom;
      item["to"] = element.dateTo;
      item["place"] = element.place;
      pageStore.userData.additionalInfo?.educations.add(item);
    });
    pageStore.userData.additionalInfo?.workExperiences.clear();
    (_controllerKnowledge?.getAllKnowledge() ?? []).forEach((element) {
      Map<String, String> item = {};
      item["from"] = element.dateFrom;
      item["to"] = element.dateTo;
      item["place"] = element.place;
      pageStore.userData.additionalInfo?.workExperiences.add(item);
    });
    pageStore.userData.additionalInfo!.address = pageStore.address;
    if (!profile!.isLoading)
      pageStore.userData.skillFilters =
          _controller!.getSkillAndSpecialization();
    profile!.changeProfile(
      pageStore.userData,
      media: pageStore.media,
    );
    if (profile!.isSuccess) {
      await successAlert(
        context,
        "settings.profileChanged".tr(),
      );
      Navigator.pop(context);
    }
  }

  showDialog() {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(
                  "modals.attention".tr(),
                ),
                content: Text(
                  "modals.unsavedChanges".tr(),
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text(
                      "meta.ok".tr(),
                    ),
                    onPressed: Navigator.of(context).pop,
                  ),
                  CupertinoDialogAction(
                    child: Text(
                      "modals.dontSave".tr(),
                    ),
                    onPressed: onBack,
                  ),
                  CupertinoDialogAction(
                    child: Text(
                      "settings.save".tr(),
                    ),
                    onPressed: onSave,
                  )
                ],
              )
            : AlertDialog(
                title: Text(
                  "modals.error".tr(),
                ),
                content: Text(
                  "modals.dontSave".tr(),
                ),
                actions: [
                  TextButton(
                    child: Text(
                      "meta.ok".tr(),
                    ),
                    onPressed: Navigator.of(context).pop,
                  ),
                  TextButton(
                    child: Text(
                      "modals.dontSave".tr(),
                    ),
                    onPressed: onBack,
                  ),
                  TextButton(
                    child: Text(
                      "settings.save".tr(),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onSave();
                    },
                  )
                ],
              );
      },
    );
  }

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
