import 'package:app/ui/pages/new_wallet_page/model/colletaral_model.dart';
import 'package:app/ui/pages/new_wallet_page/widgets/additional_info_colleteral.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CollateralTransaction extends StatefulWidget {
  const CollateralTransaction({Key? key, required this.item}) : super(key: key);
  final CollateralTransactionModel item;

  @override
  State<CollateralTransaction> createState() => _CollateralTransactionState();
}

class _CollateralTransactionState extends State<CollateralTransaction> {
  
  bool _isLarge = false;
  void _updatedSize() {
    setState(() {
      _isLarge ? _isLarge = false : _isLarge = true;
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _updatedSize(),
      child: Padding(
        padding: const EdgeInsets.only(left: 17.0),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 17.0),
                  child: Container(
                    width: 32,
                    height: 32,
                    child: Image.asset(widget.item.icon),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            widget.item.token,
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Locked: ${widget.item.locked}',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '${widget.item.amount} WUSD',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(0, 170, 91, 1),
                            ),
                          ),
                          Text(
                            'Ratio: ${widget.item.ratio} (%)',
                            style: TextStyle(
                                color: Color.fromRGBO(170, 175, 185, 1)),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            _isLarge ? AdditionalInfoColleteral() : SizedBox(),
          ],
        ),
      ),
    );
  }
}
