import 'dart:convert';

import 'package:app/http/core/http_client.dart';
import 'package:app/ui/widgets/default_app_bar.dart';
import 'package:app/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JournalErrorsPage extends StatefulWidget {
  const JournalErrorsPage({Key? key}) : super(key: key);

  @override
  State<JournalErrorsPage> createState() => _JournalErrorsPageState();
}

class _JournalErrorsPageState extends State<JournalErrorsPage> {
  late Future<List<ErrorRequestModel>> _future;

  Future<List<ErrorRequestModel>> _getList() async {
    final _sp = await SharedPreferences.getInstance();
    final _list = _sp.getStringList(errorsSharedKeys) ?? [];
    setState(() {});
    return _list.map((e) => ErrorRequestModel.fromJson(jsonDecode(e))).toList();
  }

  @override
  void initState() {
    _future = _getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: "Journal errors",
        actions: [
          IconButton(
            onPressed: () async {
              final _sp = await SharedPreferences.getInstance();
              _sp.remove(errorsSharedKeys);
              _future = _getList();
            },
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<ErrorRequestModel>>(
          future: _future,
          builder:
              (BuildContext context, AsyncSnapshot<List<ErrorRequestModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.separated(
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (_, index) {
                  final error = snapshot.data![index];
                  return ListTile(
                    title: Text('Url: ${error.url}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        Text('Method: ${error.method}'),
                        const SizedBox(
                          height: 4,
                        ),
                        Text('Query: ${error.query}'),
                        const SizedBox(
                          height: 4,
                        ),
                        Text('Data: ${error.data}'),
                        const SizedBox(
                          height: 4,
                        ),
                        Text('Message: ${error.message}'),
                        const SizedBox(
                          height: 4,
                        ),
                        Text('Response: ${error.response}'),
                        const SizedBox(
                          height: 4,
                        ),
                        Text('Date: ${error.date}'),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                    onLongPress: () {
                      Clipboard.setData(ClipboardData(text: error.toString()));
                      SnackBarUtils.success(
                        context,
                        title: 'Copy',
                        duration: const Duration(milliseconds: 1000),
                      );
                    },
                  );
                },
                separatorBuilder: (_, index) {
                  return Divider(
                    thickness: 1,
                  );
                },
              );
            }
            return Text(snapshot.connectionState.name);
          },
        ),
      ),
    );
  }
}
