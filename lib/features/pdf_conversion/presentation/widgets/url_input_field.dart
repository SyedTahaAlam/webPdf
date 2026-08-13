// lib/features/pdf_conversion/presentation/widgets/url_input_field.dart

import 'package:flutter/material.dart';
import 'package:webpdf/core/widgets/app_text_field.dart';

/// Styled URL input field with browser-style prefix icon.
class UrlInputField extends StatelessWidget {
  const UrlInputField({
    required this.controller,
    super.key,
    this.errorText,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String? errorText;
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: 'Website URL',
      hint: 'https://example.com',
      errorText: errorText,
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.go,
      onSubmitted: onSubmitted,
      prefixIcon: const Icon(Icons.link),
      suffixIcon: controller.text.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: controller.clear,
            )
          : null,
    );
  }
}
