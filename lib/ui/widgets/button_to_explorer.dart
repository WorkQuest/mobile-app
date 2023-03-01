import 'package:app/constants.dart';
import 'package:app/web3/repository/wallet_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ButtonToExplorer extends StatelessWidget {
  const ButtonToExplorer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14.0),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'wallet.goExplorer'.tr(),
              style: const TextStyle(fontSize: 16, color: AppColor.enabledButton),
            ),
            const SizedBox(
              width: 14.0,
            ),
            SvgPicture.asset(
              'assets/explorer_to_icon.svg',
              width: 16,
              height: 16,
            ),
          ],
        ),
        onPressed: _onPressedGoToExplorer,
      ),
    );
  }

  _onPressedGoToExplorer() {
    final _urlExplorer = WalletRepository().getConfigNetwork().urlExplorer + WalletRepository().userAddress;
    launchUrl(Uri.parse(_urlExplorer));
  }
}
