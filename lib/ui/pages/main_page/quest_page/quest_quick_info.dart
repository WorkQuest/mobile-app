import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:flutter/material.dart';

class QuestQuickInfo extends StatefulWidget {
  final BaseQuestResponse? quest;
  QuestQuickInfo(this.quest);

  @override
  _QuestQuickInfoState createState() => _QuestQuickInfoState();
}

class Priority {
  final int r;
  final int g;
  final int b;
  final String lable;
  Priority(this.r, this.g, this.b, this.lable);
}

class _QuestQuickInfoState extends State<QuestQuickInfo> {
  bool isFavorite = false;
  List<Priority> prioritys = [
    Priority(34, 204, 20, ""),
    Priority(34, 204, 20, "Low"),
    Priority(232, 210, 13, "Normal"),
    Priority(223, 51, 51, "Urgent")
  ];
  @override
  Widget build(BuildContext context) {
    final priority = prioritys[widget.quest?.priority ?? 0];
    return AnimatedContainer(
        height: widget.quest == null ? 0.0 : 324.0,
        width: MediaQuery.of(context).size.width,
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn,
        child: Container(
            padding: EdgeInsets.fromLTRB(16.0, 22.0, 16.0, 16.0),
            color: Colors.white,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    'https://pbs.twimg.com/profile_images/2881220369/2b27ac38b43b17a8c5eacfc443ce3384_400x400.jpeg',
                    width: 30.0,
                    height: 30.0,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(width: 10.0),
                Text(
                  "${widget.quest?.user.firstName ?? ""} ${widget.quest?.user.lastName ?? ""}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Spacer(),
                IconButton(
                    onPressed: () => setState(() => isFavorite = !isFavorite),
                    icon: isFavorite
                        ? Icon(
                            Icons.star,
                            size: 30,
                            color: Color(0xFFE8D20D),
                          )
                        : Icon(
                            Icons.star_border_outlined,
                            size: 30,
                            color: Color(0xFFE9EDF2),
                          ))
              ]),
              Row(
                children: [
                  Icon(Icons.location_on_rounded, color: Color(0xFF7C838D)),
                  Text("220m from you",
                      style: TextStyle(
                          color: Color(0xFF7C838D),
                          fontSize: 14,
                          fontWeight: FontWeight.w400))
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.quest?.title ?? "",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Text(
                widget.quest?.description ?? "",
                style: TextStyle(
                    color: Color(0xFF4C5767), fontWeight: FontWeight.w400),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  priority.lable.length == 0
                      ? Container()
                      : Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(
                                  priority.r, priority.g, priority.b, 0.1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.0))),
                          child: Text(
                            "${priority.lable} priority",
                            style: TextStyle(
                                color: Color.fromRGBO(
                                    priority.r, priority.g, priority.b, 1),
                                fontSize: 12),
                          ),
                        ),
                  Text("${widget.quest?.price ?? "--"} WUSD",
                      style: TextStyle(
                          color: Color(0xFF00AA5B),
                          fontSize: 18,
                          fontWeight: FontWeight.w700))
                ],
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 18),
                  width: MediaQuery.of(context).size.width - 32,
                  height: 43,
                  child: TextButton(
                    onPressed: () {},
                    child: Text("Show more",
                        style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.5);
                          return Color(0xFF0083C7);
                        },
                      ),
                    ),
                  ))
            ])));
  }
}
