// lib/core/widgets/app_text_field.dart

import 'package:flutter/material.dart';

/// Design-system text input with inline error display.
class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.controller,
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.onSubmitted,
    this.onChanged,
    this.autofocus = false,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final bool autofocus;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofocus: autofocus,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
