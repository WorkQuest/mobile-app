import 'package:app/constants.dart';
import 'package:app/enums.dart';
import 'package:app/model/respond_model.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/profile_details/pages/user_profile_page/user_profile_page.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/quest_details/pages/employer/quest_employer_page/store/employer_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/user_rating.dart';
import 'package:app/utils/quest_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class RespondedList extends StatefulWidget {
  final EmployerStore store;
  final ProfileMeStore? profileStore;
  final Function()? answerOnQuestPressed;
  final Function()? chooseWorkerPressed;

  const RespondedList({
    Key? key,
    required this.store,
    required this.profileStore,
    required this.answerOnQuestPressed,
    required this.chooseWorkerPressed,
  }) : super(key: key);

  @override
  State<RespondedList> createState() => _RespondedListState();
}

class _RespondedListState extends State<RespondedList> {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      if (widget.store.respondedList.isEmpty && widget.store.isLoading) {
        return Center(
          child: CircularProgressIndicator.adaptive(),
        );
      }
      if (widget.store.quest.value!.status == QuestConstants.questWaitEmployerConfirm) {
        return TextButton(
          onPressed: widget.answerOnQuestPressed,
          child: Text(
            "quests.answerOnQuest.title".tr(),
            style: TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(
              Size(double.maxFinite, 43),
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed))
                  return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                return const Color(0xFF0083C7);
              },
            ),
          ),
        );
      } else if (widget.store.respondedList.isNotEmpty &&
          (widget.store.quest.value!.status == QuestConstants.questCreated)) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "btn.responded".tr(),
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF1D2127),
                fontWeight: FontWeight.w500,
              ),
            ),
            if (widget.store.respondedList.isNotEmpty)
              for (final respond in widget.store.respondedList) selectableMember(respond),
            const SizedBox(height: 15),
            Observer(
              builder: (_) => TextButton(
                onPressed: widget.store.selectedResponders == null || widget.store.isLoading
                    ? null
                    : widget.chooseWorkerPressed,
                child: Text(
                  "quests.chooseWorker".tr(),
                  style: TextStyle(
                    color: widget.store.selectedResponders == null ? Colors.grey : Colors.white,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) return const Color(0xFFF7F8FA);
                      if (states.contains(MaterialState.pressed))
                        return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                      return const Color(0xFF0083C7);
                    },
                  ),
                  fixedSize: MaterialStateProperty.all(
                    Size(double.maxFinite, 43),
                  ),
                ),
              ),
            )
          ],
        );
      }
      return const SizedBox();
    });
  }

  Widget selectableMember(RespondModel respond) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: respondedUser(respond),
              ),
              // Spacer(),
              Transform.scale(
                scale: 1.5,
                child: Radio(
                  toggleable: true,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: respond,
                  groupValue: widget.store.selectedResponders,
                  onChanged: (RespondModel? user) => widget.store.selectedResponders = user,
                ),
              ),
            ],
          ),
          if (respond.message.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              respond.message,
              textAlign: TextAlign.start,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            GestureDetector(
              child: Text(
                "Show more",
                style: TextStyle(
                  color: Color(0xFF0083C7),
                ),
              ),
              onTap: () => showMore(respond),
            )
          ]
        ],
      ),
    );
  }

  showMore(RespondModel respond) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6.0),
          topRight: Radius.circular(6.0),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(
            top: 20,
            left: 16,
            right: 16,
          ),
          child: Column(
            children: <Widget>[
              respondedUser(respond),
              const SizedBox(height: 15),
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      respond.message,
                      softWrap: true,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget respondedUser(RespondModel respond) {
    return GestureDetector(
      onTap: () => _onPressedPushProfile(respond.workerId),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
            child: Image.network(
              respond.worker.avatar?.url ?? Constants.defaultImageNetwork,
              fit: BoxFit.cover,
              height: 50,
              width: 50,
            ),
          ),
          const SizedBox(width: 15),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${respond.worker.firstName} ${respond.worker.lastName}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (respond.worker.ratingStatistic?.status != null)
                  UserRating(respond.worker.ratingStatistic!.status!, isWorker: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _onPressedPushProfile(String workerId) {
    Navigator.of(context, rootNavigator: true).pushNamed(
      UserProfile.routeName,
      arguments: ProfileArguments(
        role: UserRole.Worker,
        userId: workerId,
      ),
    );
  }
}
