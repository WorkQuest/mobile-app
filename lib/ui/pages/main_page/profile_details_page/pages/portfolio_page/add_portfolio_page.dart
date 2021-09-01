import 'package:app/ui/pages/main_page/profile_details_page/pages/portfolio_page/store/portfolio_store.dart';
import 'package:app/ui/widgets/media_upload_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";

final _spacer = const SizedBox(
  height: 10.0,
);

class AddPortfolioPage extends StatelessWidget {
  static const String routeName = "/addPortfolioPage";

  @override
  Widget build(BuildContext context) {
    final store = context.read<PortfolioStore>();
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: const Text(
          "Add Portfolio",
        ),
      ),
      body: Observer(
        builder: (_) => SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.0,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const Text("Title"),
                    _spacer,
                    TextFormField(
                      onChanged: store.setTitle,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    const Text("Description"),
                    _spacer,
                    TextFormField(
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
                    const Text("Files"),
                    _spacer,
                    MediaUpload(media: store.media)
                  ]),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text("Save"),
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
