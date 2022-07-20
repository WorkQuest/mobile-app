import 'dart:async';

import 'package:app/constants.dart';
import 'package:app/enums.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/ui/pages/main_page/change_profile_page/change_profile_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/review_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/widgets/profile_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../report_page/report_page.dart';

extension CustomAppBar on UserProfileState {
  Widget sliverAppBar(ProfileMeResponse info,
      StreamController<AppBarParams> streamController, Function() updateState) {
    final String defaultImage =
        'https://workquest-cdn.fra1.digitaloceanspaces.com/sUYNZfZJvHr8fyVcrRroVo8PpzA5RbTghdnP0yEcJuIhTW26A5vlCYG8mZXs';
    final mark = info.ratingStatistic!.averageMark;
    final markDev = mark.toInt();
    final markMod = (mark % (markDev == 0 ? 1 : markDev) * 10).round() / 10;
    return StreamBuilder<AppBarParams>(
      initialData: AppBarParams.initial(),
      stream: streamController.stream,
      builder: (_, snapshot) => SliverAppBar(
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
          if (info.id == userStore!.userData!.id)
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () async {
                final result =
                    await Navigator.of(context, rootNavigator: true).pushNamed(
                  ChangeProfilePage.routeName,
                );
                if (result != null && result as bool) {
                  updateState.call();
                }
              },
            ),
          if (info.id != userStore!.userData!.id)
            IconButton(
              icon: Icon(
                Icons.warning_amber_outlined,
                color: Color(0xFFD8DFE3),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pushNamed(
                  ReportPage.routeName,
                  arguments: ReportPageArguments(
                    entityType: ReportEntityType.user,
                    entityId: info.id,
                  ),
                );
              },
            ),
        ],
        centerTitle: false,
        pinned: true,
        expandedHeight: 250,
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.only(
            left: 16.0,
            bottom: 3,
            top: 0.0,
          ),
          collapseMode: CollapseMode.pin,
          centerTitle: false,
          background: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                info.avatar != null
                    ? info.avatar!.url ?? defaultImage
                    : defaultImage,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: info.ratingStatistic!.status == 1 ? 67.0 : 85.0,
                left: 15.0,
                child: Row(
                  children: [
                    for (int i = 0; i < markDev; i++)
                      Icon(
                        Icons.star,
                        color: Color(0xFFE8D20D),
                        size: 20.0,
                      ),
                    if (markDev != 5)
                      ShaderMask(
                        blendMode: BlendMode.srcATop,
                        shaderCallback: (Rect rect) {
                          return LinearGradient(
                            stops: [0, markMod, markMod],
                            colors: [
                              Color(0xFFE8D20D),
                              Color(0xFFE8D20D),
                              Color(0xFFE8D20D).withOpacity(0)
                            ],
                          ).createShader(rect);
                        },
                        child: SizedBox(
                          child: Icon(
                            Icons.star,
                            color: Color(0xFFE9EDF2),
                            size: 20.0,
                          ),
                        ),
                      ),
                    for (int i = 0; i < 4 - markDev; i++)
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
            "${info.firstName} ${info.lastName}",
            snapshot.data!.appBarPosition,
            info.ratingStatistic?.status ?? 1,
            snapshot.data!.width,
          ),
        ),
      ),
    );
  }
}

extension ReviewsTab on UserProfileState {
  List<Widget> reviewsTab() => [
        SizedBox(
          height: 20,
        ),
        Observer(
          builder: (_) => portfolioStore!.reviewsList.isNotEmpty
              ? Column(
                  children: [
                    for (int index = 0;
                        index <
                            (portfolioStore!.reviewsList.length < 3
                                ? portfolioStore!.reviewsList.length
                                : 3);
                        index++)
                      ReviewsWidget(
                        avatar: portfolioStore!
                                .reviewsList[index].fromUser.avatar?.url ??
                            Constants.defaultImageNetwork,
                        name: portfolioStore!
                                .reviewsList[index].fromUser.firstName +
                            " " +
                            portfolioStore!
                                .reviewsList[index].fromUser.lastName,
                        mark: portfolioStore!.reviewsList[index].mark,
                        userRole:
                            portfolioStore!.reviewsList[index].fromUser.role ==
                                    UserRole.Employer
                                ? "role.employer"
                                : "role.worker",
                        questTitle:
                            portfolioStore!.reviewsList[index].quest.title,
                        message: portfolioStore!.reviewsList[index].message,
                        id: portfolioStore!.reviewsList[index].fromUserId,
                        myId: viewOtherUser?.userData == null
                            ? userStore!.userData!.id
                            : viewOtherUser!.userData!.id,
                        role: portfolioStore!.reviewsList[index].fromUser.role,
                      ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          portfolioStore!.setTitleName("Reviews");
                          await Navigator.pushNamed(
                            context,
                            ReviewPage.routeName,
                            arguments: ReviewPageArguments(
                              userId: widget.arguments?.userId == null
                                  ? userStore!.userData!.id
                                  : widget.arguments!.userId,
                              role: widget.arguments?.userId == null
                                  ? userStore!.userData!.role
                                  : widget.arguments!.role,
                              store: portfolioStore!,
                            ),
                          );
                          await portfolioStore!.getReviews(
                            userId: viewOtherUser?.userData == null
                                ? userStore!.userData!.id
                                : viewOtherUser!.userData!.id,
                            isForce: true,
                          );
                        },
                        child: Text(
                          "meta.showAllReviews".tr(),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/empty_quest_icon.svg",
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        viewOtherUser?.userData == null
                            ? "quests.noReview".tr()
                            : "quests.noReviewForOtherUser".tr(),
                        style: TextStyle(
                          color: Color(0xFFD8DFE3),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ];
}
