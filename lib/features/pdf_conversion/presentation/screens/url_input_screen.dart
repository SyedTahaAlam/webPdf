// lib/features/pdf_conversion/presentation/screens/url_input_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webpdf/core/router/app_router.dart';
import 'package:webpdf/core/theme/app_spacing.dart';
import 'package:webpdf/core/utils/url_validator.dart';
import 'package:webpdf/core/widgets/app_button.dart';
import 'package:webpdf/core/widgets/app_snackbar.dart';
import 'package:webpdf/features/ads/presentation/widgets/banner_ad_widget.dart';
import 'package:webpdf/features/pdf_conversion/application/conversion_controller.dart';
import 'package:webpdf/features/pdf_conversion/domain/entities/conversion_mode.dart';
import 'package:webpdf/features/pdf_conversion/presentation/widgets/mode_toggle.dart';
import 'package:webpdf/features/pdf_conversion/presentation/widgets/url_input_field.dart';

/// Home screen — URL entry and mode selection.
class UrlInputScreen extends ConsumerStatefulWidget {
  const UrlInputScreen({super.key});

  @override
  ConsumerState<UrlInputScreen> createState() => _UrlInputScreenState();
}

class _UrlInputScreenState extends ConsumerState<UrlInputScreen> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final raw = _controller.text;
    final normalised = UrlValidator.normalise(raw);
    final error = UrlValidator.validate(normalised);
    if (error != null) {
      setState(() => _error = error);
      return;
    }

    setState(() => _error = null);
    _controller.text = normalised;

    Navigator.of(context).pushNamed(AppRoutes.webview, arguments: normalised);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mode = ref.watch(
      conversionControllerProvider.select((s) => s),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('WebPdf'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'History',
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.history),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenHPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Convert websites to PDF',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Enter a URL below and choose your conversion mode.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onBackground.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  UrlInputField(
                    controller: _controller,
                    errorText: _error,
                    onSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const ModeToggle(),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: 'Load & Convert',
                    onPressed: _submit,
                    leading: const Icon(Icons.arrow_forward),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: 'View History',
                    variant: AppButtonVariant.outlined,
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRoutes.history),
                    leading: const Icon(Icons.history),
                  ),
                ],
              ),
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }
}
