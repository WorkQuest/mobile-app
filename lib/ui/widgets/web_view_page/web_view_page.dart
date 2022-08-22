import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app/constants.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/login_model.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/pages/sign_in_page/mnemonic_page.dart';
import 'package:app/ui/pages/sign_up_page/generate_wallet/wallets_page.dart';
import 'package:app/utils/profile_util.dart';
import 'package:app/utils/storage.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
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

  String get baseUrl {
    if (AccountRepository().notifierNetwork.value == Network.mainnet) {
      return "https://app.workquest.co/";
    }
    return "https://${Constants.isTestnet ? 'testnet' : 'dev'}-app.workquest.co/";
  }

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView example'),
        actions: <Widget>[
          NavigationControls(_controllerCompleter.future),
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        return Stack(
          children: [
            WebView(
              initialUrl: widget.inputUrlRoute != "https://workquest.wiki/"
                  ? baseUrl + widget.inputUrlRoute
                  : widget.inputUrlRoute,
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
                if (url.contains(baseUrl))
                  setState(() {
                    print("url: $url");
                    loading = true;
                  });
              },
              onPageFinished: (String url) async {
                if (!url.contains("app.workquest.co/api/v1/auth/login/"))
                  setState(() {
                    loading = false;
                  });
                print('Page finished loading: $url');
                String? accessToken = await Storage.readAccessToken();
                String? refreshToken = await Storage.readRefreshToken();
                _controllerCompleter.future.then((value) => value
                    .runJavascriptReturningResult(
                        """localStorage.setItem("accessToken","${accessToken ?? ''}");
                    localStorage.setItem("refreshToken","${refreshToken ?? ''}");"""));
                if (url.contains('token?code=') ||
                    url.contains('token?state=')) {
                  _controller!.runJavascript(
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
        final profileMeStore = context.read<ProfileMeStore>();
        if (firstIndex >= 0) {
          final response =
              json.decode(pageBody.substring(firstIndex, lastIndex) + "}");
          final LoginModel responseData =
              LoginModel.fromJson(response["result"]);

          Storage.writeAccessToken(responseData.access);
          Storage.writeRefreshToken(responseData.refresh);
          GetIt.I.get<ApiProvider>().httpClient.accessToken =
              responseData.access;
          String? address;
          profileMeStore.getProfileMe().then((value) {
            address = profileMeStore.userData!.walletAddress;
            if (responseData.userStatus == ProfileConstants.needSetRoleStatus)
              Navigator.of(context, rootNavigator: false).pushReplacementNamed(
                ChooseRolePage.routeName,
              );
            else if (responseData.userStatus ==
                    ProfileConstants.confirmedStatus &&
                address == null) {
              Navigator.of(context, rootNavigator: false).pushReplacementNamed(
                WalletsPage.routeName,
              );
            } else if (responseData.userStatus ==
                ProfileConstants.confirmedStatus) {
              Navigator.of(context, rootNavigator: false).pushReplacementNamed(
                MnemonicPage.routeName,
              );
            }
          });
        }
      },
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture);

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
