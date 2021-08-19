import 'package:app/ui/pages/main_page/profile_reviews_page/profileMe_reviews_page.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/pages/sign_in_page/sign_in_page.dart';
import 'package:app/ui/widgets/gradient_icon.dart';
import 'package:app/ui/widgets/web_view_page/web_view_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app/utils/storage.dart';

///Instrument Card
Widget instrumentsCard(
  context, {
  required String urlArgument,
  required String iconPath,
  required String title,
}) =>
    GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pushNamed(
          WebViewPage.routeName,
          arguments: urlArgument,
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        height: 54.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            6.0,
          ),
        ),
        child: Material(
          color: Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(
            6.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 14.0,
                  left: 17.0,
                ),
                child: GradientIcon(
                  SvgPicture.asset(
                    iconPath,
                  ),
                  16.0,
                ),
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 19.0,
                ),
                child: Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Color(0xFFD8DFE3),
                ),
              ),
            ],
          ),
        ),
      ),
    );

///Settings Card
Widget settingsCard({
  required Widget icon,
  required String title,
  required void Function() onTap,
}) =>
    Expanded(
      child: SizedBox(
        height: 130.0,
        child: Material(
          color: Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(
            6.0,
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  icon,
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_right_sharp,
                        color: Color(0xFFD8DFE3),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

///Logout button
Widget logOutButton(context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: OutlinedButton(
      onPressed: () {
        Navigator.of(context, rootNavigator: true)
            .pushNamedAndRemoveUntil(SignInPage.routeName, (route) => false);
        Storage.deleteAllFromSecureStorage();
      },
      child: Text(
        "Logout",
        style: TextStyle(
          color: Color(0xFFDF3333),
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          width: 1.0,
          color: Color.fromRGBO(223, 51, 51, 0.1),
        ),
      ),
    ),
  );
}

///Image widget
Widget myProfileImage(context, ProfileMeStore userStore) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context, rootNavigator: true)
          .pushNamed(ProfileReviews.routeName);
    },
    child: Container(
      height: 150.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            userStore.userData!.avatar!.url,
          ),
          fit: BoxFit.cover,
        ),
        color: Colors.blue,
        borderRadius: BorderRadius.circular(
          6.0,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: Text(
              " ${userStore.userData?.firstName ?? " "}  ${userStore.userData?.lastName ?? " "} ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
          Positioned(
            bottom: 16.0,
            right: 23.0,
            child: Icon(
              Icons.arrow_right_sharp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}
