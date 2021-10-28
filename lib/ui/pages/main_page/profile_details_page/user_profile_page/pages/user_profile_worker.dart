import 'package:app/ui/pages/main_page/profile_details_page/portfolio_page/create_portfolio_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/profileMe_reviews_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/store/user_profile_worker_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/widgets/profile_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class WorkerProfile extends ProfileReviews {
  //const WorkerProfile();

  @override
  _WorkerProfileState createState() => _WorkerProfileState();
}

class _WorkerProfileState extends ProfileReviewsState<ProfileReviews> {
  final String tabTitle = "profiler.portfolio".tr();

  final store = UserProfileWorkerStore();

  List<Widget> questPortfolio() => [
        ///Add new portfolio
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
                const Text("Add new"),
                const SizedBox(width: 5.0),
                const Icon(Icons.add),
              ],
            ),
          ),
        ),

        Observer(
          builder: (_) => portfolioStore!.portfolioList.isEmpty
              ? Text("profiler.dontHavePortfolio".tr())
              : Column(
                  children: [
                    for (int index = 0;
                        index < portfolioStore!.portfolioList.length;
                        index++)
                      PortfolioWidget(
                        index: index,
                        imageUrl: portfolioStore!
                                .portfolioList[index].medias.isEmpty
                            ? "https://app-ver1.workquest.co/_nuxt/img/logo.1baae1e.svg"
                            : portfolioStore!
                                .portfolioList[index].medias.first.url,
                        title: portfolioStore!.portfolioList[index].title,
                      ),
                  ],
                ),
        ),
      ];

  List<Widget> workerWidgets() => [
//_____________Skills______________/
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            "skills.yourSkills".tr(),
            textAlign: TextAlign.start,
            style: style,
          ),
        ),
        (userStore!.userData!.userSpecializations.isEmpty)
            ? Text(
                "skills.noSkills".tr(),
                style: style.copyWith(
                  color: Color(0xFF7C838D),
                  fontWeight: FontWeight.normal,
                ),
              )
            : skills(
                skills: store.parser(userStore!.userData!.userSpecializations),
                context: context,
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

  List<Widget> rateWidgets() => [
        rating(
          completedQuests: "12",
          averageRating: "4.5",
          reviews: "23",
        ),
      ];
}
