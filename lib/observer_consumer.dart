import 'package:app/base_store/i_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class ObserverConsumer<T extends IStore> extends StatefulWidget {

  final Function? onSuccess;
  final WidgetBuilder builder;

  ObserverConsumer({this.onSuccess, required this.builder});

  @override
  _ObserverConsumerState createState() => _ObserverConsumerState<T>();
}

class _ObserverConsumerState<T extends IStore> extends State<ObserverConsumer> {
  late IStore _store;
  late List<ReactionDisposer> _disposers;

  @override
  void initState() {
    _store = context.read<T>();
    _disposers = [];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.onSuccess != null) {
      _disposers.add(
        reaction(
          (_) => _store.successData,
          (dynamic? successData) {
            if (!_store.isSuccess) {
              return;
            }

            widget.onSuccess?.call();
          },
        ),
      );
    }

    _disposers.add(
      reaction(
        (_) => _store.errorMessage,
        (String? message) {
          if (message == null) {
            return;
          }

          showCupertinoDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) {
              return CupertinoAlertDialog(
                title: Text('Error'),
                content: Text(message),
              );
            },
          );
        },
      ),
    );
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
