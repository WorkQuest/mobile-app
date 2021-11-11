import 'package:app/ui/pages/main_page/change_profile_page/change_profile_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/profileMe_reviews_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/widgets/profile_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../../../enums.dart';
import 'package:easy_localization/easy_localization.dart';

extension CustomAppBar on ProfileReviewsState {
  Widget sliverAppBar() => SliverAppBar(
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
          if (widget.info == null)
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
            bottom: 16.0,
            top: 0.0,
          ),
          collapseMode: CollapseMode.pin,
          centerTitle: false,
          background: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                widget.info == null
                    ? userStore!.userData!.avatar!.url
                    : widget.info!.avatar!.url,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 85.0,
                left: 50.0,
                child: Row(
                  children: [
                    for (int i = 0;
                        i < 0; //userStore!.userData!.ratingStatistic!.averageMark;
                        i++)
                      Icon(
                        Icons.star,
                        color: Color(0xFFE8D20D),
                        size: 20.0,
                      ),
                    for (int i = 0;
                        i < 5 - 0; //userStore!.userData!.ratingStatistic!.averageMark;
                        i++)
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
            widget.info == null
                ? "${userStore!.userData!.firstName} ${userStore!.userData!.lastName}"
                : "${widget.info!.firstName} ${widget.info!.lastName}",
          ),
        ),
      );
}

extension ReviewsTab on ProfileReviewsState {
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
                        userRole: UserRole.Worker.toString().split(".").last,
                        questTitle:
                            portfolioStore!.reviewsList[index].quest.title,
                        message: portfolioStore!.reviewsList[index].message,
                        id: portfolioStore!.reviewsList[index].fromUserId,
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
