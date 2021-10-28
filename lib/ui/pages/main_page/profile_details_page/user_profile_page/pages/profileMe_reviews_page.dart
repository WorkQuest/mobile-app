import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/portfolio_page/store/portfolio_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/widgets/profile_widgets.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/sliver_sticky_tab_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';
import '../widgets/profile_page_extensions.dart';

class ProfileReviews extends StatefulWidget {
  static const String routeName = "/profileReviewPage";

  @override
  ProfileReviewsState createState() => ProfileReviewsState();
}

/// View Your own profile
class ProfileReviewsState<T extends StatefulWidget> extends State<T>
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
  ScrollController controllerTab = ScrollController();

  ProfileMeStore? userStore;
  PortfolioStore? portfolioStore;
  MyQuestStore? myQuests;
  late UserRole role;

  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    userStore = context.read<ProfileMeStore>();
    portfolioStore = context.read<PortfolioStore>();
    myQuests = context.read<MyQuestStore>();
    role = userStore!.userData?.role ?? UserRole.Employer;

    userStore!.getProfileMe().then((value) {
      setState(() => role = userStore!.userData!.role);
      myQuests!.getQuests(userStore!.userData!.id, role);
    });

    if (userStore!.userData!.role == UserRole.Worker)
      portfolioStore!.getPortfolio(
        userId: userStore!.userData!.id,
      );
    portfolioStore!.getReviews(
      userId: userStore!.userData!.id,
    );
  }

  @protected
  List<Widget> workerWidgets() => [];

  @protected
  List<Widget> employerWidgets() => [];

  @protected
  List<Widget> questPortfolio() => [];

  Widget wrapperTabBar(List<Widget> body) {
    return ListView(
      controller: controllerTab,
      physics: NeverScrollableScrollPhysics(),
      children: body,
    );
  }

  @protected
  String tabTitle = "";

  @override
  Widget build(BuildContext context) {
    final userStore = context.read<ProfileMeStore>();

    return Scaffold(
      body: CustomScrollView(
        controller: controllerMain,
        physics: ClampingScrollPhysics(),
        // headerSliverBuilder: (
        //   BuildContext context,
        //   bool innerBoxIsScrolled,
        // ) {
        //   return
        slivers: <Widget>[
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: userStore.userData!.role == UserRole.Worker
                        ? workerWidgets()
                        : employerWidgets(),
                  ),

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
                    email: userStore.userData?.email ?? " ",
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
          SliverFillRemaining(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (controllerMain.position.maxScrollExtent >
                    controllerMain.offset)
                  controllerMain
                      .jumpTo(controllerMain.offset - details.delta.dy);
                else if (0.0 > controllerTab.offset) {
                  controllerMain
                      .jumpTo(controllerMain.offset - details.delta.dy);
                } else if (controllerMain.position.maxScrollExtent >=
                    controllerMain.offset) {
                  controllerTab.jumpTo(controllerTab.offset - details.delta.dy);
                }
              },
              child: TabBarView(
                controller: this._tabController,
                children: <Widget>[
                  ///Reviews Tab
                  wrapperTabBar(reviewsTab()),

                  ///Portfolio and Quests
                  wrapperTabBar(
                    questPortfolio(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
