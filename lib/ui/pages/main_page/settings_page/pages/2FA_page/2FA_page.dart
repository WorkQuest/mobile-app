import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/2FA_page/2FA_store.dart';
import 'package:app/ui/widgets/platform_activity_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";

class TwoFAPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = context.read<TwoFAStore>();
    return ObserverListener<TwoFAStore>(
      onSuccess: () {},
      child: Observer(
        builder: (_) => Scaffold(
          appBar: CupertinoNavigationBar(
            automaticallyImplyLeading: true,
            middle: Text("2FA"),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20.0,
                    alignment: AlignmentDirectional.centerStart,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFF7F8FA),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) => Observer(
                        builder: (_) => AnimatedContainer(
                          width: constraints.maxWidth * store.index / 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue,
                          ),
                          duration: const Duration(
                            milliseconds: 150,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text("Step 1"),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            if (store.index > 1) store.index--;
                            print("${store.index}");
                          },
                          child: Text("Back"),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              width: 1.0,
                              color: Color(0xFF0083C7).withOpacity(0.1),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (store.index < 4) store.index++;
                            print("${store.index}");
                          },
                          child: store.isLoading
                              ? Center(
                                  child: PlatformActivityIndicator(),
                                )
                              : Text("Submit"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
