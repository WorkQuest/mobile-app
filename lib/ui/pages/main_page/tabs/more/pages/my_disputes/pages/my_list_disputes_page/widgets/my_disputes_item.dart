import 'dart:math';

import 'package:app/ui/pages/main_page/tabs/more/pages/my_disputes/pages/dispute_page/dispute_page.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/my_disputes/pages/my_list_disputes_page/store/my_disputes_store.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/create_review_page/create_review_page.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class MyDisputesItem extends StatefulWidget {
  const MyDisputesItem(this.store, this.index);

  final MyDisputesStore store;
  final int index;

  @override
  State<MyDisputesItem> createState() => _MyDisputesItemState();
}

class _MyDisputesItemState extends State<MyDisputesItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(
          context,
          DisputePage.routeName,
          arguments: widget.store.disputes[widget.index].id,
        );
      },
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
                disputeInfo:
                    widget.store.disputes[widget.index].number.toString(),
              ),
              space(),
              row(
                title: "dispute_page.quest",
                disputeInfo: widget.store.disputes[widget.index].quest.title,
              ),
              space(),
              row(
                title: "dispute_page.quest_employer_page",
                disputeInfo: widget
                        .store.disputes[widget.index].quest.user!.firstName +
                    " " +
                    widget.store.disputes[widget.index].quest.user!.lastName,
              ),
              space(),
              row(
                title: "dispute_page.questSalary",
                disputeInfo: (double.parse(
                            widget.store.disputes[widget.index].quest.price) *
                        pow(10, -18))
                    .toString(),
              ),
              space(),
              row(
                title: "dispute_page.status",
                disputeInfo: widget.store
                    .getStatus(widget.store.disputes[widget.index].status)
                    .tr(),
                color: getColor(widget.store.disputes[widget.index].status),
              ),
              if (widget.store.disputes[widget.index].decisionDescription !=
                      null &&
                  widget.store.disputes[widget.index].decisionDescription != "")
                decision(),
              review(),
            ],
          ),
        ),
      ),
    );
  }

  Widget review() {
    return widget.store.disputes[widget.index].currentUserDisputeReview ==
                null &&
            widget.store.disputes[widget.index].status == 4
        ? Column(
            children: [
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  await Navigator.pushNamed(
                    context,
                    CreateReviewPage.routeName,
                    arguments: CreateReviewArguments(
                      null,
                      widget.store.disputes[widget.index].id,
                    ),
                  );
                  await widget.store.getDispute(
                    widget.store.disputes[widget.index].id,
                  );
                },
                child: Text(
                  "quests.addReview".tr(),
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                    Size(double.maxFinite, 43),
                  ),
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
          )
        : widget.store.disputes[widget.index].currentUserDisputeReview !=
                    null &&
                widget.store.disputes[widget.index].status == 4
            ? reviewCard()
            : SizedBox();
  }

  Widget reviewCard() {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFFF7F8FA),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your review",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              widget.store.disputes[widget.index].currentUserDisputeReview!
                  .message,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                for (int i = 0;
                    i <
                        widget.store.disputes[widget.index]
                            .currentUserDisputeReview!.mark;
                    i++)
                  Icon(
                    Icons.star,
                    color: Color(0xFFE8D20D),
                    size: 20.0,
                  ),
                for (int i = 0;
                    i <
                        5 -
                            widget.store.disputes[widget.index]
                                .currentUserDisputeReview!.mark;
                    i++)
                  Icon(
                    Icons.star,
                    color: Color(0xFFE9EDF2),
                    size: 20.0,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget decision() {
    return Column(
      children: [
        const SizedBox(height: 30),
        const Divider(
          color: Colors.black12,
          endIndent: 50.0,
          indent: 50.0,
        ),
        const SizedBox(height: 30),
        Container(
          alignment: Alignment.centerLeft,
          child: Text("dispute_page.decision".tr()),
        ),
        space(),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.store.disputes[widget.index].decisionDescription!,
            style: TextStyle(
              color: Color(0xFF7C838D),
            ),
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }

  Color getColor(int status) {
    switch (status) {
      case 0:
        return Colors.yellow;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.green;
      case 4:
        return Colors.green;
    }
    return Colors.green;
  }

  Widget space() => const SizedBox(height: 10);

  Widget row({
    required String title,
    required String disputeInfo,
    Color color = const Color(0xFF0083C7),
  }) {
    return Row(
      children: [
        Text(title.tr()),
        Text(
          " $disputeInfo",
          style: TextStyle(color: color),
        ),
      ],
    );
  }
}
