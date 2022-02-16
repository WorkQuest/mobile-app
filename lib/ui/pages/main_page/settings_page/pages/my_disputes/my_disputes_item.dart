import 'package:app/ui/pages/main_page/settings_page/pages/my_disputes/dispute/dispute_page.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/my_disputes/store/my_disputes_store.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class MyDisputesItem extends StatelessWidget {
  const MyDisputesItem(this.store, this.index);

  final MyDisputesStore store;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: UniqueKey(),
      padding: EdgeInsets.only(top: 16.0),
      child: GestureDetector(
        onTap: () async => await Navigator.pushNamed(
          context,
          DisputePage.routeName,
          arguments: store.disputes[index],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(6.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                row(
                  title: "modals.numberDispute",
                  disputeInfo: store.disputes[index].disputeNumber.toString(),
                ),
                space(),
                row(
                  title: "dispute.quest",
                  disputeInfo: store.disputes[index].quest.title,
                ),
                space(),
                row(
                  title: "dispute.employer",
                  disputeInfo: store.disputes[index].quest.user.firstName +
                      " " +
                      store.disputes[index].quest.user.lastName,
                ),
                space(),
                row(
                  title: "dispute.questSalary",
                  disputeInfo: store.disputes[index].quest.price,
                ),
                space(),
                row(
                  title: "dispute.status",
                  disputeInfo:
                      store.getStatus(store.disputes[index].quest.status).tr(),
                  color: getColor(store.disputes[index].quest.status),
                ),
                if (store.disputes[index].decisionDescription != null &&
                    store.disputes[index].decisionDescription != "")
                  decision(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget decision() {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        const Divider(
          color: Colors.black12,
          endIndent: 50.0,
          indent: 50.0,
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "dispute.decision".tr(),
          ),
        ),
        space(),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            store.disputes[index].decisionDescription!,
            style: TextStyle(
              color: Color(0xFF7C838D),
            ),
          ),
        ),
        const SizedBox(
          height: 60,
        ),
      ],
    );
  }

  Color getColor(int status) {
    switch (status) {
      case 1:
        return Colors.green;
      case 3:
        return Colors.red;
      case 5:
        return Colors.green;
    }
    return Colors.green;
  }

  Widget space() {
    return const SizedBox(
      height: 10,
    );
  }

  Widget row({
    required String title,
    required String disputeInfo,
    Color color = const Color(0xFF0083C7),
  }) {
    return Row(
      children: [
        Text(
          title.tr(),
        ),
        Text(
          " $disputeInfo",
          style: TextStyle(
            color: color,
          ),
        ),
      ],
    );
  }
}
