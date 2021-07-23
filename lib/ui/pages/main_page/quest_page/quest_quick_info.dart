import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/my_quests_page/my_quest_details.dart';
import 'package:app/ui/pages/main_page/my_quests_page/my_quests_item.dart';
import 'package:flutter/material.dart';

class QuestQuickInfo extends StatefulWidget {
  final BaseQuestResponse? quest;
  QuestQuickInfo(this.quest);

  @override
  _QuestQuickInfoState createState() => _QuestQuickInfoState();
}

class _QuestQuickInfoState extends State<QuestQuickInfo> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: widget.quest == null ? 0.0 : 324.0,
      width: MediaQuery.of(context).size.width,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.quest != null)
              MyQuestsItem(widget.quest!, isExpanded: true),
            Spacer(),
            Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                width: MediaQuery.of(context).size.width - 32,
                height: 43,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pushNamed(
                        MyQuestDetails.routeName,
                        arguments: widget.quest);
                  },
                  child:
                      Text("Show more", style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5);
                        return const Color(0xFF0083C7);
                      },
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
