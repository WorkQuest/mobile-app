import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/profile_details_page/portfolio_page/store/portfolio_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/media_upload_widget.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

final _spacer = const SizedBox(
  height: 10.0,
);

class CreatePortfolioPage extends StatelessWidget {
  final bool allowEdit;

  CreatePortfolioPage({
    required this.allowEdit,
  });

  static const String routeName = "/addPortfolioPage";

  @override
  Widget build(BuildContext context) {
    final store = context.read<PortfolioStore>();
    final userId = context.read<ProfileMeStore>().userData!.id;
    if (allowEdit) {
      store.title = store.portfolioList[store.portfolioIndex].title;
      store.description = store.portfolioList[store.portfolioIndex].description;
      store.mediaIds =
          ObservableList.of(store.portfolioList[store.portfolioIndex].medias);
    }
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text(
          allowEdit ? "Edit Portfolio" : "Add Portfolio",
        ),
      ),
      body: Observer(
        builder: (_) => SafeArea(
          child: CustomScrollView(
            cacheExtent: 1000,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.0,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      ///media view on edit portfolio
                      Text(
                        "modals.title".tr(),
                      ),
                      _spacer,
                      TextFormField(
                        initialValue: allowEdit
                            ? store.portfolioList[store.portfolioIndex].title
                            : "",
                        onChanged: store.setTitle,
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        "modals.description".tr(),
                      ),
                      _spacer,
                      TextFormField(
                        initialValue: allowEdit
                            ? store
                                .portfolioList[store.portfolioIndex].description
                            : "",
                        //initialValue: store.description,
                        onChanged: store.setDescription,
                        keyboardType: TextInputType.multiline,
                        maxLines: 12,
                        decoration: const InputDecoration(
                          hintText: 'Quest text',
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        "uploader.files".tr(),
                      ),
                      _spacer,
                      MediaUpload(allowEdit ? store.mediaIds : ObservableList(),
                        mediaFile: store.media,
                      )
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 20.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: ObserverListener<PortfolioStore>(
                          onSuccess: () {
                            Navigator.pop(context);
                            store.media.clear();
                          },
                          child: ElevatedButton(
                            onPressed: store.canSubmit
                                ? () async {
                                    allowEdit
                                        ? store.editPortfolio(
                                            userId: userId,
                                            portfolioId: store
                                                .portfolioList[
                                                    store.portfolioIndex]
                                                .id)
                                        : store.createPortfolio(
                                            userId: userId,
                                          );
                                    if (store.isSuccess) {
                                      Navigator.pop(context);
                                      await AlertDialogUtils.showSuccessDialog(context);
                                    }
                                  }
                                : null,
                            child: store.isLoading
                                ? CircularProgressIndicator.adaptive()
                                : Text(
                                    "meta.save".tr(),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
