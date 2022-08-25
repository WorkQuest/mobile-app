import 'package:app/ui/pages/main_page/change_profile_page/store/change_profile_store.dart';
import 'package:app/ui/pages/main_page/change_profile_page/widgets/input_widget.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/knowledge_work_selection/knowledge_work_selection.dart';
import 'package:app/ui/widgets/skill_specialization_selection/skill_specialization_selection.dart';
import 'package:app/utils/profile_util.dart';
import 'package:app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:easy_localization/easy_localization.dart';

class FieldsForWorkerWidget extends StatefulWidget {
  final KnowledgeWorkSelectionController controllerKnowledge;
  final KnowledgeWorkSelectionController controllerWork;
  final SkillSpecializationController controller;
  final ChangeProfileStore pageStore;
  final ProfileMeStore profile;

  const FieldsForWorkerWidget({
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

class _FieldsForWorkerWidgetState extends State<FieldsForWorkerWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SkillSpecializationSelection(controller: widget.controller),
        Observer(
          builder: (_) => _dropDownMenuWidget(
            title: "settings.priority",
            value: widget.profile.priorityValue,
            list: ProfileConstants.priorityList,
            onChanged: (priority) {
              widget.profile.setPriorityValue(priority!);
            },
          ),
        ),
        InputWidget(
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
            list: ProfileConstants.distantWorkList,
            onChanged: (text) {
              widget.profile.setWorkplaceValue(text!);
            },
          ),
        ),
        Observer(
          builder: (_) => _dropDownMenuWidget(
            title: "quests.payPeriod.title",
            value: widget.profile.payPeriod,
            list: ProfileConstants.payPeriodLists,
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