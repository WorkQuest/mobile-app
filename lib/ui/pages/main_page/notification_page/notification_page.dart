import 'package:app/ui/pages/main_page/notification_page/notification_cell.dart';
import 'package:app/ui/pages/main_page/notification_page/store/notification_store.dart';
import 'package:app/ui/widgets/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
    store.getNotification(true);
    super.initState();
  }

  Widget build(context) {
    return Scaffold(
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (scrollEnd) {
          final metrics = scrollEnd.metrics;
          if (metrics.maxScrollExtent == metrics.pixels) {
            store.getNotification(false);
          }
          return true;
        },
        child: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: Text("ui.notifications.title".tr()),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Observer(
                    builder: (_) {
                      if (store.isLoading) {
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 6,
                          separatorBuilder: (context, index) => Divider(
                            thickness: 1,
                          ),
                          itemBuilder: (context, index) =>
                              const _ShimmerNotificationView(),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: store.listOfNotifications.length,
                        separatorBuilder: (context, index) => Divider(
                          thickness: 1,
                        ),
                        itemBuilder: (context, index) => Column(
                          children: [
                            NotificationCell(
                              store: store,
                              body: store.listOfNotifications[index],
                              userId: widget.userId,
                            ),
                            if (index == store.listOfNotifications.length - 1)
                              Divider(thickness: 1),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
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
