import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/ui/pages/main_page/my_quests_page/quests_list.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/profileMe_reviews_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../enums.dart';

class EmployerProfile extends ProfileReviews {

  EmployerProfile(ProfileMeResponse? info):super(info);
  //final ProfileMeResponse? questInfo;
   //EmployerProfile(this.questInfo):super(questInfo: questInfo);

  @override
  _EmployerProfileState createState() => _EmployerProfileState();
}

class _EmployerProfileState extends ProfileReviewsState<ProfileReviews> {
  final String tabTitle = "profiler.sidebar.quests".tr();


  List<Widget> questPortfolio() => [
        SizedBox(
          height: 20,
        ),
        myQuests?.performed != null
            ? QuestsList(
                QuestItemPriorityType.Performed,
                myQuests?.performed,
                physics: NeverScrollableScrollPhysics(),
              )
            : Center(
                child: Text(
                  "errors.emptyData.worker.myQuests.desc".tr(),
                ),
              ),
      ];

  List<Widget> employerWidgets() => [
//_____________About______________/
        Text(
          userStore!.userData?.additionalInfo?.description ??
              "modals.noDescription".tr(),
        ),
      ];
}
