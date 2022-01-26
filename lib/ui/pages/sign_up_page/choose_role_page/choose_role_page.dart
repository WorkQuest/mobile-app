import 'package:app/enums.dart';
import 'package:app/ui/pages/sign_up_page/choose_role_page/store/choose_role_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'approve_role_page.dart';

class ChooseRolePage extends StatelessWidget {
  const ChooseRolePage();

  static const String routeName = '/chooseRolePage';

  Widget build(BuildContext context) {
    final store = context.read<ChooseRoleStore>();

    return Scaffold(
      appBar: CupertinoNavigationBar(
        previousPageTitle: "  " + "meta.back".tr(),
        border: Border.fromBorderSide(BorderSide.none),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "role.choose".tr(),
                style: TextStyle(
                  color: Color(0xFF1D2127),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: getCard(context, store,UserRole.Employer),
              ),
              SizedBox(
                height: 0,
              ),
              Expanded(
                child: getCard(context, store,UserRole.Worker),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getCard(BuildContext ctx, var store,UserRole role) {
    return Observer(builder: (ctx) {
      return GestureDetector(
        onTap: () {
          try {
            ctx.read<ChooseRoleStore>().setUserRole(role);
          } catch (e, trace) {
            e.toString();
            trace.toString();
          }
          Navigator.pushNamed(ctx, ApproveRolePage.routeName, arguments: store);
        },
        child: Center(
          child: Stack(
            children: [
              Image.asset(
                "assets/${role.name.toLowerCase()}.jpg",
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, top: 20),
                width: 146,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "role.${role.name.toLowerCase()}".tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "role.${role.name.toLowerCase()}Want".tr(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
