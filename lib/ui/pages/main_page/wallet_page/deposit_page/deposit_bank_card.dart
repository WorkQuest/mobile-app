import 'package:app/constants.dart';
import 'package:app/ui/widgets/default_button.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DepositBankCard extends StatefulWidget {
  const DepositBankCard({Key? key}) : super(key: key);

  @override
  State<DepositBankCard> createState() => _DepositBankCardState();
}

class _DepositBankCardState extends State<DepositBankCard>
    with TickerProviderStateMixin {
  bool _addingBankCard = true;

  void onTabNotBankCards() {
    setState(() {
      _addingBankCard = !_addingBankCard;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _NotBankCards(
      onTab: () {
        AlertDialogUtils.showInfoAlertDialog(context,
            title: 'wallet.underConstruction'.tr(),
            content: 'meta.serviceUnavailable'.tr());
        setState(() {
          _addingBankCard = !_addingBankCard;
        });
      },
    );
  }
}

class _NotBankCards extends StatelessWidget {
  final Function()? onTab;

  const _NotBankCards({
    Key? key,
    required this.onTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: Container()),
            SizedBox(
              width: 125,
              height: 100,
              child: SvgPicture.asset(
                'assets/not_cards_icon.svg',
                color: AppColor.disabledButton,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'wallet.addCartToContinue'.tr(),
              style: const TextStyle(
                fontSize: 16,
                color: AppColor.disabledText,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(child: Container())
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
            right: 16.0,
            left: 16.0,
            bottom: MediaQuery.of(context).padding.bottom + 10),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: DefaultButton(
              onPressed: onTab,
              title: 'modals.addCard'.tr(),
            ),
          ),
        ),
      ),
    );
  }
}
