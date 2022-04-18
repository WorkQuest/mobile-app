import 'dart:async';
import 'dart:io';
import 'package:app/constants.dart';
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
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  final String baseUrl = Constants.isRelease
      ? "https://app-ver1.workquest.co/"
      : "https://app.workquest.co/";
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView example'),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        actions: <Widget>[
          NavigationControls(_controller.future),
        ],
      ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: baseUrl + widget.inputUrlRoute,
          userAgent: "random",
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) async {
            _controller.complete(webViewController);
          },
          onProgress: (int progress) {
            print("WebView is loading (progress : $progress%)");
          },
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
          },
          onPageFinished: (String url) async {
            print('Page finished loading: $url');
            _getTokenThroughSocialMedia(url);
            String? accessToken = await Storage.readAccessToken();
            String? refreshToken = await Storage.readRefreshToken();
            _controller.future.then((value) => value.evaluateJavascript(
                """localStorage.setItem("accessToken","${accessToken ?? ''}");
                localStorage.setItem("refreshToken","${refreshToken ?? ''}");"""));
          },
          gestureNavigationEnabled: true,
        );
      }),
    );
  }

  void _getTokenThroughSocialMedia(String url) async{
    if (url.contains("access") && url.contains("refresh")) {
      String accessToken = "";
      String refreshToken = "";
      String status = "";
      accessToken = url
          .split("/")
          .where((element) => element.contains("access"))
          .first
          .split("&")
          .first
          .replaceRange(0, 8, "");
      refreshToken = url
          .split("/")
          .where((element) => element.contains("refresh"))
          .first
          .split("&")[1].replaceRange(0, 8, "");
      status = url
          .split("/")
          .where((element) => element.contains("refresh"))
          .first
          .split("&")
          .last
          .split("")
          .last;
      Storage.writeAccessToken(accessToken);
      Storage.writeRefreshToken(refreshToken);
      if (status == "2")
        Navigator.of(context, rootNavigator: false).pushNamed(
          ChooseRolePage.routeName,
        );
      else if (status == "1") {
        Navigator.of(context, rootNavigator: false).pushNamed(
          MnemonicPage.routeName,
        );
      }
    }
  }

  void _onShowUserAgent(WebViewController controller, BuildContext context) async {
    // Send a message with the user agent string to the Toaster JavaScript channel we registered
    // with the WebView.
    await controller
        .evaluateJavascript('Toaster.postMessage("User Agent: " + navigator.userAgent);');
  }

  void _onListCookies(WebViewController controller, BuildContext context) async {
    final String cookies = await controller.evaluateJavascript('document.cookie');
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
    final Iterable<Text> cookieWidgets = cookieList.map((String cookie) => Text(cookie));
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
      builder: (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady = snapshot.connectionState == ConnectionState.done;
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
