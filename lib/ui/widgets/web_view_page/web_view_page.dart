import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app/model/login_model.dart';
import 'package:app/ui/pages/sign_in_page/mnemonic_page.dart';
import 'package:app/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../pages/sign_up_page/choose_role_page/choose_role_page.dart';

class WebViewPage extends StatefulWidget {
  final String inputUrlRoute;

  const WebViewPage(this.inputUrlRoute);

  static const String routeName = "/webViewPage";

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final Completer<WebViewController> _controllerCompleter =
      Completer<WebViewController>();

  final String baseUrl = "https://dev-app.workquest.co/";
  final storage = new FlutterSecureStorage();
  WebViewController? _controller;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    print("BaseUrl: ${baseUrl + widget.inputUrlRoute}");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView example'),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        actions: <Widget>[
          NavigationControls(_controllerCompleter.future),
        ],
      ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Builder(builder: (BuildContext context) {
        return Stack(
          children: [
            WebView(
              initialUrl: baseUrl + widget.inputUrlRoute,
              userAgent: "random",
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) async {
                _controllerCompleter.complete(webViewController);
                _controller = webViewController;
              },
              onProgress: (int progress) {
                print("WebView is loading (progress : $progress%)");
              },
              javascriptChannels: <JavascriptChannel>[
                // Set Javascript Channel to WebView
                _extractDataJSChannel(context),
              ].toSet(),
              navigationDelegate: (NavigationRequest request) {
                if (request.url.startsWith('https://www.youtube.com/')) {
                  print('blocking navigation to $request}');
                  return NavigationDecision.prevent;
                }
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) async {
                print('Page started loading: $url');
                if (url.contains("dev-app.workquest.co"))
                  setState(() {
                    print("url: $url");
                    loading = true;
                  });
                if (!url.contains(baseUrl + widget.inputUrlRoute))
                  setState(() {
                    loading = false;
                  });
              },
              onPageFinished: (String url) async {
                print('Page finished loading: $url');
                // _getTokenThroughSocialMedia(url);
                String? accessToken = await Storage.readAccessToken();
                String? refreshToken = await Storage.readRefreshToken();
                _controllerCompleter.future
                    .then((value) => value.runJavascriptReturningResult(
                        // evaluateJavascript(
                        """localStorage.setItem("accessToken","${accessToken ?? ''}");
                    localStorage.setItem("refreshToken","${refreshToken ?? ''}");"""));
                if (url.contains('token?code=') ||
                    url.contains('token?state=')) {
                  _controller!.evaluateJavascript(
                      "(function(){Flutter.postMessage(window.document.body.outerHTML)})();");
                }
              },
              gestureNavigationEnabled: true,
            ),
            if (loading)
              Positioned.fill(
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  JavascriptChannel _extractDataJSChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Flutter',
      onMessageReceived: (JavascriptMessage message) {
        String pageBody = message.message;
        final firstIndex = pageBody.indexOf("{");
        final lastIndex = pageBody.lastIndexOf("}");
        if (firstIndex >= 0) {
          final response =
              json.decode(pageBody.substring(firstIndex, lastIndex) + "}");
          final LoginModel responseData =
              LoginModel.fromJson(response["result"]);

          Storage.writeAccessToken(responseData.access);
          Storage.writeRefreshToken(responseData.refresh);
          if (responseData.userStatus == 2)
            Navigator.of(context, rootNavigator: false).pushNamed(
              ChooseRolePage.routeName,
            );
          else if (responseData.userStatus == 1) {
            Navigator.of(context, rootNavigator: false).pushNamed(
              MnemonicPage.routeName,
            );
          }
        }
      },
    );
  }

  // void _getTokenThroughSocialMedia(String url) async {
  //   final socialMedia = widget.inputUrlRoute.split("/").last;
  //   if (url.contains("access") && url.contains("refresh")) {
  //     String accessToken = url
  //         .split("/")
  //         .where((element) => element.contains("access"))
  //         .first
  //         .split("&")
  //         .first
  //         .replaceRange(0, 8, "");
  //     String refreshToken = url
  //         .split("/")
  //         .where((element) => element.contains("refresh"))
  //         .first
  //         .split("&")[1]
  //         .replaceRange(0, 8, "");
  //     String status = "";
  //     if (socialMedia == "facebook")
  //       status = url
  //           .split("/")
  //           .where((element) => element.contains("refresh"))
  //           .first
  //           .split("&")
  //           .last
  //           .split("")
  //           .reversed
  //           .toList()[4];
  //     else
  //       status = url
  //           .split("/")
  //           .where((element) => element.contains("refresh"))
  //           .first
  //           .split("&")
  //           .last
  //           .split("")
  //           .last;
  //     Storage.writeAccessToken(accessToken);
  //     Storage.writeRefreshToken(refreshToken);
  //     if (status == "2")
  //       Navigator.of(context, rootNavigator: false).pushNamed(
  //         ChooseRolePage.routeName,
  //       );
  //     else if (status == "1") {
  //       Navigator.of(context, rootNavigator: false).pushNamed(
  //         MnemonicPage.routeName,
  //       );
  //     }
  //   }
  // }

  void _onShowUserAgent(
      WebViewController controller, BuildContext context) async {
    // Send a message with the user agent string to the Toaster JavaScript channel we registered
    // with the WebView.
    await controller.evaluateJavascript(
        'Toaster.postMessage("User Agent: " + navigator.userAgent);');
  }

  void _onListCookies(
      WebViewController controller, BuildContext context) async {
    final String cookies =
        await controller.evaluateJavascript('document.cookie');
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Cookies:'),
          _getCookieList(cookies),
        ],
      ),
    ));
  }

  void _onAddToCache(WebViewController controller, BuildContext context) async {
    await controller.evaluateJavascript(
        'caches.open("test_caches_entry"); localStorage["test_localStorage"] = "dummy_entry";');
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(const SnackBar(
      content: Text('Added a test entry to cache.'),
    ));
  }

  void _onListCache(WebViewController controller, BuildContext context) async {
    await controller.evaluateJavascript('caches.keys()'
        '.then((cacheKeys) => JSON.stringify({"cacheKeys" : cacheKeys, "localStorage" : localStorage}))'
        '.then((caches) => Toaster.postMessage(caches))');
  }

  void _onClearCache(WebViewController controller, BuildContext context) async {
    await controller.clearCache();
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(const SnackBar(
      content: Text("Cache cleared."),
    ));
  }

  Widget _getCookieList(String cookies) {
    if (cookies == null || cookies == '""') {
      return Container();
    }
    final List<String> cookieList = cookies.split(';');
    final Iterable<Text> cookieWidgets =
        cookieList.map((String cookie) => Text(cookie));
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: cookieWidgets.toList(),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data!;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoBack()) {
                        await controller.goBack();
                      } else {
                        // ignore: deprecated_member_use
                        Scaffold.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("No back history item"),
                          ),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoForward()) {
                        await controller.goForward();
                      } else {
                        // ignore: deprecated_member_use
                        Scaffold.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("No forward history item"),
                          ),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: !webViewReady
                  ? null
                  : () {
                      controller.reload();
                    },
            ),
          ],
        );
      },
    );
  }
}
