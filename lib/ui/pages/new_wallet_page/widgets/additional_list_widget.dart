import 'package:app/ui/pages/new_wallet_page/model/additional_info_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AdditionalListWidget extends StatelessWidget {
  const AdditionalListWidget({Key? key, required this.item}) : super(key: key);
  final AdditionalInfoModel item;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.type),
                Text('Price: ${item.price}',style: TextStyle(fontSize: 14),),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Txn Hash',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  item.hash,
                  style: TextStyle(
                      color: Color.fromRGBO(0, 131, 199, 1), fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Generation time',style: TextStyle(fontSize: 14),),
                Text(
                  item.generationTime,
                  style: TextStyle(
                      color: Color.fromRGBO(170, 176, 185, 1), fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
