import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final _spacer = const SizedBox(
  height: 10.0,
);

class AddPortfolioPage extends StatelessWidget {
  static const String routeName = "/addPortfolioPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: const Text(
          "Add Portfolio",
        ),
      ),
      body: SafeArea(
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
                  TextFormField(),
                  const SizedBox(
                    height: 16.0,
                  ),
                  const Text("Description"),
                  _spacer,
                  TextFormField(
                    // initialValue: store.description,
                    // onChanged: store.setAboutQuest,
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
    );
  }

}
