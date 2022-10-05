import 'dart:io';
import 'dart:math';

import 'package:app/constants.dart';
import 'package:app/enums.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/quest_details_page/details/quest_details_page.dart';
import 'package:app/ui/pages/main_page/quest_page/create_quest_page/store/create_quest_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/confirm_transaction_dialog.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/dismiss_keyboard.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/ui/widgets/media_upload/media_upload_widget.dart';
import 'package:app/ui/widgets/skill_specialization_selection/skill_specialization_selection.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/quest_util.dart';
import 'package:app/utils/utils.dart';
import 'package:app/utils/validator.dart';
import 'package:app/utils/web3_utils.dart';
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
  late ProfileMeStore? profile;
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
    profile = context.read<ProfileMeStore>();
    store = context.read<CreateQuestStore>();
    _controller = SkillSpecializationController();
    if (widget.questInfo != null) {
      store.oldPrice = BigInt.parse(widget.questInfo!.price);
      store.payPeriod = widget.questInfo!.payPeriod;
      store.payPeriodValue = QuestUtils.getPayPeriodValue(widget.questInfo!.payPeriod);
      store.setConfirmUnderstandAboutEdit(true);
      store.priority = QuestUtils.getPriorityFromValue(widget.questInfo!.priority);
      store.contractAddress = widget.questInfo!.contractAddress ?? '';
      store.questTitle = widget.questInfo!.title;
      store.changedDistantWork(QuestUtils.getWorkplace(widget.questInfo!.workplace));
      store.changedEmployment(QuestUtils.getEmployment(widget.questInfo!.employment));
      store.description = widget.questInfo!.description;
      store.price =
          (BigInt.parse(widget.questInfo!.price).toDouble() * pow(10, -18)).toString();
      store.locationPlaceName = widget.questInfo!.locationPlaceName;
      store.setImages(widget.questInfo!.medias ?? []);
      _controller = SkillSpecializationController(
          initialValue: widget.questInfo!.questSpecializations);
    }
  }

  @override
  Widget build(context) {
    return ObserverListener<CreateQuestStore>(
      onSuccess: () async {
        if (store.successData == CreateQuestStoreState.checkAllowance) {
          if (store.needApprove) {
            store.getGasApprove(addressQuest: widget.questInfo?.contractAddress);
          } else {
            store.getGasEditOrCreateQuest(isEdit: isEdit);
          }
        } else if (store.successData == CreateQuestStoreState.getGasApprove) {
          Navigator.of(context, rootNavigator: true).pop();
          _approve();
        } else if (store.successData == CreateQuestStoreState.getGasEditOrCreateQuest) {
          Navigator.of(context, rootNavigator: true).pop();
          if (isEdit) {
            _onEditQuest();
          } else {
            _onCreateQuest();
          }
        } else if (store.successData == CreateQuestStoreState.approve) {
          Navigator.of(context, rootNavigator: true).pop();
          AlertDialogUtils.showLoadingDialog(context);
          store.checkAllowance(addressQuest: widget.questInfo?.contractAddress);
        } else if (store.successData == CreateQuestStoreState.createQuest) {
          final questStore = context.read<MyQuestStore>();
          await questStore.getQuests(
            QuestsType.Created,
            UserRole.Employer,
            true,
          );
          await questStore.getQuests(
            QuestsType.All,
            UserRole.Employer,
            true,
          );
          if (isEdit) {
            final updatedQuest = await store.getQuest(
              widget.questInfo!.id,
            );
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pop(context);
            Navigator.pushReplacementNamed(
              context,
              QuestDetails.routeName,
              arguments: QuestArguments(
                id: updatedQuest.id,
              ),
            );
            await AlertDialogUtils.showSuccessDialog(context);
          } else {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pop(context, true);
            await AlertDialogUtils.showSuccessDialog(context);
          }
        }
      },
      onFailure: () {
        print('onFailure ${store.errorMessage}');
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
                    isEdit ? "registration.edit".tr() : "quests.createAQuest".tr(),
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
                        _TitleWithField(
                          "settings.priority".tr(),
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
                            child: IgnorePointer(
                              ignoring: isEdit,
                              child: Observer(
                                builder: (_) => Platform.isIOS
                                    ? dropDownWithModalSheep(
                                        value: store.priority,
                                        children: QuestConstants.priorityList,
                                        onPressed: (value) {
                                          store.changedPriority(value);
                                        },
                                      )
                                    : DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          isExpanded: true,
                                          value: store.priority,
                                          onChanged: (String? value) {
                                            store.changedPriority(value!);
                                          },
                                          items: QuestConstants.priorityList
                                              .map<DropdownMenuItem<String>>(
                                            (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value.tr(),
                                                child: Text(value.tr()),
                                              );
                                            },
                                          ).toList(),
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            size: 30,
                                            color: Colors.blueAccent,
                                          ),
                                          hint: Text(
                                            'mining.choose'.tr(),
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
                          ),
                        ),
                        __WarningFields(
                          warningEnabled:
                              _warningFields[_specializationIndex].warningEnabled,
                          errorMessage: 'quests.specializationRequired'.tr(),
                          child: Container(
                            key: _warningFields[_specializationIndex].key,
                            child: SkillSpecializationSelection(
                              controller: _controller,
                              callback: (value) {
                                print('value: $value');
                                if (value is int && value > 0) {
                                  setState(() {
                                    _warningFields[_specializationIndex].warningEnabled =
                                        false;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        __WarningFields(
                          warningEnabled: _warningFields[_addressIndex].warningEnabled,
                          errorMessage: 'quests.addressRequired'.tr(),
                          child: _TitleWithField(
                            "quests.address".tr(),
                            Observer(
                              builder: (_) => GestureDetector(
                                onTap: () async {
                                  await store.getPrediction(context);
                                  if (store.locationPlaceName.isNotEmpty) {
                                    setState(() {
                                      _warningFields[_addressIndex].warningEnabled =
                                          false;
                                    });
                                  }
                                },
                                child: Container(
                                  key: _warningFields[_addressIndex].key,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF7F8FA),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(6.0),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 17,
                                      ),
                                      Icon(
                                        Icons.map_outlined,
                                        color: Colors.blueAccent,
                                        size: 26.0,
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Flexible(
                                        child: store.locationPlaceName.isEmpty
                                            ? Text(
                                                 "Country/City/Address",
                                                style: TextStyle(
                                                  color: Color(
                                                    0xFFD8DFE3,
                                                  ),
                                                ),
                                                overflow: TextOverflow.fade,
                                              )
                                            : Text(
                                                store.locationPlaceName,
                                                overflow: TextOverflow.fade,
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        _TitleWithField(
                          "quests.employment.title".tr(),
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
                              builder: (_) => Platform.isIOS
                                  ? dropDownWithModalSheep(
                                      value: store.employment,
                                      children: QuestConstants.employmentList,
                                      onPressed: (value) {
                                        store.changedEmployment(value);
                                      },
                                    )
                                  : DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        isExpanded: true,
                                        value: store.employment,
                                        onChanged: (String? value) {
                                          store.changedEmployment(value!);
                                        },
                                        items: QuestConstants.employmentList
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
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
                                          'mining.choose'.tr(),
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
                        ),
                        _TitleWithField(
                          "quests.distantWork.title".tr(),
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
                              builder: (_) => Platform.isIOS
                                  ? dropDownWithModalSheep(
                                      value: store.workplace,
                                      children: QuestConstants.distantWorkList,
                                      onPressed: (value) {
                                        store.changedDistantWork(value);
                                      },
                                    )
                                  : DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        isExpanded: true,
                                        value: store.workplace,
                                        onChanged: (String? value) {
                                          store.changedDistantWork(value!);
                                        },
                                        items: QuestConstants.distantWorkList
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
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
                                          'mining.choose'.tr(),
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
                        ),
                        _TitleWithField(
                          "quests.payPeriod.title".tr(),
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
                            child: IgnorePointer(
                              ignoring: isEdit,
                              child: Observer(
                                builder: (_) => Platform.isIOS
                                    ? dropDownWithModalSheep(
                                        value: store.payPeriod,
                                        children: QuestConstants.payPeriodList,
                                        onPressed: (value) {
                                          store.changedPayPeriod(value.tr());
                                        },
                                      )
                                    : DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          isExpanded: true,
                                          value: store.payPeriod,
                                          onChanged: (String? value) {
                                            store.changedPayPeriod(value!.tr());
                                          },
                                          items: QuestConstants.payPeriodList
                                              .map<DropdownMenuItem<String>>(
                                            (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value.tr(),
                                                child: Text(value.tr()),
                                              );
                                            },
                                          ).toList(),
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            size: 30,
                                            color: Colors.blueAccent,
                                          ),
                                          hint: Text(
                                            'mining.choose'.tr(),
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
                          ),
                        ),
                        _TitleWithField(
                          "quests.title".tr(),
                          Container(
                            key: _warningFields[_titleIndex].key,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: TextFormField(
                              onChanged: store.setQuestTitle,
                              validator: (value) => Validators.emptyValidator(value,
                                  customMessage: 'errors.fieldRequired'
                                      .tr(namedArgs: {'name': 'Title'})),
                              initialValue: store.questTitle,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        _TitleWithField(
                          "quests.aboutQuest".tr(),
                          TextFormField(
                            key: _warningFields[_descriptionIndex].key,
                            initialValue: store.description,
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
                            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                    key: _warningFields[_confirmUnderstandAboutEdit].key,
                                    contentPadding: const EdgeInsets.all(0),
                                    value: store.confirmUnderstandAboutEdit,
                                    onChanged: (value) =>
                                        store.setConfirmUnderstandAboutEdit(value!),
                                    controlAffinity: ListTileControlAffinity.leading,
                                    title: Text(
                                      'I understand that editing the title and the description of this quest will be '
                                      'impossible after its creation',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  if (!store.confirmUnderstandAboutEdit)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(top: 4.0, left: 10.0),
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
                        _TitleWithField(
                          "quests.price".tr(),
                          Container(
                            key: _warningFields[_priceIndex].key,
                            height: 60,
                            child: TextFormField(
                              onChanged: store.setPrice,
                              initialValue: store.price.toString(),
                              validator: (value) => Validators.zeroValidator(value,
                                  customMessage: 'errors.fieldRequired'
                                      .tr(namedArgs: {'name': 'Price'})),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              inputFormatters: [
                                DecimalFormatter(),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,18}')),
                              ],
                              keyboardType:
                                  const TextInputType.numberWithOptions(decimal: true),
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
                              onTap:
                                  store.isLoading ? null : _onPressedOnCreateOrEditQuest,
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
    } else if (store.locationPlaceName.isEmpty) {
      _setWarning(_warningFields[_addressIndex]);
      return;
    } else if (store.questTitle.isEmpty) {
      _formKey.currentState?.validate();
      _setWarning(_warningFields[_titleIndex]);
      return;
    } else if (store.description.isEmpty) {
      _formKey.currentState?.validate();
      _setWarning(_warningFields[_descriptionIndex]);
      return;
    } else if (store.price.isEmpty) {
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
      amount: ((double.tryParse(store.price) ?? 0.0) * Constants.commissionForQuest)
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
    if (store.canSubmitEditQuest) {
      if (_formKey.currentState?.validate() ?? false) {
        _showConfirmTxAlert(isEdit: true);
      }
    }
  }

  _showConfirmTxAlert({bool isEdit = false}) {
    confirmTransaction(
      context,
      fee: store.gas!,
      transaction: "ui.txInfo".tr(),
      address: Web3Utils.getAddressWorknetWQFactory(),
      amount: store.price,
      onPressConfirm: () async {
        Navigator.pop(context);
        if (isEdit) {
          store.createQuest(
            isEdit: true,
            questId: widget.questInfo!.id,
          );
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

  dropDownWithModalSheep({
    required String value,
    required List<String> children,
    required Function(String) onPressed,
  }) {
    return CupertinoButton(
      child: Row(
        children: [
          Text(
            value.tr(),
            style: TextStyle(color: Colors.black87),
          ),
          Spacer(),
          Icon(
            Icons.arrow_drop_down,
            size: 30,
            color: Colors.blueAccent,
          )
        ],
      ),
      padding: EdgeInsets.zero,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          builder: (BuildContext context) {
            var changedEmployment = value;
            return Container(
              height: 150.0 + MediaQuery.of(context).padding.bottom,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: children.indexOf(value),
                      ),
                      itemExtent: 32.0,
                      onSelectedItemChanged: (int index) {
                        changedEmployment = children[index];
                      },
                      children: children.map((e) => Center(child: Text(e.tr()))).toList(),
                    ),
                  ),
                  CupertinoButton(
                    child: Text("OK"),
                    onPressed: () {
                      onPressed.call(changedEmployment);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _TitleWithField extends StatelessWidget {
  final String title;
  final Widget child;

  const _TitleWithField(this.title, this.child, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
        ),
        child,
      ],
    );
  }
}

class __WarningFields extends StatelessWidget {
  final bool warningEnabled;
  final String errorMessage;
  final Widget child;

  const __WarningFields({
    Key? key,
    required this.child,
    required this.warningEnabled,
    required this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        if (warningEnabled)
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
      ],
    );
  }
}
