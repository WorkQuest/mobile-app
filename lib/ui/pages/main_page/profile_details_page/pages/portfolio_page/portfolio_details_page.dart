import 'package:app/ui/pages/main_page/profile_details_page/pages/portfolio_page/store/portfolio_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";

class PortfolioDetails extends StatelessWidget {
  PortfolioDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final portfolioStore = context.read<PortfolioStore>();

    return Observer(
      builder: (_) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: Row(
                  children: [
                    Expanded(
                      child: Text("Portfolio"),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
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
                          onPressed: () {},
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
                    children: [
                      Image.asset(
                        "assets/test_portfolio_page_image.png",
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        "assets/test_portfolio_page_image.png",
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        "assets/test_portfolio_page_image.png",
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      alignment: Alignment.center,
                      height: 50,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (_, index) => Observer(
                          builder: (_) => index == portfolioStore.pageNumber
                              ? _indicator(true, context)
                              : _indicator(false, context),
                        ),
                      ),
                    ),
                    Text(
                      "Lorem ipsum dolor sit amet, consectetur",
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit ut "
                      "aliquam, purus sit amet luctus venenatis, lectus magna "
                      "fringilla urna, porttitor rhoncus dolor purus non enim "
                      "praesent elementum facilisis leo, vel fringilla est"
                      " ullamcorper eget nulla facilisi etiam dignissim diam "
                      "quis enim lobortis scelerisque fermentum dui faucibus "
                      "in ornare quam viverra",
                      // style: const TextStyle(
                      //   fontSize: 23,
                      //   fontWeight: FontWeight.w500,
                      // ),
                    ),
                    Text("Skills"),
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
                    color: Theme.of(context).primaryColor.withOpacity(0.72),
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
