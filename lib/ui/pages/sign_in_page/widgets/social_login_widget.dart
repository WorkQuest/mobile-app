import 'package:app/ui/widgets/web_view_page/web_view_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialLoginWidget extends StatelessWidget {
  const SocialLoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        top: 20.0,
        right: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _iconButton(
            "assets/google_icon.svg",
            "google",
            context,
          ),
          _iconButton(
            "assets/twitter_icon.svg",
            "twitter",
            context,
          ),
          _iconButton(
            "assets/facebook_icon.svg",
            "facebook",
            context,
          ),
          _iconButton(
            "assets/linkedin_icon.svg",
            "linkedin",
            context,
          ),
        ],
      ),
    );
  }

  Widget _iconButton(
    String iconPath,
    String link,
    BuildContext context, [
    Color? color,
  ]) {
    return CupertinoButton(
      color: Color(0xFFF7F8FA),
      padding: EdgeInsets.zero,
      child: SvgPicture.asset(
        iconPath,
        color: color,
      ),
      onPressed: () async {
        // signInStore.loginSocialMedia(link);
        Navigator.of(context, rootNavigator: true).pushNamed(
          WebViewPage.routeName,
          arguments: "api/v1/auth/login/main/$link/token",
        );
      },
    );
  }
}
