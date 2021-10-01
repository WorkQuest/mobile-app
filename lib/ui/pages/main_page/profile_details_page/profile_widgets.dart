import 'package:app/ui/pages/main_page/profile_details_page/pages/portfolio_page/portfolio_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

///Portfolio Widget
class PortfolioWidget extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int index;

  const PortfolioWidget({
    required this.title,
    required this.index,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          PortfolioDetails.routeName,
          arguments: index,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Stack(
          children: [
            Container(
              height: 230,
              width: double.maxFinite,
              foregroundDecoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(6.0),
                ),
                color: Colors.black38,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    imageUrl,
                  ),
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    6.0,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 15.0,
              left: 21.0,
              right: 55.0,
              child: Text(
                title,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///Reviews Widget
class ReviewsWidget extends StatelessWidget {
  final String name;
  final String userRole;
  final String questTitle;
  final String quest;

  const ReviewsWidget({
    required this.name,
    required this.userRole,
    required this.questTitle,
    required this.quest,
  });

  @override
  Widget build(BuildContext context) {
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
                userRole,
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
                        text: "Quest    ",
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
}

///AppBar Title
Widget appBarTitle(String name) {
  return Transform.translate(
    offset: Offset(25.0, 0.0),
    child: Stack(
      children: [
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
            "Performed",
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

///Quest Rating Widget
///

Widget rating({
  required String completedQuests,
  required String averageRating,
  required String reviews,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 20.0),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(16.0),
            height: 140,
            width: 161,
            decoration: BoxDecoration(
              color: Color(0xFFF7F8FA),
              borderRadius: BorderRadius.all(
                Radius.circular(6.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Completed quests',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  completedQuests,
                  style: TextStyle(
                    color: Color(0xFF00AA5B),
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  'Show all',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Color(0xFF00AA5B),
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(16.0),
            height: 140,
            width: 161,
            decoration: BoxDecoration(
              color: Color(0xFFF7F8FA),
              borderRadius: BorderRadius.all(
                Radius.circular(6.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Average rating',
                  style: TextStyle(fontSize: 16.0),
                ),
                Row(
                  children: [
                    Text(
                      averageRating,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 23.0,
                      ),
                    ),
                    Icon(
                      Icons.star,
                      color: Color(0xFFE8D20D),
                      size: 19.0,
                    ),
                  ],
                ),
                Text(
                  "From " + reviews + " reviews",
                  style: TextStyle(
                    color: Color(0xFFD8DFE3),
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

///SocialMedia Accounts Widget
///

Widget socialAccounts() {
  return Padding(
    padding: const EdgeInsets.only(
      top: 20.0,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          child: Container(
            height: 50.0,
            width: 74.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(6.0),
              ),
              color: Color(0xFFF7F8FA),
            ),
            child: IconButton(
              onPressed: null,
              icon: SvgPicture.asset(
                "assets/facebook_icon.svg",
              ),
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: 50.0,
            width: 74.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  6.0,
                ),
              ),
              color: Color(0xFFF7F8FA),
            ),
            child: IconButton(
              onPressed: null,
              icon: SvgPicture.asset(
                "assets/twitter_icon.svg",
              ),
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: 50.0,
            width: 74.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(6.0),
              ),
              color: Color(0xFFF7F8FA),
            ),
            child: IconButton(
              onPressed: null,
              icon: SvgPicture.asset(
                "assets/instagram.svg",
              ),
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: 50.0,
            width: 74.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(6.0),
              ),
              color: Color(0xFFF7F8FA),
            ),
            child: IconButton(
              onPressed: null,
              icon: SvgPicture.asset(
                "assets/linkedin_icon.svg",
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

///Contact Details Widget
///

Widget contactDetails({
  required String location,
  required String number,
  required String email,
  required String secondNumber,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Wrap(
          children: [
            Icon(
              Icons.location_pin,
              size: 20.0,
              color: const Color(0xFF7C838D),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                location,
                overflow: TextOverflow.fade,
                style: const TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF7C838D),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Icon(
              Icons.phone,
              size: 20.0,
              color: const Color(0xFF7C838D),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                number,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7C838D),
                ),
              ),
            ),
          ],
        ),
        if (secondNumber.isNotEmpty)
          Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Icon(
                    Icons.phone,
                    size: 20.0,
                    color: const Color(0xFF7C838D),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      secondNumber,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7C838D),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        const SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Icon(
              Icons.email,
              size: 20.0,
              color: Color(0xFF7C838D),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                email,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7C838D),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

///Skills widget

Widget skills({required List<String> skills}) {
  return Wrap(
    direction: Axis.horizontal,
    spacing: 9.0,
    runSpacing: 0.0,
    children: skills
        .map(
          (item) => new ActionChip(
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 10.0,
            ),
            onPressed: () => null,
            label: Text(
              item,
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF0083C7),
              ),
            ),
            backgroundColor: Color(0xFF0083C7).withOpacity(0.1),
          ),
        )
        .toList()
          ..add(
            ActionChip(
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 10.0,
              ),
              onPressed: () {},
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Add",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
              backgroundColor: Color(0xFF0083C7),
            ),
          ),
  );
}

Widget experience({
  String? place,
  String? from,
  String? to,
}) {
  return Wrap(
    children: [
      Text(place!),
      SizedBox(
        width: 10,
      ),
      Text(
        "${from!} - ${to!}",
        softWrap: true,
      ),
    ],
  );
}
