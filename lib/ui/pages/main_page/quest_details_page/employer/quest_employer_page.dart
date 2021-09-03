import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/model/respond_model.dart';
import 'package:app/ui/pages/main_page/quest_details_page/employer/store/employer_store.dart';
import 'package:app/ui/pages/main_page/quest_details_page/quest_details_page.dart';
import 'package:app/ui/pages/main_page/quest_page/create_quest_page/create_quest_page.dart';
import 'package:app/ui/pages/main_page/raise_views_page/raise_views_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

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
          return {
            'quests.raiseViews'.tr(),
            'registration.edit'.tr(),
            'settings.delete'.tr()
          }.map((String choice) {
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
            "quests.inProgressBy".tr(),
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
          : store.respondedList!.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    if (store.respondedList!.isNotEmpty)
                      Text(
                        "btn.responded".tr(),
                        style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF1D2127),
                            fontWeight: FontWeight.w500),
                      ),
                    if (store.respondedList!.isNotEmpty)
                      for (final respond in store.respondedList ?? [])
                        selectableMember(respond),
                    // const SizedBox(height: 10),
                    // const Text(
                    //   "You invited",
                    //   style: TextStyle(
                    //       fontSize: 18,
                    //       color: Color(0xFF1D2127),
                    //       fontWeight: FontWeight.w500),
                    // ),
                    // for (var i = 0; i < 3; i++)
                    //   selectableMember(
                    //     RespondModel(
                    //       createdAt: DateTime.now(),
                    //       id: "user$i",
                    //       type: 1,
                    //       status: 1,
                    //       message: "",
                    //       questId: "",
                    //       workerId: "",
                    //       worker: User(
                    //           id: "id",
                    //           firstName: "firstName $i",
                    //           lastName: "lastName $i",
                    //           avatar: Avatar.fromJson(null)),
                    //     ),
                    //   ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed:
                          store.selectedResponders.isEmpty ? null : () {},
                      child: Text(
                        "Choose a worker",
                        style: TextStyle(
                            color: store.selectedResponders.isEmpty
                                ? Colors.grey
                                : Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled))
                              return const Color(0xFFF7F8FA);
                            if (states.contains(MaterialState.pressed))
                              return Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.5);
                            return const Color(0xFF0083C7);
                          },
                        ),
                        fixedSize: MaterialStateProperty.all(
                            Size(double.maxFinite, 43)),
                      ),
                    )
                  ],
                )
              : const SizedBox(),
    );
  }

  Widget selectableMember(RespondModel respond) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...respondedUser(respond),
              Spacer(),
              Transform.scale(
                scale: 1.5,
                child: Radio(
                  toggleable: true,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: respond.id,
                  groupValue: store.selectedResponders,
                  onChanged: (String? id) =>
                      store.selectedResponders = id ?? "",
                ),
              ),
            ],
          ),
          if (respond.message.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              respond.message,
              textAlign: TextAlign.start,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            GestureDetector(
              child: Text(
                "Show more",
                style: TextStyle(color: Color(0xFF0083C7)),
              ),
              onTap: () => showMore(respond),
            )
          ]
        ],
      ),
    );
  }

  List<Widget> respondedUser(RespondModel respond) {
    return [
      ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        child: Image.network(
          respond.worker.avatar.url,
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
            "${respond.worker.firstName} ${respond.worker.lastName}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFF6CF00),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              "levels.higher".tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ];
  }

  showMore(RespondModel respond) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6.0), topRight: Radius.circular(6.0)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(
            top: 20,
            left: 16,
            right: 16,
          ),
          child: Column(
            children: <Widget>[
              Row(children: respondedUser(respond)),
              const SizedBox(height: 15),
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      respond.message,
                      softWrap: true,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
