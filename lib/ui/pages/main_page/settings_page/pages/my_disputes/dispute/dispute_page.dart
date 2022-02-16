import 'package:app/model/dispute_model.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/my_disputes/dispute/store/dispute_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class DisputePage extends StatefulWidget {
  static const String routeName = "/disputesPage";

  final DisputeModel dispute;

  const DisputePage(this.dispute);

  @override
  _DisputePageState createState() => _DisputePageState();
}

class _DisputePageState extends State<DisputePage> {
  late DisputeStore store;
  double position = 15.0;

  @override
  void initState() {
    store = context.read<DisputeStore>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          return false;
        },
        child: NestedScrollView(
          physics: const ClampingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              CupertinoSliverNavigationBar(
                backgroundColor: Colors.white,
                largeTitle: Row(
                  children: [
                    Text(
                      "dispute.myDispute".tr(),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: position),
                      child: Text(
                        "№${widget.dispute.disputeNumber}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF7C838D),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: position),
                      child: Text(
                        store.getStatus(widget.dispute.status).tr(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.yellow,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                border: const Border.fromBorderSide(BorderSide.none),
              ),
            ];
          },
          body: Container(
          ),
        ),
      ),
    );
  }
}
