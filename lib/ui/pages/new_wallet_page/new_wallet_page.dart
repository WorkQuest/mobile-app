import 'package:app/model/media_model.dart';
import 'package:app/ui/pages/new_wallet_page/model/colletaral_model.dart';
import 'package:app/ui/pages/new_wallet_page/widgets/balance_widget.dart';
import 'package:app/ui/pages/new_wallet_page/widgets/collateral_transaction.dart';
import 'package:app/ui/pages/new_wallet_page/widgets/main_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class NewWalletPage extends StatefulWidget {
  NewWalletPage({Key? key}) : super(key: key);

  @override
  State<NewWalletPage> createState() => _NewWalletPageState();
}

class _NewWalletPageState extends State<NewWalletPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<CollateralTransactionModel> colTransactionList = [
    CollateralTransactionModel(
        icon: 'assets/token_icon.png',
        token: 'USDT',
        amount: '10.4615',
        ratio: '105',
        locked: '9.999'),
    CollateralTransactionModel(
        icon: 'assets/token_icon.png',
        token: 'USDT',
        amount: '10.4615',
        ratio: '105',
        locked: '9.999'),
    CollateralTransactionModel(
        icon: 'assets/token_icon.png',
        token: 'USDT',
        amount: '10.4615',
        ratio: '105',
        locked: '9.999'),
  ];
  final controller = ScrollController();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: controller,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
             SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 90, 16, 0),
                child: Column(

                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Container(
                        width: 350,
                        height: 40,
                        child: Text(
                          'Wallet',
                          style:
                              TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 31, 0, 0),
                      child: Container(
                        height: 220,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 360,
                              height: 21,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'sdasdasddasasd',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  IconButton(
                                    color: Colors.grey,
                                    onPressed: () {},
                                    icon: Icon(Icons.content_copy_outlined),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 26, 0, 20),
                              child: Container(
                                color: Color.fromRGBO(247, 248, 250, 1),
                                width: 343,
                                height: 100,
                                child: BalanceWidget(),
                              ),
                            ),
                            MainButtons(),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverToBoxAdapter(
                child: SafeArea(
                  child: Container(
                    decoration: BoxDecoration(),
                    height: 40,
                    child: TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicator: BoxDecoration(),
                      indicatorSize: TabBarIndicatorSize.tab,
                      controller: _tabController,
                      tabs: [
                        Tab(
                          text: 'Transactions',
                        ),
                        Tab(
                          text: 'Collateral transactions',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body:
           

            TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Text('dassd'),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: colTransactionList.length,
              itemBuilder: (context, index) {
                return CollateralTransaction(
                  item: colTransactionList[index],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
