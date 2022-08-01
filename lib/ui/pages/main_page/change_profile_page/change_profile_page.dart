import 'dart:io';
import 'dart:typed_data';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/change_profile_page/store/change_profile_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/dismiss_keyboard.dart';
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
import '../settings_page/pages/SMS_verification_page/sms_verification_page.dart';

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

  Phone? oldPhone;

  @override
  void initState() {
    profile = context.read<ProfileMeStore>();
    pageStore = ChangeProfileStore(ProfileMeResponse.clone(profile!.userData!));
    profile!.workplaceToValue();
    profile!.priorityToValue();
    profile!.payPeriodToValue();

    oldPhone = Phone(
      codeRegion: profile!.userData?.phone?.codeRegion ??
          (profile!.userData?.tempPhone?.codeRegion ?? ''),
      fullPhone: profile!.userData?.phone?.fullPhone ??
          (profile!.userData?.tempPhone?.fullPhone ?? ''),
      phone:
          profile!.userData?.phone?.phone ?? (profile!.userData?.tempPhone?.phone ?? ''),
    );
    if (profile!.userData!.additionalInfo?.address != null)
      pageStore.address = profile!.userData!.additionalInfo!.address!;
    pageStore
        .getInitCode(pageStore.userData.phone ?? pageStore.userData.tempPhone!,
            pageStore.userData.additionalInfo?.secondMobileNumber)
        .then((value) {
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
        onSuccess: () async {
          if (oldPhone != null &&
              oldPhone!.fullPhone.isNotEmpty &&
              !pageStore.numberChanged(oldPhone!.fullPhone)) {
            await AlertDialogUtils.showSuccessDialog(context);
            Navigator.pop(context, true);
          } else {
            await AlertDialogUtils.showSuccessDialog(context,
                text: 'settings.enterSMS'.tr());
            await Navigator.of(context, rootNavigator: true).pushReplacementNamed(
              SMSVerificationPage.routeName,
            );
          }
        },
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
        child: DismissKeyboard(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _ImageProfile(
                  file: pageStore.media,
                  hasMedia: pageStore.media == null,
                  url: profile!.userData!.avatar?.url,
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                    );
                    if (result != null) {
                      List<File> files = result.paths.map((path) => File(path!)).toList();
                      pageStore.media = files.first;
                    }
                  },
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
                  maxLength: 15,
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
                  maxLength: 15,
                ),
                Observer(
                  builder: (_) => _AddressProfileWidget(
                    address: pageStore.address.isEmpty
                        ? profile!.userData!.additionalInfo?.address ?? pageStore.address
                        : pageStore.address,
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
                  needValidator: phone.phoneNumber?.isEmpty ?? true,
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
                  maxLength: null,
                ),
                if (pageStore.userData.role == UserRole.Employer)
                  _FieldForEmployerWorker(
                    pageStore: pageStore,
                    profile: profile!,
                  ),
                _InputWidget(
                  title: "modals.title".tr(),
                  initialValue: pageStore.userData.additionalInfo!.description ?? "",
                  onChanged: (text) {
                    ProfileMeResponse data = pageStore.userData;
                    data.additionalInfo!.description = text;
                    pageStore.setUserData(data);
                  },
                  maxLines: null,
                  validator: Validators.descriptionValidator,
                  maxLength: null,
                ),
                if (pageStore.userData.role == UserRole.Worker)
                  _FieldsForWorkerWidget(
                    controllerKnowledge: _controllerKnowledge!,
                    controllerWork: _controllerWork!,
                    controller: _controller!,
                    pageStore: pageStore,
                    profile: profile!,
                  ),
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
                  maxLength: 30,
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
                  maxLength: 50,
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
                  maxLength: 30,
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
                  maxLength: 30,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
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
    if ((pageStore.userData.tempPhone?.fullPhone ?? "").contains("-") ||
        (pageStore.userData.tempPhone?.fullPhone ?? "").contains(" ")) {
      AlertDialogUtils.showInfoAlertDialog(
        context,
        title: "modals.warning".tr(),
        content: "errors.numberContainDashesOrSpaces".tr(),
      );
      return;
    }
    if (_formKey.currentState?.validate() ?? false) {
      if (!pageStore.validationKnowledge(_controllerKnowledge!.getListMap(), context))
        return;
      if (!pageStore.validationWork(_controllerWork!.getListMap(), context)) return;
      if (!pageStore.validationWork(_controllerWork!.getListMap(), context)) return;

      if (pageStore.userData.additionalInfo?.secondMobileNumber?.phone == "")
        pageStore.userData.additionalInfo?.secondMobileNumber = null;
      pageStore.userData.additionalInfo?.educations = _controllerKnowledge!.getListMap();
      pageStore.userData.additionalInfo?.workExperiences = _controllerWork!.getListMap();
      if (pageStore.address.isNotEmpty) {
        pageStore.userData.additionalInfo!.address = pageStore.address;
        pageStore.userData.locationPlaceName = pageStore.address;
      }
      pageStore.userData.priority = profile!.valueToPriority();
      pageStore.userData.payPeriod = profile!.valueToPayPeriod();
      pageStore.userData.workplace = profile!.valueToWorkplace();

      pageStore.savePhoneNumber();
      pageStore.saveSecondPhoneNumber();

      if (!profile!.isLoading)
        pageStore.userData.userSpecializations = _controller!.getSkillAndSpecialization();
      await profile!.changeProfile(
        pageStore.userData,
        media: pageStore.media,
      );
      _changePhone();
    }
  }

  _changePhone() async {
    Phone? userPhone = profile!.userData!.phone ?? profile!.userData!.tempPhone;
    if (userPhone != null &&
        userPhone.fullPhone.isNotEmpty &&
        pageStore.numberChanged(userPhone.fullPhone)) {
      await profile!.submitPhoneNumber();
      profile!.userData?.phone = null;
      userPhone = profile!.userData!.tempPhone;
    }
    if (profile!.isSuccess) {
      if (userPhone != null &&
          userPhone.fullPhone.isNotEmpty &&
          !pageStore.numberChanged(userPhone.fullPhone)) {
        await AlertDialogUtils.showSuccessDialog(context);
      } else {
        await AlertDialogUtils.showSuccessDialog(context, text: 'settings.enterSMS'.tr());
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

class _FieldForEmployerWorker extends StatefulWidget {
  final ChangeProfileStore pageStore;
  final ProfileMeStore profile;

  const _FieldForEmployerWorker({
    required this.pageStore,
    required this.profile,
  });

  @override
  State<_FieldForEmployerWorker> createState() => _FieldForEmployerWorkerState();
}

class _FieldForEmployerWorkerState extends State<_FieldForEmployerWorker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InputWidget(
          title: "settings.workExps.CompanyName".tr(),
          initialValue: widget.pageStore.userData.additionalInfo?.company ?? "",
          onChanged: (text) {
            ProfileMeResponse data = widget.pageStore.userData;
            data.additionalInfo?.company = text;
            widget.pageStore.setUserData(data);
          },
          maxLength: null,
        ),
        _InputWidget(
          title: "settings.position".tr(),
          initialValue: widget.pageStore.userData.additionalInfo?.ceo ?? "",
          onChanged: (text) {
            ProfileMeResponse data = widget.pageStore.userData;
            data.additionalInfo?.ceo = text;
            widget.pageStore.setUserData(data);
          },
          maxLength: null,
        ),
        _InputWidget(
          title: "settings.site".tr(),
          initialValue: widget.pageStore.userData.additionalInfo?.website ?? "",
          onChanged: (text) {
            ProfileMeResponse data = widget.pageStore.userData;
            data.additionalInfo?.website = text;
            widget.pageStore.setUserData(data);
          },
          maxLength: null,
        ),
      ],
    );
  }
}

class _FieldsForWorkerWidget extends StatefulWidget {
  final KnowledgeWorkSelectionController controllerKnowledge;
  final KnowledgeWorkSelectionController controllerWork;
  final SkillSpecializationController controller;
  final ChangeProfileStore pageStore;
  final ProfileMeStore profile;

  const _FieldsForWorkerWidget({
    Key? key,
    required this.controllerKnowledge,
    required this.controllerWork,
    required this.controller,
    required this.pageStore,
    required this.profile,
  }) : super(key: key);

  @override
  _FieldsForWorkerWidgetState createState() => _FieldsForWorkerWidgetState();
}

class _FieldsForWorkerWidgetState extends State<_FieldsForWorkerWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SkillSpecializationSelection(controller: widget.controller),
        Observer(
          builder: (_) => _dropDownMenuWidget(
            title: "settings.priority",
            value: widget.profile.priorityValue,
            list: widget.profile.priorityList,
            onChanged: (priority) {
              widget.profile.setPriorityValue(priority!);
            },
          ),
        ),
        _InputWidget(
          title: "settings.costPerHour".tr(),
          initialValue: widget.pageStore.userData.costPerHour,
          onChanged: (text) => widget.pageStore.userData.costPerHour = text,
          validator: Validators.emptyValidator,
          inputType: TextInputType.number,
          maxLength: null,
        ),
        Observer(
          builder: (_) => _dropDownMenuWidget(
            title: "settings.distantWork",
            value: widget.profile.distantWork,
            list: widget.profile.distantWorkList,
            onChanged: (text) {
              widget.profile.setWorkplaceValue(text!);
            },
          ),
        ),
        Observer(
          builder: (_) => _dropDownMenuWidget(
            title: "quests.payPeriod.title",
            value: widget.profile.payPeriod,
            list: widget.profile.payPeriodLists,
            onChanged: (text) {
              widget.profile.setPayPeriod(text!);
            },
          ),
        ),
        KnowledgeWorkSelection(
          title: "Knowledge",
          hintText: "settings.education.educationalInstitution".tr(),
          controller: widget.controllerKnowledge,
          data: widget.pageStore.userData.additionalInfo?.educations,
        ),
        KnowledgeWorkSelection(
          title: "Work experience",
          hintText: "Work place",
          controller: widget.controllerWork,
          data: widget.pageStore.userData.additionalInfo?.workExperiences,
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
                  child: Text(value.tr()),
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
  final bool needValidator;
  final void Function(PhoneNumber)? onChanged;

  const _PhoneNumberWidget({
    Key? key,
    required this.title,
    required this.initialValue,
    required this.onChanged,
    this.needValidator = false,
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
            initialValue: widget.initialValue,
            validator: widget.needValidator ? null : (value) => null,
            errorMessage: "modals.invalidPhone".tr(),
            autoValidateMode: AutovalidateMode.onUserInteraction,
            onInputChanged: widget.onChanged,
            selectorConfig: SelectorConfig(
              leadingPadding: 16,
              setSelectorButtonAsPrefixIcon: true,
              selectorType: PhoneInputSelectorType.DIALOG,
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
                  color: Colors.green,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(
                  color: Colors.red,
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
  final String? Function(String?)? validator;
  final TextInputType inputType;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;

  const _InputWidget({
    Key? key,
    required this.title,
    required this.initialValue,
    required this.onChanged,
    required this.maxLength,
    this.validator,
    this.inputType = TextInputType.text,
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
          maxLength: maxLength,
          initialValue: initialValue,
          maxLines: maxLines,
          readOnly: readOnly,
          onChanged: onChanged,
          validator: validator,
          keyboardType: inputType,
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

class _ImageProfile extends StatefulWidget {
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
  State<_ImageProfile> createState() => _ImageProfileState();
}

class _ImageProfileState extends State<_ImageProfile> {
  late Future<Uint8List> future;
  File? file;

  @override
  void initState() {
    super.initState();
    if (!widget.hasMedia) {
      file = widget.file!;
      future = file!.readAsBytes();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.hasMedia) {
      if (file == null || file != widget.file) {
        future = widget.file!.readAsBytes();
        file = widget.file!;
      }
    }
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(65),
            child: widget.hasMedia
                ? Image.network(
                    widget.url ?? Constants.defaultImageNetwork,
                    height: 130,
                    width: 130,
                    fit: BoxFit.cover,
                  )
                : FutureBuilder<Uint8List>(
                    future: future,
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Image.memory(
                          snapshot.data!,
                          height: 130,
                          width: 130,
                          fit: BoxFit.cover,
                        );
                      }
                      return SizedBox(
                        height: 130,
                        width: 130,
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      );
                    },
                  ),
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: widget.onPressed,
          ),
        ],
      ),
    );
  }
}
