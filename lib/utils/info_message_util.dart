class InfoMessageUtil {
  static String groupChatCreate = 'GroupChatCreate';
  static String newMessage = 'NewMessage';
  static String messageReadByRecipient = 'MessageReadByRecipient';
  static String groupChatAddUser = 'GroupChatAddMember';
  static String groupChatLeaveUser = 'GroupChatLeaveMember';
  static String groupChatDeleteUser = 'GroupChatDeleteMember';
  static String groupChatRestoredUser = 'GroupChatMemberRestored';
  static String employerInviteOnQuest = 'EmployerInviteOnQuest';
  static String workerResponseOnQuest = 'WorkerResponseOnQuest';
  static String employerRejectResponseOnQuest = 'EmployerRejectResponseOnQuest';
  static String workerRejectInviteOnQuest = 'WorkerRejectInviteOnQuest';
  static String workerAcceptInviteOnQuest = 'WorkerAcceptInviteOnQuest';
  static String questChatAddDisputeAdmin = 'QuestChatAddDisputeAdmin';
  static String questChatLeaveDisputeAdmin = 'QuestChatLeaveDisputeAdmin';

  bool needNameStart(String action, bool itsMe) {
    if (action.contains(".employerInvitedWorkerToQuest") ||
        action.contains(".respondedToTheQuest") ||
        action.contains(".rejectedTheResponseToTheQuest") ||
        action.contains(".rejectedTheInviteToTheQuest") ||
        action.contains(".acceptedTheInviteToTheQuest") ||
        action.contains(".createdAGroupChat") ||
        action.contains(".removedFromChat") ||
        action.contains(".addedToChat") ||
        action.contains(".leftTheChat") ||
        action.contains(".restoredToChat") ||
        action.contains(".userRemovedFromChat")) return true;
    return false;
  }

  bool needNameFinish(String action) {
    if (action.contains(".youHaveRemovedFromChat") ||
        action.contains(".userAddedToChat") ||
        action.contains(".userRemovedFromChat")) return true;
    return false;
  }

  String getMessage(String action, bool itsMe) {
    String text = "chat.infoMessage.";
    switch (action) {
      case "EmployerInviteOnQuest":
        text += itsMe ? 'youInvitedToTheQuest' : 'employerInvitedWorkerToQuest';
        return text;
      case "WorkerResponseOnQuest":
        text += itsMe ? 'youHaveRespondedToTheQuest' : 'respondedToTheQuest';
        return text;
      case "EmployerRejectResponseOnQuest":
        text += itsMe
            ? 'youRejectTheResponseOnQuest'
            : 'rejectedTheResponseToTheQuest';
        return text;
      case 'WorkerRejectInviteOnQuest':
        text += itsMe
            ? 'youRejectedTheInviteToTheQuest'
            : 'rejectedTheInviteToTheQuest';
        return text;
      case 'WorkerAcceptInviteOnQuest':
        text += itsMe
            ? 'youAcceptedTheInviteToTheQuest'
            : 'acceptedTheInviteToTheQuest';
        return text;
      case 'GroupChatCreate':
        text += itsMe ? 'youCreatedAGroupChat' : 'createdAGroupChat';
        return text;
      case 'GroupChatDeleteMember':
        text += itsMe ? 'youHaveRemovedFromChat' : 'removedFromChat';
        return text;
      case 'GroupChatAddMember':
        text += itsMe ? 'youAddedToChat' : 'addedToChat';
        return text;
      case 'GroupChatLeaveMember':
        text += itsMe ? 'youLeftTheChat' : 'leftTheChat';
        return text;
      case 'QuestChatAddDisputeAdmin':
        text += 'adminAddedToChat';
        return text;
      case 'QuestChatLeaveDisputeAdmin':
        text += 'adminLeaveFromChat';
        return text;
      case 'GroupChatMemberRestored':
        text += 'restoredToChat';
        return text;
    }
    return text;
  }
}
