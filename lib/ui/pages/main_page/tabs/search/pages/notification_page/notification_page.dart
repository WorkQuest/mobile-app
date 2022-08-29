import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/notification_page/store/notification_store.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/notification_page/widgets/notification_cell.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/notification_page/widgets/shimmer/shimmer_notification_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  static const String routeName = "/notificationsPage";

  const NotificationPage();

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late NotificationStore store;

  @override
  void initState() {
    store = context.read<NotificationStore>();
    store.getNotification();
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
            onRefresh: _onRefresh,
            child: NotificationListener<ScrollEndNotification>(
              onNotification: _scrollListener,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  CupertinoSliverNavigationBar(
                    largeTitle: Text("ui.notifications.title".tr()),
                  ),
                  Observer(
                    builder: (_) {
                      if (store.isSuccess &&
                          store.listOfNotifications.isEmpty) {
                        return SliverFillRemaining(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/empty_quest_icon.svg"),
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
                            if (store.isLoading &&
                                store.listOfNotifications.isEmpty)
                              ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 6,
                                separatorBuilder: (context, index) => Divider(
                                  thickness: 1,
                                ),
                                itemBuilder: (context, index) =>
                                    const ShimmerNotificationView(),
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
                                      index ==
                                          store.listOfNotifications.length) {
                                    return Column(
                                      children: const [
                                        SizedBox(height: 10),
                                        CircularProgressIndicator.adaptive(),
                                      ],
                                    );
                                  }
                                  return Column(
                                    children: [
                                      NotificationCell(
                                        store: store,
                                        body: store.listOfNotifications[index],
                                      ),
                                      if (index ==
                                          store.listOfNotifications.length - 1)
                                        Divider(thickness: 1),
                                    ],
                                  );
                                },
                              ),
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

  Future<void> _onRefresh() {
    if (store.isLoading) {
      return Future.value(false);
    }
    return store.getNotification();
  }

  bool _scrollListener(ScrollEndNotification scrollEnd) {
    final before = scrollEnd.metrics.extentBefore;
    final max = scrollEnd.metrics.maxScrollExtent;

    if (before == max) {
      if (store.isLoading) return true;
      store.getNotification(isForce: false);
    }

    return true;
  }
}
