enum WQContractFunctions {
  acceptJob,
  acceptJobResult,
  arbiter,
  arbitration,
  arbitrationAcceptWork,
  arbitrationDecreaseCost,
  arbitrationRejectWork,
  arbitrationRework,
  assignJob,
  cancelJob,
  cost,
  deadline,
  declineJob,
  editJob,
  employer,
  fee,
  feeReceiver,
  forfeit,
  getInfo,
  jobHash,
  pensionFund,
  referal,
  status,
  timeDone,
  verificationJob,
  worker
}
enum WQFContractFunctions {
  ADMIN_ROLE,
  ARBITER_ROLE,
  DEFAULT_ADMIN_ROLE,
  UPGRADER_ROLE,
  feeEmployer,
  feeReceiver,
  feeWorker,
  getRoleAdmin,
  getWorkQuests,
  grantRole,
  hasRole,
  initialize,
  newWorkQuest,
  pensionFund,
  proxiableUUID,
  referral,
  renounceRole,
  revokeRole,
  setFeeEmployer,
  setFeeReceiver,
  setFeeWorker,
  setPensionFund,
  setRefferal,
  setWusd,
  supportsInterface,
  upgradeTo,
  upgradeToAndCall,
  workquestValid,
  workquests,
  wusd,
}

enum WQFContractEvents {
  AdminChanged,
  BeaconUpgraded,
  RoleAdminChanged,
  RoleGranted,
  RoleRevoked,
  Upgraded,
  WorkQuestCreated
}

enum WQPromotionFunctions {
  ADMIN_ROLE,
  DEFAULT_ADMIN_ROLE,
  UPGRADER_ROLE,
  factory,
  feeReceiver,
  getRoleAdmin,
  grantRole,
  hasRole,
  initialize,
  promoteQuest,
  promoteUser,
  proxiableUUID,
  questTariff,
  renounceRole,
  revokeRole,
  setFactory,
  setQuestTariff,
  setUserTariff,
  supportsInterface,
  upgradeTo,
  upgradeToAndCall,
  usersTariff,
  wusd,
}

enum WQBridgeTokenFunctions {
  ADMIN_ROLE,
  BURNER_ROLE,
  DEFAULT_ADMIN_ROLE,
  MINTER_ROLE,
  PAUSER_ROLE,
  addBlockList,
  allowance,
  approve,
  balanceOf,
  burn,
  decimals,
  decreaseAllowance,
  getOwner,
  getRoleAdmin,
  grantRole,
  hasRole,
  increaseAllowance,
  initialize,
  isBlockListed,
  mint,
  name,
  pause,
  paused,
  removeBlockList,
  renounceRole,
  revokeRole,
  supportsInterface,
  symbol,
  totalSupply,
  transfer,
  transferFrom,
  unpause,
}

enum TYPE_WALLET { Coinpaymebts }
