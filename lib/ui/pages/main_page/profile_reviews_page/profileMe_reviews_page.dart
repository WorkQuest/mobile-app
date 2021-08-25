import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/change_profile_page/change_profile_page.dart';
import 'package:app/ui/pages/main_page/profile_reviews_page/profile_widgets.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/sliver_sticky_tab_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import "package:provider/provider.dart";

class ProfileReviews extends StatefulWidget {
  static const String routeName = "/profileReviewPage";
  final ProfileWidgets _profileWidgets = ProfileWidgets();

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

  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userStore = context.read<ProfileMeStore>();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
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
                title: widget._profileWidgets.appBarTitle(
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
                                  : _skills(
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
                                  "Education",
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
                                  "Work Experience",
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
                        "Reviews",
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                    Tab(
                      child: Text(
                        userStore.userData!.role == UserRole.Worker
                            ? "Portfolio"
                            : "Quests",
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
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Material(
                color: Color(0xFFF7F8FA),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  //controller: _scrollController,
                  padding: EdgeInsets.only(
                    top: 0.0,
                  ),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return widget._profileWidgets.reviews(
                        "Edward cooper",
                        UserRole.Worker,
                        "SPA saloon design",
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit ut aliquam, purus sit amet luctus venenatis, lectus magna fringilla urna, porttitor rhoncus dolor purus non enim praesent elementum.");
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Material(
                color: Color(0xFFF7F8FA),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  //controller: _scrollController,
                  padding: EdgeInsets.only(
                    top: 0.0,
                  ),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return userStore.userData!.role == UserRole.Worker
                        ? widget._profileWidgets.portfolio()
                        : widget._profileWidgets.quest(
                            title: 'Paint the garage quickly',
                            description: "Paint the garage",
                            price: "1500");
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///SocialMedia Accounts Widget
  ///
  ///
  ///

  Widget socialAccounts() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: Container(
              height: 50.0,
              width: 74.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(6.0),
                ),
                color: Color(0xFFF7F8FA),
              ),
              child: IconButton(
                onPressed: null,
                icon: SvgPicture.asset(
                  "assets/facebook_icon.svg",
                ),
              ),
            ),
          ),
          Flexible(
            child: Container(
              height: 50.0,
              width: 74.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    6.0,
                  ),
                ),
                color: Color(0xFFF7F8FA),
              ),
              child: IconButton(
                onPressed: null,
                icon: SvgPicture.asset(
                  "assets/twitter_icon.svg",
                ),
              ),
            ),
          ),
          Flexible(
            child: Container(
              height: 50.0,
              width: 74.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(6.0),
                ),
                color: Color(0xFFF7F8FA),
              ),
              child: IconButton(
                onPressed: null,
                icon: SvgPicture.asset(
                  "assets/instagram.svg",
                ),
              ),
            ),
          ),
          Flexible(
            child: Container(
              height: 50.0,
              width: 74.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(6.0),
                ),
                color: Color(0xFFF7F8FA),
              ),
              child: IconButton(
                onPressed: null,
                icon: SvgPicture.asset(
                  "assets/linkedin_icon.svg",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///Contact Details Widget
  ///
  ///
  ///

  Widget contactDetails({
    required String location,
    required String number,
    required String email,
    required String secondNumber,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_pin,
                size: 20.0,
                color: Color(0xFF7C838D),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  location,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7C838D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Icon(
                Icons.phone,
                size: 20.0,
                color: Color(0xFF7C838D),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  number,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7C838D),
                  ),
                ),
              ),
            ],
          ),
          if (secondNumber.isNotEmpty)
            Column(
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 27.0),
                  child: Text(
                    secondNumber,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF7C838D),
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Icon(
                Icons.email,
                size: 20.0,
                color: Color(0xFF7C838D),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  email,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7C838D),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///Skills widget

  Widget _skills({required List<String> skills}) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 9.0,
      runSpacing: 0.0,
      children: skills
          .map(
            (item) => new ActionChip(
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 10.0,
              ),
              onPressed: () => null,
              label: Text(
                item,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Color(0xFF0083C7),
                ),
              ),
              backgroundColor: Color(0xFF0083C7).withOpacity(0.1),
            ),
          )
          .toList()
            ..add(
              ActionChip(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 10.0,
                ),
                onPressed: () {},
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Add",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
                backgroundColor: Color(0xFF0083C7),
              ),
            ),
    );
  }

  Widget experience({
    String? place,
    String? from,
    String? to,
  }) {
    return Row(
      children: [
        Text(place!),
        SizedBox(
          width: 10,
        ),
        Text("${from!} - ${to!}"),
      ],
    );
  }

  ///Quest Rating Widget
  ///

  Widget rating({
    required String completedQuests,
    required String averageRating,
    required String reviews,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.all(16.0),
              height: 140,
              width: 161,
              decoration: BoxDecoration(
                color: Color(0xFFF7F8FA),
                borderRadius: BorderRadius.all(
                  Radius.circular(6.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Completed quests',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    completedQuests,
                    style: TextStyle(
                      color: Color(0xFF00AA5B),
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
                    'Show all',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Color(0xFF00AA5B),
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(16.0),
              height: 140,
              width: 161,
              decoration: BoxDecoration(
                color: Color(0xFFF7F8FA),
                borderRadius: BorderRadius.all(
                  Radius.circular(6.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Average rating',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Row(
                    children: [
                      Text(
                        averageRating,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 23.0,
                        ),
                      ),
                      Icon(
                        Icons.star,
                        color: Color(0xFFE8D20D),
                        size: 19.0,
                      ),
                    ],
                  ),
                  Text(
                    "From " + reviews + " reviews",
                    style: TextStyle(
                      color: Color(0xFFD8DFE3),
                      fontSize: 12.0,
                    ),
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
