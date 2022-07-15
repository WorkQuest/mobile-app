import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/notification_page/notification_cell.dart';
import 'package:app/ui/pages/main_page/notification_page/store/notification_store.dart';
import 'package:app/ui/widgets/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  static const String routeName = "/notificationsPage";

  NotificationPage(this.userId);

  final String userId;

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late NotificationStore store;

  @override
  void initState() {
    store = context.read<NotificationStore>();
    store.getNotification(isForce: true);
    super.initState();
  }

  Widget build(context) {
    return ObserverListener<NotificationStore>(
      onSuccess: () {},
      onFailure: () => false,
      child: Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            displacement: 50,
            edgeOffset: 100,
            onRefresh: () {
              if (store.isLoading) {
                return Future.value(false);
              }
              return store.getNotification(isForce: true);
            },
            child: NotificationListener<ScrollEndNotification>(
              onNotification: (scrollEnd) {
                final metrics = scrollEnd.metrics;
                if (metrics.maxScrollExtent < metrics.pixels) {
                  if (store.isLoading) {
                    return false;
                  }
                  store.getNotification(isForce: false);
                }
                return true;
              },
              child: CustomScrollView(
                physics:
                    const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  CupertinoSliverNavigationBar(
                    largeTitle: Text("ui.notifications.title".tr()),
                  ),
                  Observer(
                    builder: (_) {
                      if (store.isSuccess && store.listOfNotifications.isEmpty) {
                        return SliverFillRemaining(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/empty_quest_icon.svg",
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'quests.notification.noNotifications'.tr(),
                                style: TextStyle(
                                  color: Color(0xFFD8DFE3),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            if (store.isLoading && store.listOfNotifications.isEmpty)
                              ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 6,
                                separatorBuilder: (context, index) => Divider(
                                  thickness: 1,
                                ),
                                itemBuilder: (context, index) =>
                                    const _ShimmerNotificationView(),
                              )
                            else
                              ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: store.isLoading
                                      ? store.listOfNotifications.length + 1
                                      : store.listOfNotifications.length,
                                  separatorBuilder: (context, index) => Divider(
                                        thickness: 1,
                                      ),
                                  itemBuilder: (context, index) {
                                    if (store.isLoading &&
                                        index == store.listOfNotifications.length) {
                                      return Column(
                                        children: const [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          CircularProgressIndicator.adaptive(),
                                        ],
                                      );
                                    }
                                    return Column(
                                      children: [
                                        NotificationCell(
                                          store: store,
                                          body: store.listOfNotifications[index],
                                          userId: widget.userId,
                                        ),
                                        if (index == store.listOfNotifications.length - 1)
                                          Divider(thickness: 1),
                                      ],
                                    );
                                  }),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShimmerNotificationView extends StatelessWidget {
  const _ShimmerNotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _ShimmerItem(height: 34, width: 34),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _ShimmerItem(height: 46, width: 46),
                  const SizedBox(width: 10),
                  _ShimmerItem(height: 20, width: 220),
                  const SizedBox(width: 5),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.centerLeft,
            child: const _ShimmerItem(
              width: 130,
              height: 20,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ShimmerItem(height: 40, width: 320),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShimmerItem extends StatelessWidget {
  final double height;
  final double width;

  const _ShimmerItem({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.stand(
      child: Container(
        child: SizedBox(
          height: height,
          width: width,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
        ),
      ),
    );
  }
}
