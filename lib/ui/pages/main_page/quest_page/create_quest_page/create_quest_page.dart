import 'dart:io';
import 'dart:math';

import 'package:app/constants.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/quest_details_page/details/quest_details_page.dart';
import 'package:app/ui/pages/main_page/quest_page/create_quest_page/store/create_quest_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/transfer_page/mobx/transfer_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/dismiss_keyboard.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/ui/widgets/skill_specialization_selection/skill_specialization_selection.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/quest_util.dart';
import 'package:app/utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import "package:provider/provider.dart";
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../enums.dart';
import '../../../../../observer_consumer.dart';
import '../../../../../utils/web3_utils.dart';
import '../../../../widgets/media_upload/media_upload_widget.dart';
import '../../../../../web3/repository/account_repository.dart';
import '../../wallet_page/confirm_transaction_dialog.dart';

class CreateQuestPage extends StatefulWidget {
  static const String routeName = '/createQuestPage';
  final BaseQuestResponse? questInfo;

  CreateQuestPage({this.questInfo});

  @override
  _CreateQuestPageState createState() => _CreateQuestPageState();
}

class _CreateQuestPageState extends State<CreateQuestPage> {
  final _formKey = GlobalKey<FormState>();
  SkillSpecializationController? _controller;
  late ProfileMeStore? profile;
  late TransferStore transferStore;
  final _scrollController = ScrollController();

  final addressKey = new GlobalKey();
  final specializationKey = new GlobalKey();
  final titleKey = new GlobalKey();
  final descriptionKey = new GlobalKey();
  final priceKey = new GlobalKey();
  final confirmUnderstandAboutEdit = new GlobalKey();
  final contractAddress = Constants.worknetWQFactory;

  bool isEdit = false;

  void initState() {
    super.initState();
    profile = context.read<ProfileMeStore>();
    transferStore = context.read<TransferStore>();
    if (widget.questInfo != null) {
      this.isEdit = true;
      final store = context.read<CreateQuestStore>();
      store.setConfirmUnderstandAboutEdit(true);
      print("questInfo!.priority: ${widget.questInfo!.priority - 1}");
      store.priority = QuestConstants.priorityList[widget.questInfo!.priority - 1];
      store.contractAddress = widget.questInfo!.contractAddress ?? '';
      store.questTitle = widget.questInfo!.title;
      store.changedDistantWork(QuestUtils.getEmployment(widget.questInfo!.workplace));
      store.changedEmployment(QuestUtils.getEmployment(widget.questInfo!.employment));
      // store.getWorkplace(widget.questInfo!.workplace);
      // store.getEmployment(widget.questInfo!.employment);
      store.description = widget.questInfo!.description;
      store.price = (BigInt.parse(widget.questInfo!.price).toDouble() * pow(10, -18)).toString();
      store.locationPlaceName = widget.questInfo!.locationPlaceName;
      store.setImages(widget.questInfo!.medias ?? []);
      _controller = SkillSpecializationController(initialValue: widget.questInfo!.questSpecializations);
    } else
      _controller = SkillSpecializationController();
  }

  Widget build(context) {
    final store = context.read<CreateQuestStore>();

    final questStore = context.read<MyQuestStore>();

    return Form(
      key: _formKey,
      child: Scaffold(
        body: DismissKeyboard(
          child: CustomScrollView(
            controller: _scrollController,
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
                      titledField(
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
                                      items: QuestConstants.priorityList.map<DropdownMenuItem<String>>(
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
                      Container(
                        key: specializationKey,
                        child: SkillSpecializationSelection(
                          controller: _controller,
                        ),
                      ),
                      titledField(
                        "quests.address".tr(),
                        Observer(
                          builder: (_) => GestureDetector(
                            onTap: () {
                              store.getPrediction(context);
                            },
                            child: Container(
                              key: addressKey,
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
                                            "Moscow, Lenina street, 3",
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
                      titledField(
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
                                      items: QuestConstants.employmentList.map<DropdownMenuItem<String>>((String value) {
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
                      titledField(
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
                                      items: QuestConstants.distantWorkList.map<DropdownMenuItem<String>>((String value) {
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
                      titledField(
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
                          child: Observer(
                            builder: (_) => Platform.isIOS
                                ? dropDownWithModalSheep(
                                    value: store.payPeriod,
                                    children: QuestConstants.payPeriodList,
                                    onPressed: (value) {
                                      store.changedPayPeriod(value);
                                    },
                                  )
                                : DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      value: store.payPeriod,
                                      onChanged: (String? value) {
                                        store.changedPayPeriod(value!);
                                      },
                                      items: QuestConstants.payPeriodList.map<DropdownMenuItem<String>>(
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
                      titledField(
                        "quests.title".tr(),
                        Container(
                          key: titleKey,
                          height: 60,
                          alignment: Alignment.centerLeft,
                          child: TextFormField(
                            onChanged: store.setQuestTitle,
                            validator: Validators.emptyValidator,
                            initialValue: store.questTitle,
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
                      titledField(
                        "quests.aboutQuest".tr(),
                        TextFormField(
                          key: descriptionKey,
                          initialValue: store.description,
                          onChanged: store.setAboutQuest,
                          validator: Validators.emptyValidator,
                          keyboardType: TextInputType.multiline,
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
                                  key: confirmUnderstandAboutEdit,
                                  contentPadding: const EdgeInsets.all(0),
                                  value: store.confirmUnderstandAboutEdit,
                                  onChanged: (value) => store.setConfirmUnderstandAboutEdit(value!),
                                  controlAffinity: ListTileControlAffinity.leading,
                                  title: Text(
                                    'I understand that editing the title and the description of this quest will be '
                                    'impossible after its creation',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                if (!store.confirmUnderstandAboutEdit)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      'The field is required',
                                      style: TextStyle(
                                        fontSize: 14,
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
                      titledField(
                        "quests.price".tr(),
                        Container(
                          key: priceKey,
                          height: 60,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            onChanged: store.setPrice,
                            initialValue: store.price.toString(),
                            validator: Validators.zeroValidator,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9]'),
                              ),
                            ],
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
                        child: ObserverListener<CreateQuestStore>(
                          onFailure: () {
                            return false;
                          },
                          onSuccess: () async {
                            ///review
                            await questStore.getQuests(
                              profile!.userData!.id,
                              UserRole.Employer,
                              true,
                            );
                            if (isEdit) {
                              final updatedQuest = await store.getQuest(widget.questInfo!.id);
                              Navigator.pushReplacementNamed(
                                context,
                                QuestDetails.routeName,
                                arguments: QuestArguments(
                                  questInfo: updatedQuest,
                                  id: null,
                                ),
                              );
                            }
                            Navigator.pop(context, true);
                            await AlertDialogUtils.showSuccessDialog(context);
                          },
                          child: Observer(
                            builder: (context) => LoginButton(
                              withColumn: true,
                              enabled: store.isLoading,
                              onTap: store.isLoading
                                  ? null
                                  : () async {
                                      store.skillFilters = _controller!.getSkillAndSpecialization();
                                      if (isEdit) {
                                        if (store.canSubmitEditQuest) {
                                          if (_formKey.currentState?.validate() ?? false) {
                                            await store.createQuest(
                                              isEdit: true,
                                              questId: widget.questInfo!.id,
                                            );
                                          }
                                        }
                                      } else if (store.canCreateQuest) {
                                        if (_formKey.currentState?.validate() ?? false) {
                                          if (!store.confirmUnderstandAboutEdit) {
                                            Scrollable.ensureVisible(
                                              confirmUnderstandAboutEdit.currentContext!,
                                            );
                                            return;
                                          }
                                          try {
                                            await _checkPossibilityTx(store.price);
                                          } on FormatException catch (e) {
                                            AlertDialogUtils.showInfoAlertDialog(context,
                                                title: 'modals.error'.tr(), content: e.message);
                                            return;
                                          } catch (e) {
                                            AlertDialogUtils.showInfoAlertDialog(context,
                                                title: 'modals.error'.tr(), content: e.toString());
                                            return;
                                          }
                                          confirmTransaction(
                                            context,
                                            fee: transferStore.fee,
                                            transaction: "Transaction info",
                                            address: contractAddress,
                                            amount: transferStore.amount,
                                            onPress: () async {
                                              store.createQuest();
                                              Navigator.pop(context);
                                              if (store.isSuccess) {
                                                Navigator.pop(context);
                                                AlertDialogUtils.showSuccessDialog(context);
                                              }
                                            },
                                          );
                                        }
                                      } else {
                                        store.emptyField(context);
                                      }
                                      if (store.skillFilters.isEmpty)
                                        Scrollable.ensureVisible(
                                          specializationKey.currentContext!,
                                        );
                                      else if (store.locationPlaceName.isEmpty)
                                        Scrollable.ensureVisible(
                                          addressKey.currentContext!,
                                        );
                                      else if (store.questTitle.isEmpty)
                                        Scrollable.ensureVisible(
                                          titleKey.currentContext!,
                                        );
                                      else if (store.description.isEmpty)
                                        Scrollable.ensureVisible(
                                          descriptionKey.currentContext!,
                                        );
                                      else if (store.price.isEmpty)
                                        Scrollable.ensureVisible(
                                          priceKey.currentContext!,
                                        );
                                    },
                              title: isEdit ? "Edit Quest" : 'quests.createAQuest'.tr(),
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
        ),
      ),
    );
  }

  Future<void> _checkPossibilityTx(String price) async {
    transferStore.setAmount(price);
    if (transferStore.fee.isEmpty) {
      await transferStore.getFee();
    }
    await Web3Utils.checkPossibilityTx(TokenSymbols.WUSD, double.parse(price), isMain: true);
    if (transferStore.addressTo.toLowerCase() == AccountRepository().userAddress.toLowerCase()) {
      throw FormatException('errors.provideYourAddress'.tr());
    }
    if (double.parse(transferStore.amount) == 0.0) {
      throw FormatException('errors.invalidAmount'.tr());
    }
  }

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

  dropDownWithModalSheep({
    required String value,
    required List<String> children,
    required Function(String) onPressed,
  }) {
    return CupertinoButton(
      child: Row(
        children: [
          Text(
            value,
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
                      children: children.map((e) => Center(child: Text(e))).toList(),
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
