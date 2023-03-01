import 'package:app/ui/pages/main_page/settings_page/pages/my_disputes/my_disputes_item.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/my_disputes/store/my_disputes_store.dart';
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

  double leftPos = 0.0;
  double bottomPos = 0.0;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    store = context.read<MyDisputesStore>();
    store.getDisputes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          //Animate Padding
          if (scrollController.offset < 240)
            setState(() {
              leftPos = 0.0;
              bottomPos = 0.0;
            });
          if (scrollController.offset > 0 && scrollController.offset < 240)
            setState(() {
              leftPos = 25.0;
              bottomPos = 9.0;
            });

          return false;
        },
        child: NestedScrollView(
          controller: scrollController,
          physics: const ClampingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 100.0,
                pinned: true,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFF0083C7),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(
                    left: 16.0,
                    bottom: 8.0,
                    top: 0.0,
                  ),
                  collapseMode: CollapseMode.pin,
                  centerTitle: false,
                  title: AnimatedPadding(
                    padding: EdgeInsets.only(left: leftPos, bottom: bottomPos),
                    duration: Duration(milliseconds: 100),
                    child: Text(
                      "btn.myDisputes".tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D2127),
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
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
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (scrollEnd) {
          final metrics = scrollEnd.metrics;
          if (metrics.maxScrollExtent < metrics.pixels && !store.isLoading) {
            store.getDisputes();
          }
          return true;
        },
        child: Observer(
          builder: (_) => ListView.builder(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            shrinkWrap: true,
            itemCount: store.disputes.length,
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context, index) {
              return Column(
                children: [
                  const SizedBox(height: 16),
                  MyDisputesItem(store, index),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget getEmptyBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset("assets/empty_disputes_icon.svg"),
        const SizedBox(height: 10.0),
        Text(
          "modals.noDisputes".tr(),
          style: TextStyle(color: Color(0xFFD8DFE3)),
        ),
      ],
    );
  }

  Widget getLoadingBody() =>
      Center(child: CircularProgressIndicator.adaptive());
}
