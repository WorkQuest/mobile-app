import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:easy_localization/easy_localization.dart';

class PhoneNumberWidget extends StatefulWidget {
  final String title;
  final PhoneNumber? initialValue;
  final bool needValidator;
  final void Function(PhoneNumber)? onChanged;

  const PhoneNumberWidget({
    Key? key,
    required this.title,
    required this.initialValue,
    required this.onChanged,
    this.needValidator = false,
  }) : super(key: key);

  @override
  State<PhoneNumberWidget> createState() => _PhoneNumberWidgetState();
}

class _PhoneNumberWidgetState extends State<PhoneNumberWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title.tr()),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFF7F8FA)),
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: InternationalPhoneNumberInput(
            initialValue: widget.initialValue,
            validator: widget.needValidator ? null : (value) => null,
            errorMessage: "modals.invalidPhone".tr(),
            autoValidateMode: AutovalidateMode.onUserInteraction,
            onInputChanged: widget.onChanged,
            selectorConfig: SelectorConfig(
              leadingPadding: 16,
              setSelectorButtonAsPrefixIcon: true,
              selectorType: PhoneInputSelectorType.DIALOG,
            ),
            hintText: "modals.phoneNumber".tr(),
            keyboardType: TextInputType.number,
            inputBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
            inputDecoration: InputDecoration(
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(
                  color: Colors.green,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(
                  color: Color(0xFFf7f8fa),
                  width: 2.0,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(
                  width: 1.0,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
