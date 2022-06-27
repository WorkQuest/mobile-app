import 'package:app/ui/pages/main_page/quest_page/quest_list/quest_list.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_map/quest_map.dart';
import 'package:app/ui/pages/main_page/quest_page/store/quest_page_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/store/wallet_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/transactions/store/transactions_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import "package:provider/provider.dart";

class QuestPage extends StatefulWidget {
  @override
  _QuestPageState createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage> {
  final QuestPageStore questPage = QuestPageStore();

  @override
  void initState() {
    //Send All required requests
    final wallet = context.read<WalletStore>();
    wallet.getCoins();
    GetIt.I.get<TransactionsStore>().getTransactions(isForce: true);
    super.initState();
  }

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
