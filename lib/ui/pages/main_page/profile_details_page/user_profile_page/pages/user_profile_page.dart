import 'package:app/enums.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/portfolio_page/store/portfolio_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/store/user_profile_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/widgets/profile_widgets.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/sliver_sticky_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';
import '../widgets/profile_page_extensions.dart';

class UserProfile extends StatefulWidget {
  static const String routeName = "/profileReviewPage";
  final ProfileMeResponse? info;

  UserProfile(this.info);

  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState<T extends UserProfile> extends State<T>
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

  ScrollController controllerMain = ScrollController();

  ProfileMeStore? userStore;
  PortfolioStore? portfolioStore;
  UserProfileStore? viewOtherUser;
  MyQuestStore? myQuests;
  late UserRole role;

  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 2);

    portfolioStore = context.read<PortfolioStore>();
    myQuests = context.read<MyQuestStore>();
    userStore = context.read<ProfileMeStore>();

    if (widget.info == null) {
      role = userStore!.userData?.role ?? UserRole.Worker;
      portfolioStore!.reviewsList.clear();
      portfolioStore!.offsetReview = 0;

      if (role == UserRole.Worker)
        portfolioStore!.getPortfolio(userId: userStore!.userData!.id);

      portfolioStore!.getReviews(userId: userStore!.userData!.id);
      myQuests!.getQuests(userStore!.userData!.id, role, true);
    } else {
      role = widget.info?.role ?? UserRole.Worker;
      viewOtherUser = context.read<UserProfileStore>();
      viewOtherUser!.offset = 0;
      viewOtherUser!.quests.clear();

      if (viewOtherUser!.quests.isEmpty)
        viewOtherUser!.getQuests(widget.info!.id, role);

      if (role == UserRole.Worker)
        portfolioStore!.getPortfolio(userId: widget.info!.id);
      portfolioStore!.getReviews(userId: widget.info!.id);
    }
  }

  @protected
  List<Widget> listWidgets() => [];

  @protected
  List<Widget> questPortfolio() => [];

  @protected
  List<Widget> addToQuest() => [];

  @protected
  List<Widget> employerRateWidgets() => [];

  @protected
  List<Widget> workerRateWidgets() => [];

  Widget wrapperTabBar(
    List<Widget> body, [
    bool getReviews = true,
  ]) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.atEdge) if (scrollNotification
                .metrics.pixels ==
            scrollNotification.metrics.maxScrollExtent) {
          if (widget.info == null) {
            print("123123123");
            //on your own profile
            if (getReviews && !portfolioStore!.isLoading)
              portfolioStore!.getReviews(
                userId: userStore!.userData!.id,
              );
            else if (role == UserRole.Worker)
              portfolioStore!.getPortfolio(
                userId: userStore!.userData!.id,
              );
            myQuests!.getQuests(userStore!.userData!.id, role, false);
          } else {
            //on another user profile
            viewOtherUser!.getQuests(widget.info!.id, role);
            if (getReviews && !portfolioStore!.isLoading)
              portfolioStore!.getReviews(
                userId: widget.info!.id,
              );
            else if (role == UserRole.Worker)
              portfolioStore!.getPortfolio(
                userId: widget.info!.id,
              );
          }
        }
        return false;
      },
      child: ListView(
        children: body,
      ),
    );
  }

  @protected
  String tabTitle = "";

  double appBarPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    // final userStore = context.read<ProfileMeStore>();
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          //Animate Padding
          if (controllerMain.offset < 240)
            setState(() {
              appBarPosition = 0.0;
            });
          if (controllerMain.offset > 0 && controllerMain.offset < 240)
            setState(() {
              appBarPosition = controllerMain.offset < 120 ? 0.0 : 25.0;
            });

          return false;
        },
        child: NestedScrollView(
          controller: controllerMain,
          physics: ClampingScrollPhysics(),
          headerSliverBuilder: (
            BuildContext context,
            bool innerBoxIsScrolled,
          ) {
            return <Widget>[
              //__________AppBar__________//
              sliverAppBar(widget.info),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: listWidgets(),
                      ),

                      ///Social Accounts
                      socialAccounts(
                        socialNetwork: widget.info == null
                            ? userStore!.userData?.additionalInfo?.socialNetwork
                            : widget.info!.additionalInfo?.socialNetwork,
                      ),

                      ///Contact Details
                      contactDetails(
                        location: widget.info == null
                            ? userStore!.userData?.additionalInfo?.address ??
                                ''
                            : widget.info!.additionalInfo?.address ?? "",
                        number: widget.info == null
                            ? userStore!.userData?.tempPhone?.fullPhone ??
                                userStore!.userData?.phone?.fullPhone ??
                                ""
                            : widget.info!.tempPhone?.fullPhone ??
                                widget.info!.phone?.fullPhone ??
                                "",
                        secondNumber: widget.info == null
                            ? userStore!.userData?.additionalInfo
                                    ?.secondMobileNumber?.fullPhone ??
                                ""
                            : widget.info!.additionalInfo?.secondMobileNumber
                                    ?.fullPhone ??
                                "",
                        email: widget.info == null
                            ? userStore!.userData?.email ?? " "
                            : widget.info!.email ?? " ",
                      ),

                      ...role == UserRole.Employer
                          ? employerRateWidgets()
                          : workerRateWidgets(),

                      ...addToQuest(),
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
                          "profiler.reviews".tr(),
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ),
                      Tab(
                        child: Text(
                          tabTitle,
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: Observer(
            builder: (_) => TabBarView(
              controller: this._tabController,
              children: <Widget>[
                ///Reviews Tab
                wrapperTabBar(
                  reviewsTab(),
                ),

                ///Portfolio and Quests
                wrapperTabBar(
                  questPortfolio(),
                  false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
