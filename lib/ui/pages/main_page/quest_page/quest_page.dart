import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_list/quest_list.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_map/widgets/handler_permission_map.dart';
import 'package:app/ui/pages/main_page/quest_page/store/quest_page_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/store/wallet_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";

class QuestPage extends StatefulWidget {
  @override
  _QuestPageState createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage> {
  final QuestPageStore questPage = QuestPageStore();
  UserRole? role;

  @override
  void initState() {
    //Send All required requests
    final wallet = context.read<WalletStore>();
    wallet.getCoins();
    role = context.read<ProfileMeStore>().userData?.role;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => role == null
          ? CircularProgressIndicator.adaptive()
          : IndexedStack(
              index: questPage.pageIndex,
              children: [
                HandlerPermissionMapWidget(changePage: questPage.setQuestListPage,),
                QuestList(questPage.setMapPage),
              ],
            ),
    );
  }
}
