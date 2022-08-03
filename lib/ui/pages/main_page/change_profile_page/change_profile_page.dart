import 'dart:io';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/change_profile_page/store/change_profile_store.dart';
import 'package:app/ui/pages/main_page/change_profile_page/widgets/address_profile_widget.dart';
import 'package:app/ui/pages/main_page/change_profile_page/widgets/fields_for_employer_worker.dart';
import 'package:app/ui/pages/main_page/change_profile_page/widgets/fields_for_worker_widget.dart';
import 'package:app/ui/pages/main_page/change_profile_page/widgets/image_profile.dart';
import 'package:app/ui/pages/main_page/change_profile_page/widgets/input_widget.dart';
import 'package:app/ui/pages/main_page/change_profile_page/widgets/phone_number_widget.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/dismiss_keyboard.dart';
import 'package:app/ui/widgets/knowledge_work_selection/knowledge_work_selection.dart';
import 'package:app/ui/widgets/skill_specialization_selection/skill_specialization_selection.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';
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

  // PhoneNumber phone = PhoneNumber();
  // PhoneNumber secondPhone = PhoneNumber();

  Phone? oldPhone;

  @override
  void initState() {
    profile = context.read<ProfileMeStore>();
    pageStore = ChangeProfileStore(ProfileMeResponse.clone(profile!.userData!));
    profile!.workplaceToValue();
    profile!.priorityToValue();
    profile!.payPeriodToValue();

    oldPhone = Phone(
      codeRegion: profile!.userData?.phone?.codeRegion ?? "",
      fullPhone: profile!.userData?.phone?.fullPhone ?? "",
      phone: profile!.userData?.phone?.phone ?? "",
    );
    if (profile!.userData!.additionalInfo?.address != null)
      pageStore.address = profile!.userData!.additionalInfo!.address!;
    pageStore
        .getInitCode(pageStore.userData.phone ?? pageStore.userData.tempPhone!,
            pageStore.userData.additionalInfo?.secondMobileNumber)
        .then((value) {
      // phone = pageStore.phoneNumber ?? PhoneNumber();
      // secondPhone = pageStore.secondPhoneNumber ?? PhoneNumber();
      // setState(() {});
      print("inited");
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
            child: Text("settings.save".tr()),
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
            await profile!.submitPhoneNumber();
            profile!.userData?.phone = null;
            await AlertDialogUtils.showSuccessDialog(context,
                text: 'settings.enterSMS'.tr());
            await Navigator.of(context, rootNavigator: true)
                .pushReplacementNamed(
              SMSVerificationPage.routeName,
            );
          }
        },
        child: Observer(
          builder: (_) => profile!.isLoading
              ? Center(child: CircularProgressIndicator.adaptive())
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
                ImageProfile(
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
                InputWidget(
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
                InputWidget(
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
                  builder: (_) => AddressProfileWidget(
                    address: pageStore.address.isEmpty
                        ? profile!.userData!.additionalInfo?.address ??
                            pageStore.address
                        : pageStore.address,
                    onTap: () {
                      pageStore.getPrediction(context);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Observer(
                  builder: (_) => PhoneNumberWidget(
                    title: "modals.phoneNumber",
                    initialValue: pageStore.phoneNumber,
                    onChanged: (PhoneNumber phone) {
                      pageStore.setPhoneNumber(phone);
                    },
                    needValidator:
                        pageStore.phoneNumber?.phoneNumber?.isEmpty ?? true,
                  ),
                ),
                if (profile!.userData!.role == UserRole.Employer)
                  Observer(
                    builder: (_) => PhoneNumberWidget(
                      title: "modals.secondPhoneNumber",
                      initialValue: pageStore.secondPhoneNumber,
                      onChanged: (PhoneNumber phone) {
                        pageStore.setSecondPhoneNumber(phone);
                      },
                    ),
                  ),
                InputWidget(
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
                  FieldForEmployerWorker(
                    pageStore: pageStore,
                    profile: profile!,
                  ),
                InputWidget(
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
                  maxLength: null,
                ),
                if (pageStore.userData.role == UserRole.Worker)
                  FieldsForWorkerWidget(
                    controllerKnowledge: _controllerKnowledge!,
                    controllerWork: _controllerWork!,
                    controller: _controller!,
                    pageStore: pageStore,
                    profile: profile!,
                  ),
                InputWidget(
                  title: "settings.twitterUsername".tr(),
                  initialValue: pageStore
                          .userData.additionalInfo!.socialNetwork?.twitter ??
                      "",
                  onChanged: (text) {
                    ProfileMeResponse data = pageStore.userData;
                    data.additionalInfo!.socialNetwork?.twitter = text;
                    pageStore.setUserData(data);
                  },
                  validator: Validators.nicknameTwitterValidator,
                  maxLength: 30,
                ),
                InputWidget(
                  title: "settings.facebookUsername".tr(),
                  initialValue: pageStore
                          .userData.additionalInfo!.socialNetwork?.facebook ??
                      "",
                  onChanged: (text) {
                    ProfileMeResponse data = pageStore.userData;
                    data.additionalInfo!.socialNetwork?.facebook = text;
                    pageStore.setUserData(data);
                  },
                  validator: Validators.nicknameFacebookValidator,
                  maxLength: 50,
                ),
                InputWidget(
                  title: "settings.linkedInUsername".tr(),
                  initialValue: pageStore
                          .userData.additionalInfo!.socialNetwork?.linkedin ??
                      "",
                  onChanged: (text) {
                    ProfileMeResponse data = pageStore.userData;
                    data.additionalInfo!.socialNetwork?.linkedin = text;
                    pageStore.setUserData(data);
                  },
                  validator: Validators.nicknameLinkedInValidator,
                  maxLength: 30,
                ),
                InputWidget(
                  title: "settings.instagramUsername".tr(),
                  initialValue: pageStore
                          .userData.additionalInfo!.socialNetwork?.instagram ??
                      "",
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
      AlertDialogUtils.showProfileDialog(context, onSave: _onSave());
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
      if (!pageStore.validationKnowledge(
          _controllerKnowledge!.getListMap(), context)) return;
      if (!pageStore.validationWork(_controllerWork!.getListMap(), context))
        return;
      if (!pageStore.validationWork(_controllerWork!.getListMap(), context))
        return;

      if (pageStore.userData.additionalInfo?.secondMobileNumber?.phone == "")
        pageStore.userData.additionalInfo?.secondMobileNumber = null;
      pageStore.userData.additionalInfo?.educations =
          _controllerKnowledge!.getListMap();
      pageStore.userData.additionalInfo?.workExperiences =
          _controllerWork!.getListMap();
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
        pageStore.userData.userSpecializations =
            _controller!.getSkillAndSpecialization();
      await profile!.changeProfile(
        pageStore.userData,
        media: pageStore.media,
      );
    }
  }
}
