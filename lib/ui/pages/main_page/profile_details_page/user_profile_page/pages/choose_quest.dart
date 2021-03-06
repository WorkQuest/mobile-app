import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/store/user_profile_store.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ChooseQuest extends StatefulWidget {
  static const String routeName = '/chooseQuest';

  const ChooseQuest(this.workerId);

  final String workerId;

  @override
  State<ChooseQuest> createState() => _ChooseQuestState();
}

class _ChooseQuestState extends State<ChooseQuest> {
  late UserProfileStore store;

  @override
  void initState() {
    store = context.read<UserProfileStore>();
    store.getQuests(
      userId: widget.workerId,
      role: UserRole.Worker,
      newList: true,
      isProfileYours: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        buttonRow(context, store),
      ],
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_sharp,
          ),
        ),
        centerTitle: true,
        title: Text(
          "quests.quests".tr(),
          style: TextStyle(
            color: Color(0xFF1D2127),
          ),
        ),
      ),
      body: Observer(
        builder: (_) => store.quests.isEmpty && store.isLoading
            ? Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : NotificationListener<ScrollEndNotification>(
                onNotification: (scrollEnd) {
                  final metrics = scrollEnd.metrics;
                  if ((metrics.atEdge ||
                          metrics.maxScrollExtent < metrics.pixels) &&
                      !store.isLoading)
                    store.getQuests(
                      userId: widget.workerId,
                      role: UserRole.Worker,
                      newList: true,
                      isProfileYours: false,
                    );
                  return true;
                },
                child: ListView.builder(
                  itemBuilder: (context, index) => Observer(
                    builder: (_) => RadioListTile<String>(
                      title: Text(
                        store.quests[index].title,
                      ),
                      value: store.quests[index].id,
                      groupValue: store.questId,
                      onChanged: (value) {
                        store.setQuest(value, store.quests[index].id);
                      },
                    ),
                  ),
                  itemCount: store.quests.length,
                ),
              ),
      ),
    );
  }

  Widget buttonRow(
    BuildContext context,
    UserProfileStore store,
  ) =>
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 45.0,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "meta.cancel".tr(),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      width: 1.0,
                      color: Color(0xFF0083C7).withOpacity(0.1),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Observer(
                builder: (_) => ElevatedButton(
                  onPressed: store.questId.isNotEmpty
                      ? () async {
                          await store.startQuest(widget.workerId);
                          if (store.isSuccess) {
                            Navigator.pop(context);
                            await AlertDialogUtils.showSuccessDialog(context);
                          }
                        }
                      : null,
                  child: Text(
                    "quests.addToQuest".tr(),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
