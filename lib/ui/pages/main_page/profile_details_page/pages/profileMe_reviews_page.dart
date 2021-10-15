import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/pages/portfolio_page/store/portfolio_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/profile_widgets.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/sliver_sticky_tab_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';
import '../profile_page_extensions.dart';

class ProfileReviews extends StatefulWidget {
  static const String routeName = "/profileReviewPage";

  @override
  ProfileReviewsState createState() => ProfileReviewsState();
}

/// View Your own profile
class ProfileReviewsState extends State<ProfileReviews>
    with SingleTickerProviderStateMixin {
  final TextStyle style = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
  );

  final Widget spacer = const SizedBox(
    height: 20.0,
  );

  late TabController _tabController;

  ProfileMeStore? userStore;
  PortfolioStore? portfolioStore;
  MyQuestStore? myQuests;
  late UserRole role;

  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 2,
    );
    userStore = context.read<ProfileMeStore>();
    portfolioStore = context.read<PortfolioStore>();
    myQuests = context.read<MyQuestStore>();
    role = userStore!.userData?.role ?? UserRole.Employer;

    userStore!.getProfileMe().then((value) {
      setState(() => role = userStore!.userData!.role);
      myQuests!.getQuests(
        userStore!.userData!.id,
        role,
      );
    });

    if (userStore!.userData!.role == UserRole.Worker)
      portfolioStore!.getPortfolio(
        userId: userStore!.userData!.id,
      );
    portfolioStore!.getReviews(
      userId: userStore!.userData!.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userStore = context.read<ProfileMeStore>();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (
          BuildContext context,
          bool innerBoxIsScrolled,
        ) {
          return <Widget>[
            //__________AppBar__________//
            sliverAppBar(),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                16.0,
                16.0,
                16.0,
                0.0,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    userStore.userData!.role == UserRole.Worker
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: workerWidgets(),
                          )
                        : Text("Employee Details"),

                    ///Social Accounts
                    socialAccounts(
                      socialNetwork:
                          userStore.userData?.additionalInfo?.socialNetwork,
                    ),

                    ///Contact Details
                    contactDetails(
                        location:
                            userStore.userData?.additionalInfo?.address ?? ' ',
                        number: userStore.userData?.phone ?? " ",
                        secondNumber: userStore
                                .userData?.additionalInfo?.secondMobileNumber ??
                            "",
                        email: userStore.userData?.email ?? " "),
                    rating(
                      completedQuests: "12",
                      averageRating: "4.5",
                      reviews: "23",
                    ),
                    spacer,
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: StickyTabBarDelegate(
                child: TabBar(
                  unselectedLabelColor: Color(0xFF8D96A1),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Colors.white,
                  ),
                  labelColor: Colors.black,
                  controller: this._tabController,
                  tabs: <Widget>[
                    Tab(
                      child: Text(
                        "workers.reviews".tr(),
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                    Tab(
                      child: Text(
                        userStore.userData!.role == UserRole.Worker
                            ? "profiler.portfolio".tr()
                            : "profiler.sidebar.quests".tr(),
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: this._tabController,
          children: <Widget>[
            ///Reviews Tab
            reviewsTab(),

            ///Portfolio and Quests
            questPortfolio()
          ],
        ),
      ),
    );
  }
}
