import 'package:app/model/profile_response/social_network.dart';
import 'package:app/ui/pages/main_page/change_profile_page/change_profile_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/portfolio_page/portfolio_details_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/portfolio_page/store/portfolio_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/profile_quests_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/store/user_profile_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/animation_show_more.dart';
import 'package:app/ui/widgets/gradient_icon.dart';
import 'package:app/ui/widgets/user_avatar.dart';
import 'package:app/ui/widgets/user_rating.dart';
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
        Navigator.pushNamed(
          context,
          PortfolioDetails.routeName,
          arguments: PortfolioArguments(index, isProfileYour),
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
class ReviewsWidget extends StatefulWidget {
  final String avatar;
  final String name;
  final int mark;
  final String userRole;
  final String questTitle;
  final String message;
  final String cutMessage;
  final String id;
  final String myId;
  final UserRole role;
  final bool last;

  const ReviewsWidget({
    required this.avatar,
    required this.name,
    required this.mark,
    required this.userRole,
    required this.questTitle,
    required this.message,
    required this.cutMessage,
    required this.id,
    required this.myId,
    required this.role,
    required this.last,
  });

  @override
  State<ReviewsWidget> createState() => _ReviewsWidgetState();
}

class _ReviewsWidgetState extends State<ReviewsWidget> {
  bool enabled = false;

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
                    if (profile.assignedWorker != null) {
                      portfolioStore.clearData();
                      await Navigator.of(context, rootNavigator: true)
                          .pushNamed(
                        UserProfile.routeName,
                        arguments: ProfileArguments(
                          role: widget.role,
                          userId: widget.id,
                        ),
                      );
                      portfolioStore.clearData();
                      if (widget.role == UserRole.Worker)
                        portfolioStore.getPortfolio(
                          userId: widget.myId,
                          newList: true,
                        );
                      else {
                        userProfileStore.quests.clear();
                        userProfileStore.getQuests(
                          userId: widget.myId,
                          newList: true,
                          isProfileYours:
                              widget.id == widget.myId ? true : false,
                        );
                      }
                      portfolioStore.getReviews(
                          userId: widget.myId, newList: true);
                    }
                    profile.assignedWorker = null;
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: UserAvatar(
                          width: 40,
                          height: 40,
                          url: widget.avatar,
                        ),
                      ),
                      // backgroundImage: NetworkImage(widget.avatar),
                    ),
                    title: Text(
                      widget.name,
                      style: TextStyle(fontSize: 16.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      widget.userRole.tr(),
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Color(0xFF00AA5B),
                      ),
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
                      for (int i = 0; i < widget.mark; i++)
                        Icon(
                          Icons.star,
                          color: Color(0xFFE8D20D),
                          size: 19.0,
                        ),
                      for (int i = 0; i < 5 - widget.mark; i++)
                        Icon(
                          Icons.star,
                          color: Color(0xFFE9EDF2),
                          size: 19.0,
                        ),
                      const SizedBox(width: 13),
                      Text("${widget.mark}"),
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
                          text: widget.questTitle,
                          style: TextStyle(
                            color: Color(0xFF7C838D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 15.0,
                ),
                child: widget.message.length < 50
                    ? Text(
                        widget.message,
                        overflow: TextOverflow.ellipsis,
                      )
                    : AnimationShowMore(
                        text: widget.message,
                        enabled: enabled,
                        onShowMore: (value) {
                          setState(() {
                            this.enabled = value;
                          });
                        },
                      ),
              ),
            ],
          ),
        ),
        if (widget.last)
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
Widget appBarTitle(String name, double padding, int status, double width) {
  return Padding(
    padding: EdgeInsets.only(left: padding),
    child: Stack(
      children: [
        Positioned(
          bottom: status == 1 ? 13.0 : 30.0,
          left: 0.0,
          child: Container(
            width: width,
            child: Text(
              name,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        if (status != 1)
          Positioned(
            bottom: 5.0,
            left: 0.0,
            child: Container(
              child: UserRating(status),
            ),
          ),
      ],
    ),
  );
}

///Quest Rating Widget

Widget employerRating({
  required String completedQuests,
  required double averageRating,
  required String reviews,
  required String userId,
  required BuildContext context,
}) {
  final rating = ((averageRating * 10).round() / 10).toString();
  final profile = context.read<ProfileMeStore>();
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
                GestureDetector(
                  onTap: () async {
                    if (userId != profile.userData!.id &&
                        completedQuests != "0") {
                      // profile.offset = 0;
                      // profile.setUserId(userId);
                      // await profile.getCompletedQuests();
                      await Navigator.pushNamed(
                        context,
                        ProfileQuestsPage.routeName,
                        arguments: profile,
                      );
                      // profile.quests.clear();
                      // profile.offset = 0;
                    }
                  },
                  child: Text(
                    "workers.showAll".tr(),
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: userId != profile.userData!.id &&
                              completedQuests != "0"
                          ? Color(0xFF00AA5B)
                          : Color(0xFFF7F8FA),
                      fontSize: 12.0,
                    ),
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

Widget workerQuestStats({
  required String title,
  required String rate,
  required String thirdLine,
  String? userId,
  ProfileMeStore? profile,
  Color textColor = const Color(0xFF00AA5B),
  BuildContext? context,
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
            GestureDetector(
              onTap: () async {
                if (userId != null &&
                    context != null &&
                    userId != profile?.userData?.id &&
                    thirdLine != "0") {
                  await Navigator.pushNamed(
                    context,
                    ProfileQuestsPage.routeName,
                    arguments: profile,
                  );
                }
              },
              child: Text(
                thirdLine.tr(),
                style: TextStyle(
                  decoration: title == "quests.activeQuests"
                      ? TextDecoration.underline
                      : null,
                  color: Color(0xFFD8DFE3),
                  fontSize: 12.0,
                ),
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
  required String userId,
  required BuildContext context,
}) {
  final rating = averageRating.toStringAsFixed(1);
  final profile = context.read<ProfileMeStore>();
  return Padding(
    padding: const EdgeInsets.only(top: 20.0),
    child: Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            workerQuestStats(
              title: "quests.activeQuests",
              rate: activeQuests,
              thirdLine: "workers.showAll",
              userId: userId,
              context: context,
              profile: profile,
            ),
            workerQuestStats(
              title: 'quests.completedQuests',
              rate: completedQuests,
              thirdLine: 'workers.oneTime',
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
  required String? title,
  required String launchUrl,
  required String fallbackUrl,
  required Widget icon,
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
          icon: icon,
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
          title: facebook,
          fallbackUrl: 'https://www.facebook.com/$facebook',
          launchUrl: 'fb://profile/$facebook',
          icon: SvgPicture.asset(
            "assets/facebook_icon_disabled.svg",
            color: facebook != null ? Color(0xFF3B67D7) : null,
          ),
        ),
        _socialMediaIcon(
          title: twitter,
          fallbackUrl: 'https://twitter.com/$twitter',
          launchUrl: '',
          icon: SvgPicture.asset(
            "assets/twitter_icon_disabled.svg",
            color: twitter != null ? Color(0xFF24CAFF) : null,
          ),
        ),
        _socialMediaIcon(
          title: instagram,
          fallbackUrl: 'https://www.instagram.com/$instagram',
          launchUrl: '',
          icon: instagram != null
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
                  "assets/instagram_disabled.svg",
                ),
        ),
        _socialMediaIcon(
          title: linkedin,
          fallbackUrl: 'https://linkedin.com/in/$linkedin',
          launchUrl: '',
          icon: SvgPicture.asset(
            "assets/linkedin_icon_disabled.svg",
            color: linkedin != null ? Color(0xFF0A7EEA) : null,
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
  required bool isVerify,
  required UserRole role,
  required String? company,
  required String? ceo,
  required String? website,
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
              if (isVerify)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Text(
                      "Number Confirmed",
                      style: TextStyle(
                        color: Color(0xFF0083C7),
                        fontSize: 8,
                      ),
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
        if (role == UserRole.Employer)
          Column(
            children: [
              if ((company ?? "").isNotEmpty)
                Column(
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/union.svg",
                          width: 20.0,
                          height: 20.0,
                          color: Color(0xFF7C838D),
                        ),
                        // Image.asset(
                        //   "union.svg",
                        //   width: 20.0,
                        //   height: 20.0,
                        //   color: Color(0xFF7C838D),
                        // ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              company!,
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
              if ((ceo ?? "").isNotEmpty)
                Column(
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/ceo.svg",
                          width: 20.0,
                          height: 20.0,
                          color: Color(0xFF7C838D),
                        ),
                        // Image.asset(
                        //   "assets/union.svg",
                        //   width: 20.0,
                        //   height: 20.0,
                        //   color: Color(0xFF7C838D),
                        // ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              ceo!,
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
              if ((website ?? "").isNotEmpty)
                Column(
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/glob.svg",
                          width: 20.0,
                          height: 20.0,
                          color: Color(0xFF7C838D),
                        ),
                        // Icon(
                        //   Icons.web,
                        //   size: 20.0,
                        //   color: Color(0xFF7C838D),
                        // ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              website!,
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
            ],
          ),
      ],
    ),
  );
}

///Skills widget
class SkillsWidget extends StatefulWidget {
  final isExpanded;
  final isProfileMy;
  final List<String>? skills;
  final Function(bool) onPressed;

  SkillsWidget({
    Key? key,
    required this.isProfileMy,
    required this.isExpanded,
    required this.onPressed,
    required this.skills,
  }) : super(key: key);

  @override
  _SkillsWidgetState createState() => _SkillsWidgetState();
}

class _SkillsWidgetState extends State<SkillsWidget>
    with TickerProviderStateMixin<SkillsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 500),
          alignment: Alignment.topCenter,
          child: skills(
            isProfileMy: widget.isProfileMy,
            skills: widget.isExpanded
                ? widget.skills
                : widget.skills!.sublist(0, 5),
            context: context,
          ),
        ),
        if (!widget.isExpanded)
          TextButton(
            child: const Text('Show more'),
            onPressed: () {
              widget.onPressed.call(!widget.isExpanded);
            },
          )
      ],
    );
  }
}

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

class PortfolioArguments {
  int index;
  bool isProfileYour;

  PortfolioArguments(this.index, this.isProfileYour);
}
