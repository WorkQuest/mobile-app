import 'package:app/enums.dart';
import 'package:app/ui/pages/sign_up_page/choose_role_page/store/choose_role_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'approve_role_page.dart';

class ChooseRolePage extends StatelessWidget {
  const ChooseRolePage();

  static const String routeName = '/chooseRolePage';

  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext buildContext) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Choose your role",
              style: TextStyle(
                color: Color(0xFF1D2127),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            getEmployerCard(buildContext),
            SizedBox(
              height: 10,
            ),
            getWorkerCard(buildContext),
          ],
        ),
      ),
    );
  }

  Widget getWorkerCard(BuildContext ctx) {
    return GestureDetector(
      onTap: (){
        ctx.read<ChooseRoleStore>().setUserRole(UserRole.Worker);
        Navigator.pushNamed(ctx, ApproveRolePage.routeName);
      },
      child: Stack(
        children: [
          Image.asset(
            "assets/worker.jpg",
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, top: 20),
            width: 146,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Worker",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "I want to search a tasks and working on freelance",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getEmployerCard(BuildContext ctx) {
    return GestureDetector(
      onTap: (){
        ctx.read<ChooseRoleStore>().setUserRole(UserRole.Employer);
        Navigator.pushNamed(ctx, ApproveRolePage.routeName);
      },
      child: Stack(
        children: [
          Image.asset(
            "assets/employer.jpg",
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, top: 20),
            width: 146,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Employer",
                  style: TextStyle(
                      color: Color(0xFF1D2127),
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "I want to make a tasks and looking for a workers",
                  style: TextStyle(color: Color(0xFF1D2127)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
