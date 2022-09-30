import 'package:app/ui/pages/pin_code_page/pin_code_page.dart';
import 'package:app/ui/pages/pin_code_page/store/pin_code_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'di/injector.dart';

class BackgroundObserverPage extends StatefulWidget {
  final Widget? child;
  final BuildContext? con;

  BackgroundObserverPage({this.child, this.con, Key? key}) : super(key: key);

  @override
  _BackgroundObserverPageState createState() => _BackgroundObserverPageState();
}

class _BackgroundObserverPageState extends State<BackgroundObserverPage>
    with WidgetsBindingObserver {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        _resumed();
        break;
      case AppLifecycleState.paused:
        _paused();
        break;
      case AppLifecycleState.inactive:
        _inactive();
        break;
      default:
        break;
    }
  }

  Future _paused() async {
    final sp = await SharedPreferences.getInstance();
    sp.setInt(lastKnownStateKey, AppLifecycleState.paused.index);
  }

  Future _inactive() async {
    final sp = await SharedPreferences.getInstance();
    // final prevState = sp.getInt(lastKnownStateKey);

    // final prevStateIsNotPaused = prevState != null &&
    //     AppLifecycleState.values[prevState] != AppLifecycleState.paused;

    // if (prevStateIsNotPaused) {
    sp.setInt(backgroundedTimeKey, DateTime.now().millisecondsSinceEpoch);
    // }

    sp.setInt(lastKnownStateKey, AppLifecycleState.inactive.index);
  }

  Future _resumed() async {
    if (isOpen) return;
    final sp = await SharedPreferences.getInstance();

    final bgTime = sp.getInt(backgroundedTimeKey) ?? MAX_INT;
    final allowedBackgroundTime = bgTime + pinLockMillis;
    final shouldShowPIN =
        DateTime.now().millisecondsSinceEpoch > allowedBackgroundTime;

    if (shouldShowPIN) {
      setState(() {
        isOpen = true;
      });
      await Navigator.push(
          widget.con ?? context,
          MaterialPageRoute(
            builder: (context) => Provider(
              create: (context) => getIt.get<PinCodeStore>(),
              child: PinCodePage(isRecheck: true),
            ),
          ));
      setState(() {
        isOpen = false;
      });
    }

    sp.remove(backgroundedTimeKey);
    sp.setInt(lastKnownStateKey, AppLifecycleState.resumed.index);
  }
}

const lastKnownStateKey = 'lastKnownStateKey';
const backgroundedTimeKey = 'backgroundedTimeKey';
const pinLockMillis = 900000; //(15 minutes) milli seconds
const MAX_INT = 9223372036854775807 - pinLockMillis;
