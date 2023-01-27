import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final String title;
  final String initialValue;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType inputType;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;

  const InputWidget({
    Key? key,
    required this.title,
    required this.initialValue,
    required this.onChanged,
    required this.maxLength,
    this.validator,
    this.inputType = TextInputType.text,
    this.readOnly = false,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 5),
        TextFormField(
          maxLength: maxLength,
          initialValue: initialValue,
          maxLines: maxLines,
          readOnly: readOnly,
          onChanged: onChanged,
          validator: validator,
          keyboardType: inputType,
          decoration: InputDecoration(
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(
                color: Colors.blue,
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
        const SizedBox(height: 20),
      ],
    );
  }
}