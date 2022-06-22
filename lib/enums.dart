enum QuestItemPriorityType {
  Active,
  Invited,
  Requested,
  Performed,
  Starred,
}

enum UserRole {
  Worker,
  Employer,
  Admin,
}

enum QuestPriority {
  All,
  Low,
  Normal,
  Urgent,
}

enum AdType {
  Free,
  Paid,
}

enum ErrorCodes {
  /// Invalid payload errors (400)
  InvalidPayload,
  UnconfirmedUser,
  InvalidRole,
  InvalidStatus,
  AlreadyAnswer,
  KYCAlreadyVerified,
  KYCRequired,
  InvalidEmail,

  /// Authorization errors (401)
  TokenExpired,
  TokenInvalid,
  SessionNotFound,

  /// Forbidden (403)
  Forbidden,

  /// Not found (404)
  NotFound,

  /// Conflict (409)
  SumSubError,
}

enum TypeChat {
  active,
  privates,
  favourites,
  group,
  completed,
}
