import 'package:app/constants.dart';
import 'package:app/enums.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/profile_visibility_page/store/profile_visibility_store.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/profile_visibility_page/widgets/card_options_widget.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/profile_visibility_page/widgets/radio_tile_widget.dart';
import 'package:app/ui/widgets/default_app_bar.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

const _padding = EdgeInsets.all(16.0);

class ProfileVisibilityPage extends StatefulWidget {
  final ProfileMeResponse profile;
  static const routeName = 'profileVisibility';

  const ProfileVisibilityPage(this.profile);

  @override
  State<ProfileVisibilityPage> createState() => _ProfileVisibilityPageState();
}

class _ProfileVisibilityPageState extends State<ProfileVisibilityPage> {
  late ProfileVisibilityStore _store;

  @override
  void initState() {
    _store = context.read<ProfileVisibilityStore>();
    _store.init(widget.profile);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObserverListener<ProfileVisibilityStore>(
      onSuccess: () async {
        await AlertDialogUtils.showSuccessDialog(context);
        Navigator.pop(context, true);
      },
      onFailure: () {
        return false;
      },
      child: Observer(builder: (_) {
        final _statusRespondOrInvite =
            _getStatusAllFromTypes(_store.canRespondOrInviteToQuest);
        final _statusMySearch = _getStatusAllFromTypes(_store.mySearch);
        return Scaffold(
          appBar: DefaultAppBar(
            title: 'ui.profile.settings'.tr(),
            actions: [
              if (!_store.isLoading)
                CupertinoButton(
                  child: Text(
                    'meta.save'.tr(),
                    style: TextStyle(color: AppColor.enabledButton),
                  ),
                  onPressed: () {
                    _store.editProfileVisibility(widget.profile);
                  },
                ),
              if (_store.isLoading)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircularProgressIndicator.adaptive(),
                ),
            ],
          ),
          body: Padding(
            padding: _padding,
            child: AbsorbPointer(
              absorbing: _store.isLoading,
              child: Column(
                children: [
                  CardOptionsWidget(
                    children: [
                      Text(
                        widget.profile.role == UserRole.Worker
                            ? 'settings.whoAppearsListEmployers'.tr()
                            : 'settings.whoAppearsListEmployees'.tr(),
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      RadioTileWidget(
                        status: _getStatusAllFromTypes(_store.mySearch),
                        type: null,
                        onPressed: () {
                          VisibilityTypes.values.map((type) {
                            _store.setMySearch(type, !_statusMySearch);
                          }).toList();
                        },
                      ),
                      ...VisibilityTypes.values.map((type) {
                        final _status = _store.mySearch[type]!;
                        return RadioTileWidget(
                          type: type,
                          status: _status,
                          onPressed: () => _store.setMySearch(type, !_status),
                        );
                      }).toList(),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CardOptionsWidget(
                    children: [
                      Text(
                        widget.profile.role == UserRole.Worker
                            ? 'settings.whoCanInviteMe'.tr()
                            : 'settings.whoCanRespond'.tr(),
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      RadioTileWidget(
                        status: _getStatusAllFromTypes(
                            _store.canRespondOrInviteToQuest),
                        type: null,
                        onPressed: () {
                          VisibilityTypes.values.map((type) {
                            _store.setCanRespondOrInviteToQuest(
                                type, !_statusRespondOrInvite);
                          }).toList();
                        },
                      ),
                      ...VisibilityTypes.values.map((type) {
                        final _status = _store.canRespondOrInviteToQuest[type]!;
                        return RadioTileWidget(
                          type: type,
                          status: _status,
                          onPressed: () => _store.setCanRespondOrInviteToQuest(
                              type, !_status),
                        );
                      }).toList(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  bool _getStatusAllFromTypes(Map<VisibilityTypes, bool> types) {
    bool _result = true;
    types.forEach((key, value) {
      /// false value
      if (!types[key]!) {
        _result = false;
      }
    });
    return _result;
  }
}
