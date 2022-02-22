import 'package:app/ui/pages/main_page/settings_page/pages/2FA_page/2FA_page.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/SMS_verification_page/sms_verification_page.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/change_language_page.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/change_password_page.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/my_disputes/my_disputes_page.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/profile_settings_page.dart';
import 'package:app/ui/pages/main_page/settings_page/settings_page_widgets.dart';
import 'package:app/ui/pages/main_page/settings_page/store/settings_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/pages/sign_up_page/choose_role_page/approve_role_page.dart';
import 'package:app/ui/pages/sign_up_page/choose_role_page/store/choose_role_store.dart';
import 'package:app/ui/widgets/gradient_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

import '../../../../constants.dart';

class SettingsPage extends StatelessWidget {
  static const String routeName = "/settingsPageEmployer";

  final _spacer = SizedBox(width: 10.0);

  @override
  Widget build(context) {
    final settingStore = context.read<SettingsPageStore>();
    final userStore = context.read<ProfileMeStore>();
    final chooseRoleStore = context.read<ChooseRoleStore>();

    return Scaffold(
      body: Observer(
        builder: (_) => CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: Row(
                children: [
                  Expanded(
                    child: Text("ui.profile.myProfile".tr()),
                  ),
                  InkWell(
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileSettings(settingStore),
                      ),
                    ),
                    child: const Icon(
                      Icons.settings_outlined,
                    ),
                  ),
                  const SizedBox(width: 20.0)
                ],
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    MyProfileImage(userStore),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ///Change Password
                              SettingsCard(
                                icon: GradientIcon(
                                  SvgPicture.asset(
                                    "assets/settings_password_icon.svg",
                                  ),
                                  20.0,
                                ),
                                title: "settings.changePass".tr(),
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pushNamed(
                                    ChangePasswordPage.routeName,
                                  );
                                },
                              ),
                              _spacer,

                              ///2FA
                              SettingsCard(
                                icon: CupertinoSwitch(
                                  activeColor: const Color(0xFF0083C7),
                                  onChanged: (_) {},
                                  value:
                                      userStore.userData?.isTotpActive ?? false,
                                ),
                                title: "settings.2FA".tr(),
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pushNamed(TwoFAPage.routeName);
                                },
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ///SMS Verification
                                SettingsCard(
                                  icon: GradientIcon(
                                    SvgPicture.asset(
                                      "assets/settings_message_icon.svg",
                                    ),
                                    20.0,
                                  ),
                                  title: "settings.smsVerification2".tr(),
                                  onTap: () =>
                                      Navigator.of(context, rootNavigator: true)
                                          .pushNamed(
                                    SMSVerificationPage.routeName,
                                  ),
                                ),
                                _spacer,

                                ///Change Role
                                SettingsCard(
                                  icon: GradientIcon(
                                    SvgPicture.asset(
                                      "assets/settings_role_icon.svg",
                                    ),
                                    20.0,
                                  ),
                                  title: "settings.changeRole".tr(),
                                  onTap:
                                      userStore.userData?.isTotpActive == true
                                          ? () {
                                              chooseRoleStore.isChange = true;
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pushNamed(
                                                ApproveRolePage.routeName,
                                                arguments: chooseRoleStore,
                                              );
                                            }
                                          : () {},
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ///My Disputes
                                SettingsCard(
                                  icon: GradientIcon(
                                    SvgPicture.asset(
                                      "assets/unread_chat.svg",
                                    ),
                                    20.0,
                                  ),
                                  title: "btn.myDisputes".tr(),
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pushNamed(MyDisputesPage.routeName);
                                  },
                                ),
                                _spacer,

                                ///Change Language
                                SettingsCard(
                                  icon: GradientIcon(
                                    SvgPicture.asset(
                                      "assets/settings_language_icon.svg",
                                    ),
                                    20.0,
                                  ),
                                  title:
                                      "Language \n${Constants.languageList.keys.firstWhere(
                                    (k) =>
                                        Constants.languageList[k] ==
                                        context.locale,
                                  )}",
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pushNamed(
                                            ChangeLanguagePage.routeName);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    ///Logout button
                    const SizedBox(
                      height: 10.0,
                    ),
                    logOutButton(context),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 10.0,
                width: double.infinity,
                color: Color(0xFFF7F8FA),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Text(
                      "settings.instruments".tr(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    InstrumentCard(
                      urlArgument: "pension",
                      iconPath: "assets/settings_pension_icon.svg",
                      title: "ui.menu.pension.title".tr(),
                    ),
                    InstrumentCard(
                      urlArgument: "referral",
                      iconPath: "assets/settings_referral_icon.svg",
                      title: "ui.menu.referral.title".tr(),
                    ),
                    InstrumentCard(
                      urlArgument: "insuring",
                      iconPath: "assets/settings_p2p_icon.svg",
                      title: "ui.menu.p2p.title".tr(),
                    ),
                    InstrumentCard(
                      urlArgument: "savings",
                      iconPath: "assets/setting_saving_product_icon.svg",
                      title: "ui.menu.savings.title".tr(),
                    ),
                    InstrumentCard(
                      urlArgument: "crediting",
                      iconPath: "assets/settings_wallet.svg",
                      title: "crediting.lending".tr(),
                    ),
                    InstrumentCard(
                      urlArgument: "mining",
                      iconPath: "assets/setting_chart.svg",
                      title: "settings.liquidityMining".tr(),
                    ),
                    InstrumentCard(
                      urlArgument: "crosschain",
                      iconPath: "assets/work_quest_icon.svg",
                      title: "WorkQuest Bridge",
                    ),
                    InstrumentCard(
                      urlArgument: "staking",
                      iconPath: "assets/work_quest_icon.svg",
                      title: "WorkQuest Staking",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
