import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/search_list_page/search_list_page.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/search_map/widgets/handler_permission_map.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/search_page/store/search_page_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final SearchPageStore store = SearchPageStore();

  UserRole? get role => context.read<ProfileMeStore>().userData?.role;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => role == null
          ? CircularProgressIndicator.adaptive()
          : IndexedStack(
              index: store.pageIndex,
              children: [
                HandlerPermissionMapWidget(changePage: store.setQuestListPage,),
                SearchListPage(store.setMapPage),
              ],
            ),
    );
  }
}
