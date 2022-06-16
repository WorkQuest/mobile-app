import 'package:app/constants.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/widgets/profile_widgets.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../portfolio_page/store/portfolio_store.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatefulWidget {
  static const String routeName = '/reviewPage';

  const ReviewPage(this.store);

  final PortfolioStore store;

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late ProfileMeResponse user;
  late bool isProfileYour;

  @override
  void initState() {
    if (widget.store.otherUserData == null)
      user = context.read<ProfileMeStore>().userData!;
    else
      user = widget.store.otherUserData!;
    if (widget.store.titleName == "Reviews")
      widget.store.getReviews(userId: user.id!, newList: true);
    if (widget.store.titleName == "Portfolio")
      widget.store.getPortfolio(userId: user.id!, newList: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        automaticallyImplyLeading: true,
        middle: Text(
          widget.store.titleName,
        ),
      ),
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification.metrics.atEdge &&
              scrollNotification.metrics.pixels ==
                  scrollNotification.metrics.maxScrollExtent &&
              !widget.store.isLoading) {
            if (widget.store.titleName == "Reviews")
              widget.store.getReviews(userId: user.id!, newList: false);

            if (widget.store.titleName == "Portfolio")
              widget.store.getPortfolio(userId: user.id!, newList: false);
          }
          setState(() {});
          return false;
        },
        child: Observer(
          builder: (_) => widget.store.isLoading &&
                  widget.store.reviewsList.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          if (widget.store.titleName == "Reviews")
                            for (int index = 0;
                                index < widget.store.reviewsList.length;
                                index++)
                              ReviewsWidget(
                                avatar: widget.store.reviewsList[index].fromUser
                                        .avatar?.url ??
                                    Constants.defaultImageNetwork,
                                name: widget.store.reviewsList[index].fromUser
                                        .firstName +
                                    " " +
                                    widget.store.reviewsList[index].fromUser
                                        .lastName,
                                mark: widget.store.reviewsList[index].mark,
                                userRole: widget.store.reviewsList[index]
                                            .fromUserId ==
                                        widget.store.reviewsList[index].quest
                                            .userId
                                    ? "role.employer"
                                    : "role.worker",
                                questTitle:
                                    widget.store.reviewsList[index].quest.title,
                                cutMessage: widget.store.messages[index],
                                message:
                                    widget.store.reviewsList[index].message,
                                id: widget.store.reviewsList[index].fromUserId,
                                myId: user.id!,
                                role: user.role,
                                last:
                                    index == widget.store.reviewsList.length - 1
                                        ? true
                                        : false,
                              ),
                          if (widget.store.titleName == "Portfolio")
                            Column(
                              children: [
                                Observer(
                                  builder: (_) => widget
                                              .store.portfolioList.isEmpty &&
                                          !widget.store.isLoading
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : Column(
                                          children: [
                                            for (int index = 0;
                                                index <
                                                    widget.store.portfolioList
                                                        .length;
                                                index++)
                                              PortfolioWidget(
                                                index: index,
                                                imageUrl: widget
                                                        .store
                                                        .portfolioList[index]
                                                        .medias
                                                        .isEmpty
                                                    ? "https://app-ver1.workquest.co/_nuxt/img/logo.1baae1e.svg"
                                                    : widget
                                                        .store
                                                        .portfolioList[index]
                                                        .medias
                                                        .first
                                                        .url,
                                                title: widget.store
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
