import 'package:flutter/material.dart';

class ChooseRolePage extends StatelessWidget {
  const ChooseRolePage();

  static const String routeName = '/chooseRolePage';

  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  Widget getBody() {
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
            getEmployerCard(),
            SizedBox(
              height: 10,
            ),
            getWorkerCard(),
          ],
        ),
      ),
    );
  }

  Widget getWorkerCard() {
    return Stack(
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
    );
  }

  Widget getEmployerCard() {
    return Stack(
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
    );
  }
}
