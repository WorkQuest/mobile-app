import 'package:app/ui/pages/main_page/tabs/my_quests/pages/create_quest_page/widgets/title_with_field.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/create_quest_page/widgets/warning_field_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SelectAddressWidget extends StatelessWidget {
  final Function() onPressed;
  final bool warningEnabled;
  final String locationName;
  final bool defaultValue;
  final Key keyField;

  const SelectAddressWidget({
    Key? key,
    required this.warningEnabled,
    required this.keyField,
    required this.defaultValue,
    required this.locationName,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WarningFields(
      warningEnabled: warningEnabled,
      errorMessage: 'quests.addressRequired'.tr(),
      child: TitleWithField(
        "quests.address".tr(),
        GestureDetector(
          onTap: onPressed,
          child: Container(
            key: keyField,
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
                  child: defaultValue
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
                          locationName,
                          overflow: TextOverflow.fade,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
