import 'dart:async';

import 'package:app/model/profile_response/social_network.dart';
import 'package:app/ui/pages/main_page/change_profile_page/change_profile_page.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/portfolio_page/portfolio_details_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/portfolio_page/store/portfolio_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/profileMe_reviews_page.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/gradient_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../../../../../../enums.dart';

///Portfolio Widget
class PortfolioWidget extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int index;

  const PortfolioWidget({
    required this.title,
    required this.index,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          PortfolioDetails.routeName,
          arguments: index,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Stack(
          children: [
            Container(
              height: 230,
              width: double.maxFinite,
              foregroundDecoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(6.0),
                ),
                color: Colors.black38,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    imageUrl,
                  ),
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    6.0,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 15.0,
              left: 21.0,
              right: 55.0,
              child: Text(
                title,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///Reviews Widget
class ReviewsWidget extends StatelessWidget {
  final String avatar;
  final String name;
  final int mark;
  final String userRole;
  final String questTitle;
  final String message;
  final String id;

  const ReviewsWidget(
      {required this.avatar,
      required this.name,
      required this.mark,
      required this.userRole,
      required this.questTitle,
      required this.message,
      required this.id});

  @override
  Widget build(BuildContext context) {
    final profile = context.read<ProfileMeStore>();
    final portfolioStore = context.read<PortfolioStore>();
    final userStore = context.read<ProfileMeStore>();
    final questStore = context.read<MyQuestStore>();
    final role = profile.userData!.role;
    return Column(
      children: [
        Container(
          height: 10,
          decoration: BoxDecoration(
            color: Color(0xFFF7F8FA),
          ),
        ),
        Container(
          // margin: EdgeInsets.only(
          //   left: 16.0,
          //   right: 16.0,
          //   top: 10.0,
          // ),
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
              GestureDetector(
                onTap: () {
                  profile.getAssignedWorker(id);
                  Timer.periodic(Duration(milliseconds: 100), (timer) async {
                    if (profile.assignedWorker != null) {
                      timer.cancel();
                      await Navigator.of(context, rootNavigator: true).pushNamed(
                        ProfileReviews.routeName,
                        arguments: profile.assignedWorker,
                      );
                      if (role == UserRole.Worker)
                        portfolioStore.getPortfolio(
                          userId: userStore.userData!.id,
                        );
                      else
                        questStore.getQuests(
                            userStore.userData!.id, role, true);
                      portfolioStore.getReviews(
                        userId: userStore.userData!.id,
                      );
                    }
                  });

                },
                child: Flexible(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(avatar),
                    ),
                    title: Text(
                      name,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    subtitle: Text(
                      userRole,
                      style:
                          TextStyle(fontSize: 12.0, color: Color(0xFF00AA5B)),
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
                  child: Row(
                    children: [
                      for (int i = 0; i < mark; i++)
                        Icon(
                          Icons.star,
                          color: Color(0xFFE8D20D),
                          size: 19.0,
                        ),
                      for (int i = 0; i < 5 - mark; i++)
                        Icon(
                          Icons.star,
                          color: Color(0xFFE9EDF2),
                          size: 19.0,
                        ),
                      const SizedBox(width: 13),
                      Text("$mark"),
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
                          ),
                        ),
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
                  child: Text(message),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 10,
          decoration: BoxDecoration(
            color: Color(0xFFF7F8FA),
          ),
        ),
      ],
    );
  }
}

///AppBar Title
Widget appBarTitle(String name) {
  return Transform.translate(
    offset: Offset(25.0, 0.0),
    child: Stack(
      children: [
        Positioned(
          bottom: 18.0,
          left: 0.0,
          child: Text(
            name,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 5.0,
              vertical: 2.0,
            ),
            decoration: BoxDecoration(
              color: Color(0xFFF6CF00),
              borderRadius: BorderRadius.all(
                Radius.circular(3.0),
              ),
            ),
            child: Text(
              "HIGHER LEVEL",
              style: TextStyle(
                fontSize: 8.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

///Quest Widget
Widget quest({
  required String title,
  required String description,
  required String price,
}) {
  return Container(
    color: Colors.white,
    margin: const EdgeInsets.only(
      top: 10,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.maxFinite,
          margin: const EdgeInsets.symmetric(vertical: 16),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Color(0xFF0083C7),
          ),
          child: Text(
            "Performed",
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Color(0xFF1D2127),
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          description,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Color(0xFF4C5767),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              Icons.star_border_outlined,
              color: Color(0xFFAAB0B9),
              size: 19.0,
            ),
            Icon(
              Icons.star_border_outlined,
              color: Color(0xFFAAB0B9),
              size: 19.0,
            ),
            Icon(
              Icons.star_border_outlined,
              color: Color(0xFFAAB0B9),
              size: 19.0,
            ),
            Icon(
              Icons.star_border_outlined,
              color: Color(0xFFAAB0B9),
              size: 19.0,
            ),
            Icon(
              Icons.star_border_outlined,
              color: Color(0xFFAAB0B9),
              size: 19.0,
            ),
            Expanded(
              child: Text(
                "$price WUSD",
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: Color(0xFFAAB0B9),
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
      ],
    ),
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

///SocialMedia Accounts Widget
///

Widget socialAccounts({SocialNetwork? socialNetwork}) {
  final facebook = socialNetwork?.facebook;
  final instagram = socialNetwork?.instagram;
  final twitter = socialNetwork?.twitter;
  final linkedin = socialNetwork?.linkedin;
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
              onPressed: facebook != null
                  ? () {
                      _launchSocial('fb://profile/$facebook',
                          'https://www.facebook.com/$facebook');
                    }
                  : null,
              icon: SvgPicture.asset(
                "assets/facebook_icon_disabled.svg",
                color: facebook != null ? Color(0xFF3B67D7) : null,
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
              onPressed: twitter != null
                  ? () {
                      _launchSocial("", 'https://twitter.com/$twitter');
                    }
                  : null,
              icon: SvgPicture.asset(
                "assets/twitter_icon_disabled.svg",
                color: twitter != null ? Color(0xFF24CAFF) : null,
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
              onPressed: instagram != null
                  ? () {
                      _launchSocial(
                        "",
                        'https://www.instagram.com/$instagram',
                      );
                    }
                  : null,
              icon: instagram != null
                  ? GradientIconInstagram(
                      SvgPicture.asset(
                        "assets/instagram.svg",
                      ),
                      20.0,
                    )
                  : SvgPicture.asset(
                      "assets/instagram_disabled.svg",
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
              onPressed: linkedin != null
                  ? () {
                      _launchSocial("", 'https://linkedin.com/$linkedin');
                    }
                  : null,
              icon: SvgPicture.asset(
                "assets/linkedin_icon_disabled.svg",
                color: twitter != null ? Color(0xFF0A7EEA) : null,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

void _launchSocial(String url, String fallbackUrl) async {
  try {
    bool launched = await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
    );
    if (!launched) {
      await launch(
        fallbackUrl,
        forceSafariVC: false,
        forceWebView: false,
      );
    }
  } catch (e) {
    await launch(
      fallbackUrl,
      forceSafariVC: false,
      forceWebView: false,
    );
  }
}

///Contact Details Widget
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
              color: const Color(0xFF7C838D),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  location,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF7C838D),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (number.isNotEmpty)
          Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Icon(
                    Icons.phone,
                    size: 20.0,
                    color: const Color(0xFF7C838D),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      number,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7C838D),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        if (secondNumber.isNotEmpty)
          Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Icon(
                    Icons.phone,
                    size: 20.0,
                    color: const Color(0xFF7C838D),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
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
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  email,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7C838D),
                  ),
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

Widget skills({
  required List<String>? skills,
  required BuildContext context,
  required bool isProfileMy,
}) {
  return Wrap(
    direction: Axis.horizontal,
    spacing: 9.0,
    runSpacing: 0.0,
    children: isProfileMy
        ? (skills!
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
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      ChangeProfilePage.routeName,
                    );
                  },
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "settings.add".tr(),
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
              ))
        : skills!
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
            .toList(),
  );
}

Widget experience({
  String? place,
  String? from,
  String? to,
}) {
  return Wrap(
    children: [
      Text(place!),
      SizedBox(
        width: 10,
      ),
      Text(
        "${from!} - ${to!}",
        softWrap: true,
      ),
    ],
  );
}
