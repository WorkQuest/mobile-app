import 'package:app/ui/pages/main_page/my_quests_page/quests_list.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/profileMe_reviews_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../enums.dart';

class EmployerProfile extends ProfileReviews {
  //const WorkerProfile();

  @override
  _EmployerProfileState createState() => _EmployerProfileState();
}

class _EmployerProfileState extends ProfileReviewsState<ProfileReviews> {
  final String tabTitle = "profiler.sidebar.quests".tr();

  Widget questPortfolio() => QuestsList(
        QuestItemPriorityType.Performed,
        myQuests?.performed,
      );

  List<Widget> employerWidgets() => [
//_____________About______________/
    Text(
      userStore!.userData?.additionalInfo?.description ?? "No description",
    ),
  ];
}
