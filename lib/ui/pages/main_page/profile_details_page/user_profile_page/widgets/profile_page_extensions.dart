import 'package:app/ui/pages/main_page/change_profile_page/change_profile_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/profileMe_reviews_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/widgets/profile_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../enums.dart';

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
                userStore!.userData!.avatar!.url,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 85.0,
                left: 50.0,
                child: Row(
                  children: [
                    for (int i = 0;
                        i < userStore!.userData!.ratingStatistic;
                        i++)
                      Icon(
                        Icons.star,
                        color: Color(0xFFE8D20D),
                        size: 20.0,
                      ),
                    for (int i = 0;
                        i < 5 - userStore!.userData!.ratingStatistic;
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
            "${userStore!.userData!.firstName} ${userStore!.userData!.lastName ?? " "}",
          ),
        ),
      );
}

extension ReviewsTab on ProfileReviewsState {
  Widget reviewsTab() => Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Material(
          color: const Color(0xFFF7F8FA),
          child: portfolioStore!.reviewsList.isNotEmpty
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  //controller: _scrollController,
                  padding: const EdgeInsets.only(
                    top: 0.0,
                  ),
                  itemCount: portfolioStore!.reviewsList.length,
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
                )
              : Center(
                  child: Text(
                    "You have no reviews yet",
                  ),
                ),
        ),
      );
}
