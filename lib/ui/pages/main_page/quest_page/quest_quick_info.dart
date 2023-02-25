import 'package:app/ui/pages/main_page/my_quests_page/my_quests_item.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_list/store/quests_store.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_list/workers_item.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_map/store/quest_map_store.dart';
import 'package:flutter/material.dart';
import "package:provider/provider.dart";

class QuestQuickInfo extends StatefulWidget {
  QuestQuickInfo();

  @override
  _QuestQuickInfoState createState() => _QuestQuickInfoState();
}

class _QuestQuickInfoState extends State<QuestQuickInfo> {
  @override
  Widget build(BuildContext context) {
    final QuestMapStore mapStore = context.read<QuestMapStore>();

    bool showInfo = !mapStore.hideInfo &&
        (mapStore.currentQuestCluster.isNotEmpty ||
            mapStore.currentWorkerCluster.isNotEmpty);

    return AnimatedContainer(
      height: showInfo ? 324.0 : 0.0,
      width: MediaQuery.of(context).size.width,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      child: Container(
        color: Colors.white,
        child: ListView.builder(
            itemCount: (mapStore.isWorker ?? true)
                ? mapStore.currentQuestCluster.length
                : mapStore.currentWorkerCluster.length,
            itemBuilder: (_, index) {
              if (mapStore.isWorker ?? true)
                return MyQuestsItem(
                  mapStore.currentQuestCluster[index],
                  isExpanded: true,
                );
              return WorkersItem(
                mapStore.currentWorkerCluster[index],
                context.read<QuestsStore>(),
                showRating: true,
              );
            }),
      ),
    );
  }
}
