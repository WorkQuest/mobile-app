import 'package:app/ui/pages/main_page/chat_page/chat_room_page/chat_room_page.dart';
import 'package:app/ui/pages/main_page/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/choose_quest/store/choose_quest_store.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ChooseQuestPage extends StatefulWidget {
  static const String routeName = '/chooseQuestPage';

  const ChooseQuestPage({
    required this.workerId,
  });

  final String workerId;

  @override
  State<ChooseQuestPage> createState() => _ChooseQuestPageState();
}

class _ChooseQuestPageState extends State<ChooseQuestPage> {
  late ChooseQuestStore store;

  @override
  void initState() {
    store = context.read<ChooseQuestStore>();
    store.getQuests(
      userId: widget.workerId,
      newList: true,
      isProfileYours: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [buttonRow(context, store)],
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_sharp,
          ),
        ),
        centerTitle: true,
        title: Text(
          "quests.quests".tr(),
          style: TextStyle(
            color: Color(0xFF1D2127),
          ),
        ),
      ),
      body: Observer(
        builder: (_) => store.quests.isEmpty && store.isLoading
            ? Center(child: CircularProgressIndicator.adaptive())
            : NotificationListener<ScrollEndNotification>(
                onNotification: (scrollEnd) {
                  final metrics = scrollEnd.metrics;
                  if ((metrics.atEdge ||
                          metrics.maxScrollExtent < metrics.pixels) &&
                      !store.isLoading) {
                    store.getQuests(
                      userId: widget.workerId,
                      newList: false,
                      isProfileYours: false,
                    );
                  }
                  return true;
                },
                child: ListView.builder(
                  itemBuilder: (context, index) => Observer(builder: (_) {
                    if (store.showMore && index == store.quests.length) {
                      return Column(
                        children: const [
                          SizedBox(
                            height: 10,
                          ),
                          CircularProgressIndicator.adaptive(),
                        ],
                      );
                    }
                    return RadioListTile<String>(
                      title: Text(
                        store.quests[index].title,
                      ),
                      value: store.quests[index].id,
                      groupValue: store.questId,
                      onChanged: (value) {
                        store.setQuest(
                          store.quests[index].id,
                        );
                      },
                    );
                  }),
                  itemCount: store.showMore
                      ? store.quests.length + 1
                      : store.quests.length,
                ),
              ),
      ),
    );
  }

  Widget buttonRow(
    BuildContext context,
    ChooseQuestStore store,
  ) =>
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 45.0,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("meta.cancel".tr()),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      width: 1.0,
                      color: Color(0xFF0083C7).withOpacity(0.1),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Observer(
                builder: (_) => ElevatedButton(
                  onPressed: store.questId.isNotEmpty
                      ? () async {
                          await store.startQuest(userId: widget.workerId);
                          if (store.isSuccess) {
                            context.read<ChatStore>().refreshChats();
                            Navigator.of(context, rootNavigator: true)
                                .pushReplacementNamed(
                              ChatRoomPage.routeName,
                              arguments: ChatRoomArguments(store.chatId, true),
                            );
                            AlertDialogUtils.showSuccessDialog(context);
                          }
                        }
                      : null,
                  child: Text("wallet.send".tr()),
                ),
              ),
            ),
          ],
        ),
      );
}
