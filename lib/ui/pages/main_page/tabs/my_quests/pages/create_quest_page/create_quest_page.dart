import 'package:app/constants.dart';
import 'package:app/di/injector.dart';
import 'package:app/enums.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/create_quest_page/store/create_quest_store.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/create_quest_page/widgets/select_address_widget.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/create_quest_page/widgets/select_distant_work_widget.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/create_quest_page/widgets/select_employment_widget.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/create_quest_page/widgets/select_pay_period_widget.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/create_quest_page/widgets/select_priority_widget.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/create_quest_page/widgets/title_with_field.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/create_quest_page/widgets/warning_field_widget.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/quest_details/pages/employer/quest_employer_page/quest_employer_page.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/quest_details/pages/worker/quest_worker_page/quest_worker_page.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/confirm_transaction_dialog.dart';
import 'package:app/ui/widgets/dismiss_keyboard.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/ui/widgets/media_upload/media_upload_widget.dart';
import 'package:app/ui/widgets/skill_specialization_selection/skill_specialization_selection.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/utils.dart';
import 'package:app/utils/validator.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import "package:provider/provider.dart";
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:easy_localization/easy_localization.dart';

const _addressIndex = 0;
const _specializationIndex = 1;
const _titleIndex = 2;
const _descriptionIndex = 3;
const _priceIndex = 4;
const _confirmUnderstandAboutEdit = 5;

class _WarningFieldModel {
  final GlobalKey key;
  bool warningEnabled;

  _WarningFieldModel(this.key, this.warningEnabled);
}

class CreateQuestPage extends StatefulWidget {
  static const String routeName = '/createQuestPage';
  final BaseQuestResponse? questInfo;

  CreateQuestPage({this.questInfo});

  @override
  _CreateQuestPageState createState() => _CreateQuestPageState();
}

class _CreateQuestPageState extends State<CreateQuestPage> {
  final _formKey = GlobalKey<FormState>();
  late SkillSpecializationController _controller;
  late final CreateQuestStore store;

  bool get isEdit => widget.questInfo != null;

  List<_WarningFieldModel> _warningFields = [
    _WarningFieldModel(GlobalKey(), false),
    _WarningFieldModel(GlobalKey(), false),
    _WarningFieldModel(GlobalKey(), false),
    _WarningFieldModel(GlobalKey(), false),
    _WarningFieldModel(GlobalKey(), false),
    _WarningFieldModel(GlobalKey(), false),
  ];

  void initState() {
    super.initState();
    store = context.read<CreateQuestStore>();
    _controller = SkillSpecializationController();
    if (widget.questInfo != null) {
      store.initQuest(quest: widget.questInfo);
      _controller = SkillSpecializationController(
          initialValue: widget.questInfo!.questSpecializations);
    }
  }

  _stateListener() async {
    if (store.successData == CreateQuestStoreState.checkAllowance) {
      if (store.needApprove) {
        store.getGasApprove(addressQuest: widget.questInfo?.contractAddress);
      } else {
        if (store.isEdit) {
          store.getGasEditQuest();
        } else {
          store.getGasCreateQuest();
        }
      }
    }

    if (store.successData == CreateQuestStoreState.getGasApprove) {
      Navigator.of(context, rootNavigator: true).pop();
      _approve();
    }

    if (store.successData == CreateQuestStoreState.getGasCreateQuest ||
        store.successData == CreateQuestStoreState.getGasEditQuest) {
      Navigator.of(context, rootNavigator: true).pop();
      if (store.isEdit) {
        _onEditQuest();
      } else {
        _onCreateQuest();
      }
    }

    if (store.successData == CreateQuestStoreState.approve) {
      Navigator.of(context, rootNavigator: true).pop();
      AlertDialogUtils.showLoadingDialog(context);
      store.checkAllowance(addressQuest: widget.questInfo?.contractAddress);
    }

    if (store.successData == CreateQuestStoreState.createQuest) {
      await Future.wait(
        [
          context.read<MyQuestStore>().getQuests(questType: QuestsType.Created),
          context.read<MyQuestStore>().getQuests(questType: QuestsType.All)
        ],
      );

      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pop(context, true);
      await AlertDialogUtils.showSuccessDialog(context);
    }

    if (store.successData == CreateQuestStoreState.editQuest) {
      await Future.wait(
        [
          context.read<MyQuestStore>().getQuests(questType: QuestsType.Created),
          context.read<MyQuestStore>().getQuests(questType: QuestsType.All)
        ],
      );
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pop(context);
      Navigator.pushReplacementNamed(
        context,
        getIt.get<ProfileMeStore>().userData!.role == UserRole.Worker
            ? QuestWorkerPage.routeName
            : QuestEmployerPage.routeName,
        arguments: QuestArguments(
          id: widget.questInfo!.id,
        ),
      );
      await AlertDialogUtils.showSuccessDialog(context);
    }
  }

  @override
  Widget build(context) {
    return ObserverListener<CreateQuestStore>(
      onSuccess: _stateListener,
      onFailure: () {
        Navigator.of(context, rootNavigator: true).pop();
        return false;
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          body: DismissKeyboard(
            child: CustomScrollView(
              cacheExtent: 1000,
              slivers: [
                CupertinoSliverNavigationBar(
                  largeTitle: Text(
                    isEdit
                        ? "registration.edit".tr()
                        : "quests.createAQuest".tr(),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Observer(
                          builder: (_) => SelectPriorityWidget(
                            isEdit: isEdit,
                            priority: store.quest.priority!,
                            onSelect: (value) {
                              store.changedPriority(value!);
                            },
                          ),
                        ),
                        WarningFields(
                          warningEnabled: _warningFields[_specializationIndex]
                              .warningEnabled,
                          errorMessage: 'quests.specializationRequired'.tr(),
                          child: Container(
                            key: _warningFields[_specializationIndex].key,
                            child: SkillSpecializationSelection(
                              controller: _controller,
                              callback: (value) {
                                if (value is int && value > 0) {
                                  setState(() {
                                    _warningFields[_specializationIndex]
                                        .warningEnabled = false;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        Observer(
                          builder: (_) => SelectAddressWidget(
                            warningEnabled:
                                _warningFields[_addressIndex].warningEnabled,
                            keyField: _warningFields[_addressIndex].key,
                            defaultValue: store.quest.location
                                    ?.locationPlaceName.isEmpty ??
                                true,
                            locationName:
                                store.quest.location?.locationPlaceName ?? '',
                            onPressed: () async {
                              await store.getPrediction(context);
                              if (store.quest.location?.locationPlaceName
                                      .isNotEmpty ??
                                  false) {
                                setState(() {
                                  _warningFields[_addressIndex].warningEnabled =
                                      false;
                                });
                              }
                            },
                          ),
                        ),
                        Observer(
                          builder: (_) => SelectEmploymentWidget(
                            employment: store.quest.employment!,
                            onSelect: (value) {
                              store.changedEmployment(value!);
                            },
                          ),
                        ),
                        Observer(
                          builder: (_) => SelectDistantWorkWidget(
                            workplace: store.quest.workplace!,
                            onSelect: (value) {
                              store.changedDistantWork(value!);
                            },
                          ),
                        ),
                        Observer(
                          builder: (_) => SelectPayPeriodWidget(
                            isEdit: isEdit,
                            payPeriod: store.quest.payPeriod!,
                            onSelect: (value) {
                              store.changedPayPeriod(value!.tr());
                            },
                          ),
                        ),
                        TitleWithField(
                          "quests.title".tr(),
                          Container(
                            key: _warningFields[_titleIndex].key,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: TextFormField(
                              onChanged: store.setQuestTitle,
                              validator: (value) => Validators.emptyValidator(
                                  value,
                                  customMessage: 'errors.fieldRequired'
                                      .tr(namedArgs: {'name': 'Title'})),
                              initialValue: store.quest.title,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              maxLines: 1,
                              enabled: !isEdit,
                              decoration: InputDecoration(
                                hintText: 'modals.title'.tr(),
                              ),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        TitleWithField(
                          "quests.aboutQuest".tr(),
                          TextFormField(
                            key: _warningFields[_descriptionIndex].key,
                            initialValue: store.quest.description,
                            onChanged: store.setAboutQuest,
                            validator: (value) {
                              if (value == null) {
                                return 'errors.fieldRequired'
                                    .tr(namedArgs: {'name': 'Description'});
                              }
                              if (value.isEmpty) {
                                return 'errors.fieldRequired'
                                    .tr(namedArgs: {'name': 'Description'});
                              }
                              if (value.length < 6) {
                                return 'Description must be at least 6 characters long';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.multiline,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            enabled: !isEdit,
                            maxLines: 12,
                            decoration: InputDecoration(
                              hintText: 'quests.questText'.tr(),
                            ),
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (!this.isEdit)
                          Observer(
                            builder: (_) => Padding(
                              padding: const EdgeInsets.only(
                                top: 10.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CheckboxListTile(
                                    key: _warningFields[
                                            _confirmUnderstandAboutEdit]
                                        .key,
                                    contentPadding: const EdgeInsets.all(0),
                                    value: store.confirmUnderstandAboutEdit,
                                    onChanged: (value) => store
                                        .setConfirmUnderstandAboutEdit(value!),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(
                                      'I understand that editing the title and the description of this quest will be '
                                      'impossible after its creation',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  if (!store.confirmUnderstandAboutEdit)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4.0, left: 10.0),
                                      child: Text(
                                        'The field is required',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),

                        ///Upload media
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                          ),
                          child: MediaUploadWithProgress(
                            store: store,
                            type: MediaType.images,
                          ),
                        ),
                        TitleWithField(
                          "quests.price".tr(),
                          Container(
                            key: _warningFields[_priceIndex].key,
                            height: 60,
                            child: TextFormField(
                              onChanged: store.setPrice,
                              initialValue: (Decimal.parse(store.quest.price!) /
                                      Decimal.fromInt(10).pow(18))
                                  .toDouble()
                                  .toString(),
                              validator: (value) => Validators.zeroValidator(
                                  value,
                                  customMessage: 'errors.fieldRequired'
                                      .tr(namedArgs: {'name': 'Price'})),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              inputFormatters: [
                                DecimalFormatter(),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,18}')),
                              ],
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: InputDecoration(
                                hintText: 'quests.price'.tr(),
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
                          child: Observer(
                            builder: (context) => LoginButton(
                              withColumn: true,
                              onTap: store.isLoading
                                  ? null
                                  : _onPressedOnCreateOrEditQuest,
                              title: isEdit
                                  ? "quests.editQuest".tr()
                                  : 'quests.createAQuest'.tr(),
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
        ),
      ),
    );
  }

  _setWarning(_WarningFieldModel field) {
    Scrollable.ensureVisible(field.key.currentContext!,
        duration: const Duration(milliseconds: 350));
    setState(() {
      field.warningEnabled = true;
    });
  }

  _onPressedOnCreateOrEditQuest() async {
    store.skillFilters = _controller.getSkillAndSpecialization();
    if (store.skillFilters.isEmpty) {
      _setWarning(_warningFields[_specializationIndex]);
      return;
    } else if (store.quest.location?.locationPlaceName.isEmpty ?? true) {
      _setWarning(_warningFields[_addressIndex]);
      return;
    } else if (store.quest.title?.isEmpty ?? true) {
      _formKey.currentState?.validate();
      _setWarning(_warningFields[_titleIndex]);
      return;
    } else if (store.quest.description?.isEmpty ?? true) {
      _formKey.currentState?.validate();
      _setWarning(_warningFields[_descriptionIndex]);
      return;
    } else if (store.quest.price?.isEmpty ?? true) {
      _formKey.currentState?.validate();
      _setWarning(_warningFields[_priceIndex]);
      return;
    } else if (!store.confirmUnderstandAboutEdit) {
      Scrollable.ensureVisible(
          _warningFields[_confirmUnderstandAboutEdit].key.currentContext!);
      return;
    }
    AlertDialogUtils.showLoadingDialog(context);
    store.checkAllowance(addressQuest: widget.questInfo?.contractAddress);
  }

  _approve() {
    confirmTransaction(
      context,
      fee: store.gas!,
      transaction: '${"ui.txInfo".tr()} Approve',
      address: Web3Utils.getAddressWorknetWQFactory(),
      amount: ((Decimal.parse(store.quest.price!) / Decimal.fromInt(10).pow(18))
                  .toDouble() *
              Constants.commissionForQuest)
          .toString(),
      onPressConfirm: () async {
        Navigator.pop(context);
        AlertDialogUtils.showLoadingDialog(
          context,
        );
        store.approve(contractAddress: widget.questInfo?.contractAddress);
      },
      onPressCancel: () {
        Navigator.pop(context);
      },
    );
  }

  _onCreateQuest() async {
    if (_formKey.currentState?.validate() ?? false) {
      _showConfirmTxAlert();
    }
  }

  _onEditQuest() async {
    if (_formKey.currentState?.validate() ?? false) {
      _showConfirmTxAlert(isEdit: true);
    }
  }

  _showConfirmTxAlert({bool isEdit = false}) {
    confirmTransaction(
      context,
      fee: store.gas!,
      transaction: "ui.txInfo".tr(),
      address: Web3Utils.getAddressWorknetWQFactory(),
      amount: (Decimal.parse(store.quest.price!) / Decimal.fromInt(10).pow(18))
          .toString(),
      onPressConfirm: () async {
        Navigator.pop(context);
        if (isEdit) {
          store.editQuest(questId: widget.questInfo!.id);
        } else {
          store.createQuest();
        }
        AlertDialogUtils.showLoadingDialog(
          context,
        );
      },
      onPressCancel: () {
        Navigator.pop(context);
      },
    );
  }
}
