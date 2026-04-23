import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:se7ty/core/theme/app_colors.dart';

showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (context) => Center(
      child: Lottie.asset('assets/lotties/loading.json', width: 250),
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
