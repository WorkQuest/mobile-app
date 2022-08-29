import 'package:app/constants.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/profile_visibility_page/store/profile_visibility_store.dart';
import 'package:app/ui/widgets/default_radio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RadioTileWidget extends StatelessWidget {
  final Function()? onPressed;
  final VisibilityTypes? type;
  final bool status;

  const RadioTileWidget({
    Key? key,
    required this.onPressed,
    required this.status,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ColoredBox(
        color: Colors.transparent,
        child: SizedBox(
          height: 36,
          width: double.infinity,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              DefaultRadio(status: status),
              const SizedBox(width: 10),
              Text(
                _getTitleType(type),
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColor.subtitleText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getTitleType(VisibilityTypes? type) {
    if (type == VisibilityTypes.notRated) {
      return 'settings.typesVisibly.notRated'.tr();
    } else if (type == VisibilityTypes.topRanked) {
      return 'settings.typesVisibly.topRanked'.tr();
    } else if (type == VisibilityTypes.reliable) {
      return 'settings.typesVisibly.reliable'.tr();
    } else if (type == VisibilityTypes.verified) {
      return 'settings.typesVisibly.verified'.tr();
    } else {
      return 'settings.typesVisibly.allUsers'.tr();
    }
  }
}
