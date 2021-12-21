import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/ui/pages/main_page/my_quests_page/quests_list.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../enums.dart';

class EmployerProfile extends UserProfile {
  EmployerProfile(ProfileMeResponse? info) : super(info);

  @override
  _EmployerProfileState createState() => _EmployerProfileState();
}

class _EmployerProfileState extends UserProfileState<UserProfile> {
  final String tabTitle = "profiler.sidebar.quests".tr();

  List<Widget> questPortfolio() => [
        SizedBox(
          height: 20,
        ),
        myQuests?.performed != null
            ? QuestsList(
                QuestItemPriorityType.Performed,
                myQuests!.performed,
                physics: NeverScrollableScrollPhysics(),
                isLoading: myQuests!.isLoading,
              )
            : Center(
                child: Text(
                  "errors.emptyData.worker.myQuests.desc".tr(),
                ),
              ),
      ];

  @override
  List<Widget> listWidgets() => [
//_____________About______________/
        Text(
          widget.info == null
              ? userStore!.userData?.additionalInfo?.description ??
                  "modals.noDescription".tr()
              : widget.info!.additionalInfo?.description ??
                  "modals.noDescription".tr(),
        ),
      ];
}
