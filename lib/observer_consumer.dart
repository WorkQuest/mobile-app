import 'dart:io';
import 'package:app/base_store/i_store.dart';
import 'package:app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ObserverListener<T extends IStore> extends StatefulWidget {
  final Function() onSuccess;
  final bool Function()? onFailure;
  final Widget child;

  ObserverListener({
    required this.onSuccess,
    this.onFailure,
    required this.child,
  });

  @override
  _ObserverListenerState createState() => _ObserverListenerState<T>();
}

class _ObserverListenerState<T extends IStore> extends State<ObserverListener> {
  late IStore _store;
  late List<ReactionDisposer> _disposers;

  @override
  void initState() {
    _store = context.read<T>();
    _disposers = [_successReaction, _failureReaction];
    super.initState();
  }

  ReactionDisposer get _successReaction {
    return reaction(
      (_) => _store.isSuccess,
      (bool isSuccess) {
        if (isSuccess) {
          widget.onSuccess();
        }
      },
    );
  }

  ReactionDisposer get _failureReaction {
    print('_failureReaction');
    return reaction(
      (_) => _store.errorMessage,
      (String? errorMessage) {
        if (errorMessage != null) {
          print('qweasd');
          if (widget.onFailure != null) if (widget.onFailure!()) return;
          final _words = errorMessage.split(' ');
          print('words: $_words');
          showCupertinoDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext contextDialog) {
              return Platform.isIOS
                  ? CupertinoAlertDialog(
                      title: Text('Error'),
                      content: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: '',
                            children: _words.map((word) {
                              return TextSpan(
                                  text: '$word ',
                                  style: TextStyle(
                                    color: isLink(word) ? AppColor.enabledButton : Colors.black,
                                    fontSize: 14,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = isLink(word)
                                        ? () async {
                                            if (await canLaunchUrl(Uri.parse(word))) {
                                              launchUrl(Uri.parse(word));
                                            }
                                          }
                                        : null);
                            }).toList()),
                      ),
                      actions: [
                        CupertinoDialogAction(
                          child: Text("OK"),
                          onPressed: Navigator.of(contextDialog).pop,
                        )
                      ],
                    )
                  : AlertDialog(
                      title: Text('Error'),
                      content: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: '',
                            children: _words.map((word) {
                              return TextSpan(
                                  text: '$word ',
                                  style: TextStyle(
                                    color: isLink(word) ? AppColor.enabledButton : Colors.black,
                                    fontSize: 14,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = isLink(word)
                                        ? () async {
                                            if (await canLaunchUrl(Uri.parse(word))) {
                                              launchUrl(Uri.parse(word));
                                            }
                                          }
                                        : null);
                            }).toList()),
                      ),
                      actions: [
                        CupertinoDialogAction(
                          child: Text("OK"),
                          onPressed: Navigator.of(contextDialog).pop,
                        )
                      ],
                    );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    _disposers.forEach((d) => d());
    super.dispose();
  }

  bool isLink(String value) => value.contains('https');
}

class ObserverConsumer<T extends IStore> extends StatefulWidget {
  final List<ReactionDisposer> reactions;
  final WidgetBuilder builder;

  ObserverConsumer({
    Key? key,
    required this.reactions,
    required this.builder,
  }) : super(key: key);

  @override
  _ObserverConsumerState createState() => _ObserverConsumerState<T>();
}

class _ObserverConsumerState<T extends IStore> extends State<ObserverConsumer> {
  late List<ReactionDisposer> _disposers;

  @override
  void initState() {
    _disposers = widget.reactions;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: widget.builder,
    );
  }

  @override
  void dispose() {
    _disposers.forEach((d) => d());
    super.dispose();
  }
}
