import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PortfolioDetails extends StatelessWidget {
   PortfolioDetails({Key? key}) : super(key: key);

  final List wid =[
      Image.asset("assets/test_portfolio_page_image.png"),
    Image.asset("assets/test_portfolio_page_image.png"),
    Image.asset("assets/test_portfolio_page_image.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CupertinoNavigationBar(
          middle: Text("Portfolio"),
          trailing: IconButton(
            padding: EdgeInsets.zero,
            onPressed: null,
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        height: 200,
                       child: PageView(
                          children: [
                            Image.asset("assets/test_portfolio_page_image.png"),
                            Image.asset("assets/test_portfolio_page_image.png"),
                            Image.asset("assets/test_portfolio_page_image.png"),
                          ],
                        ),
                      ),

                      Container(),
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
                  )
                ],
              )),
        ),
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return Container(
      height: 10,
      child: AnimatedContainer(

        duration: Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive
            ? 10:8.0,
        width: isActive
            ? 12:8.0,
        decoration: BoxDecoration(
          boxShadow: [
            isActive
                ? BoxShadow(
              color: Color(0XFF2FB7B2).withOpacity(0.72),
              blurRadius: 4.0,
              spreadRadius: 1.0,
              offset: Offset(
                0.0,
                0.0,
              ),
            )
                : BoxShadow(
              color: Colors.transparent,
            )
          ],
          shape: BoxShape.circle,
          color: isActive ? Color(0XFF6BC4C9) : Color(0XFFEAEAEA),
        ),
      ),
    );
  }

  // List<Widget> _buildPageIndicator() {
  //   List<Widget> list = [];
  //   for (int i = 0; i < wid.length; i++) {
  //     list.add(i == selectedindex ? _indicator(true) : _indicator(false));
  //   }
  //   return list;
  // }
}
