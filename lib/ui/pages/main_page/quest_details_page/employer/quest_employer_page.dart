import 'package:app/model/profile_response/avatar.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/model/responded_model.dart';
import 'package:app/model/user_model.dart';
import 'package:app/ui/pages/main_page/create_quest_page/create_quest_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/employer/store/employer_store.dart';
import 'package:app/ui/pages/main_page/quest_details_page/quest_details_page.dart';
import 'package:app/ui/pages/main_page/raise_views_page/raise_views_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";

class QuestEmployer extends QuestDetails {
  QuestEmployer(BaseQuestResponse questInfo) : super(questInfo);

  @override
  _QuestEmployerState createState() => _QuestEmployerState();
}

class _QuestEmployerState extends QuestDetailsState<QuestEmployer> {
  late EmployerStore store;
  @override
  void initState() {
    store = context.read<EmployerStore>();
    store.getRespondedList(widget.questInfo.id);
    super.initState();
  }

  @override
  List<Widget>? actionAppBar() {
    return <Widget>[
      IconButton(icon: Icon(Icons.share_outlined), onPressed: () {}),
      PopupMenuButton<String>(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        onSelected: (value) {
          switch (value) {
            case "Raise views":
              Navigator.pushNamed(context, RaiseViews.routeName,
                  arguments: widget.questInfo);
              break;
            case "Edit":
              Navigator.pushNamed(context, CreateQuestPage.routeName,
                  arguments: widget.questInfo);
              break;
            case "Delete":
              break;
            default:
          }
        },
        itemBuilder: (BuildContext context) {
          return {'Raise views', 'Edit', 'Delete'}.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        },
      ),
    ];
  }

  @override
  Widget getBody() {
    return respondedList();
  }

  @override
  Widget inProgressBy() {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "In progress by:",
            style: TextStyle(color: const Color(0xFF7C838D), fontSize: 12),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Image.asset(
                  "assets/profile_avatar_test.jpg",
                  fit: BoxFit.fitHeight,
                  height: 30,
                  width: 30,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Rosalia Vans",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }

  Widget respondedList() {
    return Observer(
      builder: (_) => (store.respondedList == null)
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                if (store.respondedList!.isNotEmpty)
                  const Text(
                    "Responded",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF1D2127),
                        fontWeight: FontWeight.w500),
                  ),
                if (store.respondedList!.isNotEmpty)
                  for (var i = 0; i < store.respondedList!.length; i++)
                    selectableMember(i),
                const Text(
                  "You invited",
                  style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF1D2127),
                      fontWeight: FontWeight.w500),
                ),
                for (var i = 5; i < 7; i++) selectableMember(i),
              ],
            ),
    );
  }

  Widget selectableMember(int index) {
    RespondedModel response = (store.respondedList!.length > index)
        ? store.respondedList![index]
        : RespondedModel(
            createdAt: DateTime.now(),
            id: "user",
            type: 1,
            status: 1,
            message: "",
            questId: "",
            workerId: "",
            worker: User(
                id: "id",
                firstName: "firstName $index",
                lastName: "lastName $index",
                avatar: Avatar.fromJson(null)),
          );
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.5,
            child: Radio(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: index,
              groupValue: selectedResponders,
              onChanged: (i) {
                setState(() {
                  selectedResponders = index;
                });
              },
            ),
          ),
          const SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            child: Image.network(
              response.worker.avatar.url,
              fit: BoxFit.cover,
              height: 50,
              width: 50,
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${response.worker.firstName} ${response.worker.firstName}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6CF00),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  "HIGHER LEVEL",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
