import 'dart:io';

import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/change_profile_page/store/change_profile_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
// import 'package:app/ui/widgets/skill_specialization_selection/skill_specialization_selection.dart';
import 'package:drishya_picker/drishya_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

class ChangeProfilePage extends StatefulWidget {
  static const String routeName = "/ChangeProfilePage";
  @override
  _ChangeProfilePageState createState() => _ChangeProfilePageState();
}

class _ChangeProfilePageState extends State<ChangeProfilePage> {
  ProfileMeStore? profile;
  late ChangeProfileStore pageStore;
  // SkillSpecializationController? _controller;
  late final GalleryController gallController;

  @override
  void initState() {
    // _controller = SkillSpecializationController();
    profile = context.read<ProfileMeStore>();
    pageStore = ChangeProfileStore(ProfileMeResponse.clone(profile!.userData!));
    gallController = GalleryController(
      gallerySetting: const GallerySetting(
        maximum: 1,
        albumSubtitle: 'All',
        requestType: RequestType.image,
      ),
      panelSetting: PanelSetting(
          //topMargin: 100.0,
          headerMaxHeight: 100.0),
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
        title: const Text(
          "Change profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(onPressed: onSave, child: Text("settings.save".tr())),
        ],
      ),
      body: ObserverListener<ProfileMeStore>(
        onSuccess: () => Navigator.pop(context),
        child: Observer(
          builder: (_) => profile!.isLoading
              ? Center(child: CircularProgressIndicator())
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
          inputBody(
            title: "modals.address".tr(),
            initialValue: pageStore.userData.additionalInfo!.address ?? "",
            onChanged: (text) =>
                pageStore.userData.additionalInfo!.address = text,
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
          // SkillSpecializationSelection(
          //   controller: _controller,
          // ),
          // const SizedBox(height: 20),
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
                      pageStore.media!.bytes,
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

  onSave() {
    if (!profile!.isLoading)
      profile!.changeProfile(pageStore.userData, media: pageStore.media);
  }

  showDialog() {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text('Attention'),
                content: Text("There are unsaved changes"),
                actions: [
                  CupertinoDialogAction(
                    child: Text("meta.ok".tr()),
                    onPressed: Navigator.of(context).pop,
                  ),
                  CupertinoDialogAction(
                    child: Text("Do not Save"),
                    onPressed: onBack,
                  ),
                  CupertinoDialogAction(
                    child: Text("settings.save".tr()),
                    onPressed: onSave,
                  )
                ],
              )
            : AlertDialog(
                title: Text('Error'),
                content: Text("There are unsaved changes"),
                actions: [
                  TextButton(
                    child: Text("meta.ok".tr()),
                    onPressed: Navigator.of(context).pop,
                  ),
                  TextButton(
                    child: Text("Do not Save"),
                    onPressed: onBack,
                  ),
                  TextButton(
                    child: Text("settings.save".tr()),
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
}
