import 'package:app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ChangeLanguagePage extends StatefulWidget {
  const ChangeLanguagePage({Key? key}) : super(key: key);

  static const String routeName = "/changeLanguagePage";

  @override
  _ChangeLanguagePageState createState() => _ChangeLanguagePageState();
}

class _ChangeLanguagePageState extends State<ChangeLanguagePage> {
  late Locale currentLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentLocale = context.locale;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text(
          "meta.language".tr(),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => RadioListTile(
                value: Constants.languageList.values.elementAt(index),
                groupValue: currentLocale,
                onChanged: (value) async {
                  context.setLocale(
                    Constants.languageList.values.elementAt(index),
                  );
                  setState(() {
                    currentLocale =
                        Constants.languageList.values.elementAt(index);
                  });
                  Navigator.pop(context);
                },
                title: Text(
                  Constants.languageList.keys.elementAt(index),
                ),
              ),
              childCount: Constants.languageList.length,
            ),
          )
        ],
      ),
    );
  }
}
