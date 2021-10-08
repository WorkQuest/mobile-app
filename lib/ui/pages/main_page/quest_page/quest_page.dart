import 'package:app/ui/pages/main_page/quest_page/quest_list/quest_list.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_map/quest_map.dart';
import 'package:app/ui/pages/main_page/quest_page/store/quest_page_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';


class QuestPage extends StatelessWidget{
  final QuestPageStore questPage = QuestPageStore();

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => IndexedStack(
        index: questPage.pageIndex,
        children: [
          QuestMap(questPage.setQuestListPage),
          QuestList(questPage.setMapPage),
        ],
      ),
    );
  }
}
