import 'package:app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({Key? key}) : super(key: key);

  //static const String routeName = "/changeLanguagePage";

  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
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
          "Language",
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => RadioListTile(
                value: Constants.languageList.values.elementAt(index),
                groupValue: currentLocale,
                onChanged: (value) {
                  context.setLocale(
                    Constants.languageList.values.elementAt(index),
                  );
                  setState(() {
                    currentLocale =
                        Constants.languageList.values.elementAt(index);
                  });
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
