import 'dart:io';
import 'package:app/constants.dart';
import 'package:app/enums.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/SMS_verification_page/sms_verification_page.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/change_profile_page/store/change_profile_store.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/change_profile_page/widgets/address_profile_widget.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/change_profile_page/widgets/fields_for_employer_worker.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/change_profile_page/widgets/fields_for_worker_widget.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/change_profile_page/widgets/image_profile.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/change_profile_page/widgets/input_widget.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/change_profile_page/widgets/phone_number_widget.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/dismiss_keyboard.dart';
import 'package:app/ui/widgets/knowledge_work_selection/knowledge_work_selection.dart';
import 'package:app/ui/widgets/skill_specialization_selection/skill_specialization_selection.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/profile_util.dart';
import 'package:app/utils/validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

class ChangeProfilePage extends StatefulWidget {
  static const String routeName = "/ChangeProfilePage";

  @override
  _ChangeProfilePageState createState() => _ChangeProfilePageState();
}

class _ChangeProfilePageState extends State<ChangeProfilePage> {
  ProfileMeStore? profile;
  late ChangeProfileStore store;

  final _formKey = GlobalKey<FormState>();

  SkillSpecializationController? _controller;
  KnowledgeWorkSelectionController? _controllerKnowledge;
  KnowledgeWorkSelectionController? _controllerWork;

  @override
  void initState() {
    profile = context.read<ProfileMeStore>();
    store = ChangeProfileStore(ProfileMeResponse.clone(profile!.userData!));
    profile!.distantWork =
        ProfileUtils.workplaceToValue(profile!.userData!.workplace);
    profile!.priorityValue =
        ProfileUtils.priorityToValue(profile!.userData!.priority);
    profile!.payPeriod =
        ProfileUtils.payPeriodToValue(profile!.userData!.payPeriod);
    if (profile!.userData!.additionalInfo?.address != null)
      store.address = profile!.userData!.additionalInfo!.address!;
    store.getInitCode(store.userData.phone ?? store.userData.tempPhone!,
        store.userData.additionalInfo?.secondMobileNumber);
    if (profile!.userData!.locationPlaceName != null)
      store.address = profile!.userData!.locationPlaceName!;
    _controller = SkillSpecializationController(
        initialValue: store.userData.userSpecializations);
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
          if (store.phoneNumber != null &&
              store.phoneNumber!.phoneNumber!.isNotEmpty &&
              !store.numberChanged(store.oldPhoneNumber!.phoneNumber)) {
            await AlertDialogUtils.showSuccessDialog(context);
            Navigator.pop(context, true);
          } else {
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
                  file: store.media,
                  hasMedia: store.media == null,
                  url: profile!.userData!.avatar?.url,
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                    );
                    if (result != null) {
                      List<File> files =
                          result.paths.map((path) => File(path!)).toList();
                      store.media = files.first;
                    }
                  },
                ),
                InputWidget(
                  title: "labels.firstName".tr(),
                  initialValue: store.userData.firstName ?? '',
                  onChanged: (text) {
                    ProfileMeResponse data = store.userData;
                    data.firstName = text;
                    store.setUserData(data);
                  },
                  validator: Validators.firstNameValidator,
                  maxLength: 15,
                ),
                InputWidget(
                  title: "labels.lastName".tr(),
                  initialValue: store.userData.lastName ?? '',
                  onChanged: (text) {
                    ProfileMeResponse data = store.userData;
                    data.lastName = text;
                    store.setUserData(data);
                  },
                  validator: Validators.lastNameValidator,
                  maxLength: 15,
                ),
                Observer(
                  builder: (_) => AddressProfileWidget(
                    address: store.address.isEmpty
                        ? profile!.userData!.additionalInfo?.address ??
                            store.address
                        : store.address,
                    onTap: () {
                      store.getPrediction(context);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Observer(
                  builder: (_) => PhoneNumberWidget(
                    title: "modals.phoneNumber",
                    initialValue: store.oldPhoneNumber,
                    onChanged: (PhoneNumber phone) {
                      store.setPhoneNumber(phone);
                    },
                    needValidator:
                        store.phoneNumber?.phoneNumber?.isEmpty ?? true,
                  ),
                ),
                if (profile!.userData!.role == UserRole.Employer)
                  Observer(
                    builder: (_) => PhoneNumberWidget(
                      title: "modals.secondPhoneNumber",
                      initialValue: store.secondPhoneNumber,
                      onChanged: (PhoneNumber phone) {
                        store.setSecondPhoneNumber(phone);
                      },
                    ),
                  ),
                InputWidget(
                  title: "signUp.email".tr(),
                  readOnly: true,
                  initialValue: store.userData.email ?? "",
                  onChanged: (text) {
                    ProfileMeResponse data = store.userData;
                    data.email = text;
                    store.setUserData(data);
                  },
                  validator: Validators.emailValidator,
                  maxLength: null,
                ),
                if (store.userData.role == UserRole.Employer)
                  FieldForEmployerWorker(
                    pageStore: store,
                    profile: profile!,
                  ),
                InputWidget(
                  title: "modals.title".tr(),
                  initialValue:
                      store.userData.additionalInfo!.description ?? "",
                  onChanged: (text) {
                    ProfileMeResponse data = store.userData;
                    data.additionalInfo!.description = text;
                    store.setUserData(data);
                  },
                  maxLines: null,
                  validator: Validators.descriptionValidator,
                  maxLength: null,
                ),
                if (store.userData.role == UserRole.Worker)
                  FieldsForWorkerWidget(
                    controllerKnowledge: _controllerKnowledge!,
                    controllerWork: _controllerWork!,
                    controller: _controller!,
                    pageStore: store,
                    profile: profile!,
                  ),
                InputWidget(
                  title: "settings.twitterUsername".tr(),
                  initialValue:
                      store.userData.additionalInfo!.socialNetwork?.twitter ??
                          "",
                  onChanged: (text) {
                    ProfileMeResponse data = store.userData;
                    data.additionalInfo!.socialNetwork?.twitter = text;
                    store.setUserData(data);
                  },
                  validator: Validators.nicknameTwitterValidator,
                  maxLength: 30,
                ),
                InputWidget(
                  title: "settings.facebookUsername".tr(),
                  initialValue:
                      store.userData.additionalInfo!.socialNetwork?.facebook ??
                          "",
                  onChanged: (text) {
                    ProfileMeResponse data = store.userData;
                    data.additionalInfo!.socialNetwork?.facebook = text;
                    store.setUserData(data);
                  },
                  validator: Validators.nicknameFacebookValidator,
                  maxLength: 50,
                ),
                InputWidget(
                  title: "settings.linkedInUsername".tr(),
                  initialValue:
                      store.userData.additionalInfo!.socialNetwork?.linkedin ??
                          "",
                  onChanged: (text) {
                    ProfileMeResponse data = store.userData;
                    data.additionalInfo!.socialNetwork?.linkedin = text;
                    store.setUserData(data);
                  },
                  validator: Validators.nicknameLinkedInValidator,
                  maxLength: 30,
                ),
                InputWidget(
                  title: "settings.instagramUsername".tr(),
                  initialValue:
                      store.userData.additionalInfo!.socialNetwork?.instagram ??
                          "",
                  onChanged: (text) {
                    ProfileMeResponse data = store.userData;
                    data.additionalInfo!.socialNetwork?.instagram = text;
                    store.setUserData(data);
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
    if (!store.areThereAnyChanges(profile!.userData))
      Navigator.pop(context);
    else
      AlertDialogUtils.showProfileDialog(context, onSave: _onSave);
  }

  _onSave() async {
    if ((store.userData.tempPhone?.fullPhone ?? "").contains("-") ||
        (store.userData.tempPhone?.fullPhone ?? "").contains(" ")) {
      AlertDialogUtils.showInfoAlertDialog(
        context,
        title: "modals.warning".tr(),
        content: "errors.numberContainDashesOrSpaces".tr(),
      );
      return;
    }
    if (_formKey.currentState?.validate() ?? false) {
      if (!store.validationKnowledge(
          _controllerKnowledge!.getListMap(), context)) return;
      if (!store.validationWork(_controllerWork!.getListMap(), context)) return;
      if (!store.validationWork(_controllerWork!.getListMap(), context)) return;
      if (Constants.isTestnet)
        _nextStep();
      else if (!store.userData.neverEditedProfileFlag!) {
        if (store.userData.isTotpActive ?? false)
          AlertDialogUtils.showSecurityTotpPDialog(
            context,
            setTotp: profile!.setTotp,
            onTapOk: _nextStep,
          );
        else
          AlertDialogUtils.showInfoAlertDialog(
            context,
            title: "modals.warning".tr(),
            content: "modals.errorEditProfile2FA".tr(),
          );
      } else
        _nextStep();
    }
  }

  _nextStep() async {
    store.userData.totpCode = profile!.totp;
    if (store.userData.additionalInfo?.secondMobileNumber?.phone == "")
      store.userData.additionalInfo?.secondMobileNumber = null;
    store.userData.additionalInfo?.educations =
        _controllerKnowledge!.getListMap();
    store.userData.additionalInfo?.workExperiences =
        _controllerWork!.getListMap();
    if (store.address.isNotEmpty) {
      store.userData.additionalInfo!.address = store.address;
      store.userData.locationPlaceName = store.address;
    } else
      AlertDialogUtils.showInfoAlertDialog(
        context,
        title: "Warning",
        content: "Address is empty",
      );
    store.userData.priority =
        ProfileUtils.valueToPriority(profile!.priorityValue);
    store.userData.payPeriod =
        ProfileUtils.valueToPayPeriod(profile!.payPeriod);
    store.userData.workplace =
        ProfileUtils.valueToWorkplace(profile!.distantWork);

    store.savePhoneNumber();
    store.saveSecondPhoneNumber();

    if (!profile!.isLoading)
      store.userData.userSpecializations =
          _controller!.getSkillAndSpecialization();
    await profile!.changeProfile(
      store.userData,
      media: store.media,
    );
    store.userData.neverEditedProfileFlag = false;
  }
}
