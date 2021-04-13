import 'package:app/app_localizations.dart';
import 'package:app/constants.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ImageHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 0.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: context.translate(LoginPageKeys.username),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: context.translate(LoginPageKeys.password),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageHeader extends StatelessWidget {
  const ImageHeader();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Color(0xFF103D7C),
              BlendMode.color,
            ),
            image: AssetImage(
              "assets/login_page_header.png",
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.translate(LoginPageKeys.welcomeTo),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  context.translate(LoginPageKeys.pleaseSignIn),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
