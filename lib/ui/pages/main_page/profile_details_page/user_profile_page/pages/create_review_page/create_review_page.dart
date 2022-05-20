import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/model/quests_models/your_review.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/create_review_page/store/create_review_store.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";

class CreateReviewPage extends StatefulWidget {
  static const String routeName = '/createReviewPage';

  final ReviewArguments arguments;

  const CreateReviewPage(this.arguments);

  @override
  _CreateReviewPageState createState() => _CreateReviewPageState();
}

class _CreateReviewPageState extends State<CreateReviewPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(context) {
    final store = context.read<CreateReviewStore>();
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: CupertinoNavigationBar(
          automaticallyImplyLeading: true,
          middle: Text(
            "quests.addNewReview".tr(),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                16.0,
                16.0,
                16.0,
                0.0,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Text(
                      "quests.rateEmployer".tr(),
                    ),
                    const SizedBox(height: 24),
                    Observer(
                      builder: (_) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (int i = 0; i < 5; i++)
                            IconButton(
                              icon: const Icon(
                                Icons.star,
                                size: 40,
                              ),
                              color: store.star[i] == true
                                  ? Color(0xFFE8D20D)
                                  : Color(0xFFE9EDF2),
                              onPressed: () {
                                store.mark = i + 1;
                                store.setStar();
                              },
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      "quests.addYourReview".tr(),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Color(0xFFF7F8FA),
                        borderRadius: BorderRadius.all(
                          Radius.circular(6.0),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        validator: Validators.emptyValidator,
                        onChanged: (text) => store.setMessage(text),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        textAlignVertical: TextAlignVertical.top,
                        expands: true,
                        maxLength: 200,
                        decoration: InputDecoration(
                          hintText: "chat.message".tr(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          if (widget.arguments.quest != null) {
                            await store.addReview(widget.arguments.quest!.id);
                            widget.arguments.quest!.yourReview = YourReview(
                              id: "",
                              questId: widget.arguments.quest!.id,
                              fromUserId: "",
                              toUserId: "",
                              message: store.message,
                              mark: store.mark,
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                            );
                          } else {}
                          Navigator.pop(context);
                          if (store.isSuccess)
                            await AlertDialogUtils.showSuccessDialog(context);
                        }
                      },
                      child: Text(
                        "quests.addReview".tr(),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ReviewArguments {
  ReviewArguments(this.quest, this.disputeId);

  BaseQuestResponse? quest;
  String? disputeId;
}
