import 'package:app/ui/widgets/default_textfield.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const double _horizontalConstraints = 44.0;
const double _verticalConstraints = 24.0;

const _prefixConstraints = const BoxConstraints(
  maxHeight: _verticalConstraints,
  maxWidth: _horizontalConstraints,
  minHeight: _verticalConstraints,
  minWidth: _horizontalConstraints,
);

class AlertTotpWidget extends StatefulWidget {
  final Function(String)? onChanged;

  const AlertTotpWidget({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  _AlertTotpWidgetState createState() => _AlertTotpWidgetState();
}

class _AlertTotpWidgetState extends State<AlertTotpWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('securityCheck.confCode'.tr()),
          const SizedBox(
            height: 6,
          ),
          DefaultTextField(
            controller: _controller,
            onChanged: widget.onChanged,
            keyboardType: TextInputType.number,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            autofillHints: [AutofillHints.password],
            prefixIconConstraints: _prefixConstraints,
            hint: "123456",
            inputFormatters: [
              LengthLimitingTextInputFormatter(6),
            ],
            suffixIcon: null,
            validator: (_) {
              if (_controller.text.length < 6) {
                return 'errors.smallLength'.tr();
              }
              return null;
            },
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            'securityCheck.enterDiginCodeGoogle'.tr(),
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}