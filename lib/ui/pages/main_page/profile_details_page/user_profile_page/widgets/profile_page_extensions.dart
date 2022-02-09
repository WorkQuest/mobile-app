import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/ui/pages/main_page/change_profile_page/change_profile_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/widgets/profile_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:easy_localization/easy_localization.dart';

extension CustomAppBar on UserProfileState {
  Widget sliverAppBar(ProfileMeResponse? info) {
    final mark = info == null
        ? userStore!.userData!.ratingStatistic!.averageMark
        : info.ratingStatistic!.averageMark;
    final markDev = mark.toInt();
    final markMod = (mark % (markDev == 0 ? 1 : markDev) * 10).round() / 10;
    return SliverAppBar(
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
        if (info == null)
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pushNamed(
              ChangeProfilePage.routeName,
            ),
          ),
      ],
      centerTitle: false,
      pinned: true,
      expandedHeight: 250,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
          left: 16.0,
          bottom: appBarPositionVertical,
          top: 0.0,
        ),
        collapseMode: CollapseMode.pin,
        centerTitle: false,
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              info == null
                  ? userStore!.userData!.avatar!.url
                  : info.avatar!.url,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: info == null
                  ? userStore!.userData!.ratingStatistic!.status != "noStatus"
                      ? 85.0
                      : 67.0
                  : info.ratingStatistic!.status != "noStatus"
                      ? 85.0
                      : 67.0,
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
          info == null
              ? "${userStore!.userData!.firstName} ${userStore!.userData!.lastName}"
              : "${info.firstName} ${info.lastName}",
          appBarPosition,
          info == null
              ? userStore!.userData!.ratingStatistic?.status ?? "noStatus"
              : info.ratingStatistic?.status ?? "noStatus",
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
        portfolioStore!.reviewsList.isNotEmpty
            ? Observer(
                builder: (_) => Column(
                  children: [
                    for (int index = 0;
                        index < portfolioStore!.reviewsList.length;
                        index++)
                      ReviewsWidget(
                        avatar: portfolioStore!
                            .reviewsList[index].fromUser.avatar.url,
                        name: portfolioStore!
                                .reviewsList[index].fromUser.firstName +
                            " " +
                            portfolioStore!
                                .reviewsList[index].fromUser.lastName,
                        mark: portfolioStore!.reviewsList[index].mark,
                        userRole: portfolioStore!
                                    .reviewsList[index].fromUserId ==
                                portfolioStore!.reviewsList[index].quest.userId
                            ? "role.employer"
                            : "role.worker",
                        questTitle:
                            portfolioStore!.reviewsList[index].quest.title,
                        message: portfolioStore!.reviewsList[index].message,
                        id: portfolioStore!.reviewsList[index].fromUserId,
                        myId: widget.info == null
                            ? userStore!.userData!.id
                            : widget.info!.id,
                        role: widget.info == null
                            ? userStore!.userData!.role
                            : widget.info!.role,
                      ),
                  ],
                ),
              )
            : Center(
                child: Text(
                  widget.info == null
                      ? "quests.noReview".tr()
                      : "quests.noReviewForOtherUser".tr(),
                ),
              ),
      ];
}
