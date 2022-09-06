import 'package:app/ui/pages/main_page/tabs/more/pages/change_profile_page/store/change_profile_store.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/change_profile_page/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class FieldForEmployerWorker extends StatefulWidget {
  final ChangeProfileStore store;

  const FieldForEmployerWorker({required this.store});

  @override
  State<FieldForEmployerWorker> createState() => _FieldForEmployerWorkerState();
}

class _FieldForEmployerWorkerState extends State<FieldForEmployerWorker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputWidget(
          title: "settings.workExps.CompanyName".tr(),
          initialValue: widget.store.userData.additionalInfo?.company ?? "",
          onChanged: (value) => widget.store.setCompanyName(value),
          maxLength: null,
        ),
        InputWidget(
          title: "settings.position".tr(),
          initialValue: widget.store.userData.additionalInfo?.ceo ?? "",
          onChanged: (value) => widget.store.setCeo(value),
          maxLength: null,
        ),
        InputWidget(
          title: "settings.site".tr(),
          initialValue: widget.store.userData.additionalInfo?.website ?? "",
          onChanged: (value) => widget.store.setWebsite(value),
          maxLength: null,
        ),
      ],
    );
  }
}
