import 'package:app/ui/pages/main_page/wallet_page/swap_page/store/swap_store.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/repository/wallet_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../constants.dart';
import '../../../../../../observer_consumer.dart';
import 'mobx/confirm_transfer_store.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);

class ConfirmTransferPage extends StatefulWidget {
  final TokenSymbols typeCoin;
  final String addressTo;
  final String amount;
  final String fee;

  const ConfirmTransferPage({
    Key? key,
    required this.typeCoin,
    required this.addressTo,
    required this.amount,
    required this.fee,
  }) : super(key: key);

  @override
  _ConfirmTransferPageState createState() => _ConfirmTransferPageState();
}

class _ConfirmTransferPageState extends State<ConfirmTransferPage> {
  late final ConfirmTransferStore store;


  @override
  void initState() {
    store = context.read<ConfirmTransferStore>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObserverListener<ConfirmTransferStore>(
      onSuccess: () async {
        Navigator.of(context, rootNavigator: true).pop();
        await AlertDialogUtils.showSuccessDialog(context);
        Navigator.pop(context, true);
      },
      onFailure: () {
        Navigator.of(context, rootNavigator: true).pop();
        if (store.errorMessage!.contains('The waiting time is over')) {
          AlertDialogUtils.showInfoAlertDialog(
            context,
            title: 'meta.warning'.tr(),
            content: store.errorMessage!,
            okPressed: () {
              Navigator.pop(context, true);
            },
          );
          return true;
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'wallet.transfer'.tr(),
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          centerTitle: true,
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColor.enabledButton,
            ),
          ),
        ),
        body: Padding(
          padding: _padding,
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              _InformationWidget(
                fee: widget.fee,
                typeCoins: widget.typeCoin,
                addressTo: widget.addressTo,
                amount: widget.amount,
              ),
              Expanded(child: SizedBox()),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 10.0,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      AlertDialogUtils.showLoadingDialog(context);
                      store.sendTransaction(
                        widget.addressTo,
                        widget.amount,
                        widget.typeCoin,
                        Decimal.parse(widget.fee),
                      );
                    },
                    child: Text('meta.confirm'.tr()),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _InformationWidget extends StatelessWidget {
  final String addressTo;
  final TokenSymbols typeCoins;
  final String amount;
  final String fee;

  const _InformationWidget({
    Key? key,
    required this.addressTo,
    required this.typeCoins,
    required this.amount,
    required this.fee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: AppColor.disabledButton),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'wallet.recipientsAddress'.tr(),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            addressTo,
            style: const TextStyle(
              fontSize: 14,
              color: AppColor.subtitleText,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'wallet.amount'.tr(),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            '$amount ${typeCoins.name}',
            style: const TextStyle(
              fontSize: 14,
              color: AppColor.subtitleText,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'wallet.table.trxFee'.tr(),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            '$fee ${_getTitleCoinFee()}',
            style: const TextStyle(
              fontSize: 14,
              color: AppColor.subtitleText,
            ),
          ),
        ],
      ),
    );
  }

  String _getTitleCoinFee() {
    final _network =
        Web3Utils.getSwapNetworksFromNetworkName(WalletRepository().networkName.value ?? NetworkName.workNetMainnet);
    switch (_network) {
      case SwapNetworks.ETH:
        return 'ETH';
      case SwapNetworks.BSC:
        return 'BNB';
      case SwapNetworks.POLYGON:
        return 'MATIC';
      default:
        return 'WQT';
    }
  }

}
