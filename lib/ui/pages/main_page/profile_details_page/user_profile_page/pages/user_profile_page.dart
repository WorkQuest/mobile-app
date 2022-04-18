import 'dart:async';

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
  late StreamController<AppBarParams> _streamController;

  ProfileMeStore? userStore;
  PortfolioStore? portfolioStore;
  UserProfileStore? viewOtherUser;
  MyQuestStore? myQuests;
  late UserRole role;
  late bool isVerify;

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 2);
    _streamController = StreamController<AppBarParams>();

    portfolioStore = context.read<PortfolioStore>();
    myQuests = context.read<MyQuestStore>();
    userStore = context.read<ProfileMeStore>();

    portfolioStore!.clearData();

    if (widget.info == null) {
      role = userStore!.userData?.role ?? UserRole.Worker;

      if (role == UserRole.Worker)
        portfolioStore!.getPortfolio(
          userId: userStore!.userData!.id,
          newList: true,
        );

      portfolioStore!.getReviews(
        userId: userStore!.userData!.id,
        newList: true,
      );
      portfolioStore!.setOtherUserData(userStore!.userData);
      myQuests!.getQuests(userStore!.userData!.id, role, true);
    } else {
      role = widget.info?.role ?? UserRole.Worker;
      viewOtherUser = context.read<UserProfileStore>();
      viewOtherUser!.offset = 0;
      viewOtherUser!.quests.clear();

      portfolioStore!.setOtherUserData(widget.info);

      if (viewOtherUser!.quests.isEmpty)
        viewOtherUser!.getQuests(widget.info!.id, role, true);

      if (role == UserRole.Worker)
        portfolioStore!.getPortfolio(userId: widget.info!.id, newList: true);
      portfolioStore!.getReviews(userId: widget.info!.id, newList: true);
      portfolioStore!.setOtherUserData(widget.info);
    }
    isVerify = widget.info == null
        ? userStore!.userData?.phone != null
        : widget.info?.phone != null;
  }

  @protected
  List<Widget> listWidgets() => [];

  @protected
  List<Widget> questPortfolio() => [];

  @protected
  List<Widget> addToQuest() => [];

  @protected
  List<Widget> ratingsWidget() => [];

  Widget wrapperTabBar(
    List<Widget> body,
    String name, [
    bool getReviews = true,
  ]) {
    ScrollController _controller = ScrollController();
    return NotificationListener<ScrollEndNotification>(
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        controller: _controller,
        children: body,
      ),
    );
  }

  @protected
  String tabTitle = "";

  double appBarPosition = 0.0;

  double width = 240.0;

  double appBarPositionVertical = 16.0;

  double pastPosition = 0.0;
  double presentPosition = 0.0;

  ScrollController reviewController = ScrollController();
  ScrollController questController = ScrollController();
  ScrollController disabledController = ScrollController();

  double scrollPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (controllerMain.offset < 180) {
              double width = 240 + (controllerMain.offset.round() / 200 * 60);
              double appBarPosition = controllerMain.offset.round() / 200 * 28;
              double appBarPositionVertical =
                  (controllerMain.offset.round() / 200 * 10);
              _streamController.sink.add(
                  AppBarParams(width, appBarPosition, appBarPositionVertical));
            }
            return false;
          },
          child: NestedScrollView(
            controller: controllerMain,
            headerSliverBuilder: (
              BuildContext context,
              bool innerBoxIsScrolled,
            ) {
              return <Widget>[
                //__________AppBar__________//
                sliverAppBar(widget.info, _streamController, _update),
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
                              ? userStore!.userData?.additionalInfo?.address ?? ''
                              : widget.info!.additionalInfo?.address ?? "",
                          number: widget.info == null
                              ? userStore!.userData?.phone?.fullPhone ??
                                  userStore!.userData?.tempPhone?.fullPhone ??
                                  ""
                              : widget.info?.phone?.fullPhone ??
                                  widget.info!.tempPhone?.fullPhone ??
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
                          isVerify: isVerify,
                        ),

                        ...ratingsWidget(),

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
                  wrapperTabBar(reviewsTab(), "reviews"),

                  ///Portfolio and Quests
                  wrapperTabBar(questPortfolio(), "quest", false),
                ],
              ),
            ),
          ),
        ),
      );
  }

  _update() {
    setState(() {});
  }
}

class AppBarParams {
  double width;
  double appBarPosition;
  double appBarPositionVertical;

  AppBarParams(this.width, this.appBarPosition, this.appBarPositionVertical);

  factory AppBarParams.initial() {
    return AppBarParams(240.0, 0.0, 16.0);
  }
}
