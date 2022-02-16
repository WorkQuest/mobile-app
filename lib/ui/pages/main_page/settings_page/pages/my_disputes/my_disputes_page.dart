import 'package:app/ui/pages/main_page/settings_page/pages/my_disputes/my_disputes_item.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/my_disputes/store/my_disputes_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class MyDisputesPage extends StatefulWidget {
  static const String routeName = "/myDisputesPage";

  const MyDisputesPage();

  @override
  _MyDisputesPageState createState() => _MyDisputesPageState();
}

class _MyDisputesPageState extends State<MyDisputesPage> {
  late MyDisputesStore store;

  @override
  void initState() {
    store = context.read<MyDisputesStore>();
    store.getDisputes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        physics: const ClampingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            CupertinoSliverNavigationBar(
              backgroundColor: Colors.white,
              largeTitle: Text(
                "btn.myDisputes".tr(),
              ),
              border: const Border.fromBorderSide(BorderSide.none),
            ),
          ];
        },
        body: Container(
          color: Color(0xFFF7F8FA),
          child: Observer(
            builder: (_) => store.disputes.isEmpty
                ? Center(
                    child: store.isLoading
                        ? getLoadingBody()
                        : getEmptyBody(context),
                  )
                : getBody(),
          ),
        ),
      ),
    );
  }

  Widget getBody() {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 16.0,
      ),
      child: ListView.builder(
        physics: BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        shrinkWrap: true,
        itemCount: store.disputes.length,
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, index) {
          return MyDisputesItem(store, index);
        },
      ),
    );
  }

  Widget getEmptyBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/empty_disputes_icon.svg",
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          "modals.noDisputes".tr(),
          style: TextStyle(
            color: Color(0xFFD8DFE3),
          ),
        ),
      ],
    );
  }

  Widget getLoadingBody() {
    return Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}
