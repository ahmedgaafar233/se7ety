import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:se7ty/core/theme/app_colors.dart';

showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/lotties/loading.json', // The instructor's path from screenshot
          width: 150,
          errorBuilder: (context, error, stackTrace) {
            // Fallback if loading.json is missing or corrupted
            return const CircularProgressIndicator(color: AppColors.primary);
          },
        ),
      ],
    ),
  );
}

showMyDialog(BuildContext context, String error) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('خطأ'),
      content: Text(error),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('موافق'),
        ),
      ],
    ),
  );
}
