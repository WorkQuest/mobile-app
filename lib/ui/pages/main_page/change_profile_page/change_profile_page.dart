import 'dart:io';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/change_profile_page/store/change_profile_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/knowledge_work_selection/knowledge_work_selection.dart';
import 'package:app/ui/widgets/skill_specialization_selection/skill_specialization_selection.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';
import '../../../../enums.dart';

class ChangeProfilePage extends StatefulWidget {
  static const String routeName = "/ChangeProfilePage";

  @override
  _ChangeProfilePageState createState() => _ChangeProfilePageState();
}

class _ChangeProfilePageState extends State<ChangeProfilePage>
    with AutomaticKeepAliveClientMixin {
  ProfileMeStore? profile;
  late ChangeProfileStore pageStore;

  final _formKey = GlobalKey<FormState>();

  SkillSpecializationController? _controller;
  KnowledgeWorkSelectionController? _controllerKnowledge;
  KnowledgeWorkSelectionController? _controllerWork;

  @override
  void initState() {
    profile = context.read<ProfileMeStore>();
    pageStore = ChangeProfileStore(ProfileMeResponse.clone(profile!.userData!));
    profile!.workplaceToValue();
    pageStore.getInitCode(
        pageStore.userData.tempPhone ?? pageStore.userData.phone,
        pageStore.userData.additionalInfo?.secondMobileNumber);
    if (profile!.userData!.additionalInfo!.address != null)
      pageStore.address = profile!.userData!.additionalInfo!.address!;
    _controller = SkillSpecializationController(
        initialValue: pageStore.userData.userSpecializations);
    _controllerKnowledge = KnowledgeWorkSelectionController();
    _controllerWork = KnowledgeWorkSelectionController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
      child: Form(
        key: _formKey,
        child: ListView(
          addAutomaticKeepAlives: true,
          children: [
            changeImage(),
            inputBody(
              title: "labels.firstName".tr(),
              initialValue: pageStore.userData.firstName,
              onChanged: (text) => pageStore.userData.firstName = text,
              validator: Validators.firstNameValidator,
            ),
            inputBody(
              title: "labels.lastName".tr(),
              initialValue: pageStore.userData.lastName,
              onChanged: (text) => pageStore.userData.lastName = text,
              validator: Validators.lastNameValidator,
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
                              child: Text(
                                pageStore.address,
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
            phoneNumber(
              title: "modals.phoneNumber",
              initialValue: pageStore.phoneNumber,
              onChanged: (PhoneNumber phone) {
                pageStore.userData.phone.codeRegion = phone.dialCode ?? "";
                pageStore.userData.phone.phone =
                    phone.phoneNumber?.replaceAll((phone.dialCode ?? ""), "") ??
                        "";
                pageStore.userData.phone.fullPhone = phone.phoneNumber ?? "";
              },
            ),
            phoneNumber(
              title: "modals.secondPhoneNumber",
              initialValue: pageStore.secondPhoneNumber,
              onChanged: (PhoneNumber phone) {
                pageStore.userData.additionalInfo?.secondMobileNumber!
                    .codeRegion = phone.dialCode ?? "";
                pageStore.userData.additionalInfo?.secondMobileNumber!.phone =
                    phone.phoneNumber?.replaceAll((phone.dialCode ?? ""), "") ??
                        "";
                pageStore.userData.additionalInfo?.secondMobileNumber!
                    .fullPhone = phone.phoneNumber ?? "";
              },
            ),
            inputBody(
              title: "signUp.email".tr(),
              readOnly: true,
              initialValue: pageStore.userData.email ?? "",
              onChanged: (text) => pageStore.userData.email,
              validator: Validators.emailValidator,
            ),
            inputBody(
              title: "modals.title".tr(),
              initialValue:
                  pageStore.userData.additionalInfo!.description ?? "",
              onChanged: (text) =>
                  pageStore.userData.additionalInfo!.description = text,
              maxLines: null,
              validator: Validators.descriptionValidator,
            ),
            if (pageStore.userData.role == UserRole.Worker) fieldForWorker(),
            inputBody(
              title: "settings.twitterUsername".tr(),
              initialValue:
                  pageStore.userData.additionalInfo!.socialNetwork?.twitter ??
                      "",
              onChanged: (text) => pageStore
                  .userData.additionalInfo!.socialNetwork?.twitter = text,
              validator: Validators.nicknameTwitterValidator,
            ),
            inputBody(
              title: "settings.facebookUsername".tr(),
              initialValue:
                  pageStore.userData.additionalInfo!.socialNetwork?.facebook ??
                      "",
              onChanged: (text) => pageStore
                  .userData.additionalInfo!.socialNetwork?.facebook = text,
              validator: Validators.nicknameFacebookValidator,
            ),
            inputBody(
              title: "settings.linkedInUsername".tr(),
              initialValue:
                  pageStore.userData.additionalInfo!.socialNetwork?.linkedin ??
                      "",
              onChanged: (text) => pageStore
                  .userData.additionalInfo!.socialNetwork?.linkedin = text,
              validator: Validators.nicknameLinkedInValidator,
            ),
            inputBody(
              title: "settings.instagramUsername".tr(),
              initialValue:
                  pageStore.userData.additionalInfo!.socialNetwork?.instagram ??
                      "",
              onChanged: (text) => pageStore
                  .userData.additionalInfo!.socialNetwork?.instagram = text,
              validator: Validators.nicknameLinkedInValidator,
            ),
            const SizedBox(height: 20),
          ],
        ),
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
                      pageStore.media!.readAsBytesSync(),
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
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.image,
                );
                if (result != null) {
                  List<File> files =
                      result.paths.map((path) => File(path!)).toList();
                  pageStore.media = files.first;
                }
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
        Observer(
          builder: (_) => dropDownMenu(
            title: "settings.priority",
            value: profile!.priorityValue.name,
            list: QuestPriority.values.map((e) => e.name).toList(),
            onChanged: (priority) {
              profile!.setPriorityValue(priority!);
            },
          ),
        ),
        inputBody(
          title: "settings.costPerHour".tr(),
          initialValue: pageStore.userData.wagePerHour,
          onChanged: (text) => pageStore.userData.wagePerHour = text,
          validator: Validators.emptyValidator,
        ),
        Observer(
          builder: (_) => dropDownMenu(
            title: "settings.distantWork",
            value: profile!.distantWork,
            list: profile!.distantWorkList,
            onChanged: (text) {
              profile!.setWorkplaceValue(text!);
            },
          ),
        ),
        KnowledgeWorkSelection(
          title: "Knowledge",
          hintText: "settings.education.educationalInstitution".tr(),
          controller: _controllerKnowledge,
          data: pageStore.userData.additionalInfo?.educations,
        ),
        KnowledgeWorkSelection(
          title: "Work experience",
          hintText: "Work place",
          controller: _controllerWork,
          data: pageStore.userData.additionalInfo?.workExperiences,
        ),
      ],
    );
  }

  Widget phoneNumber({
    required String title,
    required PhoneNumber? initialValue,
    required void Function(PhoneNumber)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.tr()),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFF7F8FA)),
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Observer(
            builder: (_) => InternationalPhoneNumberInput(
              validator: title == "modals.secondPhoneNumber"
                  ? (value) {}
                  : Validators.phoneNumberValidator,
              initialValue: initialValue,
              errorMessage: "modals.invalidPhone".tr(),
              onInputChanged: onChanged,
              selectorConfig: SelectorConfig(
                setSelectorButtonAsPrefixIcon: true,
                selectorType: PhoneInputSelectorType.DROPDOWN,
              ),
              hintText: "modals.phoneNumber".tr(),
              keyboardType: TextInputType.number,
              inputBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(
                  color: Colors.blue,
                ),
              ),
              inputDecoration: InputDecoration(
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
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
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide: BorderSide(
                    width: 1.0,
                    color: Colors.red,
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

  Widget inputBody({
    required String title,
    required String initialValue,
    required void Function(String)? onChanged,
    required String? Function(String?) validator,
    bool readOnly = false,
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
          readOnly: readOnly,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(
                width: 1.0,
                color: Colors.red,
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
            title.tr(),
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
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              isExpanded: true,
              value: value,
              onChanged: onChanged,
              items: list.map<DropdownMenuItem<String>>((String value) {
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
                title,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  onBack() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  onSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (!pageStore.validationKnowledge(
          _controllerKnowledge!.getListMap(), context)) return;
      if (!pageStore.validationWork(_controllerWork!.getListMap(), context))
        return;
      if (pageStore.userData.additionalInfo?.secondMobileNumber?.phone == "")
        pageStore.userData.additionalInfo?.secondMobileNumber = null;
      pageStore.userData.additionalInfo?.educations =
          _controllerKnowledge!.getListMap();
      pageStore.userData.additionalInfo?.workExperiences =
          _controllerWork!.getListMap();
      pageStore.userData.additionalInfo!.address = pageStore.address;
      pageStore.userData.locationPlaceName = pageStore.address;
      pageStore.userData.priority = profile!.userData!.priority;
      pageStore.userData.workplace = profile!.valueToWorkplace();
      if (!profile!.isLoading)
        pageStore.userData.userSpecializations =
            _controller!.getSkillAndSpecialization();
      await profile!.changeProfile(
        pageStore.userData,
        media: pageStore.media,
      );
      if (pageStore.numberChanged(profile!.userData!.phone))
        await profile!.submitPhoneNumber();
      if (profile!.isSuccess) {
        await AlertDialogUtils.showSuccessDialog(context);
        Navigator.pop(context);
      }
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
