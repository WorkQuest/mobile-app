import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/change_profile_page/change_profile_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/pages/portfolio_page/create_portfolio_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/pages/portfolio_page/store/portfolio_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/profile_widgets.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/sliver_sticky_tab_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

class ProfileReviews extends StatefulWidget {
  static const String routeName = "/profileReviewPage";

  @override
  _ProfileReviewsState createState() => _ProfileReviewsState();
}

/// View Your own profile
class _ProfileReviewsState extends State<ProfileReviews>
    with SingleTickerProviderStateMixin {
  final TextStyle _style = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
  );

  final Widget _spacer = const SizedBox(
    height: 20.0,
  );

  late TabController _tabController;

  ProfileMeStore? userStore;
  PortfolioStore? portfolioStore;

  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 2,
    );
    userStore = context.read<ProfileMeStore>();
    portfolioStore = context.read<PortfolioStore>();
    if (userStore!.userData!.role == UserRole.Worker)
      portfolioStore!.getPortfolio(
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
            SliverAppBar(
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
                  onPressed: () => Navigator.of(context, rootNavigator: true)
                      .pushNamed(ChangeProfilePage.routeName),
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
                      userStore.userData!.avatar!.url,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 85.0,
                      left: 50.0,
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Color(0xFFE8D20D),
                            size: 20.0,
                          ),
                          Icon(
                            Icons.star,
                            color: Color(0xFFE8D20D),
                            size: 20.0,
                          ),
                          Icon(
                            Icons.star,
                            color: Color(0xFFE8D20D),
                            size: 20.0,
                          ),
                          Icon(
                            Icons.star,
                            color: Color(0xFFE8D20D),
                            size: 20.0,
                          ),
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
                  "${userStore.userData!.firstName} ${userStore.userData!.lastName ?? " "}",
                ),
              ),
            ),
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
                        ?

                        /// Column for Worker Specific Data
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ///Skills Column
                              ///
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Text(
                                  'Your Skills',
                                  textAlign: TextAlign.start,
                                  style: _style,
                                ),
                              ),
                              (userStore.userData!.additionalInfo!.skills!
                                      .isEmpty)
                                  ? Text(
                                      "No skills",
                                      style: _style.copyWith(
                                        color: Color(0xFF7C838D),
                                        fontWeight: FontWeight.normal,
                                      ),
                                    )
                                  : skills(
                                      skills: userStore
                                          .userData!.additionalInfo!.skills!,
                                    ),

                              _spacer,

                              ///About Column
                              ///
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  "About",
                                  style: _style,
                                ),
                              ),
                              Text(
                                userStore.userData?.additionalInfo
                                        ?.description ??
                                    "No description",
                              ),

                              _spacer,

                              ///Education
                              ///
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  "settings.educations".tr(),
                                  style: _style.copyWith(
                                    fontSize: 14,
                                  ),
                                ),
                              ),

                              (userStore.userData!.additionalInfo!.educations!
                                      .isNotEmpty)
                                  ? ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: userStore.userData!
                                          .additionalInfo!.educations!.length,
                                      itemBuilder: (_, index) {
                                        return experience(
                                            place: userStore
                                                .userData!
                                                .additionalInfo!
                                                .educations![index]
                                                .place,
                                            from: userStore
                                                .userData!
                                                .additionalInfo!
                                                .educations![index]
                                                .from,
                                            to: userStore
                                                .userData!
                                                .additionalInfo!
                                                .educations![index]
                                                .to);
                                      })
                                  : Text("No Information"),

                              _spacer,

                              ///Work Experience
                              ///
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  "settings.workExp".tr(),
                                  style: _style.copyWith(
                                    fontSize: 14,
                                  ),
                                ),
                              ),

                              (userStore.userData!.additionalInfo!
                                      .workExperiences!.isNotEmpty)
                                  ? ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: userStore
                                          .userData!
                                          .additionalInfo!
                                          .workExperiences!
                                          .length,
                                      itemBuilder: (_, index) {
                                        return experience(
                                            place: userStore
                                                    .userData!
                                                    .additionalInfo!
                                                    .workExperiences![index]
                                                    .place ??
                                                " ",
                                            from: userStore
                                                    .userData!
                                                    .additionalInfo!
                                                    .workExperiences![index]
                                                    .from ??
                                                " ",
                                            to: userStore
                                                    .userData!
                                                    .additionalInfo!
                                                    .workExperiences![index]
                                                    .to ??
                                                " ");
                                      })
                                  : Text(
                                      "No Information",
                                      style: _style.copyWith(
                                        color: Color(0xFF7C838D),
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                            ],
                          )
                        : Text("Employee Details"),

                    ///Social Accounts

                    socialAccounts(),

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
                    _spacer,
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
                        "profile.reviews".tr(),
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                    Tab(
                      child: Text(
                        userStore.userData!.role == UserRole.Worker
                            ? "profile.portfolio".tr()
                            : "profile.sidebar.quests".tr(),
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
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Material(
                color: const Color(0xFFF7F8FA),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  //controller: _scrollController,
                  padding: const EdgeInsets.only(
                    top: 0.0,
                  ),
                  itemCount: 10,
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
                ),
              ),
            ),

            ///Portfolio and Quests
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Material(
                color: const Color(0xFFF7F8FA),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ///Add new portfolio
                    if (userStore.userData!.role == UserRole.Worker)
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
                              ]),
                        ),
                      ),

                    Expanded(
                      child: Observer(
                        builder: (_) => userStore.userData!.role ==
                                UserRole.Worker
                            ? Center(
                                child: portfolioStore!.portfolioList.isEmpty
                                    ? Text("You do not have any  Portfolio")
                                    : ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.only(
                                          top: 0.0,
                                        ),
                                        itemCount: portfolioStore!
                                            .portfolioList.length,
                                        itemBuilder: (context, index) =>
                                            PortfolioWidget(
                                          index: index,
                                          imageUrl: portfolioStore!
                                              .portfolioList[index]
                                              .medias
                                              .first
                                              .url,
                                          title: portfolioStore!
                                              .portfolioList[index].title,
                                        ),
                                      ),
                              )
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(
                                  top: 0.0,
                                ),
                                itemCount: 5,
                                itemBuilder: (context, index) => quest(
                                  title: 'Paint the garage quickly',
                                  description: "Paint the garage",
                                  price: "1500",
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
