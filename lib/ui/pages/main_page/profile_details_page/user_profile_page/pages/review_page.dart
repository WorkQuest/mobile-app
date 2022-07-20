import 'package:app/constants.dart';
import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/profile_details_page/portfolio_page/details_portfolio/store/portfolio_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/widgets/profile_widgets.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

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
  late PortfolioStore store;

  bool get isReviews => store.titleName == "Reviews";
  bool get isPortfolio => store.titleName == "Portfolio";

  @override
  void initState() {
    store = widget.arguments.store;
    if (isReviews) store.getReviews(userId: widget.arguments.userId, isForce: true);
    if (isPortfolio) store.getPortfolio(userId: widget.arguments.userId, isForce: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: store.titleName),
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (scrollEnd) {
          final metrics = scrollEnd.metrics;
          if (metrics.maxScrollExtent < metrics.pixels) {
            if (store.isLoading) {
              return false;
            }
            if (isReviews) {
              store.getReviews(
                userId: widget.arguments.userId,
              );
            }

            if (isPortfolio) {
              store.getPortfolio(
                userId: widget.arguments.userId,
              );
            }
          }
          return true;
        },
        child: Observer(
          builder: (_) {
            if (store.isLoading &&
                (isReviews ? store.reviewsList.isEmpty : store.portfolioList.isEmpty)) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (isReviews) {
              return ListView.builder(
                physics:
                    const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                itemCount: store.isLoading
                    ? store.reviewsList.length + 1
                    : store.reviewsList.length,
                itemBuilder: (_, index) {
                  if (store.isLoading && index == store.reviewsList.length) {
                    return Column(
                      children: const [
                        SizedBox(
                          height: 10,
                        ),
                        CircularProgressIndicator.adaptive(),
                      ],
                    );
                  }
                  final review = store.reviewsList[index];
                  return ReviewsWidget(
                    avatar: review.fromUser.avatar?.url ?? Constants.defaultImageNetwork,
                    name: review.fromUser.firstName + " " + review.fromUser.lastName,
                    mark: review.mark,
                    userRole: review.fromUser.role == UserRole.Employer
                        ? "role.employer"
                        : "role.worker",
                    questTitle: review.quest.title,
                    message: review.message,
                    id: review.fromUserId,
                    myId: widget.arguments.userId,
                    role: widget.arguments.role,
                  );
                },
              );
            }
            if (isPortfolio) {
              return ListView.builder(
                physics:
                    const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                itemCount: store.isLoading
                    ? store.portfolioList.length + 1
                    : store.portfolioList.length,
                itemBuilder: (_, index) {
                  if (store.isLoading && index == store.portfolioList.length) {
                    return Column(
                      children: const [
                        SizedBox(
                          height: 10,
                        ),
                        CircularProgressIndicator.adaptive(),
                      ],
                    );
                  }
                  final portfolio = store.portfolioList[index];
                  return PortfolioWidget(
                    addPortfolio: store.addPortfolio,
                    index: index,
                    imageUrl: portfolio.medias.isEmpty
                        ? Constants.defaultImageNetwork
                        : portfolio.medias.first.url,
                    title: portfolio.title,
                    isProfileYour: GetIt.I.get<ProfileMeStore>().userData!.id == widget.arguments.userId,
                  );
                },
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
