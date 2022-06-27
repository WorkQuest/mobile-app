import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/my_quests_page/quests_list.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

class QuestsTab extends StatefulWidget {
  const QuestsTab({
    required this.store,
    required this.type,
    required this.role,
  });

  final MyQuestStore store;
  final QuestsType type;
  final UserRole role;

  @override
  State<QuestsTab> createState() => _QuestsTabState();
}

class _QuestsTabState extends State<QuestsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      widget.store.getQuests(widget.type, widget.role, true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () {
        return widget.store.getQuests(widget.type, widget.role, true);
      },
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (scrollEnd) {
          final metrics = scrollEnd.metrics;
          if (metrics.maxScrollExtent < metrics.pixels &&
              !widget.store.isLoading) {
            widget.store.getQuests(widget.type, widget.role, false);
          }
          return true;
        },
        child: Observer(
          builder: (_) => QuestsList(
            widget.type,
            widget.store.quests[widget.type] ?? ObservableList.of([]),
            isLoading: widget.store.isLoading,
            from: FromQuestList.myQuest,
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
