import 'package:app/enums.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/portfolio_page/store/portfolio_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/widgets/profile_widgets.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/sliver_sticky_tab_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';
import '../widgets/profile_page_extensions.dart';

class ProfileReviews extends StatefulWidget {
  static const String routeName = "/profileReviewPage";
  final ProfileMeResponse? info;

  ProfileReviews(this.info);

  @override
  ProfileReviewsState createState() => ProfileReviewsState();
}

/// View Your own profile
class ProfileReviewsState<T extends ProfileReviews> extends State<T>
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
    portfolioStore = context.read<PortfolioStore>();
    myQuests = context.read<MyQuestStore>();
    userStore = context.read<ProfileMeStore>();
    if (widget.info == null) {
      role = userStore!.userData?.role ?? UserRole.Worker;

      userStore!.getProfileMe().then((value) {
        setState(() => role = userStore!.userData!.role);
        myQuests!.getQuests(userStore!.userData!.id, role, true);
      });

      if (role == UserRole.Worker)
        portfolioStore!.getPortfolio(
          userId: userStore!.userData!.id,
        );
      portfolioStore!.getReviews(
        userId: userStore!.userData!.id,
      );
    } else {
      role = widget.info?.role ?? UserRole.Worker;

      userStore!.getProfileMe().then((value) {
        setState(() => role = widget.info!.role);
        myQuests!.getQuests(widget.info!.id, role, true);
      });

      if (role == UserRole.Worker)
        portfolioStore!.getPortfolio(
          userId: widget.info!.id,
        );
      portfolioStore!.getReviews(
        userId: widget.info!.id,
      );
    }
  }

  @protected
  List<Widget> listWidgets() => [];

  @protected
  List<Widget> questPortfolio() => [];

  Widget wrapperTabBar(List<Widget> body) {
    return ListView(
      controller: controllerTab,
      children: body,
    );
  }

  @protected
  String tabTitle = "";

  double appBarPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    final userStore = context.read<ProfileMeStore>();
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (controllerMain.offset < 240)
            setState(() {
              appBarPosition = 0.0;
            });
          if (controllerMain.offset > 0 && controllerMain.offset < 240)
            setState(() {
              appBarPosition = controllerMain.offset < 120 ? 0.0 : 25.0;
              // print(appBarPosition);
            });
          return true;
        },
        child: CustomScrollView(
          controller: controllerMain,
          physics: ClampingScrollPhysics(),
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
                        children: listWidgets()),

                    ///Social Accounts
                    socialAccounts(
                      socialNetwork: widget.info == null
                          ? userStore.userData?.additionalInfo?.socialNetwork
                          : widget.info!.additionalInfo?.socialNetwork,
                    ),

                    ///Contact Details
                    contactDetails(
                      location: widget.info == null
                          ? userStore.userData?.additionalInfo?.address ?? ' '
                          : widget.info!.additionalInfo?.address ?? " ",
                      number: widget.info == null
                          ? userStore.userData?.phone ?? " "
                          : widget.info!.phone ?? " ",
                      secondNumber: widget.info == null
                          ? userStore.userData?.additionalInfo
                                  ?.secondMobileNumber ??
                              ""
                          : widget.info!.additionalInfo?.secondMobileNumber ??
                              "",
                      email: widget.info == null
                          ? userStore.userData?.email ?? " "
                          : widget.info!.email ?? " ",
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
                    controllerTab
                        .jumpTo(controllerTab.offset - details.delta.dy);
                  }
                },
                child: Observer(
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
