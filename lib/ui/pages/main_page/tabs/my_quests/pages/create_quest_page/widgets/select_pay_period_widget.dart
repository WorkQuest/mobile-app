import 'dart:io';

import 'package:app/ui/pages/main_page/tabs/my_quests/pages/create_quest_page/widgets/dropdown_with_modal_sheep_widget.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/create_quest_page/widgets/title_with_field.dart';
import 'package:app/utils/quest_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SelectPayPeriodWidget extends StatelessWidget {
  final bool isEdit;
  final String payPeriod;
  final dynamic Function(String?) onSelect;

  const SelectPayPeriodWidget({
    Key? key,
    required this.isEdit,
    required this.payPeriod,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TitleWithField(
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
          child: Platform.isIOS
              ? DropDownWithModalSheepWidget(
                  value: QuestUtils.getPayPeriod(payPeriod),
                  children: QuestConstants.payPeriodList,
                  onPressed: onSelect,
                )
              : DropdownButtonHideUnderline(
                  child: DropdownButton(
                    isExpanded: true,
                    value: QuestUtils.getPayPeriod(payPeriod),
                    onChanged: onSelect,
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
    );
  }
}