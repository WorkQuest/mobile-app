import 'package:app/ui/pages/main_page/my_quests_page/my_quests_item.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/my_disputes/dispute/store/dispute_store.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../../../../../../enums.dart';

class DisputePage extends StatefulWidget {
  static const String routeName = "/disputesPage";

  final String disputeId;

  const DisputePage(this.disputeId);

  @override
  _DisputePageState createState() => _DisputePageState();
}

class _DisputePageState extends State<DisputePage> {
  late DisputeStore store;

  double leftPos = 0.0;
  double bottomPos = 0.0;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    store = context.read<DisputeStore>();
    store.getDispute(widget.disputeId).then((value) {
      if (store.dispute != null) {
        store.getMessages(store.dispute!.quest.questChat!.chatId!);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          //Animate Padding
          if (scrollController.offset < 240)
            setState(() {
              leftPos = 0.0;
              bottomPos = 0.0;
            });
          if (scrollController.offset > 0 && scrollController.offset < 240)
            setState(() {
              leftPos = 25.0;
              bottomPos = 9.0;
            });
          return false;
        },
        child: Observer(
          builder: (_) => store.dispute == null
              ? Center(child: CircularProgressIndicator())
              : NestedScrollView(
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[appBar()];
                  },
                  body: Container(
                    color: Color(0xFFF7F8FA),
                    child: NotificationListener<ScrollEndNotification>(
                      onNotification: (scrollEnd) {
                        final metrics = scrollEnd.metrics;
                        if (metrics.maxScrollExtent < metrics.pixels &&
                            !store.isLoading) {
                          store.getMessages(
                              store.dispute!.quest.questChat!.chatId!);
                        }
                        return true;
                      },
                      child: SingleChildScrollView(
                        clipBehavior: Clip.none,
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        child: Observer(
                          builder: (_) {
                            return body();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget body() {
    return Column(
      children: [
        MyQuestsItem(
          store.dispute!.quest,
          itemType: QuestItemPriorityType.Active,
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          color: Colors.white,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                top: 16,
                bottom: 16,
              ),
              child: Text(
                "dispute.chatHistory".tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        //TODO: RETURN
        // Column(
        //   children: store.messages
        //       .map((element) => MessageCell(
        //             UniqueKey(),
        //             element,
        //             element.senderUserId,
        //           ))
        //       .toList(),
        // ),
      ],
    );
  }

  Widget appBar() {
    return SliverAppBar(
      expandedHeight: 100.0,
      pinned: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Color(0xFF0083C7),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
          left: 16.0,
          bottom: 8.0,
          top: 0.0,
        ),
        collapseMode: CollapseMode.pin,
        centerTitle: false,
        title: AnimatedPadding(
          padding: EdgeInsets.only(
            left: leftPos,
            bottom: bottomPos,
          ),
          duration: Duration(milliseconds: 100),
          child: Row(
            children: [
              Text(
                "dispute.myDispute".tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D2127),
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Padding(
                padding: EdgeInsets.only(top: 9),
                child: Text(
                  "№${store.dispute!.number}",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF7C838D),
                    fontSize: 10.0,
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Padding(
                padding: EdgeInsets.only(top: 9),
                child: Text(
                  store.getStatus(store.dispute!.status).tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: getColor(store.dispute!.status),
                    fontSize: 10.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getColor(int status) {
    switch (status) {
      case 0:
        return Colors.yellow;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.green;
    }
    return Colors.green;
  }
}
