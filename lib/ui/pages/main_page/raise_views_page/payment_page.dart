// import 'package:app/ui/pages/main_page/raise_views_page/store/raise_views_store.dart';
// import 'package:app/ui/pages/main_page/raise_views_page/widgets/wallet_view_tab.dart';
// import 'package:app/ui/pages/main_page/wallet_page/bank_card_widget.dart';
// import 'package:app/ui/widgets/sliver_sticky_tab_bar.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';
//
// import '../../../../constants.dart';
//
// class PaymentPage extends StatefulWidget {
//   const PaymentPage(this.store, {Key? key}) : super(key: key);
//
//   final RaiseViewStore store;
//
//   static const String routeName = "/paymentPage";
//
//   @override
//   _PaymentPageState createState() => _PaymentPageState();
// }
//
// class _PaymentPageState extends State<PaymentPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(
//       vsync: this,
//       length: 2,
//     );
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "modals.payment".tr(),
//           style: TextStyle(fontSize: 16, color: Colors.black),
//         ),
//         centerTitle: true,
//         leading: CupertinoButton(
//           padding: EdgeInsets.zero,
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: const Icon(
//             Icons.arrow_back_ios,
//             color: AppColor.enabledButton,
//           ),
//         ),
//       ),
//       body: CustomScrollView(
//         physics: NeverScrollableScrollPhysics(),
//         slivers: [
//           SliverPadding(
//             padding: EdgeInsets.only(top: 10.0),
//             sliver: SliverPersistentHeader(
//               pinned: true,
//               delegate: StickyTabBarDelegate(
//                 child: TabBar(
//                   unselectedLabelColor: Color(0xFF8D96A1),
//                   indicator: BoxDecoration(
//                     borderRadius: BorderRadius.circular(6.0),
//                     color: Colors.white,
//                   ),
//                   labelColor: Colors.black,
//                   controller: this._tabController,
//                   tabs: <Widget>[
//                     Tab(
//                       child: Text(
//                         "ui.cryptoAddress".tr(),
//                         style: TextStyle(fontSize: 14.0),
//                       ),
//                     ),
//                     Tab(
//                       child: Text(
//                         "wallet.bankCard".tr(),
//                         style: TextStyle(fontSize: 14.0),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           SliverFillRemaining(
//             child: TabBarView(
//               controller: this._tabController,
//               children: [
//                 ///Wallet Transfer
//                 WalletViewTab(
//                   store: widgets.store,
//                   questId: widgets.store.questId,
//                 ),
//
//                 ///Card Transfer
//                 BankCardTransaction(
//                   transaction: "Pay",
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget titledTextBox(
//     String title,
//     Widget textField,
//   ) =>
//       Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//           ),
//           const SizedBox(height: 5.0),
//           Flexible(
//             fit: FlexFit.loose,
//             child: textField,
//           ),
//         ],
//       );
// }
