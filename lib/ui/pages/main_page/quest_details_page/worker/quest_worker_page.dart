import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/quest_details_page/quest_details_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/worker/store/worker_store.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";

class QuestWorker extends QuestDetails {
  final bool isMyQuest;
  QuestWorker(BaseQuestResponse questInfo, this.isMyQuest) : super(questInfo);

  @override
  _QuestWorkerState createState() => _QuestWorkerState();
}

class _QuestWorkerState extends QuestDetailsState<QuestWorker> {
  late WorkerStore store;

  AnimationController? controller;

  @override
  void initState() {
    store = context.read<WorkerStore>();
    store.quest = widget.questInfo;
    controller = BottomSheet.createAnimationController(this);
    controller!.duration = Duration(seconds: 1);
    super.initState();
  }

  @override
  List<Widget>? actionAppBar() {
    return [
      Observer(
        builder: (_) => IconButton(
          icon: Icon(
            store.quest!.star ? Icons.star : Icons.star_border,
            color: store.quest!.star ? Color(0xFFE8D20D) : Color(0xFFD8DFE3),
          ),
          onPressed: store.onStar,
        ),
      )
    ];
  }

  @override
  Widget getBody() {
    if (widget.isMyQuest) return const SizedBox();
    return Observer(
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            "${widget.questInfo.price} WUSD",
            textAlign: TextAlign.end,
            style: const TextStyle(
                color: Color(0xFF00AA5B),
                fontSize: 18.0,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          if (!store.quest!.response)
            store.isLoading
                ? Center(child: CircularProgressIndicator())
                : TextButton(
                    onPressed: bottomForm,
                    child: const Text("Send a request",
                        style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                      fixedSize:
                          MaterialStateProperty.all(Size(double.maxFinite, 43)),
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
                  ),
        ],
      ),
    );
  }

  bottomForm() {
    TextEditingController textController = TextEditingController();
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6.0), topRight: Radius.circular(6.0)),
      ),
      context: context,
      backgroundColor: Colors.white,
      transitionAnimationController: controller,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 10.0,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 5.0,
                  width: 70.0,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 23),
                  Text(
                    "Write a few words to the employer",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: 'Hello...',
                    ),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 15),
                  DottedBorder(
                    padding: EdgeInsets.all(0),
                    color: Color(0xFFe9edf2),
                    strokeWidth: 3.0,
                    child: Container(
                      height: 66,
                      padding: EdgeInsets.only(left: 20, right: 10),
                      color: Color(0xFFf7f8fa),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Upload a images or videos"),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.add_a_photo))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      store.sendRespondOnQuest(textController.text);
                      Navigator.pop(context);
                    },
                    child: const Text("Send a request",
                        style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                      fixedSize:
                          MaterialStateProperty.all(Size(double.maxFinite, 43)),
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
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ],
          ),
        );
      },
    ).whenComplete(
      () => controller = BottomSheet.createAnimationController(this),
    );
  }

  @override
  void dispose() {
    widget.questInfo.update(store.quest!);
    super.dispose();
  }
}