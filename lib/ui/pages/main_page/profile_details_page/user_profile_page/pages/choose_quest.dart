import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/store/user_profile_store.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ChooseQuest extends StatelessWidget {
  static const String routeName = '/chooseQuest';

  const ChooseQuest(this.workerId);

  final String workerId;

  @override
  Widget build(BuildContext context) {
    final store = context.read<UserProfileStore>();
    return Scaffold(
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
        builder: (_) => store.isLoading
            ? Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : ListView.builder(
                itemBuilder: (context, index) => Column(
                  children: [
                    Observer(
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
                    if (index == store.quests.length - 1)
                      buttonRow(context, store),
                  ],
                ),
                itemCount: store.quests.length,
                // ,
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
              child: ElevatedButton(
                onPressed: () async {
                  store.startQuest(workerId);
                  Navigator.pop(context);
                  await AlertDialogUtils.showSuccessDialog(context);
                },
                child: Text(
                  "quests.addToQuest".tr(),
                ),
              ),
            ),
          ],
        ),
      );
}
