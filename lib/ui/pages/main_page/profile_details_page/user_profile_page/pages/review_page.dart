import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/widgets/profile_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../portfolio_page/store/portfolio_store.dart';

class ReviewPageArguments {
  final String userId;
  final UserRole role;
  final PortfolioStore store;

  ReviewPageArguments({
    required this.userId,
    required this.role,
    required this.store,
  });
}

class ReviewPage extends StatefulWidget {
  static const String routeName = '/reviewPage';

  final ReviewPageArguments arguments;

  const ReviewPage(this.arguments);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late bool isProfileYour;

  @override
  void initState() {
    if (widget.arguments.store.titleName == "Reviews")
      widget.arguments.store
          .getReviews(userId: widget.arguments.userId, newList: true);
    if (widget.arguments.store.titleName == "Portfolio")
      widget.arguments.store
          .getPortfolio(userId: widget.arguments.userId, newList: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        automaticallyImplyLeading: true,
        middle: Text(
          widget.arguments.store.titleName,
        ),
      ),
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification.metrics.atEdge &&
              scrollNotification.metrics.pixels ==
                  scrollNotification.metrics.maxScrollExtent &&
              !widget.arguments.store.isLoading) {
            print('NotificationListener | getReviews');
            if (widget.arguments.store.titleName == "Reviews")
              widget.arguments.store
                  .getReviews(userId: widget.arguments.userId, newList: false);

            if (widget.arguments.store.titleName == "Portfolio")
              widget.arguments.store.getPortfolio(
                  userId: widget.arguments.userId, newList: false);
          }
          setState(() {});
          return false;
        },
        child: Observer(
          builder: (_) => widget.arguments.store.isLoading &&
                  widget.arguments.store.reviewsList.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          if (widget.arguments.store.titleName == "Reviews")
                            for (int index = 0;
                                index <
                                    widget.arguments.store.reviewsList.length;
                                index++)
                              ReviewsWidget(
                                avatar: widget
                                        .arguments
                                        .store
                                        .reviewsList[index]
                                        .fromUser
                                        .avatar
                                        ?.url ??
                                    "https://workquest-cdn.fra1.digitaloceanspaces.com/sUYNZfZJvHr8fyVcrRroVo8PpzA5RbTghdnP0yEcJuIhTW26A5vlCYG8mZXs",
                                name: widget.arguments.store.reviewsList[index]
                                        .fromUser.firstName +
                                    " " +
                                    widget.arguments.store.reviewsList[index]
                                        .fromUser.lastName,
                                mark: widget
                                    .arguments.store.reviewsList[index].mark,
                                userRole: widget.arguments.store
                                            .reviewsList[index].fromUserId ==
                                        widget.arguments.store
                                            .reviewsList[index].quest.userId
                                    ? "role.employer"
                                    : "role.worker",
                                questTitle: widget.arguments.store
                                    .reviewsList[index].quest.title,
                                cutMessage:
                                    widget.arguments.store.messages[index],
                                message: widget
                                    .arguments.store.reviewsList[index].message,
                                id: widget.arguments.store.reviewsList[index]
                                    .fromUserId,
                                myId: widget.arguments.userId,
                                role: widget.arguments.role,
                                last: index ==
                                        widget.arguments.store.reviewsList
                                                .length -
                                            1
                                    ? true
                                    : false,
                              ),
                          if (widget.arguments.store.titleName == "Portfolio")
                            Column(
                              children: [
                                Observer(
                                  builder: (_) => widget.arguments.store
                                              .portfolioList.isEmpty &&
                                          !widget.arguments.store.isLoading
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : Column(
                                          children: [
                                            for (int index = 0;
                                                index <
                                                    widget.arguments.store
                                                        .portfolioList.length;
                                                index++)
                                              PortfolioWidget(
                                                index: index,
                                                imageUrl: widget
                                                        .arguments
                                                        .store
                                                        .portfolioList[index]
                                                        .medias
                                                        .isEmpty
                                                    ? "https://dev-app.workquest.co/_nuxt/img/logo.1baae1e.svg"
                                                    : widget
                                                        .arguments
                                                        .store
                                                        .portfolioList[index]
                                                        .medias
                                                        .first
                                                        .url,
                                                title: widget.arguments.store
                                                    .portfolioList[index].title,
                                                isProfileYour: false,
                                              ),
                                          ],
                                        ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
