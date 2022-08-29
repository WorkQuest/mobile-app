import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/starred_messages_page/store/starred_message_store.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/starred_messages_page/widgets/starred_message_cell.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

const _physics = BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());

class StarredMessagePage extends StatefulWidget {
  static const String routeName = "/starredMessage";

  final String userId;

  const StarredMessagePage(this.userId);

  @override
  _StarredMessagePageState createState() => _StarredMessagePageState();
}

class _StarredMessagePageState extends State<StarredMessagePage> {
  late StarredMessageStore store;

  void initState() {
    store = context.read<StarredMessageStore>();
    store.getMessages(isForce: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObserverListener<StarredMessageStore>(
      onSuccess: () {
        if (store.successData == StarredMessageStoreState.removeStar) {
          setState(() {});
        }
      },
      onFailure: () => false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_sharp,
            ),
          ),
          centerTitle: true,
          title: Text(
            "chat.starredMessage".tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: NotificationListener<ScrollStartNotification>(
            onNotification: (scrollStart) {
              final metrics = scrollStart.metrics;
              if (metrics.maxScrollExtent < metrics.pixels &&
                  !store.isLoading) {
                store.getMessages();
              }
              return true;
            },
            child: RefreshIndicator(
              onRefresh: () async {
                store.getMessages(isForce: true);
                return;
              },
              child: Observer(
                builder: (_) {
                  if (store.isLoading && store.messages.isEmpty) {
                    return Center(child: CircularProgressIndicator.adaptive());
                  }
                  if (store.isSuccess && store.messages.isEmpty) {
                    return SingleChildScrollView(
                      physics: _physics,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 3,
                            width: double.infinity,
                          ),
                          SvgPicture.asset(
                            "assets/empty_quest_icon.svg",
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'chat.noStarMessages'.tr(),
                            style: TextStyle(
                              color: Color(0xFFD8DFE3),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 3,
                            width: double.infinity,
                          ),
                        ],
                      ),
                    );
                  }
                  if (store.messages.isNotEmpty) {
                    return ListView.separated(
                      physics: _physics,
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.black12,
                        endIndent: 50.0,
                        indent: 50.0,
                      ),
                      itemCount: store.isLoading
                          ? store.messages.length + 1
                          : store.messages.length,
                      itemBuilder: (context, index) {
                        if (store.isLoading && index == store.messages.length) {
                          return Column(
                            children: const [
                              SizedBox(
                                height: 10,
                              ),
                              CircularProgressIndicator.adaptive(),
                            ],
                          );
                        }
                        final message = store.messages[index];
                        return StarredMessageCell(
                          message: message,
                          setStar: () => store.removeStar(message),
                          userId: widget.userId,
                          index: index,
                          store: store,
                        );
                      },
                    );
                  }
                  return SizedBox();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
