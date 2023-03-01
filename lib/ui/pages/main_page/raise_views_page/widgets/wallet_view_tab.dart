// import 'package:app/constants.dart';
// import 'package:app/ui/pages/main_page/raise_views_page/store/raise_views_store.dart';
// import 'package:app/ui/pages/main_page/raise_views_page/widgets/bottom_sheet_widget.dart';
// import 'package:app/ui/pages/main_page/raise_views_page/widgets/item_list_bottom_sheet.dart';
// import 'package:app/utils/alert_dialog.dart';
// import 'package:app/web3/contractEnums.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// class WalletViewTab extends StatefulWidget {
//   final RaiseViewStore store;
//   final String? questId;
//
//   const WalletViewTab({
//     Key? key,
//     required this.store,
//     required this.questId,
//   }) : super(key: key);
//
//   @override
//   _WalletViewTabState createState() => _WalletViewTabState();
// }
//
// class _WalletViewTabState extends State<WalletViewTab> {
//   final _divider = const SizedBox(height: 5.0);
//
//   @override
//   void initState() {
//     super.initState();
//     widget.store.initValue();
//     widget.store.setTitleSelectedCoin(TokenSymbols.WUSD);
//     widget.store.setTitleSelectedWallet(TYPE_WALLET.Coinpaymebts);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Observer(
//         builder: (context) => Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text("ui.chooseCurrency".tr()),
//             _divider,
//             GestureDetector(
//               onTap: _chooseCoin,
//               child: Container(
//                 height: 46,
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 15.0,
//                   vertical: 12.5,
//                 ),
//                 decoration: BoxDecoration(
//                   color: widget.store.selectedCoin
//                       ? Colors.white
//                       : AppColor.disabledButton,
//                   borderRadius: BorderRadius.circular(6.0),
//                   border: Border.all(
//                     color: AppColor.disabledButton,
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     if (widget.store.selectedCoin)
//                       Container(
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [
//                               AppColor.enabledButton,
//                               AppColor.blue,
//                             ],
//                           ),
//                         ),
//                         child: SizedBox(
//                           width: 32,
//                           height: 32,
//                           child: SvgPicture.asset(
//                             widget.store.currentCoin!.iconPath,
//                           ),
//                         ),
//                       ),
//                     Text(
//                       widget.store.selectedCoin
//                           ? widget.store.currentCoin!.title!
//                           : 'wallet.enterCoin'.tr(),
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: widget.store.selectedCoin
//                             ? Colors.black
//                             : AppColor.disabledText,
//                       ),
//                     ),
//                     const Spacer(),
//                     Icon(
//                       Icons.arrow_drop_down_outlined,
//                       size: 25.0,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15.0),
//             Text('wallet.wallet'.tr()),
//             _divider,
//             GestureDetector(
//               onTap: _chooseWallet,
//               child: Container(
//                 height: 46,
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 15.0,
//                   vertical: 12.5,
//                 ),
//                 decoration: BoxDecoration(
//                   color: widget.store.selectedWallet
//                       ? Colors.white
//                       : AppColor.disabledButton,
//                   borderRadius: BorderRadius.circular(6.0),
//                   border: Border.all(
//                     color: AppColor.disabledButton,
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     if (widget.store.selectedWallet)
//                       Container(
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [
//                               AppColor.enabledButton,
//                               AppColor.blue,
//                             ],
//                           ),
//                         ),
//                         child: SizedBox(
//                           width: 32,
//                           height: 32,
//                           child: SvgPicture.asset(
//                             widget.store.currentWallet!.iconPath,
//                           ),
//                         ),
//                       ),
//                     Text(
//                       widget.store.selectedWallet
//                           ? widget.store.currentWallet!.title
//                           : 'wallet.enterCoin'.tr(),
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: widget.store.selectedWallet
//                             ? Colors.black
//                             : AppColor.disabledText,
//                       ),
//                     ),
//                     const Spacer(),
//                     Icon(
//                       Icons.arrow_drop_down_outlined,
//                       size: 25.0,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             Spacer(),
//             ElevatedButton(
//               onPressed: widget.store.canSubmit
//                   ? () async {
//                       AlertDialogUtils.showLoadingDialog(context);
//                       if (widget.questId == null || widget.questId!.isEmpty) {
//                         await widget.store.raiseProfile();
//                       } else {
//                         await widget.store.raiseQuest(widget.questId!);
//                       }
//
//                       if (widget.store.isSuccess) {
//                         print('ObserverListener onSuccess');
//                         Navigator.of(context, rootNavigator: true).pop();
//                         await AlertDialogUtils.showSuccessDialog(context);
//                         Navigator.pop(context);
//                         Navigator.pop(context);
//                       } else {
//                         print('ObserverListener onSuccess');
//                         Navigator.of(context, rootNavigator: true).pop();
//                         await AlertDialogUtils.showInfoAlertDialog(context,
//                             title: 'Error',
//                             content: widget.store.errorMessage!);
//                       }
//                     }
//                   : null,
//               child: Text("wallet.pay".tr()),
//             ),
//             const SizedBox(height: 20.0),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _chooseCoin() {
//     showModalBottomSheet(
//       context: context,
//       useRootNavigator: true,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return BottomSheetWidget(
//           children: widget.store.coins
//               .map(
//                 (coin) => ItemListBottomSheet(
//                   title: coin.title!,
//                   iconPath: coin.iconPath,
//                   onTap: coin.isEnable!
//                       ? () {
//                           _selectCoin(coin);
//                           Navigator.pop(context);
//                         }
//                       : null,
//                 ),
//               )
//               .toList(),
//         );
//       },
//     );
//   }
//
//   void _chooseWallet() {
//     showModalBottomSheet(
//       context: context,
//       useRootNavigator: true,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return BottomSheetWidget(
//           children: widget.store.wallets
//               .map(
//                 (wallet) => ItemListBottomSheet(
//                   title: wallet.title,
//                   iconPath: wallet.iconPath,
//                   onTap: () {
//                     _selectWallet(wallet);
//                     Navigator.pop(context);
//                   },
//                 ),
//               )
//               .toList(),
//         );
//       },
//     );
//   }
//
//   void _selectCoin(DataCoins coin) {
//     widget.store.setCurrentCoin(coin);
//     widget.store.setTitleSelectedCoin(coin.symbolToken);
//   }
//
//   void _selectWallet(WalletItem wallet) {
//     widget.store.setCurrentWallet(wallet);
//     widget.store.setTitleSelectedWallet(wallet.typeWallet);
//   }
// }
