import 'package:flutter/material.dart';
import '../../../../enums.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileWidgets {

  ///AppBar Title
  Widget appBarTitle(String name) {
    return Transform.translate(
      offset: Offset(25.0, 0.0),
      child: Stack(
        children: [
          // Positioned(
          //   top: 0.0,
          //   left: 0.0,
          //   child: IconButton(
          //     onPressed: () => Navigator.pop(context),
          //     icon: Icon(
          //       Icons.arrow_back_ios,
          //     ),
          //   ),
          // ),
          Positioned(
            bottom: 18.0,
            left: 0.0,
            child: Text(
              name,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
          // Positioned(
          //   bottom: 42.0,
          //   left: 0.0,
          //   child: AnimatedOpacity(
          //     duration: Duration(seconds: 3),
          //     opacity: 0.5,
          //     child: Row(
          //       children: [
          //         Icon(
          //           Icons.star,
          //           color: Color(0xFFE8D20D),
          //           size: 15.0,
          //         ),
          //         Icon(
          //           Icons.star,
          //           color: Color(0xFFE8D20D),
          //           size: 15.0,
          //         ),
          //         Icon(
          //           Icons.star,
          //           color: Color(0xFFE8D20D),
          //           size: 15.0,
          //         ),
          //         Icon(
          //           Icons.star,
          //           color: Color(0xFFE8D20D),
          //           size: 15.0,
          //         ),
          //         Icon(
          //           Icons.star,
          //           color: Color(0xFFE9EDF2),
          //           size: 15.0,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 2.0,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFF6CF00),
                borderRadius: BorderRadius.all(
                  Radius.circular(3.0),
                ),
              ),
              child: Text(
                "HIGHER LEVEL",
                style: TextStyle(
                  fontSize: 8.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  ///Portfolio Widget
  Widget portfolio() {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 10.0,
        ),
        child: Stack(
          children: [
            Container(
              height: 230,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(6.0),
                ),
                image: DecorationImage(
                  image: AssetImage("assets/profile_avatar_test.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 15.0,
              left: 21.0,
              right: 55.0,
              child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing  elit ut aliquam ",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
                bottom: 15.0,
                right: 21.0,
                child: Icon(
                  Icons.arrow_right_sharp,
                  color: Colors.white,
                )),
          ],
        ),
      ),
    );
  }

  ///Reviews Widget
  Widget reviews(
      String name, UserRole userRole, String questTitle, String quest) {
    return Container(
      margin: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 10.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(6.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(
                  "assets/profile_avatar_test.jpg",
                ),
              ),
              title: Text(
                name,
                style: TextStyle(fontSize: 16.0),
              ),
              subtitle: Text(
                userRole.toString(),
                style: TextStyle(fontSize: 12.0, color: Color(0xFF00AA5B)),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 15.0,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Color(0xFFE8D20D),
                    size: 19.0,
                  ),
                  Icon(
                    Icons.star,
                    color: Color(0xFFE8D20D),
                    size: 19.0,
                  ),
                  Icon(
                    Icons.star,
                    color: Color(0xFFE8D20D),
                    size: 19.0,
                  ),
                  Icon(
                    Icons.star,
                    color: Color(0xFFE8D20D),
                    size: 19.0,
                  ),
                  Icon(
                    Icons.star,
                    color: Color(0xFFE9EDF2),
                    size: 19.0,
                  ),
                  SizedBox(
                    width: 13.0,
                  ),
                  Text('4.00')
                ],
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 15.0,
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "quests.quests".tr() + "    ",
                        style: TextStyle(
                          color: Colors.black,
                        )),
                    TextSpan(
                      text: questTitle,
                      style: TextStyle(
                        color: Color(0xFF7C838D),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 15.0,
              ),
              child: Text(quest),
            ),
          ),
        ],
      ),
    );
  }

  ///Quest Widget
  Widget quest(
      {required String title,
      required String description,
      required String price}) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(
        top: 10,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.maxFinite,
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Color(0xFF0083C7),
            ),
            child: Text(
              "quests.performed".tr(),
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color(0xFF1D2127),
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            description,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color(0xFF4C5767),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                Icons.star_border_outlined,
                color: Color(0xFFAAB0B9),
                size: 19.0,
              ),
              Icon(
                Icons.star_border_outlined,
                color: Color(0xFFAAB0B9),
                size: 19.0,
              ),
              Icon(
                Icons.star_border_outlined,
                color: Color(0xFFAAB0B9),
                size: 19.0,
              ),
              Icon(
                Icons.star_border_outlined,
                color: Color(0xFFAAB0B9),
                size: 19.0,
              ),
              Icon(
                Icons.star_border_outlined,
                color: Color(0xFFAAB0B9),
                size: 19.0,
              ),
              Expanded(
                child: Text(
                  "$price WUSD",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: Color(0xFFAAB0B9),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
