import 'package:app/ui/pages/main_page/my_quests_page/my_quests_item.dart';
import 'package:app/ui/pages/main_page/quest_details_page/quest_details_page.dart';
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
    return AnimatedContainer(
      height: mapStore.infoPanel == InfoPanel.Nope ? 0.0 : 324.0,
      width: MediaQuery.of(context).size.width,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      child: mapStore.infoPanel == InfoPanel.Point
          ? getQuestBody()
          : getClusterBody(),
    );
  }

  Widget getClusterBody() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 36.0, left: 16),
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  "Quests in the region:\n",
                  style: TextStyle(fontSize: 20),
                ),
                Text("???"),
              ],
            ),
          ),
          Spacer(),
          button(
            title: "View all",
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget getQuestBody() {
    final QuestMapStore mapStore = context.read<QuestMapStore>();
    return Container(
      color: Colors.white,
      child: mapStore.selectQuestInfo != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyQuestsItem(mapStore.selectQuestInfo!, isExpanded: true),
                Spacer(),
                button(
                  title: "Show more",
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pushNamed(
                        QuestDetails.routeName,
                        arguments: mapStore.selectQuestInfo!);
                  },
                ),
              ],
            )
          : Flexible(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }

  Widget button({required String title, required void Function()? onPressed}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      width: MediaQuery.of(context).size.width - 32,
      height: 43,
      child: TextButton(
        onPressed: onPressed,
        child: Text(title, style: TextStyle(color: Colors.white)),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return Theme.of(context).colorScheme.primary.withOpacity(0.5);
              return const Color(0xFF0083C7);
            },
          ),
        ),
      ),
    );
  }
}
