// lib/features/pdf_conversion/presentation/widgets/url_input_field.dart

import 'package:flutter/material.dart';
import 'package:webpdf/core/widgets/app_text_field.dart';

/// Styled URL input field with browser-style prefix icon.
class UrlInputField extends StatefulWidget {
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
  State<UrlInputField> createState() => _UrlInputFieldState();
}

class _UrlInputFieldState extends State<UrlInputField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      label: 'Website URL',
      hint: 'https://example.com',
      errorText: widget.errorText,
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.go,
      onSubmitted: widget.onSubmitted,
      prefixIcon: const Icon(Icons.link),
      suffixIcon: widget.controller.text.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: widget.controller.clear,
            )
          : null,
    );
  }
}
