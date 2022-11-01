import 'package:app/ui/pages/new_wallet_page/model/additional_info_model.dart';
import 'package:app/ui/pages/new_wallet_page/widgets/additional_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AdditionalInfoColleteral extends StatelessWidget {
  AdditionalInfoColleteral({Key? key}) : super(key: key);
  final List<AdditionalInfoModel> additionalInfoList = [
    AdditionalInfoModel(
        type: 'Produced',
        price: '1',
        hash: '0x26a5ded4...a6bb86649d',
        generationTime: 'Aug 24 2022, 05:49 am'),
    AdditionalInfoModel(
        type: 'Generated',
        price: '1',
        hash: '0x26a5ded4...a6bb86649d',
        generationTime: 'Aug 24 2022, 05:49 am'),
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 19.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 46,
                width: 104,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Generate'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Container(
                  height: 46,
                  width: 104,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Deposit'),
                  ),
                ),
              ),
              Container(
                height: 46,
                width: 104,
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text('Remove'),
                ),
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: additionalInfoList.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return AdditionalListWidget(item: additionalInfoList[index]);
            },
          ),
        ],
      ),
    );
  }
}
