import 'package:app/ui/pages/main_page/profile_details_page/portfolio_page/store/portfolio_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

import 'create_portfolio_page.dart';

class PortfolioDetails extends StatelessWidget {
  final int index;
  static const String routeName = "/portfolioDetails";

  const PortfolioDetails({required this.index});

  @override
  Widget build(BuildContext context) {
    final portfolioStore = context.read<PortfolioStore>();
    portfolioStore.pageNumber = 0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Observer(
        builder: (_) => SafeArea(
          child: CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: Row(
                  children: [
                    Expanded(
                      child: Text("profile.portfolio".tr()),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            portfolioStore.portfolioIndex = index;
                            Navigator.of(context, rootNavigator: false)
                                .popAndPushNamed(
                              CreatePortfolioPage.routeName,
                              arguments: true,
                            );
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            await portfolioStore.deletePortfolio(
                              portfolioId:
                                  portfolioStore.portfolioList[index].id,
                            );
                          },
                          icon: Icon(
                            Icons.delete_forever,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              ///Images View
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  height: 300,
                  child: PageView(
                    onPageChanged: portfolioStore.changePageNumber,
                    children: portfolioStore.portfolioList[index].medias
                        .map(
                          (e) => Image.network(
                            e.url,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    ///Image position indicator
                    Container(
                      alignment: Alignment.center,
                      height: 50,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            portfolioStore.portfolioList[index].medias.length,
                        itemBuilder: (_, index) => Observer(
                          builder: (_) => index == portfolioStore.pageNumber
                              ? _indicator(true, context)
                              : _indicator(false, context),
                        ),
                      ),
                    ),

                    ///Portfolio Title
                    Text(
                      portfolioStore.portfolioList[index].title,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),

                    ///Portfolio Description
                    Text(
                      portfolioStore.portfolioList[index].description,
                      // style: const TextStyle(
                      //   fontSize: 23,
                      //   fontWeight: FontWeight.w500,
                      // ),
                    ),
                    Text("skills.title".tr()),
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _indicator(
    bool isActive,
    BuildContext context,
  ) {
    return Container(
      height: 10,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(horizontal: 7.0),
        height: isActive ? 10 : 8.0,
        width: isActive ? 12 : 8.0,
        decoration: BoxDecoration(
          boxShadow: [
            isActive
                ? BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(
                          0.72,
                        ),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: Offset(
                      0.0,
                      0.0,
                    ),
                  )
                : BoxShadow(
                    color: Colors.transparent,
                  ),
          ],
          shape: BoxShape.circle,
          color: isActive
              ? Theme.of(context).primaryColor.withOpacity(0.72)
              : Color(0XFFEAEAEA),
        ),
      ),
    );
  }
}
