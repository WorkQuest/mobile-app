import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/my_quests_page/my_quests_item.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/search_list_page/store/search_list_store.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/search_list_page/widgets/workers_item.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/search_map/store/search_map_store.dart';
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
    final SearchMapStore mapStore = context.read<SearchMapStore>();

    bool showInfo = !mapStore.hideInfo &&
        (mapStore.currentQuestCluster.isNotEmpty ||
            mapStore.currentWorkerCluster.isNotEmpty);

    return AnimatedContainer(
      height: showInfo ? 370.0 : 0.0,
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
                  questInfo: mapStore.currentQuestCluster[index],
                  itemType: QuestsType.All,
                  isExpanded: true,
                  showStar: false,
                );
              return WorkersItem(
                mapStore.currentWorkerCluster[index],
                context.read<SearchListStore>(),
                showRating: true,
              );
            }),
      ),
    );
  }
}
