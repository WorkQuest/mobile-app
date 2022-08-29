import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/create_quest_page/create_quest_page.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/widgets/quests_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

class QuestsListType extends StatefulWidget {
  const QuestsListType({
    required this.store,
    required this.type,
    required this.role,
  });

  final MyQuestStore store;
  final QuestsType type;
  final UserRole role;

  @override
  State<QuestsListType> createState() => _QuestsListTypeState();
}

class _QuestsListTypeState extends State<QuestsListType> {
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if (widget.store.quests[widget.type] == null) {
        widget.store.getQuests(questType: widget.type);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: NotificationListener<ScrollEndNotification>(
          onNotification: _onScrollListener,
          child: Observer(
            builder: (_) => Column(
              children: [
                if (widget.role == UserRole.Employer)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12.0,
                      right: 12.0,
                      top: 15.0,
                      bottom: 15.0,
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.of(context, rootNavigator: true).pushNamed<bool>(
                          CreateQuestPage.routeName,
                        );
                      },
                      child: Text("quests.addNewQuest".tr()),
                    ),
                  ),
                Expanded(
                  child: QuestsList(
                    widget.type,
                    widget.store.quests[widget.type] ?? ObservableList.of([]),
                    isLoading: widget.store.isLoading,
                    from: FromQuestList.myQuest,
                    role: widget.role,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() {
    return widget.store.getQuests(questType: widget.type);
  }

  bool _onScrollListener(ScrollEndNotification scrollEnd) {
    final metrics = scrollEnd.metrics;
    if (metrics.maxScrollExtent < metrics.pixels && !widget.store.isLoading) {
      widget.store.getQuests(questType: widget.type, isForce: false);
    }
    return true;
  }
}
