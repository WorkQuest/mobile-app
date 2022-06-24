import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/profile_details_page/portfolio_page/create_portfolio_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/choose_quest/choose_quest_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/review_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/store/user_profile_worker_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/widgets/profile_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';

import '../../../raise_views_page/raise_views_page.dart';

import '../../../../../widgets/animation_show_more.dart';

class WorkerProfile extends UserProfile {
  WorkerProfile(ProfileArguments? arguments) : super(arguments);

  @override
  _WorkerProfileState createState() => _WorkerProfileState();
}

class _WorkerProfileState extends UserProfileState<UserProfile> {
  final String tabTitle = "profiler.portfolio".tr();

  final store = UserProfileWorkerStore();

  List<Widget> questPortfolio() => [
        ///Add new portfolio
        if (viewOtherUser?.userData == null)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            child: OutlinedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                CreatePortfolioPage.routeName,
                arguments: false,
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: Colors.blueAccent.withOpacity(0.3),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "quests.addNew".tr(),
                  ),
                  const SizedBox(width: 5.0),
                  const Icon(Icons.add),
                ],
              ),
            ),
          ),

        Observer(
          builder: (_) => portfolioStore!.portfolioList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 18.0,
                      ),
                      SvgPicture.asset(
                        "assets/empty_quest_icon.svg",
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "profiler.dontHavePortfolioOtherUser".tr(),
                        style: TextStyle(
                          color: Color(0xFFD8DFE3),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    for (int index = 0;
                        index <
                            (portfolioStore!.portfolioList.length < 3
                                ? portfolioStore!.portfolioList.length
                                : 3);
                        index++)
                      PortfolioWidget(
                        index: index,
                        imageUrl: portfolioStore!
                                .portfolioList[index].medias.isEmpty
                            ? "https://testnet-app.workquest.co/_nuxt/img/logo.1baae1e.svg"
                            : portfolioStore!
                                .portfolioList[index].medias.first.url,
                        title: portfolioStore!.portfolioList[index].title,
                        isProfileYour:
                            viewOtherUser?.userData == null ? true : false,
                      ),
                  ],
                ),
        ),

        if (portfolioStore!.portfolioList.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
            ),
            child: ElevatedButton(
              onPressed: () async {
                portfolioStore!.setTitleName("Portfolio");
                await Navigator.pushNamed(
                  context,
                  ReviewPage.routeName,
                  arguments: ReviewPageArguments(
                    userId: widget.arguments?.userId == null
                        ? userStore!.userData!.id
                        : widget.arguments!.userId,
                    role: widget.arguments?.userId == null
                        ? userStore!.userData!.role
                        : widget.arguments!.role,
                    store: portfolioStore!,
                  ),
                );
                await portfolioStore!.getPortfolio(
                  userId: viewOtherUser?.userData == null
                      ? userStore!.userData!.id: viewOtherUser!.userData!.id,
                  newList: true,
                );
              },
              child: Text(
                "meta.showAllReviews".tr(),
              ),
            ),
          ),
      ];

  @override
  List<Widget> listWidgets() => [
//_____________Skills______________/
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            viewOtherUser?.userData == null
                ? "skills.yourSkills".tr()
                : "skills.title".tr(),
            textAlign: TextAlign.start,
            style: style,
          ),
        ),
        viewOtherUser?.userData == null
            ? (userStore!.userData!.userSpecializations.isEmpty)
                ? Text(
                    "skills.noSkills".tr(),
                    style: style.copyWith(
                      color: Color(0xFF7C838D),
                      fontWeight: FontWeight.normal,
                    ),
                  )
                : Observer(
                    builder: (_) => SkillsWidget(
                      skills: store
                          .parser(userStore!.userData!.userSpecializations),
                      isProfileMy: true,
                      isExpanded: store.expandedSkills ||
                          userStore!.userData!.userSpecializations.length < 5,
                      onPressed: (bool value) {
                        store.setExpandedSkills(value);
                      },
                    ),
                  )
            : (viewOtherUser!.userData!.userSpecializations.isEmpty)
                ? Text(
                    "skills.noSkills".tr(),
                    style: style.copyWith(
                      color: Color(0xFF7C838D),
                      fontWeight: FontWeight.normal,
                    ),
                  )
                : Observer(
                    builder: (_) => SkillsWidget(
                      skills: store
                          .parser(viewOtherUser!.userData!.userSpecializations),
                      isProfileMy: false,
                      isExpanded: store.expandedSkills ||
                          userStore!.userData!.userSpecializations.length < 5,
                      onPressed: (bool value) {
                        store.setExpandedSkills(value);
                      },
                    ),
                  ),

        spacer,

//_____________About______________/
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            "about.about".tr(),
            style: style,
          ),
        ),
        Observer(builder: (_) {
          final description = viewOtherUser?.userData == null
              ? userStore!.userData?.additionalInfo?.description ??
                  "modals.noDescription".tr()
              : viewOtherUser!.userData!.additionalInfo?.description ??
                  "modals.noDescription".tr();
          return AnimationShowMore(
            text: description,
            enabled: store.expandedDescription || description.length < 100,
            onShowMore: (value) => store.setExpandedDescription(value),
          );
        }),

        spacer,

//_____________Education______________/
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            "settings.educations".tr(),
            style: style.copyWith(
              fontSize: 14,
            ),
          ),
        ),
        viewOtherUser?.userData == null
            ? (userStore!.userData!.additionalInfo!.educations.isNotEmpty)
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:
                        userStore!.userData!.additionalInfo!.educations.length,
                    itemBuilder: (_, index) {
                      final education = userStore!
                          .userData!.additionalInfo!.educations[index];
                      return experience(
                          place: education["place"] ?? "--",
                          from: education["from"] ?? "--",
                          to: education["to"] ?? "--");
                    })
                : Text(
                    "profiler.noInformation".tr(),
                  )
            : (viewOtherUser!.userData!.additionalInfo!.educations.isNotEmpty)
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: viewOtherUser!
                        .userData!.additionalInfo!.educations.length,
                    itemBuilder: (_, index) {
                      final education = viewOtherUser!
                          .userData!.additionalInfo!.educations[index];
                      return experience(
                          place: education["place"] ?? "--",
                          from: education["from"] ?? "--",
                          to: education["to"] ?? "--");
                    },
                  )
                : Text(
                    "profiler.noInformation".tr(),
                  ),

        spacer,

//_____________Work Experience______________/
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            "settings.workExp".tr(),
            style: style.copyWith(
              fontSize: 14,
            ),
          ),
        ),
        viewOtherUser?.userData == null
            ? (userStore!.userData!.additionalInfo!.workExperiences.isNotEmpty)
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: userStore!
                        .userData!.additionalInfo!.workExperiences.length,
                    itemBuilder: (_, index) {
                      final userExperience = userStore!
                          .userData!.additionalInfo!.workExperiences[index];
                      return experience(
                          place: userExperience["place"] ?? "--",
                          from: userExperience["from"] ?? "--",
                          to: userExperience["to"] ?? "--");
                    })
                : Text(
                    "profiler.noInformation".tr(),
                    style: style.copyWith(
                      color: Color(0xFF7C838D),
                      fontWeight: FontWeight.normal,
                    ),
                  )
            : (viewOtherUser!
                    .userData!.additionalInfo!.workExperiences.isNotEmpty)
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: viewOtherUser!
                        .userData!.additionalInfo!.workExperiences.length,
                    itemBuilder: (_, index) {
                      final userExperience = viewOtherUser!
                          .userData!.additionalInfo!.workExperiences[index];
                      return experience(
                          place: userExperience["place"] ?? "--",
                          from: userExperience["from"] ?? "--",
                          to: userExperience["to"] ?? "--");
                    })
                : Text(
                    "profiler.noInformation".tr(),
                    style: style.copyWith(
                      color: Color(0xFF7C838D),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
      ];

  List<Widget> addToQuest() => [
        if (viewOtherUser?.userData != null &&
            userStore!.userData!.role == UserRole.Employer)
          Column(
            children: [
              spacer,
              ElevatedButton(
                onPressed: () async {
                  viewOtherUser!.offset = 0;
                  viewOtherUser!.quests.clear();
                  viewOtherUser!.questId = "";
                  viewOtherUser!.workerId = viewOtherUser!.userData!.id;
                  await Navigator.of(context, rootNavigator: true).pushNamed(
                    ChooseQuestPage.routeName,
                    arguments: ChooseQuestArguments(
                      workerId: viewOtherUser!.userData!.id,
                      workerAddress: viewOtherUser!.userData!.walletAddress!,
                    ),
                  );
                  viewOtherUser!.quests.clear();
                  viewOtherUser!.offset = 0;
                },
                child: Text(
                  "quests.addToQuest".tr(),
                ),
              ),
            ],
          ),
        if (viewOtherUser?.userData == null)
          Column(
            children: [
              spacer,
              ElevatedButton(
                onPressed: () async {
                  await Navigator.of(context, rootNavigator: true).pushNamed(
                    RaiseViews.routeName,
                    arguments: "",
                  );
                },
                child: Text(
                  "profiler.raiseViews".tr(),
                ),
              ),
            ],
          ),
      ];

  List<Widget> ratingsWidget() => [
        workerRating(
          completedQuests: viewOtherUser?.userData == null
              ? userStore!.userData!.questsStatistic == null
                  ? '0'
                  : userStore!.userData!.questsStatistic!.completed.toString()
              : viewOtherUser!.userData!.questsStatistic == null
                  ? '0'
                  : viewOtherUser!.userData!.questsStatistic!.completed
                      .toString(),
          activeQuests: viewOtherUser?.userData == null
              ? userStore!.userData!.questsStatistic == null
                  ? '0'
                  : userStore!.userData!.questsStatistic!.opened.toString()
              : viewOtherUser!.userData!.questsStatistic == null
                  ? '0'
                  : viewOtherUser!.userData!.questsStatistic!.opened.toString(),
          averageRating: viewOtherUser?.userData == null
              ? userStore!.userData!.ratingStatistic!.averageMark
              : viewOtherUser!.userData!.ratingStatistic!.averageMark,
          reviews: viewOtherUser?.userData == null
              ? userStore!.userData!.ratingStatistic!.reviewCount.toString()
              : viewOtherUser!.userData!.ratingStatistic!.reviewCount
                  .toString(),
          userId: viewOtherUser?.userData == null
              ? userStore!.userData!.id: viewOtherUser!.userData!.id,
          context: context,
        ),
      ];
}
