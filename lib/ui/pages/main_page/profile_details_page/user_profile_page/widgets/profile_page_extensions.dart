import 'dart:async';

import 'package:app/constants.dart';
import 'package:app/enums.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/ui/pages/main_page/change_profile_page/change_profile_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/review_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/widgets/profile_widgets.dart';
import 'package:app/ui/widgets/user_avatar.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share/share.dart';

import '../../../../report_page/report_page.dart';

extension CustomAppBar on UserProfileState {
  Widget sliverAppBar(ProfileMeResponse info,
      StreamController<AppBarParams> streamController, Function() updateState) {
    final mark = info.ratingStatistic!.averageMark;
    final markDev = mark.toInt();
    final markMod = (mark % (markDev == 0 ? 1 : markDev) * 10).round() / 10;
    return StreamBuilder<AppBarParams>(
      initialData: AppBarParams.initial(),
      stream: streamController.stream,
      builder: (_, snapshot) {
        final _color = Color.lerp(
            AppColor.enabledButton, Colors.white, snapshot.data!.color / 255);
        return SliverAppBar(
          backgroundColor: Color(0xFF0083C7),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: _color,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.share_outlined,
                color: _color,
              ),
              onPressed: () async {
                late String _url;
                if (AccountRepository().notifierNetwork.value ==
                    Network.mainnet) {
                  _url =
                      "https://app.workquest.co/profile/${info.id}";
                } else {
                  _url =
                      "https://${Constants.isTestnet ? 'testnet' : 'dev'}-app.workquest.co/profile/${info.id}";
                }
                Share.share(_url);
              },
            ),
            if (info.id == userStore!.userData!.id)
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: _color,
                ),
                onPressed: () async {
                  final result =
                      await Navigator.of(context, rootNavigator: true)
                          .pushNamed(
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
                  color: _color,
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
                Positioned.fill(child: ColoredBox(color: Colors.black)),
                UserAvatar(
                  url: info.avatar?.url,
                  fit: BoxFit.fitHeight,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  loadingFitSize: false,
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
        );
      },
    );
  }
}

extension ReviewsTab on UserProfileState {
  List<Widget> reviewsTab() => [
        const SizedBox(height: 20),
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
                    if (portfolioStore!.reviewsList.length > 3)
                      Padding(
                        padding: EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            portfolioStore!.setTitleName("Reviews");
                            Navigator.pushNamed(
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
                          },
                          child: Text("meta.showAllReviews".tr()),
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
                      SvgPicture.asset("assets/empty_quest_icon.svg"),
                      const SizedBox(height: 10.0),
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
