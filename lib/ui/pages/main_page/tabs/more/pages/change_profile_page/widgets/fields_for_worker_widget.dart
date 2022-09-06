import 'package:app/ui/pages/main_page/tabs/more/pages/change_profile_page/store/change_profile_store.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/change_profile_page/widgets/input_widget.dart';
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
  final ChangeProfileStore store;

  const FieldsForWorkerWidget({
    Key? key,
    required this.controllerKnowledge,
    required this.controllerWork,
    required this.controller,
    required this.store,
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
            value: ProfileUtils.priorityToValue(widget.store.userData.priority),
            list: ProfileConstants.priorityList,
            onChanged: (value) => widget.store.setPriority(ProfileUtils.valueToPriority(value!)),
          ),
        ),
        InputWidget(
          title: "settings.costPerHour".tr(),
          initialValue: widget.store.userData.costPerHour,
          onChanged: (value) => widget.store.setPerHour(value),
          validator: Validators.emptyValidator,
          inputType: TextInputType.number,
          maxLength: null,
        ),
        Observer(
          builder: (_) => _dropDownMenuWidget(
            title: "settings.distantWork",
            value: widget.store.userData.workplace ?? 'Remote work',
            list: ProfileConstants.distantWorkList,
            onChanged: (value) => widget.store.setWorkplace(value!),
          ),
        ),
        Observer(
          builder: (_) => _dropDownMenuWidget(
            title: "quests.payPeriod.title",
            value: ProfileUtils.payPeriodToValue(widget.store.userData.payPeriod),
            list: ProfileConstants.payPeriodLists,
            onChanged: (value) => widget.store.setPayPeriod(ProfileUtils.valueToPayPeriod(value!)),
          ),
        ),
        KnowledgeWorkSelection(
          title: "Knowledge",
          hintText: "settings.education.educationalInstitution".tr(),
          controller: widget.controllerKnowledge,
          data: widget.store.userData.additionalInfo?.educations,
        ),
        KnowledgeWorkSelection(
          title: "Work experience",
          hintText: "Work place",
          controller: widget.controllerWork,
          data: widget.store.userData.additionalInfo?.workExperiences,
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
