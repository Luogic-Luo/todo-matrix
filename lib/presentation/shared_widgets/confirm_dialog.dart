import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmLabel;
  final String cancelLabel;
  final Color? confirmColor;
  final VoidCallback onConfirm;

  const ConfirmDialog({
    super.key,
    this.title = AppStrings.deleteConfirmation,
    this.content = AppStrings.deleteConfirmationDesc,
    this.confirmLabel = AppStrings.delete,
    this.cancelLabel = AppStrings.cancel,
    this.confirmColor,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(cancelLabel),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          style: confirmColor != null
              ? FilledButton.styleFrom(backgroundColor: confirmColor)
              : FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
          child: Text(confirmLabel),
        ),
      ],
    );
  }

  static Future<bool?> show(
    BuildContext context, {
    String title = AppStrings.deleteConfirmation,
    String content = AppStrings.deleteConfirmationDesc,
    String confirmLabel = AppStrings.delete,
    String cancelLabel = AppStrings.cancel,
    Color? confirmColor,
    required VoidCallback onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: title,
        content: content,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        confirmColor: confirmColor,
        onConfirm: onConfirm,
      ),
    );
  }
}
