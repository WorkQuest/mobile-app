import 'dart:io';

import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/quest_details_page/details/quest_details_page.dart';
import 'package:app/ui/pages/main_page/quest_page/create_quest_page/store/create_quest_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/ui/widgets/media_upload_widget.dart';
import 'package:app/ui/widgets/skill_specialization_selection/skill_specialization_selection.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import "package:provider/provider.dart";
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../enums.dart';
import '../../../../../observer_consumer.dart';

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

  bool isEdit = false;

  void initState() {
    super.initState();
    profile = context.read<ProfileMeStore>();
    if (widget.questInfo != null) {
      this.isEdit = true;
      final store = context.read<CreateQuestStore>();
      store.priority = store.priorityList[widget.questInfo!.priority - 1];
      store.category = widget.questInfo?.category ?? "";
      store.questTitle = widget.questInfo!.title;
      store.getWorkplace(widget.questInfo!.workplace);
      store.getEmployment(widget.questInfo!.employment);
      store.description = widget.questInfo!.description;
      store.price = widget.questInfo!.price;
      store.locationPlaceName = widget.questInfo!.locationPlaceName;
      store.mediaIds = ObservableList.of(widget.questInfo!.medias!);
      _controller = SkillSpecializationController(
          initialValue: widget.questInfo!.questSpecializations);
    } else
      _controller = SkillSpecializationController();
  }

  Widget build(context) {
    final store = context.read<CreateQuestStore>();

    final questStore = context.read<MyQuestStore>();

    return Form(
      key: _formKey,
      child: Scaffold(
        body: CustomScrollView(
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
                      "Runtime",
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
                                  children: store.priorityList,
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
                                    items:
                                        store.priorityList.map<DropdownMenuItem<String>>(
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
                    SkillSpecializationSelection(controller: _controller),
                    titledField(
                      "quests.address".tr(),
                      Observer(
                        builder: (_) => GestureDetector(
                          onTap: () {
                            store.getPrediction(context);
                          },
                          child: Container(
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
                    // titledField(
                    //   "quests.runtime".tr(),
                    //   Container(
                    //     height: 50,
                    //     padding: EdgeInsets.symmetric(horizontal: 15.0),
                    //     decoration: BoxDecoration(
                    //       color: Color(0xFFF7F8FA),
                    //       borderRadius: BorderRadius.all(
                    //         Radius.circular(6.0),
                    //       ),
                    //     ),
                    //     alignment: Alignment.centerLeft,
                    //     child: Observer(
                    //       builder: (_) => Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           InkWell(
                    //             onTap: () {
                    //               store.decreaseRuntime();
                    //             },
                    //             child: Icon(
                    //               Icons.arrow_left,
                    //               size: 30,
                    //               color: Color(0xFFAAB0B9),
                    //             ),
                    //           ),
                    //           Text("qwe"),
                    //           InkWell(
                    //             onTap: () {
                    //               store.increaseRuntime();},
                    //             child: Icon(
                    //               Icons.arrow_right,
                    //               size: 30,
                    //               color: Color(0xFFAAB0B9),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
                                  children: store.employmentList,
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
                                    items: store.employmentList
                                        .map<DropdownMenuItem<String>>((String value) {
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
                                  children: store.distantWorkList,
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
                                    items: store.distantWorkList
                                        .map<DropdownMenuItem<String>>((String value) {
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
                      "quests.title".tr(),
                      Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        child: TextFormField(
                          onChanged: store.setQuestTitle,
                          validator: Validators.emptyValidator,
                          initialValue: store.questTitle,
                          maxLines: 1,
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
                        initialValue: store.description,
                        onChanged: store.setAboutQuest,
                        validator: Validators.emptyValidator,
                        keyboardType: TextInputType.multiline,
                        maxLines: 12,
                        decoration: InputDecoration(
                          hintText: 'quests.questText'.tr(),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),

                    ///Upload media
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                      ),
                      child: MediaUpload(
                        store.mediaIds,
                        mediaFile: store.mediaFile,
                      ),
                    ),
                    titledField(
                      "quests.price".tr(),
                      Container(
                        height: 50,
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
                        onSuccess: () async {
                          ///review
                          await questStore.getQuests(
                            profile!.userData!.id,
                            UserRole.Employer,
                            true,
                          );
                          if (isEdit) {
                            final updatedQuest =
                                await store.getQuest(widget.questInfo!.id);
                            Navigator.pushReplacementNamed(
                              context,
                              QuestDetails.routeName,
                              arguments: updatedQuest,
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
                                      store.skillFilters =
                                          _controller!.getSkillAndSpecialization();
                                      if (isEdit) {
                                        if (store.canSubmitEditQuest) {
                                          if (_formKey.currentState?.validate() ?? false)
                                            await store.createQuest(
                                              isEdit: true,
                                              questId: widget.questInfo!.id,
                                            );
                                        }
                                      } else if (store.canCreateQuest) {
                                        if (_formKey.currentState?.validate() ?? false)
                                          await store.createQuest();
                                      } else
                                        store.emptyField(context);
                                    },
                              title: isEdit ? "Edit Quest" : 'quests.createAQuest'.tr()),
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
    );
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
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                          initialItem: children.indexOf(value)),
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
