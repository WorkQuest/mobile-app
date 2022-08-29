import 'package:app/ui/widgets/default_textfield.dart';
import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final Function(String) onChanged;
  final String title;
  final String hint;

  const FormTextField({
    Key? key,
    required this.title,
    required this.hint,
    required this.validator,
    required this.onChanged,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(
          height: 5.0,
        ),
        DefaultTextField(
          controller: controller,
          onChanged: onChanged,
          isPassword: true,
          hint: hint,
          validator: validator,
          suffixIcon: null,
          inputFormatters: [],
        ),
      ],
    );
  }
}