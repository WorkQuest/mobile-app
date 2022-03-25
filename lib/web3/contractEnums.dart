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
  DEFAULT_ADMIN_ROLE,
  UPGRADER_ROLE,
  allArbiters,
  arbiterList,
  arbiters,
  fee,
  feeReceiver,
  getRoleAdmin,
  getWorkQuests,
  grantRole,
  hasRole,
  initialize,
  newWorkQuest,
  pensionFund,
  referral,
  renounceRole,
  revokeRole,
  supportsInterface,
  updateArbiter,
  updateFeeReceiver,
  updatePensionFund,
  updateRefferal,
  upgradeTo,
  upgradeToAndCall,
  workquestValid,
  workquests
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
enum TYPE_COINS {
  WUSD, WQT, wBNB, wETH
}

enum TYPE_WALLET {
  Coinpaymebts
}
