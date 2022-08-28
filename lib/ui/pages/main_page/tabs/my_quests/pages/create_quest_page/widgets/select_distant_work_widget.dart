import 'dart:io';

import 'package:app/ui/pages/main_page/tabs/my_quests/pages/create_quest_page/widgets/dropdown_with_modal_sheep_widget.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/create_quest_page/widgets/title_with_field.dart';
import 'package:app/utils/quest_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SelectDistantWorkWidget extends StatelessWidget {
  final String workplace;
  final dynamic Function(String?) onSelect;

  const SelectDistantWorkWidget({
    Key? key,
    required this.workplace,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('SelectDistantWorkWidget: $workplace');
    return TitleWithField(
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
        child: Platform.isIOS
            ? DropDownWithModalSheepWidget(
                value: QuestUtils.getWorkplace(workplace),
                children: QuestConstants.distantWorkList,
                onPressed: onSelect,
              )
            : DropdownButtonHideUnderline(
                child: DropdownButton(
                  isExpanded: true,
                  value: QuestUtils.getWorkplace(workplace),
                  onChanged: onSelect,
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
    );
  }
}
