import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/profile_details_page/portfolio_page/store/portfolio_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/media_upload_widget.dart';
import 'package:app/ui/widgets/platform_activity_indicator.dart';
import 'package:app/ui/widgets/success_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      store.mediaIds = ObservableList.of(store.portfolioList[store.portfolioIndex].medias);
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
                      if (allowEdit)
                        SizedBox(
                          height: 150.0,
                          child: ListView.separated(
                            separatorBuilder: (_, index) => SizedBox(
                              width: 10.0,
                            ),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: store.portfolioList[store.portfolioIndex]
                                .medias.length,
                            itemBuilder: (_, index) => SizedBox(
                              width: 120.0,
                              child: Stack(
                                clipBehavior: Clip.none,
                                fit: StackFit.expand,
                                children: [
                                  // Media
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      store.portfolioList[store.portfolioIndex]
                                          .medias[index].url,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: -15.0,
                                    right: -15.0,
                                    child: IconButton(
                                      onPressed: () => store
                                          .portfolioList[store.portfolioIndex]
                                          .medias
                                          .removeAt(index),
                                      //widget.media.removeAt(index),
                                      icon: Icon(Icons.cancel),
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  // For video duration
                                  // if (widget.media[index].entity.type == AssetType.video)
                                  //   Positioned(
                                  //     right: 4.0,
                                  //     bottom: 4.0,
                                  //     child: ClipRRect(
                                  //       borderRadius: BorderRadius.circular(20.0),
                                  //       child: Container(
                                  //         color: Colors.black.withOpacity(0.7),
                                  //         padding: const EdgeInsets.symmetric(
                                  //             horizontal: 6.0, vertical: 2.0),
                                  //         child: Text(
                                  //           widget.media[index].entity.duration.formattedDuration,
                                  //           textAlign: TextAlign.center,
                                  //           style: const TextStyle(
                                  //             fontSize: 13.0,
                                  //             color: Colors.white,
                                  //             fontWeight: FontWeight.w700,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      _spacer,
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
                      MediaUpload(
                        mediaDrishya: store.media,
                        mediaURL: allowEdit
                            ?  store.mediaIds
                            : ObservableList(),
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
                                            portfolioId: store
                                                .portfolioList[
                                                    store.portfolioIndex]
                                                .id)
                                        : store.createPortfolio();
                                    store.getPortfolio(userId: userId);
                                    if (store.isSuccess) {
                                      await successAlert(
                                        context,
                                        "Portfolio created".tr(),
                                      );
                                      Navigator.pop(context);
                                    }
                                  }
                                : null,
                            child: store.isLoading
                                ? PlatformActivityIndicator()
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
