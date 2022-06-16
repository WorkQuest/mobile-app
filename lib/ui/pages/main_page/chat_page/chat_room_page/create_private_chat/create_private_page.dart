import 'package:app/ui/pages/main_page/chat_page/chat_room_page/chat_room_page.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/create_private_chat/store/create_private_store.dart';
import 'package:app/ui/widgets/dismiss_keyboard.dart';
import 'package:app/ui/widgets/media_upload/media_upload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class CreatePrivatePage extends StatefulWidget {
  static const String routeName = "/createPrivatePage";

  const CreatePrivatePage(this.userId);

  final String userId;

  @override
  State<CreatePrivatePage> createState() => _CreatePrivatePageState();
}

class _CreatePrivatePageState extends State<CreatePrivatePage> {
  late CreatePrivateStore store;

  @override
  void initState() {
    store = context.read<CreatePrivateStore>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_sharp,
            ),
          ),
          centerTitle: true,
          title: Text(
            "Send a private message",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const SizedBox(height: 23),
              Text("Message"),
              const SizedBox(height: 10),
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 300.0),
                  child: TextField(
                    onChanged: store.setMessage,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(hintText: "Type your message"),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: MediaUploadWithProgress(
                  store: store,
                  type: MediaType.images,
                ),
              ),
              const SizedBox(height: 21),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 45.0,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            width: 1.0,
                            color: Color(0xFF0083C7).withOpacity(0.1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: Observer(
                      builder: (_) => ElevatedButton(
                        onPressed: () async {
                          await store.sendMessage(widget.userId);
                          if (store.isSuccess) {
                            Navigator.of(context, rootNavigator: true)
                                .pushReplacementNamed(
                              ChatRoomPage.routeName,
                              arguments: store.chatId,
                            );
                          }
                        },
                        child: store.isLoading
                            ? Center(
                                child: CircularProgressIndicator.adaptive(),
                              )
                            : Text("Send"),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
