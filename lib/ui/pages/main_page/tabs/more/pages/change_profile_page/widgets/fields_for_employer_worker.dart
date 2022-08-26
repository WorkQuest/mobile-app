import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/change_profile_page/store/change_profile_store.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/change_profile_page/widgets/input_widget.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class FieldForEmployerWorker extends StatefulWidget {
  final ChangeProfileStore pageStore;
  final ProfileMeStore profile;

  const FieldForEmployerWorker({
    required this.pageStore,
    required this.profile,
  });

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
          initialValue: widget.pageStore.userData.additionalInfo?.company ?? "",
          onChanged: (text) {
            ProfileMeResponse data = widget.pageStore.userData;
            data.additionalInfo?.company = text;
            widget.pageStore.setUserData(data);
          },
          maxLength: null,
        ),
        InputWidget(
          title: "settings.position".tr(),
          initialValue: widget.pageStore.userData.additionalInfo?.ceo ?? "",
          onChanged: (text) {
            ProfileMeResponse data = widget.pageStore.userData;
            data.additionalInfo?.ceo = text;
            widget.pageStore.setUserData(data);
          },
          maxLength: null,
        ),
        InputWidget(
          title: "settings.site".tr(),
          initialValue: widget.pageStore.userData.additionalInfo?.website ?? "",
          onChanged: (text) {
            ProfileMeResponse data = widget.pageStore.userData;
            data.additionalInfo?.website = text;
            widget.pageStore.setUserData(data);
          },
          maxLength: null,
        ),
      ],
    );
  }
}
