import 'dart:math';

import 'package:app/constants.dart';
import 'package:app/enums.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/chat_model/member.dart';
import 'package:app/ui/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ChatCell extends StatelessWidget {
  final Function()? onLongPress;
  final Function()? onTap;
  final ChatModel chat;
  final String userId;
  final String infoActionMessage;
  final bool chatStarred;

  const ChatCell({
    Key? key,
    required this.onLongPress,
    required this.onTap,
    required this.chat,
    required this.userId,
    required this.infoActionMessage,
    required this.chatStarred,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final differenceTime = DateTime.now()
        .difference(chat.chatData.lastMessage?.createdAt ?? DateTime.now())
        .inDays;

    Member? member;
    chat.members?.forEach((element) {
      if (element.type != "Admin" || chat.type != TypeChat.active)
        member = element;
    });

    final text = chat.chatData.lastMessage?.sender?.userId == userId
        ? "chat.you".tr() +
            " ${chat.chatData.lastMessage?.text ?? infoActionMessage} "
        : "${chat.chatData.lastMessage?.sender!.user?.firstName ?? chat.meMember?.deletionData?.message.sender?.user?.firstName ?? member!.user?.firstName ?? member!.admin?.firstName ?? ""}:" +
            " ${chat.chatData.lastMessage?.text ?? infoActionMessage} ";
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        color: chatStarred ? Color(0xFFE9EDF2) : Color(0xFFFFFFFF),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.5,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: chat.type != TypeChat.group
                          ? UserAvatar(
                              width: 56,
                              height: 56,
                              url: member!.user?.avatar?.url ??
                                  Constants.defaultImageNetwork,
                            )
                          : Stack(
                              children: [
                                Container(
                                  color: _getRandomColor(chat.id),
                                  height: 56,
                                  width: 56,
                                ),
                                Positioned.fill(
                                  child: Center(
                                    child: Text(
                                      chat.groupChat!.name.length == 1
                                          ? "${chat.groupChat!.name[0].toUpperCase()}"
                                          : "${chat.groupChat!.name[0].toUpperCase()}" +
                                              "${chat.groupChat!.name[1]}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                chat.type == TypeChat.group
                                    ? "${chat.groupChat!.name}"
                                    : "${member!.user?.firstName ?? member!.admin?.firstName ?? "--"} "
                                        "${member!.user?.lastName ?? member!.admin?.lastName ?? "--"}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (chat.type == TypeChat.active ||
                                chat.type == TypeChat.completed)
                              Expanded(
                                child: Text(
                                  "Quest: ${chat.questChat?.quest?.title}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColor.enabledButton,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          text,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF7C838D),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          differenceTime == 0
                              ? "chat.today".tr()
                              : differenceTime == 1
                                  ? "$differenceTime " + "chat.day".tr()
                                  : "$differenceTime " + "chat.days".tr(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFD8DFE3),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 50),
                  Column(
                    children: [
                      if (chat.chatData.lastMessage?.senderStatus == "Unread")
                        Container(
                          width: 11,
                          height: 11,
                          margin: chat.star == null
                              ? const EdgeInsets.only(top: 25, right: 16)
                              : const EdgeInsets.only(top: 20, right: 16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF0083C7),
                          ),
                        ),
                      if (chat.star != null)
                        Container(
                          margin: chat.chatData.lastMessage?.senderStatus ==
                                  "Unread"
                              ? const EdgeInsets.only(top: 3, right: 16)
                              : const EdgeInsets.only(top: 23, right: 16),
                          child: Icon(
                            Icons.star,
                            color: Color(0xFFE8D20D),
                            size: 20.0,
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
            Divider(
              height: 1,
              color: Color(0xFFF7F8FA),
            )
          ],
        ),
      ),
    );
  }

  Color _getRandomColor(String id) {
    Random random = Random(id.hashCode.toInt());

    List<Color> colors = [
      Color(0xFF00ABEA),
      Color(0xFF3C6AD7),
      Color(0xFF582BD3),
      Color(0xFF812ED3),
      Color(0xFFAE29C9),
      Color(0xFFD4344F),
      Color(0xFFE05300),
      Color(0xFF29C6B7),
      Color(0xFFEEAD00),
    ];

    return colors[random.nextInt(colors.length)];
  }
}
