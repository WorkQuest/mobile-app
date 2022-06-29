import 'package:app/enums.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/profile_visibility_page/store/profile_visibility_store.dart';
import 'package:app/ui/widgets/default_app_bar.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../../../../../../constants.dart';
import '../../../../../../model/profile_response/profile_me_response.dart';
import '../../../../../widgets/default_radio.dart';

const _padding = EdgeInsets.all(16.0);

class ProfileSettings extends StatefulWidget {
  final ProfileMeResponse profile;
  static const routeName = 'profileVisibility';

  const ProfileSettings(this.profile);

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
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
        final _statusRespondOrInvite = _getStatusAllFromTypes(_store.canRespondOrInviteToQuest);
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
              if (_store.isLoading) Padding(
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
                  _CardOptionsWidget(
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
                      _RadioTileWidget(
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
                        return _RadioTileWidget(
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
                  _CardOptionsWidget(
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
                      _RadioTileWidget(
                        status: _getStatusAllFromTypes(_store.canRespondOrInviteToQuest),
                        type: null,
                        onPressed: () {
                          VisibilityTypes.values.map((type) {
                            _store.setCanRespondOrInviteToQuest(type, !_statusRespondOrInvite);
                          }).toList();
                        },
                      ),
                      ...VisibilityTypes.values.map((type) {
                        final _status = _store.canRespondOrInviteToQuest[type]!;
                        return _RadioTileWidget(
                          type: type,
                          status: _status,
                          onPressed: () => _store.setCanRespondOrInviteToQuest(type, !_status),
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

class _CardOptionsWidget extends StatelessWidget {
  final List<Widget> children;

  const _CardOptionsWidget({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
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
}

class _RadioTileWidget extends StatelessWidget {
  final Function()? onPressed;
  final VisibilityTypes? type;
  final bool status;

  const _RadioTileWidget({
    Key? key,
    required this.onPressed,
    required this.status,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ColoredBox(
        color: Colors.transparent,
        child: SizedBox(
          height: 36,
          width: double.infinity,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              DefaultRadio(
                status: status,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                _getTitleType(type),
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColor.subtitleText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getTitleType(VisibilityTypes? type) {
    if (type == VisibilityTypes.notRated) {
      return 'settings.typesVisibly.notRated'.tr();
    } else if (type == VisibilityTypes.topRanked) {
      return 'settings.typesVisibly.topRanked'.tr();
    } else if (type == VisibilityTypes.reliable) {
      return 'settings.typesVisibly.reliable'.tr();
    } else if (type == VisibilityTypes.verified) {
      return 'settings.typesVisibly.verified'.tr();
    } else {
      return 'settings.typesVisibly.allUsers'.tr();
    }
  }
}
