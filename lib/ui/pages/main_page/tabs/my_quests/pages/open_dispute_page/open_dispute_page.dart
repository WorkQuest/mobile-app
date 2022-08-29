import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/model/quests_models/open_dispute.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/open_dispute_page/widgets/titled_field_widget.dart';
import 'package:app/ui/widgets/confirm_transaction_dialog.dart';
import 'package:app/ui/widgets/default_app_bar.dart';
import 'package:app/ui/widgets/default_textfield.dart';
import 'package:app/ui/widgets/dismiss_keyboard.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/dispute_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

import 'store/open_dispute_store.dart';

class OpenDisputePage extends StatefulWidget {
  static const String routeName = '/openDisputePage';

  final BaseQuestResponse quest;

  OpenDisputePage(this.quest);

  @override
  _OpenDisputePageState createState() => _OpenDisputePageState();
}

class _OpenDisputePageState extends State<OpenDisputePage> {
  late final OpenDisputeStore store;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    store = context.read<OpenDisputeStore>();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  _stateListener() async {
    if (store.successData == OpenDisputeState.getGasOpenDispute) {
      _openDispute();
    } else if (store.successData == OpenDisputeState.openDispute) {
      Navigator.of(context, rootNavigator: true).pop();
      await AlertDialogUtils.showSuccessDialog(context);
      final _dispute = OpenDispute(
        id: store.resultDisputeId,
        openDisputeUserId: null,
        opponentUserId: null,
        assignedAdminId: null,
        status: 0,
      );
      Navigator.pop(context, _dispute);
    }
  }

  @override
  Widget build(context) {
    return ObserverListener<OpenDisputeStore>(
      onSuccess: _stateListener,
      onFailure: () {
        Navigator.of(context, rootNavigator: true).pop();
        return false;
      },
      child: Scaffold(
        appBar: DefaultAppBar(
          title: "modals.openADispute".tr(),
        ),
        body: SingleChildScrollView(
          child: DismissKeyboard(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TitledField(
                    title: "modals.disputeTheme".tr(),
                    child: Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Color(0xFFF7F8FA),
                        borderRadius: BorderRadius.all(
                          const Radius.circular(
                            6.0,
                          ),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: _onPressedModalBottomSheet,
                        child: Row(
                          children: [
                            Expanded(
                              child: Observer(
                                builder: (_) => Text(
                                  store.theme.tr(),
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              size: 30,
                              color: Colors.blueAccent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  TitledField(
                    title: "modals.description".tr(),
                    child: SizedBox(
                      height: 200,
                      child: DefaultTextField(
                        controller: _descriptionController,
                        onChanged: (text) => store.setDescription(text),
                        hint: 'modals.enterDescription'.tr(),
                        expands: true,
                        textAlign: TextAlign.start,
                        maxLength: 1000,
                        keyboardType: TextInputType.multiline,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        enableDispose: false,
                        validator: (value) {
                          if (value == null) {
                            return null;
                          }
                          if (value.isEmpty) {
                            return 'errors.fieldEmpty'.tr();
                          }
                          if (value.length < 50) {
                            return 'errors.fieldLeastCharacters'.tr();
                          }
                          return null;
                        },
                        inputFormatters: [],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 250,
                    color: Colors.transparent,
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            right: 16.0,
            left: 16.0,
            bottom: MediaQuery.of(context).padding.bottom + 10.0,
          ),
          child: Observer(
            builder: (_) => LoginButton(
              title: "modals.openADispute".tr(),
              onTap: store.isButtonEnable && !store.isLoading
                  ? _onPressedOpenDispute
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  _onPressedOpenDispute() async {
    store.getGasOpenDispute(widget.quest.contractAddress!);
  }

  _openDispute() {
    confirmTransaction(
      context,
      fee: store.fee,
      transaction: "ui.txInfo".tr(),
      address: widget.quest.contractAddress!,
      amount: null,
      onPressConfirm: () async {
        store.openDispute(
          widget.quest.id,
          widget.quest.contractAddress!,
        );
        Navigator.pop(context);
        AlertDialogUtils.showLoadingDialog(context);
      },
      onPressCancel: () => Navigator.pop(context),
    );
  }

  _onPressedModalBottomSheet() => showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(
              20.0,
            ),
          ),
        ),
        context: context,
        builder: (context) {
          return DraggableScrollableSheet(
            initialChildSize: 1.0,
            expand: false,
            builder: (context, scrollController) => ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 15.0,
              ),
              separatorBuilder: (context, index) => const Divider(
                color: Colors.black12,
                endIndent: 50.0,
                indent: 50.0,
              ),
              controller: scrollController,
              shrinkWrap: false,
              itemCount: DisputeConstants.disputeCategoriesList.length,
              itemBuilder: (context, index) => Container(
                height: 45.0,
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    final _theme = DisputeUtil.changeTheme(
                        DisputeConstants.disputeCategoriesList[index]);
                    store.setTheme(_theme);
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DisputeConstants.disputeCategoriesList[index].tr(),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
}
