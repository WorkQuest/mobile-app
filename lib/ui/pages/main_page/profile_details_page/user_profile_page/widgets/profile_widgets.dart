import 'package:app/model/profile_response/social_network.dart';
import 'package:app/ui/pages/main_page/change_profile_page/change_profile_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/portfolio_page/portfolio_details_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/portfolio_page/store/portfolio_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/store/user_profile_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
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
  final bool isProfileYour;

  const PortfolioWidget({
    required this.title,
    required this.index,
    required this.imageUrl,
    required this.isProfileYour,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Map<String, dynamic> arguments = {
          "index": index,
          "isProfileYour": isProfileYour
        };
        Navigator.pushNamed(
          context,
          PortfolioDetails.routeName,
          arguments: arguments,
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
  final String myId;
  final UserRole role;

  const ReviewsWidget({
    required this.avatar,
    required this.name,
    required this.mark,
    required this.userRole,
    required this.questTitle,
    required this.message,
    required this.id,
    required this.myId,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final profile = context.read<ProfileMeStore>();
    final portfolioStore = context.read<PortfolioStore>();
    final userProfileStore = context.read<UserProfileStore>();
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
              Flexible(
                child: GestureDetector(
                  onTap: () async {
                    if (id != profile.userData!.id)
                      await profile.getAssignedWorker(id);
                    else
                      profile.assignedWorker = profile.userData!;
                    if (profile.assignedWorker != null) {
                      portfolioStore.clearData();
                      await Navigator.of(context, rootNavigator: true)
                          .pushNamed(
                        UserProfile.routeName,
                        arguments: profile.assignedWorker,
                      );
                      portfolioStore.clearData();
                      if (role == UserRole.Worker)
                        portfolioStore.getPortfolio(userId: myId);
                      else {
                        userProfileStore.quests.clear();
                        userProfileStore.getQuests(myId, role);
                      }
                      portfolioStore.getReviews(userId: myId);
                    }
                    profile.assignedWorker = null;
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(avatar),
                    ),
                    title: Text(
                      name,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    subtitle: Text(
                      userRole.tr(),
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
Widget appBarTitle(String name, double padding, String status) {
  return AnimatedPadding(
    padding: EdgeInsets.only(left: padding),
    duration: Duration(milliseconds: 100),
    child: Stack(
      children: [
        Positioned(
          bottom: status != "noStatus" ? 18.0 : 0.0,
          left: 0.0,
          child: Text(
            name,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
        if (status.isNotEmpty)
          Positioned(
            bottom: 0.0,
            left: 0.0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 2.0,
              ),
              child: tagStatus(status),
            ),
          ),
      ],
    ),
  );
}

Widget tag({required String text, required Color color}) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 8,
        ),
      ),
    );

Widget tagStatus(String status) {
  switch (status) {
    case "topRanked":
      return tag(
        text: "GOLD PLUS",
        color: Color(0xFFF6CF00),
      );
    case "reliable":
      return tag(
        text: "SILVER",
        color: Color(0xFFBBC0C7),
      );

    case "verified":
      return tag(
        text: "BRONZE",
        color: Color(0xFFB79768),
      );
    default:
      return SizedBox.shrink();
  }
}

///Quest Rating Widget
///

Widget employerRating({
  required String completedQuests,
  required double averageRating,
  required String reviews,
}) {
  final rating = ((averageRating * 10).round() / 10).toString();
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
                  'quests.completedQuests'.tr(),
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
                // Text(
                //   'Show all',
                //   style: TextStyle(
                //     decoration: TextDecoration.underline,
                //     color: Color(0xFF00AA5B),
                //     fontSize: 12.0,
                //   ),
                // ),
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
                  'quests.averageRating'.tr(),
                  style: TextStyle(fontSize: 16.0),
                ),
                Row(
                  children: [
                    Text(
                      rating,
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
                  "settings.education.from".tr() +
                      " " +
                      reviews +
                      " " +
                      "workers.reviews".tr(),
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

Widget workerRatingCard({
  required String title,
  required String rate,
  required String thirdLine,
  Color textColor = const Color(0xFF00AA5B),
}) =>
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
              title.tr(),
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              rate,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            Text(
              thirdLine,
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Color(0xFFD8DFE3),
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );

Widget workerRating({
  required String completedQuests,
  required double averageRating,
  required String reviews,
  required String activeQuests,
}) {
  final rating = ((averageRating * 10).round() / 10).toString();
  return Padding(
    padding: const EdgeInsets.only(top: 20.0),
    child: Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            workerRatingCard(
                title: 'quests.activeQuests',
                rate: completedQuests,
                thirdLine: 'Show all'),
            workerRatingCard(
              title: 'quests.completedQuests',
              rate: completedQuests,
              thirdLine: 'workers.oneTime'.tr(),
              textColor: Color(0xFF0083C7),
            ),
          ],
        ),
        const SizedBox(
          height: 15.0,
        ),
        Container(
          padding: EdgeInsets.all(16.0),
          height: 140,
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
                'quests.averageRating'.tr(),
                style: TextStyle(fontSize: 16.0),
              ),
              Row(
                children: [
                  Text(
                    rating,
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
                "settings.education.from".tr() +
                    " " +
                    reviews +
                    " " +
                    "workers.reviews".tr(),
                style: TextStyle(
                  color: Color(0xFFD8DFE3),
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

///SocialMedia Accounts Widget
///
Widget _socialMediaIcon({
  required String iconPath,
  required String? title,
  required String launchUrl,
  required String fallbackUrl,
  required int color,
}) =>
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
          onPressed: title != null
              ? () {
                  _launchSocial(launchUrl, fallbackUrl);
                }
              : null,
          icon: title?.contains("instagram") != null
              ? GradientIcon(
                  SvgPicture.asset(
                    "assets/instagram_disabled.svg",
                  ),
                  20.0,
                  const <Color>[
                    Color(0xFFAD00FF),
                    Color(0xFFFF9900),
                  ],
                )
              : SvgPicture.asset(
                  "assets/$iconPath.svg",
                  color: title != null ? Color(color) : null,
                ),
        ),
      ),
    );

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
        _socialMediaIcon(
          iconPath: "facebook_icon_disabled",
          title: facebook,
          fallbackUrl: 'https://www.facebook.com/$facebook',
          launchUrl: 'fb://profile/$facebook',
          color: 0xFF3B67D7,
        ),
        _socialMediaIcon(
          iconPath: "twitter_icon_disabled",
          title: twitter,
          fallbackUrl: 'https://twitter.com/$twitter',
          launchUrl: '',
          color: 0xFF24CAFF,
        ),
        _socialMediaIcon(
          iconPath: "instagram_disabled",
          title: instagram,
          fallbackUrl: 'https://www.instagram.com/$instagram',
          launchUrl: '',
          color: 0000000
         ),
        _socialMediaIcon(
          iconPath: "linkedin_icon_disabled",
          title: linkedin,
          fallbackUrl: 'https://linkedin.com/$linkedin',
          launchUrl: '',
          color: 0xFF0A7EEA,
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
        if (location.isNotEmpty)
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
