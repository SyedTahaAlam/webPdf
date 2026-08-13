// lib/features/onboarding/presentation/screens/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:webpdf/core/config/app_constants.dart';
import 'package:webpdf/core/router/app_router.dart';
import 'package:webpdf/core/theme/app_spacing.dart';
import 'package:webpdf/core/widgets/app_button.dart';

class _OnboardingPage {
  const _OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
  });
  final String title;
  final String description;
  final IconData icon;
}

const _pages = [
  _OnboardingPage(
    title: 'Convert Any Website\nto PDF',
    description:
        'Enter any URL and WebPdf captures the entire rendered page — including scrollable content — into a single PDF document.',
    icon: Icons.picture_as_pdf,
  ),
  _OnboardingPage(
    title: 'Select Just\nWhat You Need',
    description:
        'Use "Select Section" mode to tap any element on the page and convert only that portion into a PDF.',
    icon: Icons.crop_free,
  ),
  _OnboardingPage(
    title: 'Save, Share\n& Revisit',
    description:
        'All generated PDFs are saved to your History. Preview, rename, share or delete them at any time.',
    icon: Icons.history,
  ),
];

/// 3-slide intro shown to first-time users.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = PageController();
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller,
                itemCount: _pages.length,
                itemBuilder: (_, i) {
                  final page = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          page.icon,
                          size: 100,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          page.title,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          page.description,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color:
                                theme.colorScheme.onBackground.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg,
              ),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: controller,
                    count: _pages.length,
                    effect: WormEffect(
                      dotColor:
                          theme.colorScheme.primary.withOpacity(0.3),
                      activeDotColor: theme.colorScheme.primary,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: 'Get Started',
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool(
                          AppConstants.onboardingCompleteKey, true);
                      if (context.mounted) {
                        await Navigator.of(context)
                            .pushReplacementNamed(AppRoutes.home);
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextButton(
                    onPressed: () async {
                      await controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const Text('Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
