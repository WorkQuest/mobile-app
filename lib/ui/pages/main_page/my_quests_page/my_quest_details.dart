import 'package:app/ui/widgets/priority_view.dart';
import 'package:flutter/material.dart';

class MyQuestDetails extends StatefulWidget {
  static const String routeName = "/myQuestDetails";

  const MyQuestDetails();

  @override
  _MyQuestDetailsState createState() => _MyQuestDetailsState();
}

class _MyQuestDetailsState extends State<MyQuestDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_sharp,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(37),
                  child: Image.network(
                    "https://i.pinimg.com/736x/a9/3c/b4/a93cb4e0316ef9c4db83846550ff4deb.jpg",
                    width: 30,
                    height: 30,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Simon Berk",
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                PriorityView(1),
              ],
            ),
            SizedBox(
              height: 17,
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: Color(0xFF7C838D),
                ),
                SizedBox(
                  width: 9,
                ),
                Text(
                  "200 from you",
                  style: TextStyle(color: Color(0xFF7C838D)),
                ),
              ],
            ),
            SizedBox(
              height: 17,
            ),
            tagItem("Painting works"),
            SizedBox(
              height: 15,
            ),
            Text(
              "Paint the garage quicklyyy",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D2127),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit ut aliquam, purus sit amet luctus venenatis, lectus magna fringilla urna, porttitor rhoncus dolor purus non enim praesent elementum facilisis leo, vel fringilla est ullamcorper eget nulla facilisi etiam dignissim diam quis enim lobortis scelerisque fermentum dui faucibus in ornare quam viverra",
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Quest materials",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF1D2127),
                fontWeight: FontWeight.w500
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tagItem(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        color: Color(0xFF0083C7).withOpacity(0.1),
        borderRadius: BorderRadius.circular(44),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Color(0xFF0083C7),
          fontSize: 16,
        ),
      ),
    );
  }
}
