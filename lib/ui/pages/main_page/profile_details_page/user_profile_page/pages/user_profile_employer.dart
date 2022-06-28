import 'package:app/ui/pages/main_page/my_quests_page/quests_list.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/profile_quests_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/widgets/profile_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../../../../enums.dart';

class EmployerProfile extends UserProfile {
  EmployerProfile(ProfileArguments? arguments) : super(arguments);

  @override
  _EmployerProfileState createState() => _EmployerProfileState();
}

class _EmployerProfileState extends UserProfileState<UserProfile> {
  final String tabTitle = "profiler.sidebar.quests".tr();

  List<Widget> questPortfolio() => [
        SizedBox(
          height: 20,
        ),
        myQuests?.quests[QuestsType.Performed] != null ||
                (viewOtherUser?.quests.isNotEmpty ?? false)
            ? QuestsList(
                QuestsType.Performed,
                viewOtherUser?.userData == null
                    ? ObservableList.of(
                        myQuests!.quests[QuestsType.Performed]!.take(2))
                    : ObservableList.of(viewOtherUser!.quests.take(2)),
                physics: NeverScrollableScrollPhysics(),
                isLoading: myQuests!.isLoading,
                short: true,
                from: FromQuestList.questSearch,
                role: viewOtherUser?.userData == null
                    ? userStore!.userData!.role
                    : viewOtherUser!.userData!.role,
              )
            : Center(
                child: Text(
                  viewOtherUser?.userData == null
                      ? "errors.emptyData.worker.myQuests.desc".tr()
                      : "errors.emptyData.worker.myQuests.noQuest".tr(),
                ),
              ),
        if ((myQuests!.quests[QuestsType.Performed]?.isNotEmpty ?? false) ||
            (viewOtherUser?.quests.isNotEmpty ?? false))
          Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
            ),
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.pushNamed(
                  context,
                  ProfileQuestsPage.routeName,
                  arguments: viewOtherUser?.userData == null
                      ? userStore!.userData!
                      : viewOtherUser!.userData!,
                );
                if (viewOtherUser?.userData == null)
                  myQuests!.getQuests(
                    QuestsType.Performed,
                    userStore!.userData!.role,
                    true,
                  );
                else
                  portfolioStore!.getReviews(
                    userId: viewOtherUser!.userData!.id,
                    newList: true,
                  );
              },
              child: Text(
                "meta.showAllQuests".tr(),
              ),
            ),
          ),
      ];

  @override
  List<Widget> listWidgets() => [
//_____________About______________/
        Text(
          viewOtherUser?.userData == null
              ? userStore!.userData?.additionalInfo?.description ??
                  "modals.noDescription".tr()
              : viewOtherUser!.userData!.additionalInfo?.description ??
                  "modals.noDescription".tr(),
        ),
      ];

  List<Widget> ratingsWidget() => [
        employerRating(
          completedQuests: viewOtherUser?.userData == null
              ? userStore!.userData!.questsStatistic != null
                  ? userStore!.userData!.questsStatistic!.completed.toString()
                  : '0'
              : viewOtherUser!.userData!.questsStatistic != null
                  ? viewOtherUser!.userData!.questsStatistic!.completed
                      .toString()
                  : '0',
          averageRating: viewOtherUser?.userData == null
              ? userStore!.userData!.ratingStatistic!.averageMark
              : viewOtherUser!.userData!.ratingStatistic!.averageMark,
          reviews: viewOtherUser?.userData == null
              ? userStore!.userData!.ratingStatistic!.reviewCount.toString()
              : viewOtherUser!.userData!.ratingStatistic!.reviewCount
                  .toString(),
          userId: viewOtherUser?.userData == null
              ? userStore!.userData!.id
              : viewOtherUser!.userData!.id,
          context: context,
        ),
      ];
}
