import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileReviews extends StatelessWidget {
  static const String routeName = "/profileReviewPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                "assets/profile_avatar_test.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
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
                    "Mobile Dev"
                  ]),
                  rating(
                      completedQuests: "12",
                      averageRating: "4.5",
                      reviews: "23"),
                  SizedBox(
                    height: 50.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///SocialMedia Accounts

  Widget socialAccounts() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
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
          Container(
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
                "assets/twitter_icon.svg",
              ),
            ),
          ),
          Container(
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
          Container(
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
        ],
      ),
    );
  }

  ///Contact Details

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

  ///Skills

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
          ),
          Wrap(
            spacing: 9.0,
            runSpacing: 10.0,
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

  ///Quest Rating

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
                      )
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
