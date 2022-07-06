import 'dart:async';

import 'package:app/ui/pages/sign_in_page/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:easy_localization/easy_localization.dart';

class StartPage extends StatefulWidget {
  final CarouselController carouselController;

  static const String routeName = '/startPage';

  StartPage() : this.carouselController = new CarouselController();

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final _pageController = PageController();

  StreamController<double> _currentPageController = StreamController<double>();
  StreamController<double> _opacityController = StreamController<double>();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      _currentPageController.sink.add(_pageController.page!);
      if (_pageController.page! >= 0 && _pageController.page! <= 1) {
        _opacityController.sink.add(_pageController.page!);
      } else if (_pageController.page! > 1 && _pageController.page! <= 2) {
        _opacityController.sink.add(_pageController.page! - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Scaffold(
      body: SizedBox(
        height: mq.size.height,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0083C7),
                  Color(0xFF103D7C),
                ],
              ),
            ),
            child: Stack(
              children: [
                StreamBuilder<double>(
                  initialData: 0.0,
                  stream: _currentPageController.stream,
                  builder: (_, snapshot) => Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            if (snapshot.data! <= 1)
                              page(
                                firstImage: "assets/start_page_1.png",
                                secondImage: "assets/start_page_2.png",
                                context: context,
                                firstHead: "startPage.pages.first.head".tr(),
                                firstTitle: "startPage.pages.first.title".tr(),
                                secondHead: "startPage.pages.second.head".tr(),
                                secondTitle: "startPage.pages.second.title".tr(),
                              )
                            else
                              page(
                                firstImage: "assets/start_page_2.png",
                                secondImage: "assets/start_page_3.png",
                                context: context,
                                firstHead: "startPage.pages.second.head".tr(),
                                firstTitle: "startPage.pages.second.title".tr(),
                                secondHead: "startPage.pages.third.head".tr(),
                                secondTitle: "startPage.pages.third.title".tr(),
                              ),
                            PageView(
                              controller: _pageController,
                              children: <Widget>[Center(), Center(), Center()],
                            ),
                          ],
                        ),
                      ),
                      buttonRow(
                        position: snapshot.data!,
                        onPressedNext: () {
                          if (_pageController.page! < 2.0) {
                            _pageController.nextPage(
                                duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                          } else {
                            Navigator.pushNamed(context, SignInPage.routeName);
                          }
                        },
                        onPressedSkip: () {
                          Navigator.pushNamed(context, SignInPage.routeName);
                        },
                        context: context,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget page({
    required String firstImage,
    required String secondImage,
    required String firstHead,
    required String firstTitle,
    required String secondHead,
    required String secondTitle,
    required BuildContext context,
  }) {
    return StreamBuilder<double>(
      initialData: 0.0,
      stream: _opacityController.stream,
      builder: (_, snapshot) {
        return Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 1 - snapshot.data!,
                child: ShaderMask(
                  shaderCallback: (rectangle) {
                    return LinearGradient(
                      colors: [Colors.black, Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(
                      Rect.fromLTRB(
                        0,
                        0,
                        rectangle.width,
                        rectangle.height,
                      ),
                    );
                  },
                  blendMode: BlendMode.dstIn,
                  child: Container(
                    height: double.infinity,
                    child: Image.asset(
                      firstImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: snapshot.data!,
                child: ShaderMask(
                  shaderCallback: (rectangle) {
                    return LinearGradient(
                      colors: [Colors.black, Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(
                      Rect.fromLTRB(
                        0,
                        0,
                        rectangle.width,
                        rectangle.height,
                      ),
                    );
                  },
                  blendMode: BlendMode.dstIn,
                  child: Container(
                    height: double.infinity,
                    child: Image.asset(
                      secondImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: 1 - snapshot.data!,
              child: title(
                head: firstHead,
                title: firstTitle,
              ),
            ),
            Opacity(
              opacity: snapshot.data!,
              child: title(
                head: secondHead,
                title: secondTitle,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget title({
    required String head,
    required String title,
  }) =>
      Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "startPage.welcome".tr(),
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
            Text(
              "startPage.workQuest".tr(),
              style: TextStyle(
                fontSize: 34.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              head,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );

  Widget buttonRow({
    double position = 0.0,
    required void onPressedSkip()?,
    required void onPressedNext()?,
    required BuildContext context,
  }) =>
      Padding(
        padding: EdgeInsets.only(bottom: 30.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 45.0,
              width: 70.0,
              child: OutlinedButton(
                onPressed: onPressedSkip,
                child: Text(
                  "startPage.skip".tr(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    width: 1.0,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              //TODO:Remove lib and rewrite
              child: DotsIndicator(
                dotsCount: 3,
                position: position * 1.0,
                decorator: DotsDecorator(
                  activeColor: Colors.white,
                  color: Colors.white.withOpacity(0.75),
                  activeSize: Size(13, 13),
                  spacing: EdgeInsets.symmetric(horizontal: 2),
                  size: Size(10, 10),
                ),
              ),
            ),
            SizedBox(
              height: 45.0,
              width: 70.0,
              child: OutlinedButton(
                onPressed: onPressedNext,
                child: Text(
                  "startPage.next".tr(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    width: 1.0,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
