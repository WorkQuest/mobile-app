import 'package:app/enums.dart';
import 'package:app/ui/widgets/sliver_sticky_tab_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileReviews extends StatefulWidget {
  static const String routeName = "/profileReviewPage";

  @override
  _ProfileReviewsState createState() => _ProfileReviewsState();
}

///ADD KEEP ALIVE FOR TABS
///CHECK SCROLLING ISSUE

class _ProfileReviewsState extends State<ProfileReviews>
    with SingleTickerProviderStateMixin {
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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              centerTitle: false,
              background: Image.asset(
                "assets/profile_avatar_test.jpg",
                fit: BoxFit.cover,
              ),
              //title: appBarTitle(),
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
                  Container(
                    child: Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit ut aliquam, purus sit amet luctus venenatis, lectus magna fringilla urna, porttitor rhoncus dolor purus non enim praesent elementum facilisis leo, vel'),
                  ),
                  socialAccounts(),
                  contactDetails(
                      location: "Moscow, Lenina street, 3d",
                      number: "+7 989 989 98 98",
                      email: "worker@gmail.com"),
                  skills([
                    "Craft",
                    "DYI",
                    "Design",
                    "Painting Works",
                    "Mobile Dev",
                  ]),
                  rating(
                    completedQuests: "12",
                    averageRating: "4.5",
                    reviews: "23",
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
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
                      "Portfolio",
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: this._tabController,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Material(
                    color: Color(0xFFF7F8FA),
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                        top: 0.0,
                      ),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return reviews(
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
                      padding: EdgeInsets.only(
                        top: 0.0,
                      ),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return portfolio();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 43.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(6.0),
          ),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 20.0,
        ),
        child: TextButton(
          child: Text(
            "Send a request",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Color(0xFF0083C7),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  6.0,
                ),
              ),
            ),
          ),
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
          SizedBox(
            height: 17,
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
          SizedBox(
            height: 17,
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

  Widget skills(List<String> skills) {
    return Container(
      margin: EdgeInsets.only(
        top: 22.0,
      ),
      padding: EdgeInsets.all(
        16.0,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF7F8FA),
        borderRadius: BorderRadius.all(
          Radius.circular(6.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skills',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          Wrap(
            spacing: 9.0,
            runSpacing: 8.0,
            children: skills
                .map(
                  (item) => new Chip(
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
                .toList(),
          ),
        ],
      ),
    );
  }

  ///Quest Rating Widget
  ///
  ///
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

  ///Reviews Widget
  ///
  ///
  ///
  Widget reviews(
      String name, UserRole userRole, String questTitle, String quest) {
    return Container(
      margin: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 10.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(6.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(
                  "assets/profile_avatar_test.jpg",
                ),
              ),
              title: Text(
                name,
                style: TextStyle(fontSize: 16.0),
              ),
              subtitle: Text(
                userRole.toString(),
                style: TextStyle(fontSize: 12.0, color: Color(0xFF00AA5B)),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 15.0,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Color(0xFFE8D20D),
                    size: 19.0,
                  ),
                  Icon(
                    Icons.star,
                    color: Color(0xFFE8D20D),
                    size: 19.0,
                  ),
                  Icon(
                    Icons.star,
                    color: Color(0xFFE8D20D),
                    size: 19.0,
                  ),
                  Icon(
                    Icons.star,
                    color: Color(0xFFE8D20D),
                    size: 19.0,
                  ),
                  Icon(
                    Icons.star,
                    color: Color(0xFFE9EDF2),
                    size: 19.0,
                  ),
                  SizedBox(
                    width: 13.0,
                  ),
                  Text('4.00')
                ],
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 15.0,
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "Quest    ",
                        style: TextStyle(
                          color: Colors.black,
                        )),
                    TextSpan(
                      text: questTitle,
                      style: TextStyle(
                        color: Color(0xFF7C838D),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 15.0,
              ),
              child: Text(quest),
            ),
          ),
        ],
      ),
    );
  }

  /// Portfolio Widget
  ///
  ///
  ///

  Widget portfolio() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 10.0,
      ),
      child: Stack(
        children: [
          Container(
            height: 230,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(6.0),
              ),
              image: DecorationImage(
                image: AssetImage("assets/profile_avatar_test.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 15.0,
            left: 21.0,
            right: 55.0,
            child: Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing  elit ut aliquam ",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
              bottom: 15.0,
              right: 21.0,
              child: Icon(
                Icons.arrow_right_sharp,
                color: Colors.white,
              )),
        ],
      ),
    );
  }

  ///AppBar Title

  // Widget appBarTitle() {
  //   return Container(
  //     alignment: Alignment.centerLeft,
  //     margin: const EdgeInsets.only(left: 16.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Icon(
  //               Icons.star,
  //               color: Color(0xFFE8D20D),
  //               size: 19.0,
  //             ),
  //             Icon(
  //               Icons.star,
  //               color: Color(0xFFE8D20D),
  //               size: 19.0,
  //             ),
  //             Icon(
  //               Icons.star,
  //               color: Color(0xFFE8D20D),
  //               size: 19.0,
  //             ),
  //             Icon(
  //               Icons.star,
  //               color: Color(0xFFE8D20D),
  //               size: 19.0,
  //             ),
  //             Icon(
  //               Icons.star,
  //               color: Color(0xFFE9EDF2),
  //               size: 19.0,
  //             ),
  //           ],
  //         ),
  //         Text(
  //           "Rosalia Vans",
  //           style: TextStyle(
  //             fontSize: 30.0,
  //             color: Colors.white,
  //           ),
  //         ),
  //         Container(
  //           decoration: BoxDecoration(
  //             color: Color(0xFFF6CF00),
  //             borderRadius: BorderRadius.all(
  //               Radius.circular(3.0),
  //             ),
  //           ),
  //           child: Text(
  //             "HIGHER LEVEL",
  //             style: TextStyle(
  //               fontSize: 12.0,
  //               color: Colors.white,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
