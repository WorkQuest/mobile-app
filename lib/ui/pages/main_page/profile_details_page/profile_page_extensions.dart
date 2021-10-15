import 'package:app/ui/pages/main_page/change_profile_page/change_profile_page.dart';
import 'package:app/ui/pages/main_page/my_quests_page/quests_list.dart';
import 'package:app/ui/pages/main_page/profile_details_page/pages/portfolio_page/create_portfolio_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/pages/profileMe_reviews_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/profile_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../enums.dart';

extension WorkerWidgets on ProfileReviewsState {
  List<Widget> workerWidgets() => [
        //_____________Skills______________/
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            'Your Skills',
            textAlign: TextAlign.start,
            style: style,
          ),
        ),
        (userStore!.userData!.skillFilters.isEmpty)
            ? Text(
                "No skills",
                style: style.copyWith(
                  color: Color(0xFF7C838D),
                  fontWeight: FontWeight.normal,
                ),
              )
            : skills(
                skills: userStore!.userData!.additionalInfo!.skills,
              ),

        spacer,

        //_____________About______________/
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            "About",
            style: style,
          ),
        ),
        Text(
          userStore!.userData?.additionalInfo?.description ?? "No description",
        ),

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

        (userStore!.userData!.additionalInfo!.educations.isNotEmpty)
            ? ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount:
                    userStore!.userData!.additionalInfo!.educations.length,
                itemBuilder: (_, index) {
                  final education =
                      userStore!.userData!.additionalInfo!.educations[index];
                  return experience(
                      place: education["place"] ?? "--",
                      from: education["from"] ?? "--",
                      to: education["to"] ?? "--");
                })
            : Text("No Information"),

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
        (userStore!.userData!.additionalInfo!.workExperiences.isNotEmpty)
            ? ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount:
                    userStore!.userData!.additionalInfo!.workExperiences.length,
                itemBuilder: (_, index) {
                  final userExperience = userStore!
                      .userData!.additionalInfo!.workExperiences[index];
                  return experience(
                      place: userExperience["place"] ?? "--",
                      from: userExperience["from"] ?? "--",
                      to: userExperience["to"] ?? "--");
                })
            : Text(
                "No Information",
                style: style.copyWith(
                  color: Color(0xFF7C838D),
                  fontWeight: FontWeight.normal,
                ),
              ),
      ];
}

extension CustomAppBar on ProfileReviewsState {
  Widget sliverAppBar() => SliverAppBar(
        backgroundColor: Color(0xFF0083C7),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pushNamed(
              ChangeProfilePage.routeName,
            ),
          ),
        ],
        centerTitle: false,
        pinned: true,
        expandedHeight: 250,
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.only(
            left: 16.0,
            bottom: 16.0,
            top: 0.0,
          ),
          collapseMode: CollapseMode.pin,
          centerTitle: false,
          background: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                userStore!.userData!.avatar!.url,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 85.0,
                left: 50.0,
                child: Row(
                  children: [
                    for (int i = 0;
                        i < userStore!.userData!.ratingStatistic;
                        i++)
                      Icon(
                        Icons.star,
                        color: Color(0xFFE8D20D),
                        size: 20.0,
                      ),
                    for (int i = 0;
                        i < 5 - userStore!.userData!.ratingStatistic;
                        i++)
                      Icon(
                        Icons.star,
                        color: Color(0xFFE9EDF2),
                        size: 20.0,
                      ),
                  ],
                ),
              ),
            ],
          ),
          title: appBarTitle(
            "${userStore!.userData!.firstName} ${userStore!.userData!.lastName ?? " "}",
          ),
        ),
      );
}

extension QuestPortfolio on ProfileReviewsState {
  Widget questPortfolio() => Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Material(
          color: const Color(0xFFF7F8FA),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ///Add new portfolio
              if (userStore!.userData!.role == UserRole.Worker)
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
                        const Text(
                          "Add new",
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        const Icon(
                          Icons.add,
                        ),
                      ],
                    ),
                  ),
                ),

              Expanded(
                child: Observer(
                  builder: (_) => userStore!.userData!.role == UserRole.Worker
                      ? Center(
                          child: portfolioStore!.portfolioList.isEmpty
                              ? Text("You do not have any  Portfolio")
                              : ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(
                                    top: 0.0,
                                  ),
                                  itemCount:
                                      portfolioStore!.portfolioList.length,
                                  itemBuilder: (context, index) =>
                                      PortfolioWidget(
                                    index: index,
                                    imageUrl: portfolioStore!
                                        .portfolioList[index].medias.first.url,
                                    title: portfolioStore!
                                        .portfolioList[index].title,
                                  ),
                                ),
                        )
                      : Center(
                          child: QuestsList(
                            QuestItemPriorityType.Performed,
                            myQuests?.performed,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      );
}

extension ReviewsTab on ProfileReviewsState {
  Widget reviewsTab() => Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Material(
          color: const Color(0xFFF7F8FA),
          child: portfolioStore!.reviewsList.isNotEmpty
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  //controller: _scrollController,
                  padding: const EdgeInsets.only(
                    top: 0.0,
                  ),
                  itemCount: portfolioStore!.reviewsList.length,
                  itemBuilder: (context, index) {
                    return ReviewsWidget(
                        name: "Edward cooper",
                        userRole: UserRole.Worker.toString().split(".").last,
                        questTitle: "SPA saloon design",
                        quest:
                            "Lorem ipsum dolor sit amet, consectetur adipiscing "
                            "elit ut aliquam, purus sit amet luctus venenatis, "
                            "lectus magna fringilla urna, porttitor rhoncus "
                            "dolor purus non enim praesent elementum.");
                  },
                )
              : Center(
                  child: Text(
                    "You have no reviews yet",
                  ),
                ),
        ),
      );
}
