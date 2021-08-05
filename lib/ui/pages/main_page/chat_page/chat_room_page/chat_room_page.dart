import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatRoomPage extends StatefulWidget {
  static const String routeName = "/chatRoomPage";

  const ChatRoomPage();

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  ScrollController _scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );
  List<Message> listMessages = List.generate(
    20,
    (index) => Message(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit ut aliquam",
        index % 2 == 1),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Kriss Benwat",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://randomuser.me/api/portraits/men/6.jpg"),
                    maxRadius: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: CustomScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: listMessages.map((e) => _message(e)).toList(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            )
          ],
        ),
        bottomNavigationBar: _bottomTextFormFieldWithIcons());
  }

  Widget _message(Message e) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (!e.myMessage) Spacer(),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 16),
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: e.myMessage ? Color(0xFF0083C7) : Color(0xFFF7F8FA),
              // Color(0xFFF7F8FA)
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.text,
                  style: TextStyle(
                    color: e.myMessage ? Color(0xFFFFFFFF) : Color(0xFF1D2127),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "14:47",
                  style: TextStyle(
                    color: e.myMessage
                        ? Color(0xFFFFFFFF).withOpacity(0.4)
                        : Color(0xFF8D96A1).withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomTextFormFieldWithIcons() {
    return SafeArea(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 12),
            child: InkWell(
                onTap: () {},
                child: SvgPicture.asset("assets/attach_media_icon.svg")),
          ),
          Expanded(
            child: TextFormField(
              onChanged: (text) {
                print(text);
              },
              decoration: InputDecoration(
                hintText: 'Text',
              ),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 20),
            child: InkWell(
                onTap: () {},
                child: SvgPicture.asset("assets/send_message_icon.svg")),
          ),
        ],
      ),
    );
  }
}

class Message {
  String text;
  bool myMessage;

  Message(this.text, this.myMessage);
}
