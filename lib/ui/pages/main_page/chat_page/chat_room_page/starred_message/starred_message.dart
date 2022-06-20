import 'package:app/ui/pages/main_page/chat_page/chat_room_page/starred_message/starred_message_cell.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/starred_message/store/starred_message_store.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class StarredMessage extends StatefulWidget {
  static const String routeName = "/starredMessage";

  final String userId;

  const StarredMessage(this.userId);

  @override
  _StarredMessageState createState() => _StarredMessageState();
}

class _StarredMessageState extends State<StarredMessage> {
  late StarredMessageStore store;

  void initState() {
    store = context.read<StarredMessageStore>();
    store.getMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Observer(
        builder: (_) => store.initPage
            ? Center(child: CircularProgressIndicator.adaptive())
            : store.messages.isNotEmpty
                ? Padding(
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
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                          color: Colors.black12,
                          endIndent: 50.0,
                          indent: 50.0,
                        ),
                        itemCount: store.messages.length,
                        itemBuilder: (context, index) => StarredMessageCell(
                          store.messages[index],
                          index,
                          widget.userId,
                          store,
                        ),
                      ),
                    ),
                  )
                : Center(child: Text("chat.noMessages".tr())),
      ),
    );
  }
}
