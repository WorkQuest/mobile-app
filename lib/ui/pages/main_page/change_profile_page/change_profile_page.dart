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
import '../../../../constants.dart';
import '../../../../enums.dart';

class ChangeProfilePage extends StatefulWidget {
  static const String routeName = "/ChangeProfilePage";

  @override
  _ChangeProfilePageState createState() => _ChangeProfilePageState();
}

class _ChangeProfilePageState extends State<ChangeProfilePage> {
  ProfileMeStore? profile;
  late ChangeProfileStore pageStore;

  final _formKey = GlobalKey<FormState>();

  SkillSpecializationController? _controller;
  KnowledgeWorkSelectionController? _controllerKnowledge;
  KnowledgeWorkSelectionController? _controllerWork;

  PhoneNumber phone = PhoneNumber();
  PhoneNumber secondPhone = PhoneNumber();


  @override
  void initState() {
    profile = context.read<ProfileMeStore>();
    pageStore = ChangeProfileStore(ProfileMeResponse.clone(profile!.userData!));
    profile!.workplaceToValue();

    print('tempPhone: ${pageStore.userData.tempPhone!.toJson()}');
    if (profile!.userData!.additionalInfo?.address != null)
      pageStore.address = profile!.userData!.additionalInfo!.address!;
    pageStore.getInitCode(pageStore.userData.phone ?? pageStore.userData.tempPhone!,
        pageStore.userData.additionalInfo?.secondMobileNumber).then((value) {
      phone = pageStore.phoneNumber ?? PhoneNumber();
      secondPhone = pageStore.secondPhoneNumber ?? PhoneNumber();
      setState(() {});
    });
    if (profile!.userData!.locationPlaceName != null)
      pageStore.address = profile!.userData!.locationPlaceName!;
    _controller = SkillSpecializationController(
        initialValue: pageStore.userData.userSpecializations);
    _controllerKnowledge = KnowledgeWorkSelectionController();
    _controllerWork = KnowledgeWorkSelectionController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: _onBackPressed,
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
            onPressed: _onSave,
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
          physics: ClampingScrollPhysics(),
          children: [
            Observer(
              builder: (_) => _ImageProfile(
                file: pageStore.media,
                hasMedia: pageStore.media == null,
                url: profile!.userData!.avatar?.url,
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
            ),
            _InputWidget(
              title: "labels.firstName".tr(),
              initialValue: pageStore.userData.firstName,
              onChanged: (text) {
                ProfileMeResponse data = pageStore.userData;
                data.firstName = text;
                pageStore.setUserData(data);
              },
              validator: Validators.firstNameValidator,
            ),
            _InputWidget(
              title: "labels.lastName".tr(),
              initialValue: pageStore.userData.lastName,
              onChanged: (text) {
                ProfileMeResponse data = pageStore.userData;
                data.lastName = text;
                pageStore.setUserData(data);
              },
              validator: Validators.lastNameValidator,
            ),
            Observer(
              builder: (_) => _AddressProfileWidget(
                address: pageStore.address,
                onTap: () {
                  pageStore.getPrediction(context);
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _PhoneNumberWidget(
              title: "modals.phoneNumber",
              initialValue: phone,
              onChanged: (PhoneNumber phone) {
                pageStore.setPhoneNumber(phone);
              },
            ),
            if (profile!.userData!.role == UserRole.Employer)
              _PhoneNumberWidget(
                title: "modals.secondPhoneNumber",
                initialValue: secondPhone,
                onChanged: (PhoneNumber phone) {
                  pageStore.setSecondPhoneNumber(phone);
                },
              ),
            _InputWidget(
              title: "signUp.email".tr(),
              readOnly: true,
              initialValue: pageStore.userData.email ?? "",
              onChanged: (text) {
                ProfileMeResponse data = pageStore.userData;
                data.email = text;
                pageStore.setUserData(data);
              },
              validator: Validators.emailValidator,
            ),
            _InputWidget(
              title: "modals.title".tr(),
              initialValue:
                  pageStore.userData.additionalInfo!.description ?? "",
              onChanged: (text) {
                ProfileMeResponse data = pageStore.userData;
                data.additionalInfo!.description = text;
                pageStore.setUserData(data);
              },
              maxLines: null,
              validator: Validators.descriptionValidator,
            ),
            if (pageStore.userData.role == UserRole.Worker)
              _fieldsForWorkerWidget(),
            _InputWidget(
              title: "settings.twitterUsername".tr(),
              initialValue:
                  pageStore.userData.additionalInfo!.socialNetwork?.twitter ?? "",
              onChanged: (text) {
                ProfileMeResponse data = pageStore.userData;
                data.additionalInfo!.socialNetwork?.twitter = text;
                pageStore.setUserData(data);
              },
              validator: Validators.nicknameTwitterValidator,
            ),
            _InputWidget(
              title: "settings.facebookUsername".tr(),
              initialValue:
                  pageStore.userData.additionalInfo!.socialNetwork?.facebook ?? "",
              onChanged: (text) {
                ProfileMeResponse data = pageStore.userData;
                data.additionalInfo!.socialNetwork?.facebook = text;
                pageStore.setUserData(data);
              },
              validator: Validators.nicknameFacebookValidator,
            ),
            _InputWidget(
              title: "settings.linkedInUsername".tr(),
              initialValue:
                  pageStore.userData.additionalInfo!.socialNetwork?.linkedin ?? "",
              onChanged: (text) {
                ProfileMeResponse data = pageStore.userData;
                data.additionalInfo!.socialNetwork?.linkedin = text;
                pageStore.setUserData(data);
              },
              validator: Validators.nicknameLinkedInValidator,
            ),
            _InputWidget(
              title: "settings.instagramUsername".tr(),
              initialValue:
                  pageStore.userData.additionalInfo!.socialNetwork?.instagram ?? "",
              onChanged: (text) {
                ProfileMeResponse data = pageStore.userData;
                data.additionalInfo!.socialNetwork?.instagram = text;
                pageStore.setUserData(data);
              },
              validator: Validators.nicknameLinkedInValidator,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _fieldsForWorkerWidget() {
    return Column(
      children: <Widget>[
        SkillSpecializationSelection(controller: _controller),
        Observer(
          builder: (_) => _dropDownMenuWidget(
            title: "settings.priority",
            value: profile!.priorityValue.name,
            list: QuestPriority.values.map((e) => e.name).toList(),
            onChanged: (priority) {
              profile!.setPriorityValue(priority!);
            },
          ),
        ),
        _InputWidget(
          title: "settings.costPerHour".tr(),
          initialValue: pageStore.userData.wagePerHour,
          onChanged: (text) => pageStore.userData.wagePerHour = text,
          validator: Validators.emptyValidator,
        ),
        Observer(
          builder: (_) => _dropDownMenuWidget(
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

  Widget _dropDownMenuWidget({
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

  _onBackPressed() {
    if (profile!.isLoading) return;
    if (!pageStore.areThereAnyChanges(profile!.userData))
      Navigator.pop(context);
    else
      _showDialog();
  }

  _onBack() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  _onSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (!pageStore.validationKnowledge(
          _controllerKnowledge!.getListMap(), context)) return;
      if (!pageStore.validationWork(_controllerWork!.getListMap(), context))
        return;

      if (pageStore.userData.additionalInfo?.secondMobileNumber?.phone == "")
        pageStore.userData.additionalInfo?.secondMobileNumber = null;
      pageStore.userData.additionalInfo?.educations = _controllerKnowledge!.getListMap();
      pageStore.userData.additionalInfo?.workExperiences = _controllerWork!.getListMap();
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
      if (profile!.userData!.tempPhone!.fullPhone.isNotEmpty &&
          pageStore.numberChanged(profile!.userData!.tempPhone!)) {
        await profile!
            .submitPhoneNumber(pageStore.userData.tempPhone!.fullPhone);
        profile!.userData?.phone = null;
      }
      Navigator.pop(context);
      if (profile!.isSuccess) {
        if (profile!.userData!.tempPhone!.fullPhone.isNotEmpty &&
            pageStore.numberChanged(profile!.userData!.tempPhone!))
          await AlertDialogUtils.showSuccessDialog(context);
        else
          await AlertDialogUtils.showSuccessDialog(context,
              text: 'Enter code from SMS in SMS Verification');
      }
    }
  }

  _showDialog() {
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
                    onPressed: _onBack,
                  ),
                  CupertinoDialogAction(
                    child: Text(
                      "settings.save".tr(),
                    ),
                    onPressed: _onSave,
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
                    onPressed: _onBack,
                  ),
                  TextButton(
                    child: Text(
                      "settings.save".tr(),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _onSave();
                    },
                  )
                ],
              );
      },
    );
  }
}

class _AddressProfileWidget extends StatelessWidget {
  final String address;
  final Function() onTap;

  const _AddressProfileWidget({
    Key? key,
    required this.address,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
        GestureDetector(
          onTap: onTap,
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
                      address,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PhoneNumberWidget extends StatefulWidget {
  final String title;
  final PhoneNumber? initialValue;
  final void Function(PhoneNumber)? onChanged;

  const _PhoneNumberWidget({
    Key? key,
    required this.title,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<_PhoneNumberWidget> createState() => _PhoneNumberWidgetState();
}

class _PhoneNumberWidgetState extends State<_PhoneNumberWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title.tr()),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFF7F8FA)),
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: InternationalPhoneNumberInput(
            validator: widget.title == "modals.secondPhoneNumber"
                ? (value) {
                    return null;
                  }
                : Validators.phoneNumberValidator,
            initialValue: widget.initialValue,
            errorMessage: "modals.invalidPhone".tr(),
            onInputChanged: widget.onChanged,
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
        const SizedBox(height: 20),
      ],
    );
  }
}

class _InputWidget extends StatelessWidget {
  final String title;
  final String initialValue;
  final void Function(String)? onChanged;
  final String? Function(String?) validator;
  final bool readOnly;
  final int? maxLines;

  const _InputWidget({
    Key? key,
    required this.title,
    required this.initialValue,
    required this.onChanged,
    required this.validator,
    this.readOnly = false,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}

class _ImageProfile extends StatelessWidget {
  final Function() onPressed;
  final bool hasMedia;
  final String? url;
  final File? file;

  const _ImageProfile({
    Key? key,
    required this.onPressed,
    required this.hasMedia,
    required this.file,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(65),
            child: hasMedia
                ? Image.network(
                    url ?? Constants.defaultImageNetwork,
                    height: 130,
                    width: 130,
                    fit: BoxFit.cover,
                  )
                : Image.memory(
                    file!.readAsBytesSync(),
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
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
