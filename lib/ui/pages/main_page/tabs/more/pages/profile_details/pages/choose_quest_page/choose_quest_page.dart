import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/chat_room_page/chat_room_page.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/profile_details/pages/choose_quest_page/store/choose_quest_store.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ChooseQuestPage extends StatefulWidget {
  static const String routeName = '/chooseQuestPage';

  const ChooseQuestPage({required this.workerId});

  final String workerId;

  @override
  State<ChooseQuestPage> createState() => _ChooseQuestPageState();
}

class _ChooseQuestPageState extends State<ChooseQuestPage> {
  late ChooseQuestStore store;

  @override
  void initState() {
    store = context.read<ChooseQuestStore>();
    store.getQuests(userId: widget.workerId);
    super.initState();
  }

  _stateListener() {
    if (store.successData == ChooseQuestState.startQuest) {
      context.read<ChatStore>().refreshChats();
      Navigator.of(context, rootNavigator: true).pushReplacementNamed(
        ChatRoomPage.routeName,
        arguments: ChatRoomArguments(store.chatId, true),
      );
      AlertDialogUtils.showSuccessDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ObserverListener<ChooseQuestStore>(
      onSuccess: _stateListener,
      onFailure: () => false,
      child: Scaffold(
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 45.0,
                    child: OutlinedButton(
                      onPressed: _onPressedCancel,
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
                      onPressed: store.questId.isNotEmpty && !store.isLoading ? _onPressedAddToQuest : null,
                      child: Text("quests.addToQuest".tr()),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
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
          builder: (_) {
            if (store.quests.isEmpty && store.isLoading) {
              return Center(child: CircularProgressIndicator.adaptive());
            }
            return NotificationListener<ScrollEndNotification>(
              onNotification: _onScrollListener,
              child: ListView.builder(
                itemBuilder: (context, index) => Observer(
                  builder: (_) {
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
                      onChanged: (_) => _onPressedSetQuest(store.quests[index].id),
                    );
                  },
                ),
                itemCount: store.showMore ? store.quests.length + 1 : store.quests.length,
              ),
            );
          },
        ),
      ),
    );
  }

  _onPressedAddToQuest() {
    store.startQuest(userId: widget.workerId);
  }

  _onPressedCancel() {
    Navigator.pop(context);
  }

  bool _onScrollListener(ScrollEndNotification scrollEnd) {
    final metrics = scrollEnd.metrics;
    if ((metrics.atEdge || metrics.maxScrollExtent < metrics.pixels) && !store.isLoading) {
      store.getQuests(userId: widget.workerId, isForce: false);
    }
    return true;
  }

  _onPressedSetQuest(String questId) {
    store.setQuest(questId);
  }
}
