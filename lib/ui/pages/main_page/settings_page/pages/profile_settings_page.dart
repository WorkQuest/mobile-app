import 'package:app/ui/pages/main_page/settings_page/store/settings_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileSettings extends StatelessWidget {
  final SettingsPageStore settingStore;

  const ProfileSettings(this.settingStore);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        body: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: Text("ui.profile.settings".tr()),
            ),
            SliverPadding(
              padding: EdgeInsets.all(10.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _card(
                      [
                        Text(
                          "settings.whoCanSee".tr(),
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        _radioTile(
                          value: 1,
                          groupValue: settingStore.privacy,
                          title: "settings.allUsers".tr(),
                          onChanged: settingStore.changePrivacy,
                        ),
                        _radioTile(
                          value: 2,
                          groupValue: settingStore.privacy,
                          title: "settings.allInternet".tr(),
                          onChanged: settingStore.changePrivacy,
                        ),
                        _radioTile(
                          value: 3,
                          groupValue: settingStore.privacy,
                          title: "settings.onlyWhenSubmittedWork".tr(),
                          onChanged: settingStore.changePrivacy,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: _card(
                        [
                          Text(
                            "Filter all work proposals",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          _radioTile(
                            value: 1,
                            groupValue: settingStore.filter,
                            title: "Only urgent proposals",
                            onChanged: settingStore.changeFilter,
                          ),
                          _radioTile(
                            value: 2,
                            groupValue: settingStore.filter,
                            title: "Only implementation",
                            onChanged: settingStore.changeFilter,
                          ),
                          _radioTile(
                            value: 3,
                            groupValue: settingStore.filter,
                            title: "Only ready for execution",
                            onChanged: settingStore.changeFilter,
                          ),
                          _radioTile(
                            value: 4,
                            groupValue: settingStore.filter,
                            title: "All registered users",
                            onChanged: settingStore.changeFilter,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _radioTile({
    required int value,
    required int groupValue,
    required String title,
    required void Function(int?) onChanged,
  }) =>
      RadioListTile(
        dense: true,
        value: value,
        onChanged: onChanged,
        groupValue: groupValue,
        contentPadding: EdgeInsets.zero,
        title: Transform.translate(
          offset: Offset(-20.0, 0.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              color: Color(0xFF7C838D),
            ),
          ),
        ),
      );

  Widget _card(
    List<Widget> children,
  ) =>
      Material(
        color: Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(6.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      );
}
