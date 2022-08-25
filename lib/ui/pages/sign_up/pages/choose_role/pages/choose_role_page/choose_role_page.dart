import 'package:app/enums.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/sign_up/pages/choose_role/pages/choose_role_page/store/choose_role_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../approve_role_page.dart';

class ChooseRolePage extends StatefulWidget {
  const ChooseRolePage();

  static const String routeName = '/chooseRolePage';

  @override
  State<ChooseRolePage> createState() => _ChooseRolePageState();
}

class _ChooseRolePageState extends State<ChooseRolePage> {
  late final ChooseRoleStore store;

  @override
  void initState() {
    store = context.read<ChooseRoleStore>();
    super.initState();
  }

  _stateListener() {
    if (store.successData == ChooseRoleState.refreshToken) {
      Navigator.pushNamed(
        context,
        ApproveRolePage.routeName,
        arguments: store,
      );
    }
  }

  Widget build(BuildContext context) {
    return ObserverListener<ChooseRoleStore>(
      onSuccess: _stateListener,
      onFailure: () => false,
      child: Scaffold(
        appBar: CupertinoNavigationBar(
          leading: Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: _onBackPressed,
              child: Row(
                children: [
                  SvgPicture.asset("assets/arrow_back.svg"),
                  Text(
                    "mining.back".tr(),
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
          border: Border.fromBorderSide(BorderSide.none),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  "role.choose".tr(),
                  style: TextStyle(
                    color: Color(0xFF1D2127),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: _CardChooseRoleWidget(
                    role: UserRole.Employer,
                    store: store,
                    color: const Color(0xFF1D2127),
                    onTap: () => _onPressedSelectRole(UserRole.Employer),
                  ),
                  // child: getCard(context, store, UserRole.Employer, Color(0xFF1D2127)),
                ),
                const SizedBox(height: 0),
                Expanded(
                  child: _CardChooseRoleWidget(
                    role: UserRole.Worker,
                    store: store,
                    onTap: () => _onPressedSelectRole(UserRole.Worker),
                  ),
                  // child: getCard(context, store, UserRole.Worker),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onPressedSelectRole(UserRole role) {
    context.read<ChooseRoleStore>().refreshToken();
    context.read<ChooseRoleStore>().setUserRole(role);
  }

  _onBackPressed() {
    store.deletePushToken();
    Navigator.pop(context);
  }
}

class _CardChooseRoleWidget extends StatelessWidget {
  final UserRole role;
  final ChooseRoleStore store;
  final Function()? onTap;
  final Color color;

  const _CardChooseRoleWidget({
    Key? key,
    required this.role,
    required this.store,
    required this.onTap,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Stack(
          children: [
            Image.asset("assets/${role.name.toLowerCase()}.jpg"),
            Container(
              margin: const EdgeInsets.only(left: 20, top: 20),
              width: 146,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "role.${role.name.toLowerCase()}".tr(),
                    style: TextStyle(
                      color: color,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "role.${role.name.toLowerCase()}Want".tr(),
                    style: TextStyle(color: color),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
