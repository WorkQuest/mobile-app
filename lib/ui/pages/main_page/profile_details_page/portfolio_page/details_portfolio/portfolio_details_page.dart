import 'dart:convert';
import 'dart:typed_data';

import 'package:app/constants.dart';
import 'package:app/ui/pages/main_page/profile_details_page/portfolio_page/details_portfolio/store/portfolio_store.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:easy_localization/easy_localization.dart';

import '../create_portfolio/create_portfolio_page.dart';

class PortfolioDetailsArguments {
  int index;
  bool isProfileYour;
  PortfolioStore store;

  PortfolioDetailsArguments({
    required this.index,
    required this.store,
    required this.isProfileYour,
  });
}

class PortfolioDetails extends StatefulWidget {
  final PortfolioDetailsArguments arguments;
  static const String routeName = "/portfolioDetails";

  const PortfolioDetails({required this.arguments});

  @override
  State<PortfolioDetails> createState() => _PortfolioDetailsState();
}

class _PortfolioDetailsState extends State<PortfolioDetails> {
  late PortfolioStore store;

  @override
  void initState() {
    store = widget.arguments.store;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      child: Text(
                        "profiler.portfolio".tr(),
                      ),
                    ),
                    if (widget.arguments.isProfileYour)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () async {
                              final result =
                                  await Navigator.of(context, rootNavigator: false)
                                      .pushNamed(
                                CreatePortfolioPage.routeName,
                                arguments: store.portfolioList[widget.arguments.index],
                              );
                              Navigator.pop(context, result);
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                        ),
                      ),
                    if (widget.arguments.isProfileYour)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () async {
                              AlertDialogUtils.showAlertDialog(context,
                                  title: Text('meta.areYouSure'.tr()),
                                  content: Text('profiler.areYouSurePortfolio'.tr()),
                                  needCancel: true,
                                  colorCancel: AppColor.enabledButton,
                                  colorOk: Colors.red, onTabOk: () {
                                store.deletePortfolio(
                                  portfolioId:
                                      store.portfolioList[widget.arguments.index].id,
                                  userId:
                                      store.portfolioList[widget.arguments.index].userId,
                                );
                                Navigator.pop(context);
                              });
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
                    onPageChanged: store.changePageNumber,
                    children: store.portfolioList[widget.arguments.index].medias
                        .map(
                          (e) => FadeInImage(
                            placeholder: MemoryImage(
                              Uint8List.fromList(
                                  base64Decode(Constants.base64WhiteHolder)),
                            ),
                            fit: BoxFit.fitHeight,
                            image: NetworkImage(
                              e.url,
                            ),
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
                  delegate: SliverChildListDelegate(
                    [
                      ///Image position indicator
                      Container(
                        alignment: Alignment.center,
                        height: 50,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              store.portfolioList[widget.arguments.index].medias.length,
                          itemBuilder: (_, index) => Observer(
                            builder: (_) => index == store.pageNumber
                                ? _indicator(true, context)
                                : _indicator(false, context),
                          ),
                        ),
                      ),

                      ///Portfolio Title
                      Text(
                        store.portfolioList[widget.arguments.index].title,
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
                        store.portfolioList[widget.arguments.index].description,
                      ),
                    ],
                  ),
                ),
              ),
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
